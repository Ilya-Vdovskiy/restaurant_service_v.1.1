package handler

import (
	"context"
	"log/slog"
	"net/http"
	"time"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/service"
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
