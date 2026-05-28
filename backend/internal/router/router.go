package router

import (
	"net/http"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/handler"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/repository"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
)

func New(db *pgxpool.Pool) http.Handler {
	mux := http.NewServeMux()

	healthHandler := handler.NewHealthHandler(db)
	mux.HandleFunc("GET /healthz", healthHandler.Check)

	readinessHandler := handler.NewReadinessHandler(db)
	mux.HandleFunc("GET /readyz", readinessHandler.Check)

	restaurantRepo := repository.NewRestaurantRepository(db)
	restaurantService := service.NewRestaurantService(restaurantRepo)
	restaurantHandler := handler.NewRestaurantHandler(restaurantService)
	mux.HandleFunc("GET /restaurants", restaurantHandler.List)
	mux.HandleFunc("POST /restaurants", restaurantHandler.Create)
	mux.HandleFunc("GET /restaurants/{id}", restaurantHandler.GetByID)
	mux.HandleFunc("PATCH /restaurants/{id}", restaurantHandler.Update)
	mux.HandleFunc("DELETE /restaurants/{id}", restaurantHandler.Deactivate)
	mux.HandleFunc("POST /restaurants/{id}/activate", restaurantHandler.Activate)

	subdivisionRepo := repository.NewSubdivisionRepository(db)
	subdivisionService := service.NewSubdivisionService(subdivisionRepo)
	subdivisionHandler := handler.NewSubdivisionHandler(subdivisionService)
	mux.HandleFunc("GET /subdivisions", subdivisionHandler.List)
	mux.HandleFunc("POST /subdivisions", subdivisionHandler.Create)

	return mux
}
