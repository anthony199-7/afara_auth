package handler

import (
	"afara_auth/internal/config"
	"afara_auth/internal/database"
	"afara_auth/internal/keycloak"
	"afara_auth/internal/model"
	"afara_auth/internal/otp"
	"net/http"
	"time"

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
		// If the user already exists in Keycloak, allow the re-registration flow to continue.
		// The user may be inactive in PostgreSQL and only needs a new OTP to be sent.
		if existing == nil {
			c.JSON(http.StatusConflict, gin.H{"error": "an account with this email already exists"})
			return
		}
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
	if err := SendOTPEmail(h.Cfg, email, plainCode, 5*time.Minute); err != nil {
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
	Code  string `json:"code"  binding:"required,len=6,numeric"`
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
	result, err := h.DB.VerifyAndConsumeOTP(ctx, email, req.Code, 5)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}
	if !result.Found {
		c.JSON(http.StatusBadRequest, gin.H{"error": "no active OTP found — please register or request a new code"})
		return
	}
	if result.Expired {
		c.JSON(http.StatusBadRequest, gin.H{"error": "OTP has expired — please request a new code"})
		return
	}
	if result.Locked {
		c.JSON(http.StatusTooManyRequests, gin.H{"error": "too many failed attempts — please request a new OTP"})
		return
	}
	if !result.Valid {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error":             "invalid OTP code",
			"attempts_remaining": result.AttemptsRemaining,
		})
		return
	}
	// 6. Look up user by email in our DB
	user, err := h.DB.FindUserByEmail(ctx, email)
	if err != nil || user == nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "user not found after OTP verification"})
		return
	}
	// 7. Resolve the live Keycloak user ID by email before enabling it.
	// This avoids using a stale UUID from PostgreSQL, which can happen after a failed or duplicated registration flow.
	keycloakUserID, err := h.KC.FindUserIDByEmail(ctx, email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to resolve user in identity provider"})
		return
	}
	if keycloakUserID == "" {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found in identity provider"})
		return
	}
	if err := h.KC.EnableUser(ctx, keycloakUserID); err != nil {
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
// ── POST /resend-otp ─────────────────────────────────────────────────────────
type ResendOTPRequest struct {
	Email string `json:"email" binding:"required,email"`
}
// ResendOTP generates a new OTP for the given email and sends it via email.
// This invalidates any previous active OTPs for the email.
func (h *AuthHandler) ResendOTP(c *gin.Context) {
	var req ResendOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	email := sanitizeEmail(req.Email)
	ctx := c.Request.Context()
	// Generate new OTP
	plainCode, err := otp.GenerateOTP()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate OTP"})
		return
	}
	hashedCode, err := otp.HashOTP(plainCode)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to hash OTP"})
		return
	}
	// Save and invalidate previous OTPs
	if err := h.DB.SaveOTP(ctx, email, hashedCode, 5*time.Minute); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save OTP"})
		return
	}
	// Send OTP email (do not reveal account existence details)
	if err := SendOTPEmail(h.Cfg, email, plainCode, 5*time.Minute); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to send OTP email"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "OTP resent if an account exists for this email"})
}

// ── POST /forgot-password ───────────────────────────────────────────────────
type ForgotPasswordRequest struct {
	Email string `json:"email" binding:"required,email"`
}
// ForgotPassword initiates a password reset by sending an OTP to the user's email.
// Response is generic to avoid account enumeration.
func (h *AuthHandler) ForgotPassword(c *gin.Context) {
	var req ForgotPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	email := sanitizeEmail(req.Email)
	ctx := c.Request.Context()
	// If user does not exist, respond 200 (avoid enumeration)
	user, err := h.DB.FindUserByEmail(ctx, email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}
	if user == nil {
		c.JSON(http.StatusOK, gin.H{"message": "If an account exists we have sent an OTP to reset the password"})
		return
	}
	// Generate OTP and send
	plainCode, err := otp.GenerateOTP()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate OTP"})
		return
	}
	hashedCode, err := otp.HashOTP(plainCode)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to hash OTP"})
		return
	}
	if err := h.DB.SaveOTP(ctx, email, hashedCode, 15*time.Minute); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save OTP"})
		return
	}
	if err := SendOTPEmail(h.Cfg, email, plainCode, 15*time.Minute); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to send OTP email"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "If an account exists we have sent an OTP to reset the password"})
}

// ── POST /reset-password ───────────────────────────────────────────────────
type ResetPasswordRequest struct {
	Email       string `json:"email" binding:"required,email"`
	Code        string `json:"code" binding:"required,len=6,numeric"`
	NewPassword string `json:"new_password" binding:"required,min=8"`
}
// ResetPassword verifies the OTP and updates the user's password in Keycloak
func (h *AuthHandler) ResetPassword(c *gin.Context) {
	var req ResetPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	email := sanitizeEmail(req.Email)
	ctx := c.Request.Context()
	result, err := h.DB.VerifyAndConsumeOTP(ctx, email, req.Code, 5)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "database error"})
		return
	}
	if !result.Found {
		c.JSON(http.StatusBadRequest, gin.H{"error": "no active OTP found — request a new code"})
		return
	}
	if result.Expired {
		c.JSON(http.StatusBadRequest, gin.H{"error": "OTP has expired — please request a new code"})
		return
	}
	if result.Locked {
		c.JSON(http.StatusTooManyRequests, gin.H{"error": "too many failed attempts — please request a new OTP"})
		return
	}
	if !result.Valid {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error":              "invalid OTP code",
			"attempts_remaining": result.AttemptsRemaining,
		})
		return
	}
	// 6. Find user and update password via Keycloak
	user, err := h.DB.FindUserByEmail(ctx, email)
	if err != nil || user == nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "user not found"})
		return
	}
	if err := h.KC.ResetPassword(ctx, user.ID, req.NewPassword); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to reset password"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "password reset successful — you may now log in"})
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
