package database

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"golang.org/x/crypto/bcrypt"
)

// OTPVerificationResult describes the outcome of an atomic OTP consume attempt.
type OTPVerificationResult struct {
	Found             bool
	Valid             bool
	Expired           bool
	Locked            bool
	AttemptsRemaining int
}

// SaveOTP stores a hashed OTP code for an email, invalidating previous ones
func (db *DB) SaveOTP(ctx context.Context, email, codeHash string, expiry time.Duration) error {
	// Start a transaction to ensure atomic invalidation and insertion
	tx, err := db.Pool.Begin(ctx)
	if err != nil {
		return fmt.Errorf("failed to begin transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	// Serialize replacement requests for the same email. Without this lock,
	// concurrent transactions can both insert an active OTP.
	if _, err = tx.Exec(ctx, `SELECT pg_advisory_xact_lock(hashtext($1))`, email); err != nil {
		return fmt.Errorf("failed to lock OTP email: %w", err)
	}

	// Invalidate previous active OTPs for this email by marking them verified
	invalidateQuery := `
		UPDATE otp_codes
		SET is_verified = true
		WHERE email = $1 AND is_verified = false
	`
	_, err = tx.Exec(ctx, invalidateQuery, email)
	if err != nil {
		return fmt.Errorf("failed to invalidate previous OTP codes: %w", err)
	}

	// Insert the new OTP code
	insertQuery := `
		INSERT INTO otp_codes (email, code_hash, expires_at, created_at, attempts, is_verified)
		VALUES ($1, $2, $3, NOW(), 0, false)
	`
	expiresAt := time.Now().Add(expiry)
	_, err = tx.Exec(ctx, insertQuery, email, codeHash, expiresAt)
	if err != nil {
		return fmt.Errorf("failed to save new OTP code: %w", err)
	}

	return tx.Commit(ctx)
}

// OTPRecord represents the raw database row for an OTP code
type OTPRecord struct {
	ID         int
	Email      string
	CodeHash   string
	ExpiresAt  time.Time
	Attempts   int
	IsVerified bool
}

// FindLatestActiveOTP retrieves the most recent unverified OTP record for an email
func (db *DB) FindLatestActiveOTP(ctx context.Context, email string) (*OTPRecord, error) {
	query := `
		SELECT id, email, code_hash, expires_at, attempts, is_verified
		FROM otp_codes
		WHERE email = $1 AND is_verified = false
		ORDER BY created_at DESC
		LIMIT 1
	`
	var record OTPRecord
	err := db.Pool.QueryRow(ctx, query, email).Scan(
		&record.ID,
		&record.Email,
		&record.CodeHash,
		&record.ExpiresAt,
		&record.Attempts,
		&record.IsVerified,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil // No active OTP found
		}
		return nil, fmt.Errorf("failed to find latest active OTP: %w", err)
	}
	return &record, nil
}

// IncrementOTPAttempts increments the attempt counter for a specific OTP row
func (db *DB) IncrementOTPAttempts(ctx context.Context, id int) error {
	query := `
		UPDATE otp_codes
		SET attempts = attempts + 1
		WHERE id = $1
	`
	_, err := db.Pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to increment OTP attempts: %w", err)
	}
	return nil
}

// InvalidateOTP marks the OTP record as verified so it cannot be used again
func (db *DB) InvalidateOTP(ctx context.Context, id int) error {
	query := `
		UPDATE otp_codes
		SET is_verified = true
		WHERE id = $1
	`
	_, err := db.Pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to invalidate OTP: %w", err)
	}
	return nil
}

// VerifyAndConsumeOTP serializes verification for one email and consumes a
// valid code exactly once. Failed attempts are incremented while the row is
// locked, so concurrent requests cannot bypass the limit.
func (db *DB) VerifyAndConsumeOTP(ctx context.Context, email, code string, maxAttempts int) (OTPVerificationResult, error) {
	tx, err := db.Pool.Begin(ctx)
	if err != nil {
		return OTPVerificationResult{}, fmt.Errorf("failed to begin OTP verification transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	var record OTPRecord
	err = tx.QueryRow(ctx, `
		SELECT id, email, code_hash, expires_at, attempts, is_verified
		FROM otp_codes
		WHERE email = $1 AND is_verified = false
		ORDER BY created_at DESC
		LIMIT 1
		FOR UPDATE
	`, email).Scan(&record.ID, &record.Email, &record.CodeHash, &record.ExpiresAt, &record.Attempts, &record.IsVerified)
	if errors.Is(err, pgx.ErrNoRows) {
		return OTPVerificationResult{}, nil
	}
	if err != nil {
		return OTPVerificationResult{}, fmt.Errorf("failed to lock active OTP: %w", err)
	}

	result := OTPVerificationResult{Found: true}
	if time.Now().After(record.ExpiresAt) {
		if _, err = tx.Exec(ctx, `UPDATE otp_codes SET is_verified = true WHERE id = $1 AND is_verified = false`, record.ID); err != nil {
			return OTPVerificationResult{}, fmt.Errorf("failed to expire OTP: %w", err)
		}
		result.Expired = true
		return result, tx.Commit(ctx)
	}
	if record.Attempts >= maxAttempts {
		if _, err = tx.Exec(ctx, `UPDATE otp_codes SET is_verified = true WHERE id = $1 AND is_verified = false`, record.ID); err != nil {
			return OTPVerificationResult{}, fmt.Errorf("failed to lock OTP: %w", err)
		}
		result.Locked = true
		return result, tx.Commit(ctx)
	}

	if bcrypt.CompareHashAndPassword([]byte(record.CodeHash), []byte(code)) == nil {
		if _, err = tx.Exec(ctx, `UPDATE otp_codes SET is_verified = true WHERE id = $1 AND is_verified = false`, record.ID); err != nil {
			return OTPVerificationResult{}, fmt.Errorf("failed to consume OTP: %w", err)
		}
		result.Valid = true
		return result, tx.Commit(ctx)
	}

	newAttempts := record.Attempts + 1
	if _, err = tx.Exec(ctx, `UPDATE otp_codes SET attempts = $1, is_verified = CASE WHEN $1 >= $2 THEN true ELSE is_verified END WHERE id = $3 AND is_verified = false`, newAttempts, maxAttempts, record.ID); err != nil {
		return OTPVerificationResult{}, fmt.Errorf("failed to record OTP attempt: %w", err)
	}
	result.AttemptsRemaining = maxAttempts - newAttempts
	return result, tx.Commit(ctx)
}
