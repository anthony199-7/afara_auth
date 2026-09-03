package keycloak

import (
	"afara_auth/internal/config"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

// Client wraps Keycloak admin and OIDC operations
type Client struct {
	cfg        *config.Config
	httpClient *http.Client
}
// NewClient creates a new Keycloak client
func NewClient(cfg *config.Config) *Client {
	return &Client{
		cfg: cfg,
		httpClient: &http.Client{
			Timeout: 10 * time.Second,
		},
	}
}
// TokenResponse holds access/refresh/id tokens from Keycloak
type TokenResponse struct {
	AccessToken      string `json:"access_token"`
	RefreshToken     string `json:"refresh_token"`
	IDToken          string `json:"id_token"`
	ExpiresIn        int    `json:"expires_in"`
	RefreshExpiresIn int    `json:"refresh_expires_in"`
	TokenType        string `json:"token_type"`
}
// UserInfo holds basic user profile from Keycloak /userinfo endpoint
type UserInfo struct {
	Sub           string `json:"sub"`
	Email         string `json:"email"`
	EmailVerified bool   `json:"email_verified"`
}
// getClientAccessToken obtains a service-account token for admin operations
func (kc *Client) getClientAccessToken(ctx context.Context) (string, error) {
	tokenURL := fmt.Sprintf("%s/realms/%s/protocol/openid-connect/token",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm)
	form := url.Values{}
	form.Set("grant_type", "client_credentials")
	form.Set("client_id", kc.cfg.KeycloakClientID)
	form.Set("client_secret", kc.cfg.KeycloakClientSecret)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, tokenURL, strings.NewReader(form.Encode()))
	if err != nil {
		return "", fmt.Errorf("failed to build token request: %w", err)
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to request service account token: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("keycloak returned non-200 for client_credentials: %d - %s", resp.StatusCode, string(body))
	}
	var tr TokenResponse
	if err := json.NewDecoder(resp.Body).Decode(&tr); err != nil {
		return "", fmt.Errorf("failed to decode client token response: %w", err)
	}
	return tr.AccessToken, nil
}
// CreateUser creates a new user in Keycloak via Admin REST API
// Returns the Keycloak user ID (UUID) on success
func (kc *Client) CreateUser(ctx context.Context, email, password string) (string, error) {
	adminToken, err := kc.getClientAccessToken(ctx)
	if err != nil {
		return "", fmt.Errorf("failed to get admin token: %w", err)
	}
	adminURL := fmt.Sprintf("%s/admin/realms/%s/users",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm)
	payload := map[string]interface{}{
    "username":      email,
    "email":         email,
    "firstName":     "Integration", // ◄ ADD THIS LINE
    "lastName":      "Test",        // ◄ ADD THIS LINE
    "enabled":       false, // or true, depending on your choice from earlier
    "emailVerified": false,
    "credentials": []map[string]interface{}{
        {
            "type":      "password",
            "value":     password,
            "temporary": false,
        },
    },
}
	body, err := json.Marshal(payload)
	if err != nil {
		return "", fmt.Errorf("failed to marshal user payload: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, adminURL, bytes.NewBuffer(body))
	if err != nil {
		return "", fmt.Errorf("failed to build create user request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+adminToken)
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to create user in keycloak: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode == http.StatusConflict {
		return "", fmt.Errorf("user with this email already exists in keycloak")
	}
	if resp.StatusCode != http.StatusCreated {
		respBody, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("keycloak returned unexpected status %d when creating user: %s", resp.StatusCode, string(respBody))
	}
	// Keycloak returns the new user's URL in the Location header
	location := resp.Header.Get("Location")
	if location == "" {
		return "", fmt.Errorf("keycloak did not return a Location header after user creation")
	}
	// Extract UUID from URL: e.g. .../users/some-uuid
	parts := strings.Split(location, "/")
	userID := parts[len(parts)-1]
	return userID, nil
}
// FindUserIDByEmail resolves the live Keycloak user ID for an email in the admin API.
func (kc *Client) FindUserIDByEmail(ctx context.Context, email string) (string, error) {
	adminToken, err := kc.getClientAccessToken(ctx)
	if err != nil {
		return "", fmt.Errorf("failed to get admin token: %w", err)
	}

	queryURL := fmt.Sprintf("%s/admin/realms/%s/users?email=%s",
		kc.cfg.KeycloakURL,
		kc.cfg.KeycloakRealm,
		url.QueryEscape(email),
	)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, queryURL, nil)
	if err != nil {
		return "", fmt.Errorf("failed to build find user request: %w", err)
	}
	req.Header.Set("Authorization", "Bearer "+adminToken)

	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to query keycloak user by email: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		respBody, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("keycloak returned unexpected status %d when finding user by email: %s", resp.StatusCode, string(respBody))
	}

	var users []struct {
		ID string `json:"id"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&users); err != nil {
		return "", fmt.Errorf("failed to decode keycloak user list: %w", err)
	}
	if len(users) == 0 {
		return "", nil
	}
	return users[0].ID, nil
}

// EnableUser re-enables a Keycloak user account (called after OTP verification)
func (kc *Client) EnableUser(ctx context.Context, keycloakUserID string) error {
	adminToken, err := kc.getClientAccessToken(ctx)
	if err != nil {
		return fmt.Errorf("failed to get admin token: %w", err)
	}
	adminURL := fmt.Sprintf("%s/admin/realms/%s/users/%s",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm, keycloakUserID)
	payload := map[string]interface{}{
		"enabled":       true,
		"emailVerified": true,
	}
	body, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal enable user payload: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPut, adminURL, bytes.NewBuffer(body))
	if err != nil {
		return fmt.Errorf("failed to build enable user request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+adminToken)
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to enable user in keycloak: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		respBody, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("keycloak returned unexpected status %d when enabling user: %s", resp.StatusCode, string(respBody))
	}
	return nil
}
// Login authenticates a user and returns Keycloak tokens using direct-access grants
func (kc *Client) Login(ctx context.Context, email, password string) (*TokenResponse, error) {
	tokenURL := fmt.Sprintf("%s/realms/%s/protocol/openid-connect/token",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm)
	form := url.Values{}
	form.Set("grant_type", "password")
	form.Set("client_id", kc.cfg.KeycloakClientID)
	form.Set("client_secret", kc.cfg.KeycloakClientSecret)
	form.Set("username", email)
	form.Set("password", password)
	form.Set("scope", "openid email profile")
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, tokenURL, strings.NewReader(form.Encode()))
	if err != nil {
		return nil, fmt.Errorf("failed to build login request: %w", err)
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to send login request to keycloak: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode == http.StatusUnauthorized {
		return nil, fmt.Errorf("invalid email or password")
	}
	if resp.StatusCode != http.StatusOK {
		respBody, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("keycloak login returned unexpected status %d: %s", resp.StatusCode, string(respBody))
	}
	var tr TokenResponse
	if err := json.NewDecoder(resp.Body).Decode(&tr); err != nil {
		return nil, fmt.Errorf("failed to decode login token response: %w", err)
	}
	return &tr, nil
}
// RefreshToken exchanges a refresh token for a new access token
func (kc *Client) RefreshToken(ctx context.Context, refreshToken string) (*TokenResponse, error) {
	tokenURL := fmt.Sprintf("%s/realms/%s/protocol/openid-connect/token",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm)
	form := url.Values{}
	form.Set("grant_type", "refresh_token")
	form.Set("client_id", kc.cfg.KeycloakClientID)
	form.Set("client_secret", kc.cfg.KeycloakClientSecret)
	form.Set("refresh_token", refreshToken)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, tokenURL, strings.NewReader(form.Encode()))
	if err != nil {
		return nil, fmt.Errorf("failed to build refresh token request: %w", err)
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to send refresh token request to keycloak: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		respBody, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("keycloak refresh returned unexpected status %d: %s", resp.StatusCode, string(respBody))
	}
	var tr TokenResponse
	if err := json.NewDecoder(resp.Body).Decode(&tr); err != nil {
		return nil, fmt.Errorf("failed to decode refresh token response: %w", err)
	}
	return &tr, nil
}
// Logout invalidates a refresh token in Keycloak
func (kc *Client) Logout(ctx context.Context, refreshToken string) error {
	logoutURL := fmt.Sprintf("%s/realms/%s/protocol/openid-connect/logout",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm)
	form := url.Values{}
	form.Set("client_id", kc.cfg.KeycloakClientID)
	form.Set("client_secret", kc.cfg.KeycloakClientSecret)
	form.Set("refresh_token", refreshToken)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, logoutURL, strings.NewReader(form.Encode()))
	if err != nil {
		return fmt.Errorf("failed to build logout request: %w", err)
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to send logout request to keycloak: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		respBody, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("keycloak logout returned unexpected status %d: %s", resp.StatusCode, string(respBody))
	}
	return nil
}
// GetUserInfo fetches user profile info from Keycloak /userinfo endpoint
func (kc *Client) GetUserInfo(ctx context.Context, accessToken string) (*UserInfo, error) {
	userinfoURL := fmt.Sprintf("%s/realms/%s/protocol/openid-connect/userinfo",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, userinfoURL, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to build userinfo request: %w", err)
	}
	req.Header.Set("Authorization", "Bearer "+accessToken)
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to send userinfo request to keycloak: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("keycloak userinfo returned status %d", resp.StatusCode)
	}
	var info UserInfo
	if err := json.NewDecoder(resp.Body).Decode(&info); err != nil {
		return nil, fmt.Errorf("failed to decode userinfo response: %w", err)
	}
	return &info, nil
}
// ResetPassword sets a new password for a Keycloak user via the Admin REST API
func (kc *Client) ResetPassword(ctx context.Context, keycloakUserID, newPassword string) error {
	adminToken, err := kc.getClientAccessToken(ctx)
	if err != nil {
		return fmt.Errorf("failed to get admin token: %w", err)
	}
	resetURL := fmt.Sprintf("%s/admin/realms/%s/users/%s/reset-password",
		kc.cfg.KeycloakURL, kc.cfg.KeycloakRealm, keycloakUserID)
	payload := map[string]interface{}{
		"type":      "password",
		"value":     newPassword,
		"temporary": false,
	}
	body, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal reset payload: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPut, resetURL, bytes.NewBuffer(body))
	if err != nil {
		return fmt.Errorf("failed to build reset password request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+adminToken)
	resp, err := kc.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("failed to call keycloak reset-password: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		respBody, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("keycloak reset-password returned unexpected status %d: %s", resp.StatusCode, string(respBody))
	}
	return nil
}