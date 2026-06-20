package handler
import (
	"fmt"
	"net/smtp"
	"strings"
	"afara_auth/internal/config"
)
// SendOTPEmail sends an OTP code to the user's email via MailPit SMTP
func SendOTPEmail(cfg *config.Config, toEmail, otpCode string) error {
	from := cfg.SMTPSender
	to := toEmail
	subject := "Your Verification Code"
	body := fmt.Sprintf(`Hello,
Your one-time verification code is:
    %s
This code will expire in 5 minutes.
If you did not request this code, please ignore this email.
– AuthApp Team`, otpCode)
	message := fmt.Sprintf("From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n%s",
		from, to, subject, body)
	addr := fmt.Sprintf("%s:%d", cfg.SMTPHost, cfg.SMTPPort)
	// MailPit/MailHog do not require authentication — plain SMTP
	err := smtp.SendMail(addr, nil, from, []string{to}, []byte(message))
	if err != nil {
		return fmt.Errorf("failed to send OTP email: %w", err)
	}
	return nil
}
// sanitizeEmail lowercases and trims whitespace from an email input
func sanitizeEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}
