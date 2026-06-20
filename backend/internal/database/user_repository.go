package database

import (
	"context"
	"errors"
	"fmt"

	"afara_auth/internal/model"

	"github.com/jackc/pgx/v5"
)

// CreateUser inserts a new user record into the PostgreSQL database
func (db *DB) CreateUser(ctx context.Context, user *model.User) error {
	query := `
		INSERT INTO users (id, email, is_active, created_at, updated_at)
		VALUES ($1, $2, $3, NOW(), NOW())
	`
	_, err := db.Pool.Exec(ctx, query, user.ID, user.Email, user.IsActive)
	if err != nil {
		return fmt.Errorf("failed to create user in db: %w", err)
	}
	return nil
}

// FindUserByEmail retrieves a user record by email
func (db *DB) FindUserByEmail(ctx context.Context, email string) (*model.User, error) {
	query := `
		SELECT id, email, is_active, created_at, updated_at
		FROM users
		WHERE email = $1
	`
	var user model.User
	err := db.Pool.QueryRow(ctx, query, email).Scan(
		&user.ID,
		&user.Email,
		&user.IsActive,
		&user.CreatedAt,
		&user.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil // User not found
		}
		return nil, fmt.Errorf("failed to find user by email: %w", err)
	}
	return &user, nil
}

// FindUserByID retrieves a user record by ID
func (db *DB) FindUserByID(ctx context.Context, id string) (*model.User, error) {
	query := `
		SELECT id, email, is_active, created_at, updated_at
		FROM users
		WHERE id = $1
	`
	var user model.User
	err := db.Pool.QueryRow(ctx, query, id).Scan(
		&user.ID,
		&user.Email,
		&user.IsActive,
		&user.CreatedAt,
		&user.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, nil // User not found
		}
		return nil, fmt.Errorf("failed to find user by ID: %w", err)
	}
	return &user, nil
}

// ActivateUser marks a user's is_active flag as true in PostgreSQL
func (db *DB) ActivateUser(ctx context.Context, id string) error {
	query := `
		UPDATE users
		SET is_active = true, updated_at = NOW()
		WHERE id = $1
	`
	commandTag, err := db.Pool.Exec(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to activate user in db: %w", err)
	}
	if commandTag.RowsAffected() == 0 {
		return fmt.Errorf("no user found with ID %s to activate", id)
	}
	return nil
}