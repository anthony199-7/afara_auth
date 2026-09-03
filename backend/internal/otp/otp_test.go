package otp

import (
	"regexp"
	"testing"
)

func TestGenerateOTPProducesSixNumericDigits(t *testing.T) {
	code, err := GenerateOTP()
	if err != nil {
		t.Fatalf("GenerateOTP() error = %v", err)
	}
	if !regexp.MustCompile(`^[0-9]{6}$`).MatchString(code) {
		t.Fatalf("GenerateOTP() = %q, want exactly six digits", code)
	}
}

func TestHashOTPIsSaltedAndVerifiesOnlyOriginalCode(t *testing.T) {
	code := "042619"

	firstHash, err := HashOTP(code)
	if err != nil {
		t.Fatalf("HashOTP() error = %v", err)
	}
	secondHash, err := HashOTP(code)
	if err != nil {
		t.Fatalf("HashOTP() second error = %v", err)
	}
	if firstHash == secondHash {
		t.Fatal("HashOTP() returned identical hashes; salt protection is absent")
	}
	if !VerifyHash(code, firstHash) {
		t.Fatal("VerifyHash() rejected the original code")
	}
	if VerifyHash("042620", firstHash) {
		t.Fatal("VerifyHash() accepted an incorrect code")
	}
}
