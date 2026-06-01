package models

import "time"

type User struct {
	ID            string     `json:"id"`
	RestaurantID  string     `json:"restaurant_id"`
	SubdivisionID *string    `json:"subdivision_id,omitempty"`
	Email         string     `json:"email"`
	Phone         *string    `json:"phone,omitempty"`
	Role          string     `json:"role"`
	Status        string     `json:"status"`
	LastName      string     `json:"last_name"`
	FirstName     string     `json:"first_name"`
	MiddleName    *string    `json:"middle_name,omitempty"`
	Position      *string    `json:"position,omitempty"`
	AvatarURL     *string    `json:"avatar_url,omitempty"`
	HiredAt       *time.Time `json:"hired_at,omitempty"`
	IsActive      bool       `json:"is_active"`
	LastLoginAt   *time.Time `json:"last_login_at,omitempty"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}

type UserInput struct {
	SubdivisionID *string `json:"subdivision_id"`
	Email         string  `json:"email"`
	Password      string  `json:"password,omitempty"`
	Phone         *string `json:"phone"`
	Role          string  `json:"role"`
	Status        string  `json:"status"`
	LastName      string  `json:"last_name"`
	FirstName     string  `json:"first_name"`
	MiddleName    *string `json:"middle_name"`
	Position      *string `json:"position"`
	AvatarURL     *string `json:"avatar_url"`
}

type Course struct {
	ID                       string         `json:"id"`
	RestaurantID             string         `json:"restaurant_id"`
	Title                    string         `json:"title"`
	Description              *string        `json:"description,omitempty"`
	Category                 string         `json:"category"`
	Status                   string         `json:"status"`
	EstimatedDurationMinutes *int           `json:"estimated_duration_minutes,omitempty"`
	CreatedByUserID          *string        `json:"created_by_user_id,omitempty"`
	PublishedAt              *time.Time     `json:"published_at,omitempty"`
	PublishedByUserID        *string        `json:"published_by_user_id,omitempty"`
	IsActive                 bool           `json:"is_active"`
	Modules                  []CourseModule `json:"modules,omitempty"`
	Exams                    []Exam         `json:"exams,omitempty"`
	CreatedAt                time.Time      `json:"created_at"`
	UpdatedAt                time.Time      `json:"updated_at"`
}

type CourseModule struct {
	ID          string        `json:"id"`
	CourseID    string        `json:"course_id"`
	Title       string        `json:"title"`
	Description *string       `json:"description,omitempty"`
	Position    int           `json:"position"`
	Blocks      []LessonBlock `json:"blocks,omitempty"`
	CreatedAt   time.Time     `json:"created_at"`
	UpdatedAt   time.Time     `json:"updated_at"`
}

type LessonBlock struct {
	ID           string         `json:"id"`
	ModuleID     string         `json:"module_id"`
	MediaAssetID *string        `json:"media_asset_id,omitempty"`
	Type         string         `json:"type"`
	Position     int            `json:"position"`
	Content      map[string]any `json:"content"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
}

type CourseInput struct {
	ID                       *string             `json:"id"`
	Title                    string              `json:"title"`
	Description              *string             `json:"description"`
	Category                 string              `json:"category"`
	Status                   string              `json:"status"`
	EstimatedDurationMinutes *int                `json:"estimated_duration_minutes"`
	Modules                  []CourseModuleInput `json:"modules"`
}

type CourseModuleInput struct {
	ID          *string            `json:"id"`
	Title       string             `json:"title"`
	Description *string            `json:"description"`
	Position    int                `json:"position"`
	Blocks      []LessonBlockInput `json:"blocks"`
}

type LessonBlockInput struct {
	ID           *string        `json:"id"`
	MediaAssetID *string        `json:"media_asset_id"`
	Type         string         `json:"type"`
	Position     int            `json:"position"`
	Content      map[string]any `json:"content"`
}

