package handler

import (
	"context"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"strings"
	"time"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/auth"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/service"
	"github.com/jackc/pgx/v5"
)

type LMSHandler struct {
	service   *service.LMSService
	jwtSecret string
}

func NewLMSHandler(service *service.LMSService, jwtSecret string) *LMSHandler {
	return &LMSHandler{service: service, jwtSecret: jwtSecret}
}

func (h *LMSHandler) RequireAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		token := auth.BearerToken(r)
		if token == "" {
			writeJSON(w, http.StatusUnauthorized, map[string]string{"error": "authorization token is required"})
			return
		}
		claims, err := auth.ParseToken(token, h.jwtSecret)
		if err != nil {
			writeJSON(w, http.StatusUnauthorized, map[string]string{"error": "invalid or expired token"})
			return
		}
		ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
		defer cancel()
		user, err := h.service.GetUserByID(ctx, claims.Sub)
		if err != nil {
			writeJSON(w, http.StatusUnauthorized, map[string]string{"error": "user not found"})
			return
		}
		next.ServeHTTP(w, r.WithContext(auth.WithUser(r.Context(), user)))
	})
}

func (h *LMSHandler) RequireRoles(next http.HandlerFunc, roles ...string) http.HandlerFunc {
	roleSet := make(map[string]struct{}, len(roles))
	for _, role := range roles {
		roleSet[role] = struct{}{}
	}
	return func(w http.ResponseWriter, r *http.Request) {
		user, ok := auth.UserFromContext(r.Context())
		if !ok {
			writeJSON(w, http.StatusUnauthorized, map[string]string{"error": "auth context missing"})
			return
		}
		if _, ok := roleSet[user.Role]; !ok {
			writeJSON(w, http.StatusForbidden, map[string]string{"error": "insufficient permissions"})
			return
		}
		next(w, r)
	}
}

func (h *LMSHandler) Login(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Login    string `json:"login"`
		Password string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid json body"})
		return
	}
	ctx, cancel := context.WithTimeout(r.Context(), 5*time.Second)
	defer cancel()
	user, token, err := h.service.Login(ctx, req.Login, req.Password)
	if err != nil {
		writeJSON(w, http.StatusUnauthorized, map[string]string{"error": "invalid login or password"})
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{"token": token, "user": user})
}

func (h *LMSHandler) Me(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	writeJSON(w, http.StatusOK, user)
}

func (h *LMSHandler) ListUsers(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	items, err := withTimeout(r, func(ctx context.Context) ([]models.User, error) {
		return h.service.ListUsers(ctx, user.RestaurantID)
	})
	writeListOrError(w, "users", items, err)
}

func (h *LMSHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	var input models.UserInput
	if !decodeJSON(w, r, &input) {
		return
	}
	created, err := withTimeout(r, func(ctx context.Context) (models.User, error) {
		return h.service.CreateUser(ctx, user.RestaurantID, input)
	})
	writeCreatedOrError(w, created, err)
}

func (h *LMSHandler) ListCourses(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	items, err := withTimeout(r, func(ctx context.Context) ([]models.Course, error) {
		return h.service.ListCourses(ctx, user.RestaurantID)
	})
	writeListOrError(w, "courses", items, err)
}

func (h *LMSHandler) GetCourse(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	id := r.PathValue("id")
	item, err := withTimeout(r, func(ctx context.Context) (models.Course, error) {
		return h.service.GetCourse(ctx, user.RestaurantID, id)
	})
	writeItemOrError(w, item, err)
}

func (h *LMSHandler) SaveCourse(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	var input models.CourseInput
	if !decodeJSON(w, r, &input) {
		return
	}
	created, err := withTimeout(r, func(ctx context.Context) (models.Course, error) {
		return h.service.SaveCourse(ctx, user.RestaurantID, user.ID, input)
	})
	writeCreatedOrError(w, created, err)
}

func (h *LMSHandler) ArchiveCourse(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	id := r.PathValue("id")
	err := withTimeoutNoValue(r, func(ctx context.Context) error {
		return h.service.ArchiveCourse(ctx, user.RestaurantID, id)
	})
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]string{"status": "archived"})
}

func (h *LMSHandler) ListExams(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	items, err := withTimeout(r, func(ctx context.Context) ([]models.Exam, error) {
		return h.service.ListExams(ctx, user.RestaurantID)
	})
	writeListOrError(w, "exams", items, err)
}

func (h *LMSHandler) GetExam(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	id := r.PathValue("id")
	item, err := withTimeout(r, func(ctx context.Context) (models.Exam, error) {
		return h.service.GetExam(ctx, user.RestaurantID, id)
	})
	writeItemOrError(w, item, err)
}

