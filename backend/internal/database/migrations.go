package database

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/jackc/pgx/v5/pgxpool"
)

func RunMigrations(ctx context.Context, db *pgxpool.Pool, migrationsPath string) error {
	if err := ensureMigrationsTable(ctx, db); err != nil {
		return err
	}

	files, err := migrationFiles(migrationsPath)
	if err != nil {
		return err
	}

	for _, file := range files {
		applied, err := isMigrationApplied(ctx, db, file.Name())
		if err != nil {
			return err
		}
		if applied {
			continue
		}

		if err := applyMigration(ctx, db, filepath.Join(migrationsPath, file.Name()), file.Name()); err != nil {
			return err
		}
	}

	return nil
}

func ensureMigrationsTable(ctx context.Context, db *pgxpool.Pool) error {
	const query = `
		CREATE TABLE IF NOT EXISTS schema_migrations (
			version TEXT PRIMARY KEY,
			applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)
	`

	if _, err := db.Exec(ctx, query); err != nil {
		return fmt.Errorf("create schema_migrations table: %w", err)
	}

	return nil
}

func migrationFiles(migrationsPath string) ([]os.DirEntry, error) {
	files, err := os.ReadDir(migrationsPath)
	if err != nil {
		return nil, fmt.Errorf("read migrations directory: %w", err)
	}

	upFiles := make([]os.DirEntry, 0, len(files))
	for _, file := range files {
		if file.IsDir() || !strings.HasSuffix(file.Name(), ".up.sql") {
			continue
		}
		upFiles = append(upFiles, file)
	}

	sort.Slice(upFiles, func(i, j int) bool {
		return upFiles[i].Name() < upFiles[j].Name()
	})

	return upFiles, nil
}

func isMigrationApplied(ctx context.Context, db *pgxpool.Pool, version string) (bool, error) {
	const query = `SELECT EXISTS(SELECT 1 FROM schema_migrations WHERE version = $1)`

	var exists bool
	if err := db.QueryRow(ctx, query, version).Scan(&exists); err != nil {
		return false, fmt.Errorf("check migration %s: %w", version, err)
	}

	return exists, nil
}

func applyMigration(ctx context.Context, db *pgxpool.Pool, path string, version string) error {
	sqlBytes, err := os.ReadFile(path)
	if err != nil {
		return fmt.Errorf("read migration %s: %w", version, err)
	}

	conn, err := db.Acquire(ctx)
	if err != nil {
		return fmt.Errorf("acquire migration connection: %w", err)
	}
	defer conn.Release()

	if _, err := conn.Exec(ctx, "BEGIN"); err != nil {
		return fmt.Errorf("begin migration %s: %w", version, err)
	}

	committed := false
	defer func() {
		if !committed {
			_, _ = conn.Exec(context.Background(), "ROLLBACK")
		}
	}()

	if _, err := conn.Conn().PgConn().Exec(ctx, string(sqlBytes)).ReadAll(); err != nil {
		return fmt.Errorf("apply migration %s: %w", version, err)
	}

	if _, err := conn.Exec(ctx, `INSERT INTO schema_migrations(version) VALUES ($1)`, version); err != nil {
		return fmt.Errorf("record migration %s: %w", version, err)
	}

	if _, err := conn.Exec(ctx, "COMMIT"); err != nil {
		return fmt.Errorf("commit migration %s: %w", version, err)
	}

	committed = true
	slog.Info("migration applied", "version", version)
	return nil
}
