package handler

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/gin-gonic/gin"
)

func TestVerifyOTPRejectsMalformedCodesAndEmailsBeforeDatabaseAccess(t *testing.T) {
	gin.SetMode(gin.TestMode)
	tests := []struct {
		name  string
		email string
		code  string
	}{
		{name: "short code", email: "user@example.com", code: "12345"},
		{name: "long code", email: "user@example.com", code: "1234567"},
		{name: "alphanumeric code", email: "user@example.com", code: "12AB56"},
		{name: "special characters", email: "user@example.com", code: "12' OR"},
		{name: "SQL injection email", email: "' OR '1'='1", code: "123456"},
	}

	for _, testCase := range tests {
		t.Run(testCase.name, func(t *testing.T) {
			router := gin.New()
			router.POST("/verify", (&AuthHandler{}).VerifyOTP)
			body := `{"email":"` + testCase.email + `","code":"` + testCase.code + `"}`
			recorder := httptest.NewRecorder()
			request := httptest.NewRequest(http.MethodPost, "/verify", strings.NewReader(body))
			request.Header.Set("Content-Type", "application/json")

			router.ServeHTTP(recorder, request)

			if recorder.Code != http.StatusBadRequest {
				t.Fatalf("status = %d, want %d; body = %s", recorder.Code, http.StatusBadRequest, recorder.Body.String())
			}
		})
	}
}
