package service

import (
	"context"
	"errors"
	"strings"
	"time"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/auth"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/repository"
)

type LMSService struct {
	repo      *repository.LMSRepository
	jwtSecret string
}

func NewLMSService(repo *repository.LMSRepository, jwtSecret string) *LMSService {
	return &LMSService{repo: repo, jwtSecret: jwtSecret}
}

func (s *LMSService) Login(ctx context.Context, login, password string) (models.User, string, error) {
	login = strings.TrimSpace(strings.ToLower(login))
	if login == "" || password == "" {
		return models.User{}, "", errors.New("login and password are required")
	}
	user, err := s.repo.Authenticate(ctx, login, password)
	if err != nil {
		return models.User{}, "", err
	}
	token, err := auth.CreateToken(user, s.jwtSecret, 24*time.Hour)
	if err != nil {
		return models.User{}, "", err
	}
	return user, token, nil
}

func (s *LMSService) GetUserByID(ctx context.Context, id string) (models.User, error) {
	return s.repo.GetUserByID(ctx, id)
}

func (s *LMSService) ListUsers(ctx context.Context, restaurantID string) ([]models.User, error) {
	return s.repo.ListUsers(ctx, restaurantID)
}

func (s *LMSService) CreateUser(ctx context.Context, restaurantID string, input models.UserInput) (models.User, error) {
	if strings.TrimSpace(input.Email) == "" || strings.TrimSpace(input.LastName) == "" || strings.TrimSpace(input.FirstName) == "" {
		return models.User{}, errors.New("email, last_name and first_name are required")
	}
	return s.repo.CreateUser(ctx, restaurantID, input)
}

func (s *LMSService) ListCourses(ctx context.Context, restaurantID string) ([]models.Course, error) {
	return s.repo.ListCourses(ctx, restaurantID)
}

func (s *LMSService) GetCourse(ctx context.Context, restaurantID, id string) (models.Course, error) {
	return s.repo.GetCourse(ctx, restaurantID, id)
}

func (s *LMSService) SaveCourse(ctx context.Context, restaurantID, actorID string, input models.CourseInput) (models.Course, error) {
	if strings.TrimSpace(input.Title) == "" {
		return models.Course{}, errors.New("course title is required")
	}
	for i := range input.Modules {
		if input.Modules[i].Position <= 0 {
			input.Modules[i].Position = i + 1
		}
		if strings.TrimSpace(input.Modules[i].Title) == "" {
			return models.Course{}, errors.New("module title is required")
		}
		for j := range input.Modules[i].Blocks {
			if input.Modules[i].Blocks[j].Position <= 0 {
				input.Modules[i].Blocks[j].Position = j + 1
			}
			if input.Modules[i].Blocks[j].Content == nil || len(input.Modules[i].Blocks[j].Content) == 0 {
				return models.Course{}, errors.New("lesson block content is required")
			}
		}
	}
	return s.repo.SaveCourse(ctx, restaurantID, actorID, input)
}

func (s *LMSService) ArchiveCourse(ctx context.Context, restaurantID, id string) error {
	return s.repo.ArchiveCourse(ctx, restaurantID, id)
}

func (s *LMSService) ListExams(ctx context.Context, restaurantID string) ([]models.Exam, error) {
	return s.repo.ListExams(ctx, restaurantID)
}

func (s *LMSService) GetExam(ctx context.Context, restaurantID, id string) (models.Exam, error) {
	return s.repo.GetExam(ctx, restaurantID, id)
}

func (s *LMSService) SaveExam(ctx context.Context, restaurantID string, input models.ExamInput) (models.Exam, error) {
	if strings.TrimSpace(input.CourseID) == "" || strings.TrimSpace(input.Title) == "" {
		return models.Exam{}, errors.New("course_id and title are required")
	}
	if input.PassingScorePercent < 0 || input.PassingScorePercent > 100 {
		return models.Exam{}, errors.New("passing_score_percent must be between 0 and 100")
	}
	for i := range input.Questions {
		if input.Questions[i].Position <= 0 {
			input.Questions[i].Position = i + 1
		}
		if input.Questions[i].Points <= 0 {
			input.Questions[i].Points = 1
		}
		if strings.TrimSpace(input.Questions[i].QuestionText) == "" {
			return models.Exam{}, errors.New("question_text is required")
		}
	}
	return s.repo.SaveExam(ctx, restaurantID, input)
}

func (s *LMSService) CreateAssignment(ctx context.Context, restaurantID, actorID string, input models.AssignmentInput) (models.Assignment, error) {
	targets := 0
	if input.TargetRestaurantID != nil {
		targets++
	}
	if input.SubdivisionID != nil {
		targets++
	}
	if input.UserID != nil {
		targets++
	}
	if input.CourseID == "" || targets != 1 {
		return models.Assignment{}, errors.New("course_id and exactly one target are required")
	}
	return s.repo.CreateAssignment(ctx, restaurantID, actorID, input)
}

func (s *LMSService) ListAssignments(ctx context.Context, restaurantID string) ([]models.Assignment, error) {
	return s.repo.ListAssignments(ctx, restaurantID)
}

func (s *LMSService) ListMobileCourses(ctx context.Context, userID string) ([]models.Course, error) {
	return s.repo.ListMobileCourses(ctx, userID)
}

func (s *LMSService) UpsertProgress(ctx context.Context, userID, courseID string, percent int) error {
	if courseID == "" {
		return errors.New("course_id is required")
	}
	return s.repo.UpsertProgress(ctx, userID, courseID, percent)
}

func (s *LMSService) StartExamAttempt(ctx context.Context, userID, examID string) (models.ExamAttempt, error) {
	if examID == "" {
		return models.ExamAttempt{}, errors.New("exam_id is required")
	}
	return s.repo.StartExamAttempt(ctx, userID, examID)
}

func (s *LMSService) FinishExamAttempt(ctx context.Context, userID, attemptID string, answers []models.AnswerInput) (models.ExamAttempt, error) {
	if attemptID == "" {
		return models.ExamAttempt{}, errors.New("attempt_id is required")
	}
	return s.repo.FinishExamAttempt(ctx, userID, attemptID, answers)
}

func (s *LMSService) AnalyticsSummary(ctx context.Context, restaurantID string) (map[string]any, error) {
	return s.repo.AnalyticsSummary(ctx, restaurantID)
}

func (s *LMSService) Reports(ctx context.Context, restaurantID string) ([]map[string]any, error) {
	return s.repo.Reports(ctx, restaurantID)
}
