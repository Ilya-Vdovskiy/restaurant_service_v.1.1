package models

import "time"

type Subdivision struct {
	ID           string    `json:"id"`
	RestaurantId string    `json:"restaurant_id"`
	Name         string    `json:"name"`
	Description  *string   `json:"description"`
	IsActive     bool      `json:"is_active"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}
