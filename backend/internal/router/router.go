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

	return mux
}
