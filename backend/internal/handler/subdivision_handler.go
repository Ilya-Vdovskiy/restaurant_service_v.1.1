package handler

import (
	"context"
	"log/slog"
	"net/http"
	"time"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/service"
)

type SubdivisionHandler struct {
	service *service.SubdivisionService
}

func NewSubdivisionHandler(servise *service.SubdivisionService) *SubdivisionHandler {
	return &SubdivisionHandler{service: servise}
}

func (h *SubdivisionHandler) List(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	subdivisions, err := h.service.List(ctx)

	if err != nil {
		slog.Error("failed to list subdivisions", "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to list subdivisions",
		})
		return
	}

	writeJSON(w, http.StatusOK, map[string]any{
		"items": subdivisions,
	})
}
