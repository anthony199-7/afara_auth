package main

import (
	"afara_auth/internal/config"
	"afara_auth/internal/database"
	"afara_auth/internal/handler"
	"afara_auth/internal/keycloak"
	"afara_auth/internal/middleware"
	"fmt"
	"log"
	"time"

	"github.com/gin-gonic/gin"
)
func main() {
	// 1. Load config
	cfg := config.Load()
	fmt.Println("Configuration loaded!")
	// 2. Connect to Database
	db, err := database.Connect(cfg)
	if err != nil {
		log.Fatalf("Database connection failed: %v", err)
	}
	defer db.Close()
	fmt.Println("PostgreSQL connected.")
	// 3. Create Keycloak client
	kc := keycloak.NewClient(cfg)
	// 4. Create auth handler
	authHandler := handler.NewAuthHandler(db, kc, cfg)
	// 5. Set up Gin router
	r := gin.Default()
	// ── Global Middleware ──────────────────────────────────────────────────
	// CORS: allows Flutter web (running on a different port) to call the API
	r.Use(middleware.CORS())
	// ── Rate Limiters ─────────────────────────────────────────────────────
	// General API rate limiter: 60 requests per minute per IP
	generalLimiter := middleware.NewRateLimiter(60, 1*time.Minute)
	// Strict OTP rate limiter: 5 requests per minute per IP
	// This prevents brute-forcing OTP codes and spamming the email system
	otpLimiter := middleware.NewRateLimiter(5, 1*time.Minute)
	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})
	// ── Public Auth Routes (no JWT required) ──────────────────────────────
	auth := r.Group("/api/auth")
	auth.Use(generalLimiter.Middleware())
	{
		auth.POST("/register", otpLimiter.Middleware(), authHandler.Register)
		auth.POST("/verify-otp", otpLimiter.Middleware(), authHandler.VerifyOTP)
		auth.POST("/login", authHandler.Login)
		auth.POST("/refresh", authHandler.Refresh)
		auth.POST("/logout", authHandler.Logout)
	}
	// ── Protected Routes (JWT required) ───────────────────────────────────
	protected := r.Group("/api")
	protected.Use(generalLimiter.Middleware())
	protected.Use(middleware.JWTAuth(cfg))
	{
		protected.GET("/me", authHandler.Profile)
	}
	// 6. Start server
	addr := fmt.Sprintf(":%s", cfg.Port)
	log.Printf("Server starting on %s", addr)
	if err := r.Run(addr); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
