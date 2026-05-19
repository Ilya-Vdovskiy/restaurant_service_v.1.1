package models

import "time"

type Restaurant struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Address   *string   `json:"address,omitempty"`
	Phone     *string   `json:"phone,omitempty"`
	LogoURL   *string   `json:"logo_url,omitempty"`
	IsActive  bool      `json:"is_active"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type RestaurantUpdate struct {
	Name    *string
	Address *string
	Phone   *string
	LogoURL *string
}
