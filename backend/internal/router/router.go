package router

import (
	"net/http"
	"strings"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/handler"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/repository"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
)

func New(db *pgxpool.Pool, jwtSecret, corsOrigins string) http.Handler {
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
	mux.HandleFunc("GET /restaurants/{restaurant_id}/subdivisions", subdivisionHandler.ListByRestaurantID)
	mux.HandleFunc("POST /restaurants/{restaurant_id}/subdivisions", subdivisionHandler.Create)

	lmsRepo := repository.NewLMSRepository(db)
	lmsService := service.NewLMSService(lmsRepo, jwtSecret)
	lmsHandler := handler.NewLMSHandler(lmsService, jwtSecret)
	protected := http.NewServeMux()

	mux.HandleFunc("POST /auth/login", lmsHandler.Login)
	protected.HandleFunc("GET /me", lmsHandler.Me)

	protected.HandleFunc("GET /users", lmsHandler.RequireRoles(lmsHandler.ListUsers, "manager", "admin", "super_admin"))
	protected.HandleFunc("POST /users", lmsHandler.RequireRoles(lmsHandler.CreateUser, "manager", "admin", "super_admin"))

	protected.HandleFunc("GET /courses", lmsHandler.RequireRoles(lmsHandler.ListCourses, "manager", "admin", "super_admin"))
	protected.HandleFunc("POST /courses", lmsHandler.RequireRoles(lmsHandler.SaveCourse, "manager", "admin", "super_admin"))
	protected.HandleFunc("GET /courses/{id}", lmsHandler.RequireRoles(lmsHandler.GetCourse, "manager", "admin", "super_admin"))
	protected.HandleFunc("PATCH /courses/{id}", lmsHandler.RequireRoles(lmsHandler.SaveCourse, "manager", "admin", "super_admin"))
	protected.HandleFunc("POST /courses/{id}/archive", lmsHandler.RequireRoles(lmsHandler.ArchiveCourse, "manager", "admin", "super_admin"))

	protected.HandleFunc("GET /exams", lmsHandler.RequireRoles(lmsHandler.ListExams, "manager", "admin", "super_admin"))
	protected.HandleFunc("POST /exams", lmsHandler.RequireRoles(lmsHandler.SaveExam, "manager", "admin", "super_admin"))
	protected.HandleFunc("GET /exams/{id}", lmsHandler.RequireRoles(lmsHandler.GetExam, "manager", "admin", "super_admin"))
	protected.HandleFunc("PATCH /exams/{id}", lmsHandler.RequireRoles(lmsHandler.SaveExam, "manager", "admin", "super_admin"))

	protected.HandleFunc("GET /assignments", lmsHandler.RequireRoles(lmsHandler.ListAssignments, "manager", "admin", "super_admin"))
	protected.HandleFunc("POST /assignments", lmsHandler.RequireRoles(lmsHandler.CreateAssignment, "manager", "admin", "super_admin"))
	protected.HandleFunc("GET /analytics/summary", lmsHandler.RequireRoles(lmsHandler.AnalyticsSummary, "manager", "admin", "super_admin"))
	protected.HandleFunc("GET /reports", lmsHandler.RequireRoles(lmsHandler.Reports, "manager", "admin", "super_admin"))

	protected.HandleFunc("GET /mobile/courses", lmsHandler.MobileCourses)
	protected.HandleFunc("GET /mobile/courses/{id}", lmsHandler.MobileCourse)
	protected.HandleFunc("POST /mobile/courses/{id}/progress", lmsHandler.SaveProgress)
	protected.HandleFunc("POST /mobile/exams/{id}/start", lmsHandler.StartAttempt)
	protected.HandleFunc("POST /mobile/exam-attempts/{id}/finish", lmsHandler.FinishAttempt)

	mux.Handle("/", lmsHandler.RequireAuth(protected))
	return withCORS(mux, corsOrigins)
}

func withCORS(next http.Handler, origins string) http.Handler {
	allowed := map[string]struct{}{}
	for _, origin := range strings.Split(origins, ",") {
		origin = strings.TrimSpace(origin)
		if origin != "" {
			allowed[origin] = struct{}{}
		}
	}

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		origin := r.Header.Get("Origin")
		if origins == "*" {
			w.Header().Set("Access-Control-Allow-Origin", "*")
		} else if _, ok := allowed[origin]; ok {
			w.Header().Set("Access-Control-Allow-Origin", origin)
			w.Header().Set("Vary", "Origin")
		}
		w.Header().Set("Access-Control-Allow-Headers", "Authorization, Content-Type")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS")
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}
