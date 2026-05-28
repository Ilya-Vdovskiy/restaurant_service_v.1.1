package repository

import (
	"context"
	"fmt"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/jackc/pgx/v5/pgxpool"
)

type SubdivisionRepository struct {
	db *pgxpool.Pool
}

func NewSubdivisionRepository(db *pgxpool.Pool) *SubdivisionRepository {
	return &SubdivisionRepository{db: db}
}

func (r *SubdivisionRepository) List(ctx context.Context) ([]models.Subdivision, error) {
	const query = `
		SELECT id, restaurant_id, name, description, is_active, created_at, updated_at
		FROM subdivisions
		ORDER BY created_at DESC
	`

	rows, err := r.db.Query(ctx, query)

	if err != nil {
		return nil, fmt.Errorf("query subdivision: %w", err)
	}
	defer rows.Close()

	subdivisions := make([]models.Subdivision, 0)

	for rows.Next() {
		var subdivision models.Subdivision

		err := rows.Scan(
			&subdivision.ID,
			&subdivision.RestaurantId,
			&subdivision.Name,
			&subdivision.Description,
			&subdivision.IsActive,
			&subdivision.CreatedAt,
			&subdivision.UpdatedAt,
		)

		if err != nil {
			return nil, fmt.Errorf("scan subdivision: %w", err)
		}

		subdivisions = append(subdivisions, subdivision)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate subdivisions: %w", err)
	}

	return subdivisions, err
}

func (r *SubdivisionRepository) Create(ctx context.Context, subdivision models.Subdivision) (models.Subdivision, error) {
	const query = `
		INSERT INTO subdivisions (name, description)
		VALUES ($1, $2)
		RETURNING id, restaurant_id, name, description, is_active, created_at, updated_at
	`

	var created models.Subdivision

	err := r.db.QueryRow(
		ctx,
		query,
		subdivision.Name,
		subdivision.Description,
	).Scan(
		&subdivision.ID,
		&subdivision.RestaurantId,
		&subdivision.Name,
		&subdivision.Description,
		&subdivision.IsActive,
		&subdivision.CreatedAt,
		&subdivision.UpdatedAt,
	)

	if err != nil {
		return models.Subdivision{}, fmt.Errorf("create subdivision: %w", err)
	}

	return created, nil
}
