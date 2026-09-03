package config

import (
	"log"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

type Config struct {
	Port                 string
	DBHost               string
	DBPort               string
	DBUser               string
	DBPassword           string
	DBName               string
	DBSSLMode            string
	KeycloakURL          string
	KeycloakRealm        string
	KeycloakClientID     string
	KeycloakClientSecret string
	JWTSecret            string
	SMTPHost             string
	SMTPPort             int
	SMTPSender           string
	SMTPUser             string
	SMTPPassword         string
	SMTPSecure           bool
	Env                  string
}

// Load reads settings from environmental variables, optionally loading from a .env file first
func Load() *Config {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found or unable to read it, fallback to default OS environment variables")
	}

	smtpPort, err := strconv.Atoi(getEnv("SMTP_PORT", "1025"))
	if err != nil {
		log.Printf("Warning: SMTP_PORT is not a valid integer: %v. Defaulting to 1025", err)
		smtpPort = 1025
	}
	smtpSecure, _ := strconv.ParseBool(getEnv("SMTP_SECURE", "false"))

	return &Config{
		Port:                 getEnv("PORT", "8082"),
		DBHost:               getEnv("DB_HOST", "localhost"),
		DBPort:               getEnv("DB_PORT", "5433"),
		DBUser:               getEnv("DB_USER", "postgres"),
		DBPassword:           getEnv("DB_PASSWORD", "postgres"),
		DBName:               getEnv("DB_NAME", "afara_auth"),
		DBSSLMode:            getEnv("DB_SSLMODE", "disable"),
		KeycloakURL:          getEnv("KEYCLOAK_URL", "http://localhost:8080"),
		KeycloakRealm:        getEnv("KEYCLOAK_REALM", "myrealm"),
		KeycloakClientID:     getEnv("KEYCLOAK_CLIENT_ID", "afara-auth-client"),
		KeycloakClientSecret: getEnv("KEYCLOAK_CLIENT_SECRET", "myclientsecret"),
		JWTSecret:            getEnv("JWT_SECRET", "myjwtsecretkeywhichisverylongandsecure123!"),
		SMTPHost:             getEnv("SMTP_HOST", "localhost"),
		SMTPPort:             smtpPort,
		SMTPSender:           getEnv("SMTP_SENDER", "noreply@authapp.local"),
		SMTPUser:             getEnv("SMTP_USER", ""),
		SMTPPassword:         getEnv("SMTP_PASSWORD", ""),
		SMTPSecure:           smtpSecure,
		Env:                  getEnv("ENV", "development"),
	}
}

func getEnv(key, defaultValue string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultValue
}
