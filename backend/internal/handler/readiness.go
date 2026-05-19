package handler

import (
	"context"
	"net/http"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

type ReadinessHandler struct {
	db *pgxpool.Pool
}

func NewReadinessHandler(db *pgxpool.Pool) *ReadinessHandler {
	return &ReadinessHandler{db: db}
}

func (h *ReadinessHandler) Check(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
	defer cancel()

	response := map[string]any{
		"ready":    true,
		"database": "ok",
	}

	if err := h.db.Ping(ctx); err != nil {
		response["ready"] = false
		response["database"] = "unavailable"
		writeJSON(w, http.StatusServiceUnavailable, response)
		return
	}

	response["database"] = "ok"
	writeJSON(w, http.StatusOK, response)
}
