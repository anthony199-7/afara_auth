package middleware
import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"
	"afara_auth/internal/config"
	"github.com/gin-gonic/gin"
)
// JWTClaims represents the decoded JWT payload claims
type JWTClaims struct {
	Sub           string      `json:"sub"`
	Email         string      `json:"email"`
	EmailVerified bool        `json:"email_verified"`
	Exp           int64       `json:"exp"`
	Iat           int64       `json:"iat"`
	Iss           string      `json:"iss"`
	Aud           interface{} `json:"aud"`
}
// JWTAuth middleware validates the Bearer token by:
//  1. Decoding the JWT payload to extract claims (sub, email, exp)
//  2. Checking local expiry to short-circuit expired tokens
//  3. Validating the token against Keycloak's userinfo endpoint (confirms it
//     was signed by Keycloak and has not been revoked)
//
// Security note: For production at high scale, you would cache the Keycloak
// JWKS keys and verify the RS256 signature locally to avoid a network round-trip
// per request. The userinfo-based approach is simpler and perfectly fine for
// development and moderate production workloads.
func JWTAuth(cfg *config.Config) gin.HandlerFunc {
	return func(c *gin.Context) {
		// 1. Extract Bearer token from Authorization header
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing authorization header"})
			return
		}
		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "bearer") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid authorization header format — expected: Bearer <token>"})
			return
		}
		token := parts[1]
		// 2. Decode the JWT payload (middle segment) without verifying signature
		claims, err := decodeJWTClaims(token)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "malformed token"})
			return
		}
		// 3. Check expiry locally first (avoid unnecessary network call)
		if time.Now().Unix() > claims.Exp {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "token has expired"})
			return
		}
		// 4. Validate the token against Keycloak's userinfo endpoint
		userinfoURL := fmt.Sprintf("%s/realms/%s/protocol/openid-connect/userinfo",
			cfg.KeycloakURL, cfg.KeycloakRealm)
		req, err := http.NewRequestWithContext(c.Request.Context(), http.MethodGet, userinfoURL, nil)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
			return
		}
		req.Header.Set("Authorization", "Bearer "+token)
		client := &http.Client{Timeout: 5 * time.Second}
		resp, err := client.Do(req)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "unable to validate token with identity provider"})
			return
		}
		defer resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or revoked token"})
			return
		}
		// 5. Set user information into Gin context for downstream handlers
		c.Set("userID", claims.Sub)
		c.Set("userEmail", claims.Email)
		c.Next()
	}
}
// decodeJWTClaims decodes the payload segment of a JWT without verifying the signature.
// This is safe because we subsequently validate the full token against Keycloak's userinfo.
func decodeJWTClaims(tokenString string) (*JWTClaims, error) {
	parts := strings.Split(tokenString, ".")
	if len(parts) != 3 {
		return nil, fmt.Errorf("token does not have 3 parts")
	}
	// Decode the payload (second segment) using base64url
	payload, err := base64URLDecode(parts[1])
	if err != nil {
		return nil, fmt.Errorf("failed to decode token payload: %w", err)
	}
	var claims JWTClaims
	if err := json.Unmarshal(payload, &claims); err != nil {
		return nil, fmt.Errorf("failed to parse token claims: %w", err)
	}
	return &claims, nil
}
// base64URLDecode decodes a base64url-encoded string (JWT standard encoding)
func base64URLDecode(s string) ([]byte, error) {
	// base64.RawURLEncoding handles the URL-safe alphabet without padding
	return base64.RawURLEncoding.DecodeString(s)
}
