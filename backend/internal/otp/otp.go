package otp

import (
	"crypto/rand"
	"fmt"
	"math/big"

	"golang.org/x/crypto/bcrypt"
)

// GenerateOTP generates a cryptographically secure 6-digit OTP code as a string
func GenerateOTP() (string, error) {
	max := big.NewInt(1000000) // 0 to 999999
	n, err := rand.Int(rand.Reader, max)
	if err != nil {
		return "", fmt.Errorf("failed to generate random number: %w", err)
	}
	return fmt.Sprintf("%06d", n.Int64()), nil
}

// HashOTP hashes the OTP code using bcrypt
func HashOTP(code string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(code), bcrypt.DefaultCost)
	if err != nil {
		return "", fmt.Errorf("failed to hash OTP: %w", err)
	}
	return string(bytes), nil
}

// VerifyHash compares a plain OTP code against a hashed OTP code
func VerifyHash(code, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(code))
	return err == nil
}