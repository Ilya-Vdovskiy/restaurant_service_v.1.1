package handler

import (
	"context"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"strings"
	"time"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/service"
	"github.com/jackc/pgx/v5"
)

type RestaurantHandler struct {
	service *service.RestaurantService
}

func NewRestaurantHandler(service *service.RestaurantService) *RestaurantHandler {
	return &RestaurantHandler{service: service}
}

func (h *RestaurantHandler) List(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	restaurants, err := h.service.List(ctx)

	if err != nil {
		slog.Error("failed to list restaurants", "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to list restaurants",
		})
		return
	}

	writeJSON(w, http.StatusOK, map[string]any{
		"items": restaurants,
	})
}

type createRestaurantRequest struct {
	Name    string  `json:"name"`
	Address *string `json:"address"`
	Phone   *string `json:"phone"`
	LogoURL *string `json:"logo_url"`
}

func (h *RestaurantHandler) Create(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	var req createRestaurantRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "invalid json body",
		})
		return
	}

	req.Name = strings.TrimSpace(req.Name)
	if req.Name == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "name is required",
		})
		return
	}

	restaurant := models.Restaurant{
		Name:    req.Name,
		Address: cleanOptionalString(req.Address),
		Phone:   cleanOptionalString(req.Phone),
		LogoURL: cleanOptionalString(req.LogoURL),
	}

	created, err := h.service.Create(ctx, restaurant)
	if err != nil {
		slog.Error("failed to list restaurants", "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to list restaurants",
		})
		return
	}

	writeJSON(w, http.StatusCreated, created)
}

func cleanOptionalString(value *string) *string {
	if value == nil {
		return nil
	}

	cleaned := strings.TrimSpace(*value)
	if cleaned == "" {
		return nil
	}

	return &cleaned
}

func (h *RestaurantHandler) GetByID(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	id := r.PathValue("id")
	if strings.TrimSpace(id) == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "restaurant id is required",
		})
		return
	}

	restaurant, err := h.service.GetByID(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			writeJSON(w, http.StatusNotFound, map[string]string{
				"error": "restaurant not found",
			})
			return
		}

		slog.Error("failed to get restaurant by id", "id", id, "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to get restaurant",
		})
		return
	}

	writeJSON(w, http.StatusOK, restaurant)
}

type updateRestaurantRequest struct {
	Name    *string `json:"name"`
	Address *string `json:"address"`
	Phone   *string `json:"phone"`
	LogoURL *string `json:"logo_url"`
}

func (h *RestaurantHandler) Update(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	id := r.PathValue("id")
	if strings.TrimSpace(id) == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "restaurant id is required",
		})
		return
	}

	var req updateRestaurantRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "invalid JSON body",
		})
		return
	}

	update := models.RestaurantUpdate{
		Name:    cleanOptionalString(req.Name),
		Address: cleanOptionalString(req.Address),
		Phone:   cleanOptionalString(req.Phone),
		LogoURL: cleanOptionalString(req.LogoURL),
	}

	if update.Name == nil && update.Address == nil && update.Phone == nil && update.LogoURL == nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "at least one field is required",
		})
		return
	}

	restaurant, err := h.service.Update(ctx, id, update)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			writeJSON(w, http.StatusNotFound, map[string]string{
				"error": "restaurant not found",
			})
			return
		}

		slog.Error("failed to update restaurant", "id", id, "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to update restaurant",
		})
		return
	}

	writeJSON(w, http.StatusOK, restaurant)
}

func (h *RestaurantHandler) Deactivate(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	id := r.PathValue("id")
	if strings.TrimSpace(id) == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "restaurant id is required",
		})
		return
	}

	restaurant, err := h.service.Deactivate(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			writeJSON(w, http.StatusNotFound, map[string]string{
				"error": "restaurant not found",
			})
			return
		}

		slog.Error("failed to deactivate restaurant by id", "id", id, "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to deactivate restaurant",
		})
		return
	}

	writeJSON(w, http.StatusOK, restaurant)
}

func (h *RestaurantHandler) Activate(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	id := r.PathValue("id")
	if strings.TrimSpace(id) == "" {
		writeJSON(w, http.StatusBadRequest, map[string]string{
			"error": "restaurant id is required",
		})
		return
	}

	restaurant, err := h.service.Activate(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			writeJSON(w, http.StatusNotFound, map[string]string{
				"error": "restaurant not found",
			})
			return
		}

		slog.Error("failed to activate restaurant by id", "id", id, "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to activate restaurant",
		})
		return
	}

	writeJSON(w, http.StatusOK, restaurant)
}
