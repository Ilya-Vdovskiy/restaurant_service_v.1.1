package models

import "time"

type Subdivision struct {
	ID           string    `json:"id"`
	RestaurantID string    `json:"restaurant_id"`
	Name         string    `json:"name"`
	Description  *string   `json:"description,omitempty"`
	IsActive     bool      `json:"is_active"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}
