package handler
import (
	"net/http"
	"time"
	"afara_auth/internal/config"
	"afara_auth/internal/database"
	"afara_auth/internal/keycloak"
	"afara_auth/internal/model"
	"afara_auth/internal/otp"
	"github.com/gin-gonic/gin"
)
// AuthHandler holds dependencies for all auth-related HTTP handlers
type AuthHandler struct {
	DB  *database.DB
	KC  *keycloak.Client
	Cfg *config.Config
}
// NewAuthHandler constructs an AuthHandler with injected dependencies
func NewAuthHandler(db *database.DB, kc *keycloak.Client, cfg *config.Config) *AuthHandler {
	return &AuthHandler{DB: db, KC: kc, Cfg: cfg}
}
// ── POST /register ────────────────────────────────────────────────────────────
type RegisterRequest struct {
	Email    string `json:"email"    binding:"required,email"`
	Password string `json:"password" binding:"required,min=8"`
}
// Register creates a disabled user in Keycloak and PostgreSQL, then sends an OTP
func (h *AuthHandler) Register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	email := sanitizeEmail(req.Email)
	ctx := c.Request.Context()
	// 1. Check if user already exists in our DB
	existing, err := h.DB.FindUserByEmail(ctx, email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database lookup failed"})
		return
	}
	if existing != nil && existing.IsActive {
		c.JSON(http.StatusConflict, gin.H{"error": "an account with this email already exists"})
		return
	}
	// 2. Create user in Keycloak (disabled until OTP verified)
	keycloakID, err := h.KC.CreateUser(ctx, email, req.Password)
	if err != nil {
		// If already exists in Keycloak but not active in our DB, allow re-registration flow
		if existing == nil {
			c.JSON(http.StatusConflict, gin.H{"error": "an account with this email already exists"})
			return
		}
		// If already in our DB (inactive), skip Keycloak creation and just resend OTP
		keycloakID = existing.ID
	}
	// 3. Save (or update) user in PostgreSQL as inactive
	if existing == nil {
		newUser := &model.User{
			ID:       keycloakID,
			Email:    email,
			IsActive: false,
		}
		if err := h.DB.CreateUser(ctx, newUser); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save user record"})
			return
		}
	}
	// 4. Generate a 6-digit OTP
	plainCode, err := otp.GenerateOTP()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate OTP"})
		return
	}
	// 5. Hash the OTP before storing (security: never store plaintext OTPs)
	hashedCode, err := otp.HashOTP(plainCode)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to hash OTP"})
		return
	}
	// 6. Save hashed OTP with 5-minute expiry (invalidates any previous OTPs for this email)
	if err := h.DB.SaveOTP(ctx, email, hashedCode, 5*time.Minute); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save OTP"})
		return
	}
	// 7. Send OTP email (MailPit captures it locally)
	if err := SendOTPEmail(h.Cfg, email, plainCode); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to send OTP email"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"message": "registration successful — check your email for the OTP verification code",
		"email":   email,
	})
}
// ── POST /verify-otp ──────────────────────────────────────────────────────────
type VerifyOTPRequest struct {
	Email string `json:"email" binding:"required,email"`
	Code  string `json:"code"  binding:"required,len=6"`
}
// VerifyOTP validates the 6-digit code and activates the user account
func (h *AuthHandler) VerifyOTP(c *gin.Context) {
	var req VerifyOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	email := sanitizeEmail(req.Email)
	ctx := c.Request.Context()
	// 1. Find latest active OTP for this email
	record, err := h.DB.FindLatestActiveOTP(ctx, email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}
	if record == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "no active OTP found — please register or request a new code"})
		return
	}
	// 2. Check expiry
	if time.Now().After(record.ExpiresAt) {
		_ = h.DB.InvalidateOTP(ctx, record.ID)
		c.JSON(http.StatusBadRequest, gin.H{"error": "OTP has expired — please request a new code"})
		return
	}
	// 3. Rate-limit: max 5 attempts before invalidating the OTP
	if record.Attempts >= 5 {
		_ = h.DB.InvalidateOTP(ctx, record.ID)
		c.JSON(http.StatusTooManyRequests, gin.H{"error": "too many failed attempts — please request a new OTP"})
		return
	}
	// 4. Verify the hashed code
	if !otp.VerifyHash(req.Code, record.CodeHash) {
		_ = h.DB.IncrementOTPAttempts(ctx, record.ID)
		remaining := 5 - (record.Attempts + 1)
		c.JSON(http.StatusUnauthorized, gin.H{
			"error":             "invalid OTP code",
			"attempts_remaining": remaining,
		})
		return
	}
	// 5. Invalidate OTP (replay protection — one-time use only)
	if err := h.DB.InvalidateOTP(ctx, record.ID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to invalidate OTP"})
		return
	}
	// 6. Look up user by email in our DB
	user, err := h.DB.FindUserByEmail(ctx, email)
	if err != nil || user == nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "user not found after OTP verification"})
		return
	}
	// 7. Enable user in Keycloak
	if err := h.KC.EnableUser(ctx, user.ID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to activate user in identity provider"})
		return
	}
	// 8. Mark user as active in our PostgreSQL database
	if err := h.DB.ActivateUser(ctx, user.ID); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to activate user in database"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"message": "email verified successfully — your account is now active. You may now log in.",
		"email":   email,
	})
}
// ── POST /login ───────────────────────────────────────────────────────────────
type LoginRequest struct {
	Email    string `json:"email"    binding:"required,email"`
	Password string `json:"password" binding:"required"`
}
// Login authenticates the user and returns JWT tokens from Keycloak
func (h *AuthHandler) Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	email := sanitizeEmail(req.Email)
	ctx := c.Request.Context()
	// 1. Check user exists and is active in our DB
	user, err := h.DB.FindUserByEmail(ctx, email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}
	if user == nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid email or password"})
		return
	}
	if !user.IsActive {
		c.JSON(http.StatusForbidden, gin.H{"error": "account not yet verified — please check your email for the OTP code"})
		return
	}
	// 2. Authenticate against Keycloak and get tokens
	tokens, err := h.KC.Login(ctx, email, req.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid email or password"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"access_token":       tokens.AccessToken,
		"refresh_token":      tokens.RefreshToken,
		"expires_in":         tokens.ExpiresIn,
		"refresh_expires_in": tokens.RefreshExpiresIn,
		"token_type":         tokens.TokenType,
	})
}
// ── POST /refresh ─────────────────────────────────────────────────────────────
type RefreshRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}
// Refresh exchanges a refresh token for a new access token
func (h *AuthHandler) Refresh(c *gin.Context) {
	var req RefreshRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx := c.Request.Context()
	tokens, err := h.KC.RefreshToken(ctx, req.RefreshToken)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired refresh token"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"access_token":       tokens.AccessToken,
		"refresh_token":      tokens.RefreshToken,
		"expires_in":         tokens.ExpiresIn,
		"refresh_expires_in": tokens.RefreshExpiresIn,
		"token_type":         tokens.TokenType,
	})
}
// ── POST /logout ──────────────────────────────────────────────────────────────
type LogoutRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}
// Logout invalidates the user's session in Keycloak
func (h *AuthHandler) Logout(c *gin.Context) {
	var req LogoutRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx := c.Request.Context()
	if err := h.KC.Logout(ctx, req.RefreshToken); err != nil {
		// Even if Keycloak rejects the logout, we return 200 — token is already effectively dead
		c.JSON(http.StatusOK, gin.H{"message": "logged out"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "logged out successfully"})
}
// ── GET /me ───────────────────────────────────────────────────────────────────
// Profile returns the authenticated user's info (requires JWT middleware — Step 12)
func (h *AuthHandler) Profile(c *gin.Context) {
	// The JWT middleware (Step 12) will set "userEmail" and "userID" in the context
	userEmail, exists := c.Get("userEmail")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	userID, _ := c.Get("userID")
	c.JSON(http.StatusOK, gin.H{
		"user_id": userID,
		"email":   userEmail,
	})
}