type Exam struct {
	ID                  string     `json:"id"`
	CourseID            string     `json:"course_id"`
	Title               string     `json:"title"`
	Description         *string    `json:"description,omitempty"`
	PassingScorePercent int        `json:"passing_score_percent"`
	MaxAttempts         *int       `json:"max_attempts,omitempty"`
	TimeLimitMinutes    *int       `json:"time_limit_minutes,omitempty"`
	IsActive            bool       `json:"is_active"`
	ShuffleQuestions    bool       `json:"shuffle_questions"`
	ShuffleOptions      bool       `json:"shuffle_options"`
	Questions           []Question `json:"questions,omitempty"`
	CreatedAt           time.Time  `json:"created_at"`
	UpdatedAt           time.Time  `json:"updated_at"`
}

type Question struct {
	ID           string           `json:"id"`
	ExamID       string           `json:"exam_id"`
	Type         string           `json:"type"`
	QuestionText string           `json:"question_text"`
	Explanation  *string          `json:"explanation,omitempty"`
	Position     int              `json:"position"`
	Points       int              `json:"points"`
	Options      []QuestionOption `json:"options,omitempty"`
	CreatedAt    time.Time        `json:"created_at"`
	UpdatedAt    time.Time        `json:"updated_at"`
}

type QuestionOption struct {
	ID         string    `json:"id"`
	QuestionID string    `json:"question_id"`
	OptionText string    `json:"option_text"`
	Position   int       `json:"position"`
	IsCorrect  bool      `json:"is_correct,omitempty"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}

type ExamInput struct {
	ID                  *string         `json:"id"`
	CourseID            string          `json:"course_id"`
	Title               string          `json:"title"`
	Description         *string         `json:"description"`
	PassingScorePercent int             `json:"passing_score_percent"`
	MaxAttempts         *int            `json:"max_attempts"`
	TimeLimitMinutes    *int            `json:"time_limit_minutes"`
	IsActive            bool            `json:"is_active"`
	ShuffleQuestions    bool            `json:"shuffle_questions"`
	ShuffleOptions      bool            `json:"shuffle_options"`
	Questions           []QuestionInput `json:"questions"`
}

type QuestionInput struct {
	ID           *string               `json:"id"`
	Type         string                `json:"type"`
	QuestionText string                `json:"question_text"`
	Explanation  *string               `json:"explanation"`
	Position     int                   `json:"position"`
	Points       int                   `json:"points"`
	Options      []QuestionOptionInput `json:"options"`
}

type QuestionOptionInput struct {
	ID         *string `json:"id"`
	OptionText string  `json:"option_text"`
	Position   int     `json:"position"`
	IsCorrect  bool    `json:"is_correct"`
}

type Assignment struct {
	ID                 string     `json:"id"`
	CourseID           string     `json:"course_id"`
	TargetRestaurantID *string    `json:"target_restaurant_id,omitempty"`
	SubdivisionID      *string    `json:"subdivision_id,omitempty"`
	UserID             *string    `json:"user_id,omitempty"`
	AssignedByUserID   *string    `json:"assigned_by_user_id,omitempty"`
	Status             string     `json:"status"`
	DueAt              *time.Time `json:"due_at,omitempty"`
	CompletedAt        *time.Time `json:"completed_at,omitempty"`
	CreatedAt          time.Time  `json:"created_at"`
	UpdatedAt          time.Time  `json:"updated_at"`
}

type AssignmentInput struct {
	CourseID           string     `json:"course_id"`
	TargetRestaurantID *string    `json:"target_restaurant_id"`
	SubdivisionID      *string    `json:"subdivision_id"`
	UserID             *string    `json:"user_id"`
	DueAt              *time.Time `json:"due_at"`
}

type ExamAttempt struct {
	ID            string     `json:"id"`
	UserID        string     `json:"user_id"`
	ExamID        string     `json:"exam_id"`
	Status        string     `json:"status"`
	AttemptNumber int        `json:"attempt_number"`
	StartedAt     time.Time  `json:"started_at"`
	FinishedAt    *time.Time `json:"finished_at,omitempty"`
	ScorePoints   *int       `json:"score_points,omitempty"`
	ScorePercent  *int       `json:"score_percent,omitempty"`
	IsFinal       bool       `json:"is_final"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}

type AnswerInput struct {
	QuestionID        string   `json:"question_id"`
	SelectedOptionID  *string  `json:"selected_option_id"`
	SelectedOptionIDs []string `json:"selected_option_ids"`
	AnswerText        *string  `json:"answer_text"`
}
