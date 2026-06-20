package database

import (
	"context"
	"fmt"
	"log"
	"time"

	"afara_auth/internal/config"

	"github.com/jackc/pgx/v5/pgxpool"
)

// DB represents our database pool wrapper
type DB struct {
	Pool *pgxpool.Pool
}

// Connect establishes a connection pool to PostgreSQL using config values
func Connect(cfg *config.Config) (*DB, error) {
	connStr := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=%s",
		cfg.DBUser,
		cfg.DBPassword,
		cfg.DBHost,
		cfg.DBPort,
		cfg.DBName,
		cfg.DBSSLMode,
	)

	// Parse connection configuration
	poolConfig, err := pgxpool.ParseConfig(connStr)
	if err != nil {
		return nil, fmt.Errorf("unable to parse database connection string: %w", err)
	}

	// Retry connection loop (useful when starting containers sequentially)
	var pool *pgxpool.Pool
	ctx := context.Background()

	for i := 0; i < 10; i++ {
		pool, err = pgxpool.NewWithConfig(ctx, poolConfig)
		if err == nil {
			// Ping the connection to ensure it is alive
			err = pool.Ping(ctx)
			if err == nil {
				log.Println("Successfully established PostgreSQL connection pool")
				return &DB{Pool: pool}, nil
			}
		}

		log.Printf("PostgreSQL is not ready yet (attempt %d/10): %v. Retrying in 3 seconds...", i+1, err)
		if pool != nil {
			pool.Close()
		}
		time.Sleep(3 * time.Second)
	}

	return nil, fmt.Errorf("could not connect to PostgreSQL after 10 attempts: %w", err)
}

// Close terminates the connection pool
func (db *DB) Close() {
	if db.Pool != nil {
		db.Pool.Close()
	}
}