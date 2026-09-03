package handler

import (
	"crypto/tls"
	"fmt"
	"net/smtp"
	"strings"
	"time"

	"afara_auth/internal/config"
)

// SendOTPEmail sends an OTP code to the user's email using SMTP with STARTTLS when needed.
func SendOTPEmail(cfg *config.Config, toEmail, otpCode string, expiry time.Duration) error {
	from := cfg.SMTPSender
	to := toEmail
	subject := "Your Verification Code"
	body := fmt.Sprintf(`Hello,
Your one-time verification code is:
    %s
This code will expire in %s.
If you did not request this code, please ignore this email.
– AuthApp Team`, otpCode, expiry.Round(time.Minute))
	message := fmt.Sprintf("From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n%s",
		from, to, subject, body)
	addr := fmt.Sprintf("%s:%d", cfg.SMTPHost, cfg.SMTPPort)

	var auth smtp.Auth
	if cfg.SMTPUser != "" {
		auth = smtp.PlainAuth("", cfg.SMTPUser, cfg.SMTPPassword, cfg.SMTPHost)
	}

	var client *smtp.Client
	var err error
	if cfg.SMTPPort == 465 || cfg.SMTPSecure {
		tlsConfig := &tls.Config{
			InsecureSkipVerify: false,
			ServerName:         cfg.SMTPHost,
		}
		conn, err := tls.Dial("tcp", addr, tlsConfig)
		if err != nil {
			return fmt.Errorf("failed to connect via TLS: %w", err)
		}
		defer conn.Close()

		client, err = smtp.NewClient(conn, cfg.SMTPHost)
		if err != nil {
			return fmt.Errorf("failed to create SMTP client: %w", err)
		}
		defer client.Close()
	} else {
		client, err = smtp.Dial(addr)
		if err != nil {
			return fmt.Errorf("failed to connect to SMTP: %w", err)
		}
		defer client.Close()

		if ok, _ := client.Extension("STARTTLS"); ok {
			tlsConfig := &tls.Config{ServerName: cfg.SMTPHost}
			if err = client.StartTLS(tlsConfig); err != nil {
				return fmt.Errorf("failed to start TLS: %w", err)
			}
		}
	}

	if auth != nil {
		if err = client.Auth(auth); err != nil {
			return fmt.Errorf("failed to authenticate SMTP: %w", err)
		}
	}
	if err = client.Mail(from); err != nil {
		return fmt.Errorf("failed to set sender: %w", err)
	}
	if err = client.Rcpt(to); err != nil {
		return fmt.Errorf("failed to set recipient: %w", err)
	}
	w, err := client.Data()
	if err != nil {
		return fmt.Errorf("failed to open data writer: %w", err)
	}
	_, err = w.Write([]byte(message))
	if err != nil {
		return fmt.Errorf("failed to write message body: %w", err)
	}
	err = w.Close()
	if err != nil {
		return fmt.Errorf("failed to close data writer: %w", err)
	}
	return client.Quit()
}

// sanitizeEmail lowercases and trims whitespace from an email input
func sanitizeEmail(email string) string {
	return strings.ToLower(strings.TrimSpace(email))
}
