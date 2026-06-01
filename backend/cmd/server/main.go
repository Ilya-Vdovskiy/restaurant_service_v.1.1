package main

import (
	"context"
	"errors"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/config"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/database"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/router"
)

func main() {
	if err := run(); err != nil {
		slog.Error("server stopped with error", "error", err)
		os.Exit(1)
	}
}

func run() error {
	cfg, err := config.Load()
	if err != nil {
		return err
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	db, err := database.NewPostgresPool(ctx, cfg.DatabaseURL)
	if err != nil {
		return err
	}
	defer db.Close()

	if err := database.RunMigrations(ctx, db, cfg.MigrationsPath); err != nil {
		return err
	}

	server := &http.Server{
		Addr:    cfg.HTTPAddr,
		Handler: router.New(db, cfg.JWTSecret, cfg.CORSOrigins),
	}

	errCh := make(chan error, 1)
	go func() {
		slog.Info("http server started", "addr", cfg.HTTPAddr)
		errCh <- server.ListenAndServe()
	}()

	select {
	case <-ctx.Done():
		slog.Info("shutdown signal received")
	case err := <-errCh:
		if !errors.Is(err, http.ErrServerClosed) {
			return err
		}
	}

	shutdownCtx, cancel := context.WithTimeout(context.Background(), cfg.ShutdownTimeout)
	defer cancel()

	if err := server.Shutdown(shutdownCtx); err != nil {
		return err
	}

	slog.Info("http server stopped")
	return nil
}
