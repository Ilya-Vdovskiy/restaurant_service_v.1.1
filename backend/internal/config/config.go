package config

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

type Config struct {
	DatabaseURL     string
	HTTPAddr        string
	MigrationsPath  string
	ShutdownTimeout time.Duration
}

func Load() (Config, error) {
	port := getEnv("SERVER_PORT", "8080")
	shutdownTimeoutSeconds, err := strconv.Atoi(getEnv("SHUTDOWN_TIMEOUT_SECONDS", "10"))
	if err != nil {
		return Config{}, fmt.Errorf("parse SHUTDOWN_TIMEOUT_SECONDS: %w", err)
	}

	cfg := Config{
		DatabaseURL:     os.Getenv("DATABASE_URL"),
		HTTPAddr:        ":" + port,
		MigrationsPath:  getEnv("MIGRATIONS_PATH", "migrations"),
		ShutdownTimeout: time.Duration(shutdownTimeoutSeconds) * time.Second,
	}

	if cfg.DatabaseURL == "" {
		return Config{}, fmt.Errorf("DATABASE_URL is required")
	}

	return cfg, nil
}

func getEnv(key, fallback string) string {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}
	return value
}
