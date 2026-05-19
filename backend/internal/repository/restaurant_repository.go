package repository

import (
	"context"
	"fmt"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/jackc/pgx/v5/pgxpool"
)

type RestaurantRepository struct {
	db *pgxpool.Pool
}

func NewRestaurantRepository(db *pgxpool.Pool) *RestaurantRepository {
	return &RestaurantRepository{db: db}
}

func (r *RestaurantRepository) List(ctx context.Context) ([]models.Restaurant, error) {
	const query = `
		SELECT id, name, address, phone, logo_url, is_active, created_at, updated_at
		FROM restaurants
		ORDER BY created_at DESC
	`

	rows, err := r.db.Query(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("query restaurants: %w", err)
	}
	defer rows.Close()

	restaurants := make([]models.Restaurant, 0)

	for rows.Next() {
		var restaurant models.Restaurant

		err := rows.Scan(
			&restaurant.ID,
			&restaurant.Name,
			&restaurant.Address,
			&restaurant.Phone,
			&restaurant.LogoURL,
			&restaurant.IsActive,
			&restaurant.CreatedAt,
			&restaurant.UpdatedAt,
		)

		if err != nil {
			return nil, fmt.Errorf("scan restaurants: %w", err)
		}

		restaurants = append(restaurants, restaurant)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterate restaurants: %w", err)
	}

	return restaurants, nil
}
