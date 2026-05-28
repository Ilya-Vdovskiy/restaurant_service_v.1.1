package handler

import (
	"context"
	"encoding/json"
	"log/slog"
	"net/http"
	"strings"
	"time"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
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

type createSubdivisionRequest struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}

func (h *SubdivisionHandler) Create(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()

	var req createSubdivisionRequest

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

	subdivision := models.Subdivision{
		Name:        req.Name,
		Description: cleanOptionalString(&req.Description),
	}

	created, err := h.service.Create(ctx, subdivision)
	if err != nil {
		slog.Error("failed to list subdivision", "error", err)
		writeJSON(w, http.StatusInternalServerError, map[string]string{
			"error": "failed to list subdivision",
		})
		return
	}

	writeJSON(w, http.StatusCreated, created)
}