func (h *LMSHandler) SaveExam(w http.ResponseWriter, r *http.Request) {
	var input models.ExamInput
	if !decodeJSON(w, r, &input) {
		return
	}
	user, _ := auth.UserFromContext(r.Context())
	item, err := withTimeout(r, func(ctx context.Context) (models.Exam, error) {
		return h.service.SaveExam(ctx, user.RestaurantID, input)
	})
	writeCreatedOrError(w, item, err)
}

func (h *LMSHandler) CreateAssignment(w http.ResponseWriter, r *http.Request) {
	var input models.AssignmentInput
	if !decodeJSON(w, r, &input) {
		return
	}
	user, _ := auth.UserFromContext(r.Context())
	item, err := withTimeout(r, func(ctx context.Context) (models.Assignment, error) {
		return h.service.CreateAssignment(ctx, user.RestaurantID, user.ID, input)
	})
	writeCreatedOrError(w, item, err)
}

func (h *LMSHandler) ListAssignments(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	items, err := withTimeout(r, func(ctx context.Context) ([]models.Assignment, error) {
		return h.service.ListAssignments(ctx, user.RestaurantID)
	})
	writeListOrError(w, "assignments", items, err)
}

func (h *LMSHandler) AnalyticsSummary(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	item, err := withTimeout(r, func(ctx context.Context) (map[string]any, error) {
		return h.service.AnalyticsSummary(ctx, user.RestaurantID)
	})
	writeItemOrError(w, item, err)
}

func (h *LMSHandler) Reports(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	items, err := withTimeout(r, func(ctx context.Context) ([]map[string]any, error) {
		return h.service.Reports(ctx, user.RestaurantID)
	})
	writeListOrError(w, "reports", items, err)
}

func (h *LMSHandler) MobileCourses(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	items, err := withTimeout(r, func(ctx context.Context) ([]models.Course, error) {
		return h.service.ListMobileCourses(ctx, user.ID)
	})
	writeListOrError(w, "courses", items, err)
}

func (h *LMSHandler) MobileCourse(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	id := r.PathValue("id")
	item, err := withTimeout(r, func(ctx context.Context) (models.Course, error) {
		return h.service.GetCourse(ctx, user.RestaurantID, id)
	})
	writeItemOrError(w, item, err)
}

func (h *LMSHandler) SaveProgress(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	var req struct {
		ProgressPercent int `json:"progress_percent"`
	}
	if !decodeJSON(w, r, &req) {
		return
	}
	err := withTimeoutNoValue(r, func(ctx context.Context) error {
		return h.service.UpsertProgress(ctx, user.ID, r.PathValue("id"), req.ProgressPercent)
	})
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]string{"status": "saved"})
}

func (h *LMSHandler) StartAttempt(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	item, err := withTimeout(r, func(ctx context.Context) (models.ExamAttempt, error) {
		return h.service.StartExamAttempt(ctx, user.ID, r.PathValue("id"))
	})
	writeCreatedOrError(w, item, err)
}

func (h *LMSHandler) FinishAttempt(w http.ResponseWriter, r *http.Request) {
	user, _ := auth.UserFromContext(r.Context())
	var req struct {
		Answers []models.AnswerInput `json:"answers"`
	}
	if !decodeJSON(w, r, &req) {
		return
	}
	item, err := withTimeout(r, func(ctx context.Context) (models.ExamAttempt, error) {
		return h.service.FinishExamAttempt(ctx, user.ID, r.PathValue("id"), req.Answers)
	})
	writeItemOrError(w, item, err)
}

func decodeJSON(w http.ResponseWriter, r *http.Request, dest any) bool {
	if err := json.NewDecoder(r.Body).Decode(dest); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid json body"})
		return false
	}
	return true
}

func withTimeout[T any](r *http.Request, fn func(context.Context) (T, error)) (T, error) {
	ctx, cancel := context.WithTimeout(r.Context(), 8*time.Second)
	defer cancel()
	return fn(ctx)
}

func withTimeoutNoValue(r *http.Request, fn func(context.Context) error) error {
	ctx, cancel := context.WithTimeout(r.Context(), 8*time.Second)
	defer cancel()
	return fn(ctx)
}

func writeListOrError[T any](w http.ResponseWriter, key string, items []T, err error) {
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, map[string]any{"items": items, "total": len(items), "key": key})
}

func writeItemOrError[T any](w http.ResponseWriter, item T, err error) {
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, item)
}

func writeCreatedOrError[T any](w http.ResponseWriter, item T, err error) {
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, item)
}

func writeError(w http.ResponseWriter, err error) {
	status := http.StatusInternalServerError
	message := "internal server error"
	if errors.Is(err, pgx.ErrNoRows) {
		status = http.StatusNotFound
		message = "not found"
	} else if strings.Contains(err.Error(), "required") || strings.Contains(err.Error(), "must be") || strings.Contains(err.Error(), "max attempts") {
		status = http.StatusBadRequest
		message = err.Error()
	} else {
		slog.Error("request failed", "error", err)
	}
	writeJSON(w, status, map[string]string{"error": message})
}
