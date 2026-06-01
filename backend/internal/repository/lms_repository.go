package repository

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"

	"github.com/Ilya-Vdovskiy/restaurant_service_v.1.1/internal/models"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type LMSRepository struct {
	db *pgxpool.Pool
}

func NewLMSRepository(db *pgxpool.Pool) *LMSRepository {
	return &LMSRepository{db: db}
}

func (r *LMSRepository) Authenticate(ctx context.Context, login, password string) (models.User, error) {
	const query = `
		SELECT u.id, u.restaurant_id, u.subdivision_id, u.email, u.phone, u.role::text, u.status::text,
		       u.last_name, u.first_name, u.middle_name, u.position, u.avatar_url, u.hired_at,
		       u.is_active, u.last_login_at, u.created_at, u.updated_at
		FROM auth_credentials ac
		JOIN users u ON u.id = ac.user_id
		WHERE ac.login = $1
		  AND ac.password_hash = crypt($2, ac.password_hash)
		  AND u.is_active = true
	`
	user, err := scanUser(r.db.QueryRow(ctx, query, login, password))
	if err != nil {
		return models.User{}, err
	}

	_, _ = r.db.Exec(ctx, `UPDATE users SET last_login_at = NOW() WHERE id = $1`, user.ID)
	return user, nil
}

func (r *LMSRepository) GetUserByID(ctx context.Context, id string) (models.User, error) {
	const query = `
		SELECT id, restaurant_id, subdivision_id, email, phone, role::text, status::text,
		       last_name, first_name, middle_name, position, avatar_url, hired_at,
		       is_active, last_login_at, created_at, updated_at
		FROM users
		WHERE id = $1 AND is_active = true
	`
	return scanUser(r.db.QueryRow(ctx, query, id))
}

func (r *LMSRepository) ListUsers(ctx context.Context, restaurantID string) ([]models.User, error) {
	const query = `
		SELECT id, restaurant_id, subdivision_id, email, phone, role::text, status::text,
		       last_name, first_name, middle_name, position, avatar_url, hired_at,
		       is_active, last_login_at, created_at, updated_at
		FROM users
		WHERE restaurant_id = $1 AND is_active = true
		ORDER BY last_name, first_name
	`
	rows, err := r.db.Query(ctx, query, restaurantID)
	if err != nil {
		return nil, fmt.Errorf("query users: %w", err)
	}
	defer rows.Close()

	users := make([]models.User, 0)
	for rows.Next() {
		user, err := scanUser(rows)
		if err != nil {
			return nil, err
		}
		users = append(users, user)
	}
	return users, rows.Err()
}

func (r *LMSRepository) CreateUser(ctx context.Context, restaurantID string, input models.UserInput) (models.User, error) {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return models.User{}, err
	}
	defer tx.Rollback(ctx)

	role := defaultString(input.Role, "employee")
	status := defaultString(input.Status, "active")
	const query = `
		INSERT INTO users (
			restaurant_id, subdivision_id, email, phone, role, status,
			last_name, first_name, middle_name, position, avatar_url
		)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
		RETURNING id, restaurant_id, subdivision_id, email, phone, role::text, status::text,
		          last_name, first_name, middle_name, position, avatar_url, hired_at,
		          is_active, last_login_at, created_at, updated_at
	`
	user, err := scanUser(tx.QueryRow(
		ctx, query, restaurantID, input.SubdivisionID, input.Email, input.Phone, role, status,
		input.LastName, input.FirstName, input.MiddleName, input.Position, input.AvatarURL,
	))
	if err != nil {
		return models.User{}, fmt.Errorf("create user: %w", err)
	}

	if input.Password != "" {
		_, err = tx.Exec(ctx, `
			INSERT INTO auth_credentials (user_id, login, password_hash, password_changed_at)
			VALUES ($1, $2, crypt($3, gen_salt('bf')), NOW())
		`, user.ID, input.Email, input.Password)
		if err != nil {
			return models.User{}, fmt.Errorf("create auth credentials: %w", err)
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return models.User{}, err
	}
	return user, nil
}

func (r *LMSRepository) ListCourses(ctx context.Context, restaurantID string) ([]models.Course, error) {
	const query = `
		SELECT id, restaurant_id, title, description, category::text, status::text,
		       estimated_duration_minutes, created_by_user_id, published_at, published_by_user_id,
		       is_active, created_at, updated_at
		FROM courses
		WHERE restaurant_id = $1 AND is_active = true
		ORDER BY created_at DESC
	`
	rows, err := r.db.Query(ctx, query, restaurantID)
	if err != nil {
		return nil, fmt.Errorf("query courses: %w", err)
	}
	defer rows.Close()

	courses := make([]models.Course, 0)
	for rows.Next() {
		course, err := scanCourse(rows)
		if err != nil {
			return nil, err
		}
		courses = append(courses, course)
	}
	return courses, rows.Err()
}

func (r *LMSRepository) GetCourse(ctx context.Context, restaurantID, id string) (models.Course, error) {
	const query = `
		SELECT id, restaurant_id, title, description, category::text, status::text,
		       estimated_duration_minutes, created_by_user_id, published_at, published_by_user_id,
		       is_active, created_at, updated_at
		FROM courses
		WHERE restaurant_id = $1 AND id = $2 AND is_active = true
	`
	course, err := scanCourse(r.db.QueryRow(ctx, query, restaurantID, id))
	if err != nil {
		return models.Course{}, err
	}
	course.Modules, err = r.listModules(ctx, course.ID)
	if err != nil {
		return models.Course{}, err
	}
	course.Exams, err = r.ListExamsByCourse(ctx, restaurantID, course.ID)
	if err != nil {
		return models.Course{}, err
	}
	return course, nil
}

func (r *LMSRepository) SaveCourse(ctx context.Context, restaurantID, actorID string, input models.CourseInput) (models.Course, error) {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return models.Course{}, err
	}
	defer tx.Rollback(ctx)

	category := defaultString(input.Category, "additional")
	status := defaultString(input.Status, "draft")
	var course models.Course

	if input.ID == nil || *input.ID == "" {
		const query = `
			INSERT INTO courses (restaurant_id, title, description, category, status, estimated_duration_minutes, created_by_user_id)
			VALUES ($1,$2,$3,$4,$5,$6,$7)
			RETURNING id, restaurant_id, title, description, category::text, status::text,
			          estimated_duration_minutes, created_by_user_id, published_at, published_by_user_id,
			          is_active, created_at, updated_at
		`
		course, err = scanCourse(tx.QueryRow(ctx, query, restaurantID, input.Title, input.Description, category, status, input.EstimatedDurationMinutes, actorID))
	} else {
		const query = `
			UPDATE courses
			SET title = $3, description = $4, category = $5, status = $6, estimated_duration_minutes = $7,
			    published_at = CASE WHEN $6 = 'published' AND published_at IS NULL THEN NOW() ELSE published_at END,
			    published_by_user_id = CASE WHEN $6 = 'published' AND published_by_user_id IS NULL THEN $8 ELSE published_by_user_id END
			WHERE restaurant_id = $1 AND id = $2
			RETURNING id, restaurant_id, title, description, category::text, status::text,
			          estimated_duration_minutes, created_by_user_id, published_at, published_by_user_id,
			          is_active, created_at, updated_at
		`
		course, err = scanCourse(tx.QueryRow(ctx, query, restaurantID, *input.ID, input.Title, input.Description, category, status, input.EstimatedDurationMinutes, actorID))
	}
	if err != nil {
		return models.Course{}, fmt.Errorf("save course: %w", err)
	}

	_, err = tx.Exec(ctx, `DELETE FROM course_modules WHERE course_id = $1`, course.ID)
	if err != nil {
		return models.Course{}, fmt.Errorf("replace modules: %w", err)
	}
	for idx, module := range input.Modules {
		position := module.Position
		if position <= 0 {
			position = idx + 1
		}
		var moduleID string
		err = tx.QueryRow(ctx, `
			INSERT INTO course_modules (course_id, title, description, position)
			VALUES ($1,$2,$3,$4)
			RETURNING id
		`, course.ID, module.Title, module.Description, position).Scan(&moduleID)
		if err != nil {
			return models.Course{}, fmt.Errorf("create module: %w", err)
		}
		for blockIdx, block := range module.Blocks {
			blockPosition := block.Position
			if blockPosition <= 0 {
				blockPosition = blockIdx + 1
			}
			content, err := json.Marshal(block.Content)
			if err != nil {
				return models.Course{}, fmt.Errorf("encode block content: %w", err)
			}
			_, err = tx.Exec(ctx, `
				INSERT INTO lesson_blocks (module_id, media_asset_id, type, position, content)
				VALUES ($1,$2,$3,$4,$5)
			`, moduleID, block.MediaAssetID, defaultString(block.Type, "text"), blockPosition, content)
			if err != nil {
				return models.Course{}, fmt.Errorf("create block: %w", err)
			}
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return models.Course{}, err
	}
	return r.GetCourse(ctx, restaurantID, course.ID)
}

func (r *LMSRepository) ArchiveCourse(ctx context.Context, restaurantID, id string) error {
	tag, err := r.db.Exec(ctx, `UPDATE courses SET is_active = false, status = 'archived' WHERE restaurant_id = $1 AND id = $2`, restaurantID, id)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return pgx.ErrNoRows
	}
	return nil
}

func (r *LMSRepository) ListExams(ctx context.Context, restaurantID string) ([]models.Exam, error) {
	const query = `
		SELECT e.id, e.course_id, e.title, e.description, e.passing_score_percent,
		       e.max_attempts, e.time_limit_minutes, e.is_active, e.shuffle_questions, e.shuffle_options,
		       e.created_at, e.updated_at
		FROM exams e
		JOIN courses c ON c.id = e.course_id
		WHERE c.restaurant_id = $1 AND c.is_active = true
		ORDER BY e.created_at DESC
	`
	return r.queryExams(ctx, query, restaurantID)
}

func (r *LMSRepository) ListExamsByCourse(ctx context.Context, restaurantID, courseID string) ([]models.Exam, error) {
	const query = `
		SELECT e.id, e.course_id, e.title, e.description, e.passing_score_percent,
		       e.max_attempts, e.time_limit_minutes, e.is_active, e.shuffle_questions, e.shuffle_options,
		       e.created_at, e.updated_at
		FROM exams e
		JOIN courses c ON c.id = e.course_id
		WHERE c.restaurant_id = $1 AND c.id = $2
		ORDER BY e.created_at DESC
	`
	return r.queryExams(ctx, query, restaurantID, courseID)
}

func (r *LMSRepository) GetExam(ctx context.Context, restaurantID, id string) (models.Exam, error) {
	const query = `
		SELECT e.id, e.course_id, e.title, e.description, e.passing_score_percent,
		       e.max_attempts, e.time_limit_minutes, e.is_active, e.shuffle_questions, e.shuffle_options,
		       e.created_at, e.updated_at
		FROM exams e
		JOIN courses c ON c.id = e.course_id
		WHERE c.restaurant_id = $1 AND e.id = $2
	`
	exam, err := scanExam(r.db.QueryRow(ctx, query, restaurantID, id))
	if err != nil {
		return models.Exam{}, err
	}
	exam.Questions, err = r.listQuestions(ctx, exam.ID, true)
	return exam, err
}

func (r *LMSRepository) SaveExam(ctx context.Context, restaurantID string, input models.ExamInput) (models.Exam, error) {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return models.Exam{}, err
	}
	defer tx.Rollback(ctx)

	var ownsCourse bool
	err = tx.QueryRow(ctx, `SELECT EXISTS (SELECT 1 FROM courses WHERE id = $1 AND restaurant_id = $2)`, input.CourseID, restaurantID).Scan(&ownsCourse)
	if err != nil {
		return models.Exam{}, err
	}
	if !ownsCourse {
		return models.Exam{}, pgx.ErrNoRows
	}

	var exam models.Exam
	if input.ID == nil || *input.ID == "" {
		exam, err = scanExam(tx.QueryRow(ctx, `
			INSERT INTO exams (course_id, title, description, passing_score_percent, max_attempts, time_limit_minutes, is_active, shuffle_questions, shuffle_options)
			VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
			RETURNING id, course_id, title, description, passing_score_percent, max_attempts, time_limit_minutes, is_active, shuffle_questions, shuffle_options, created_at, updated_at
		`, input.CourseID, input.Title, input.Description, input.PassingScorePercent, input.MaxAttempts, input.TimeLimitMinutes, input.IsActive, input.ShuffleQuestions, input.ShuffleOptions))
	} else {
		exam, err = scanExam(tx.QueryRow(ctx, `
			UPDATE exams
			SET course_id = $2, title = $3, description = $4, passing_score_percent = $5, max_attempts = $6,
			    time_limit_minutes = $7, is_active = $8, shuffle_questions = $9, shuffle_options = $10
			WHERE id = $1
			RETURNING id, course_id, title, description, passing_score_percent, max_attempts, time_limit_minutes, is_active, shuffle_questions, shuffle_options, created_at, updated_at
		`, *input.ID, input.CourseID, input.Title, input.Description, input.PassingScorePercent, input.MaxAttempts, input.TimeLimitMinutes, input.IsActive, input.ShuffleQuestions, input.ShuffleOptions))
	}
	if err != nil {
		return models.Exam{}, fmt.Errorf("save exam: %w", err)
	}

	_, err = tx.Exec(ctx, `DELETE FROM questions WHERE exam_id = $1`, exam.ID)
	if err != nil {
		return models.Exam{}, err
	}
	for idx, question := range input.Questions {
		position := question.Position
		if position <= 0 {
			position = idx + 1
		}
		points := question.Points
		if points <= 0 {
			points = 1
		}
		var questionID string
		err = tx.QueryRow(ctx, `
			INSERT INTO questions (exam_id, type, question_text, explanation, position, points)
			VALUES ($1,$2,$3,$4,$5,$6)
			RETURNING id
		`, exam.ID, defaultString(question.Type, "single_choice"), question.QuestionText, question.Explanation, position, points).Scan(&questionID)
		if err != nil {
			return models.Exam{}, err
		}
		for optionIdx, option := range question.Options {
			optionPosition := option.Position
			if optionPosition <= 0 {
				optionPosition = optionIdx + 1
			}
			_, err = tx.Exec(ctx, `
				INSERT INTO question_options (question_id, option_text, position, is_correct)
				VALUES ($1,$2,$3,$4)
			`, questionID, option.OptionText, optionPosition, option.IsCorrect)
			if err != nil {
				return models.Exam{}, err
			}
		}
	}
	if err := tx.Commit(ctx); err != nil {
		return models.Exam{}, err
	}
	return r.GetExam(ctx, restaurantID, exam.ID)
}

func (r *LMSRepository) CreateAssignment(ctx context.Context, restaurantID, actorID string, input models.AssignmentInput) (models.Assignment, error) {
	const query = `
		INSERT INTO course_assignments (course_id, target_restaurant_id, subdivision_id, user_id, assigned_by_user_id, due_at)
		SELECT $1, $2, $3, $4, $5, $6
		WHERE EXISTS (SELECT 1 FROM courses WHERE id = $1 AND restaurant_id = $7)
		RETURNING id, course_id, target_restaurant_id, subdivision_id, user_id, assigned_by_user_id, status::text, due_at, completed_at, created_at, updated_at
	`
	return scanAssignment(r.db.QueryRow(ctx, query, input.CourseID, input.TargetRestaurantID, input.SubdivisionID, input.UserID, actorID, input.DueAt, restaurantID))
}

func (r *LMSRepository) ListAssignments(ctx context.Context, restaurantID string) ([]models.Assignment, error) {
	const query = `
		SELECT ca.id, ca.course_id, ca.target_restaurant_id, ca.subdivision_id, ca.user_id, ca.assigned_by_user_id,
		       ca.status::text, ca.due_at, ca.completed_at, ca.created_at, ca.updated_at
		FROM course_assignments ca
		JOIN courses c ON c.id = ca.course_id
		WHERE c.restaurant_id = $1
		ORDER BY ca.created_at DESC
	`
	rows, err := r.db.Query(ctx, query, restaurantID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	assignments := make([]models.Assignment, 0)
	for rows.Next() {
		assignment, err := scanAssignment(rows)
		if err != nil {
			return nil, err
		}
		assignments = append(assignments, assignment)
	}
	return assignments, rows.Err()
}

func (r *LMSRepository) ListMobileCourses(ctx context.Context, userID string) ([]models.Course, error) {
	const query = `
		SELECT DISTINCT c.id, c.restaurant_id, c.title, c.description, c.category::text, c.status::text,
		       c.estimated_duration_minutes, c.created_by_user_id, c.published_at, c.published_by_user_id,
		       c.is_active, c.created_at, c.updated_at
		FROM courses c
		JOIN course_assignments ca ON ca.course_id = c.id
		LEFT JOIN users u ON u.id = $1
		WHERE c.status = 'published'
		  AND c.is_active = true
		  AND (ca.user_id = $1 OR ca.subdivision_id = u.subdivision_id OR ca.target_restaurant_id = u.restaurant_id)
		ORDER BY c.created_at DESC
	`
	rows, err := r.db.Query(ctx, query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	courses := make([]models.Course, 0)
	for rows.Next() {
		course, err := scanCourse(rows)
		if err != nil {
			return nil, err
		}
		courses = append(courses, course)
	}
	return courses, rows.Err()
}

func (r *LMSRepository) UpsertProgress(ctx context.Context, userID, courseID string, percent int) error {
	if percent < 0 {
		percent = 0
	}
	if percent > 100 {
		percent = 100
	}
	status := "in_progress"
	if percent == 100 {
		status = "completed"
	}
	_, err := r.db.Exec(ctx, `
		INSERT INTO user_course_progress (user_id, course_id, status, progress_percent, started_at, completed_at)
		VALUES ($1, $2, $3, $4, NOW(), CASE WHEN $4 = 100 THEN NOW() ELSE NULL END)
		ON CONFLICT (user_id, course_id, module_id, lesson_block_id)
		DO UPDATE SET status = EXCLUDED.status, progress_percent = EXCLUDED.progress_percent,
		              completed_at = EXCLUDED.completed_at
	`, userID, courseID, status, percent)
	return err
}

func (r *LMSRepository) StartExamAttempt(ctx context.Context, userID, examID string) (models.ExamAttempt, error) {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return models.ExamAttempt{}, err
	}
	defer tx.Rollback(ctx)

	var nextAttempt int
	err = tx.QueryRow(ctx, `SELECT COALESCE(MAX(attempt_number), 0) + 1 FROM exam_attempts WHERE user_id = $1 AND exam_id = $2`, userID, examID).Scan(&nextAttempt)
	if err != nil {
		return models.ExamAttempt{}, err
	}

	var maxAttempts *int
	err = tx.QueryRow(ctx, `SELECT max_attempts FROM exams WHERE id = $1 AND is_active = true`, examID).Scan(&maxAttempts)
	if err != nil {
		return models.ExamAttempt{}, err
	}
	if maxAttempts != nil && nextAttempt > *maxAttempts {
		return models.ExamAttempt{}, errors.New("max attempts exceeded")
	}

	attempt, err := scanAttempt(tx.QueryRow(ctx, `
		INSERT INTO exam_attempts (user_id, exam_id, attempt_number)
		VALUES ($1,$2,$3)
		RETURNING id, user_id, exam_id, status::text, attempt_number, started_at, finished_at, score_points, score_percent, is_final, created_at, updated_at
	`, userID, examID, nextAttempt))
	if err != nil {
		return models.ExamAttempt{}, err
	}
	if err := tx.Commit(ctx); err != nil {
		return models.ExamAttempt{}, err
	}
	return attempt, nil
}

func (r *LMSRepository) FinishExamAttempt(ctx context.Context, userID, attemptID string, answers []models.AnswerInput) (models.ExamAttempt, error) {
	tx, err := r.db.Begin(ctx)
	if err != nil {
		return models.ExamAttempt{}, err
	}
	defer tx.Rollback(ctx)

	var examID string
	var passingScore int
	err = tx.QueryRow(ctx, `
		SELECT ea.exam_id, e.passing_score_percent
		FROM exam_attempts ea
		JOIN exams e ON e.id = ea.exam_id
		WHERE ea.id = $1 AND ea.user_id = $2 AND ea.status = 'in_progress'
	`, attemptID, userID).Scan(&examID, &passingScore)
	if err != nil {
		return models.ExamAttempt{}, err
	}

	questions, err := r.listQuestionsWithQuerier(ctx, tx, examID, true)
	if err != nil {
		return models.ExamAttempt{}, err
	}
	questionByID := make(map[string]models.Question, len(questions))
	totalPoints := 0
	for _, question := range questions {
		questionByID[question.ID] = question
		totalPoints += question.Points
	}

	pointsAwarded := 0
	for _, answer := range answers {
		question, ok := questionByID[answer.QuestionID]
		if !ok {
			continue
		}
		isCorrect := false
		var selectedOptionID *string
		if answer.SelectedOptionID != nil {
			selectedOptionID = answer.SelectedOptionID
			for _, option := range question.Options {
				if option.ID == *answer.SelectedOptionID && option.IsCorrect {
					isCorrect = true
					break
				}
			}
		}
		awarded := 0
		if isCorrect {
			awarded = question.Points
			pointsAwarded += awarded
		}
		var answerID string
		err = tx.QueryRow(ctx, `
			INSERT INTO exam_attempt_answers (attempt_id, question_id, selected_option_id, answer_text, is_correct, points_awarded)
			VALUES ($1,$2,$3,$4,$5,$6)
			ON CONFLICT (attempt_id, question_id)
			DO UPDATE SET selected_option_id = EXCLUDED.selected_option_id, answer_text = EXCLUDED.answer_text,
			              is_correct = EXCLUDED.is_correct, points_awarded = EXCLUDED.points_awarded
			RETURNING id
		`, attemptID, answer.QuestionID, selectedOptionID, answer.AnswerText, isCorrect, awarded).Scan(&answerID)
		if err != nil {
			return models.ExamAttempt{}, err
		}
		for _, optionID := range answer.SelectedOptionIDs {
			_, _ = tx.Exec(ctx, `
				INSERT INTO exam_attempt_answer_options (attempt_answer_id, option_id)
				VALUES ($1,$2)
				ON CONFLICT DO NOTHING
			`, answerID, optionID)
		}
	}
	scorePercent := 0
	if totalPoints > 0 {
		scorePercent = (pointsAwarded * 100) / totalPoints
	}
	status := "failed"
	if scorePercent >= passingScore {
		status = "passed"
	}
	attempt, err := scanAttempt(tx.QueryRow(ctx, `
		UPDATE exam_attempts
		SET status = $3, finished_at = NOW(), score_points = $4, score_percent = $5, is_final = true
		WHERE id = $1 AND user_id = $2
		RETURNING id, user_id, exam_id, status::text, attempt_number, started_at, finished_at, score_points, score_percent, is_final, created_at, updated_at
	`, attemptID, userID, status, pointsAwarded, scorePercent))
	if err != nil {
		return models.ExamAttempt{}, err
	}
	if err := tx.Commit(ctx); err != nil {
		return models.ExamAttempt{}, err
	}
	return attempt, nil
}

func (r *LMSRepository) AnalyticsSummary(ctx context.Context, restaurantID string) (map[string]any, error) {
	row := r.db.QueryRow(ctx, `
		SELECT
			(SELECT COUNT(*) FROM users WHERE restaurant_id = $1 AND is_active = true),
			(SELECT COUNT(*) FROM courses WHERE restaurant_id = $1 AND is_active = true),
			(SELECT COUNT(*) FROM exam_attempts ea JOIN exams e ON e.id = ea.exam_id JOIN courses c ON c.id = e.course_id WHERE c.restaurant_id = $1 AND ea.finished_at IS NOT NULL),
			(SELECT COALESCE(ROUND(AVG(score_percent))::int, 0) FROM exam_attempts ea JOIN exams e ON e.id = ea.exam_id JOIN courses c ON c.id = e.course_id WHERE c.restaurant_id = $1 AND ea.score_percent IS NOT NULL)
	`, restaurantID)
	var usersCount, coursesCount, attemptsCount, avgScore int
	if err := row.Scan(&usersCount, &coursesCount, &attemptsCount, &avgScore); err != nil {
		return nil, err
	}
	return map[string]any{
		"users_count":    usersCount,
		"courses_count":  coursesCount,
		"attempts_count": attemptsCount,
		"avg_score":      avgScore,
	}, nil
}

func (r *LMSRepository) Reports(ctx context.Context, restaurantID string) ([]map[string]any, error) {
	summary, err := r.AnalyticsSummary(ctx, restaurantID)
	if err != nil {
		return nil, err
	}
	return []map[string]any{
		{"type": "summary", "title": "Сводный отчет по обучению", "format": "json", "data": summary},
	}, nil
}

type rowScanner interface {
	Scan(dest ...any) error
}

type queryer interface {
	Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error)
}

func scanUser(row rowScanner) (models.User, error) {
	var user models.User
	err := row.Scan(
		&user.ID, &user.RestaurantID, &user.SubdivisionID, &user.Email, &user.Phone, &user.Role, &user.Status,
		&user.LastName, &user.FirstName, &user.MiddleName, &user.Position, &user.AvatarURL, &user.HiredAt,
		&user.IsActive, &user.LastLoginAt, &user.CreatedAt, &user.UpdatedAt,
	)
	return user, err
}

func scanCourse(row rowScanner) (models.Course, error) {
	var course models.Course
	err := row.Scan(
		&course.ID, &course.RestaurantID, &course.Title, &course.Description, &course.Category, &course.Status,
		&course.EstimatedDurationMinutes, &course.CreatedByUserID, &course.PublishedAt, &course.PublishedByUserID,
		&course.IsActive, &course.CreatedAt, &course.UpdatedAt,
	)
	return course, err
}

func scanExam(row rowScanner) (models.Exam, error) {
	var exam models.Exam
	err := row.Scan(
		&exam.ID, &exam.CourseID, &exam.Title, &exam.Description, &exam.PassingScorePercent,
		&exam.MaxAttempts, &exam.TimeLimitMinutes, &exam.IsActive, &exam.ShuffleQuestions, &exam.ShuffleOptions,
		&exam.CreatedAt, &exam.UpdatedAt,
	)
	return exam, err
}

func scanAssignment(row rowScanner) (models.Assignment, error) {
	var assignment models.Assignment
	err := row.Scan(
		&assignment.ID, &assignment.CourseID, &assignment.TargetRestaurantID, &assignment.SubdivisionID, &assignment.UserID,
		&assignment.AssignedByUserID, &assignment.Status, &assignment.DueAt, &assignment.CompletedAt,
		&assignment.CreatedAt, &assignment.UpdatedAt,
	)
	return assignment, err
}

func scanAttempt(row rowScanner) (models.ExamAttempt, error) {
	var attempt models.ExamAttempt
	err := row.Scan(
		&attempt.ID, &attempt.UserID, &attempt.ExamID, &attempt.Status, &attempt.AttemptNumber,
		&attempt.StartedAt, &attempt.FinishedAt, &attempt.ScorePoints, &attempt.ScorePercent,
		&attempt.IsFinal, &attempt.CreatedAt, &attempt.UpdatedAt,
	)
	return attempt, err
}

func (r *LMSRepository) listModules(ctx context.Context, courseID string) ([]models.CourseModule, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, course_id, title, description, position, created_at, updated_at
		FROM course_modules
		WHERE course_id = $1
		ORDER BY position
	`, courseID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	modules := make([]models.CourseModule, 0)
	for rows.Next() {
		var module models.CourseModule
		if err := rows.Scan(&module.ID, &module.CourseID, &module.Title, &module.Description, &module.Position, &module.CreatedAt, &module.UpdatedAt); err != nil {
			return nil, err
		}
		module.Blocks, err = r.listBlocks(ctx, module.ID)
		if err != nil {
			return nil, err
		}
		modules = append(modules, module)
	}
	return modules, rows.Err()
}

func (r *LMSRepository) listBlocks(ctx context.Context, moduleID string) ([]models.LessonBlock, error) {
	rows, err := r.db.Query(ctx, `
		SELECT id, module_id, media_asset_id, type::text, position, content, created_at, updated_at
		FROM lesson_blocks
		WHERE module_id = $1
		ORDER BY position
	`, moduleID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	blocks := make([]models.LessonBlock, 0)
	for rows.Next() {
		var block models.LessonBlock
		var content []byte
		if err := rows.Scan(&block.ID, &block.ModuleID, &block.MediaAssetID, &block.Type, &block.Position, &content, &block.CreatedAt, &block.UpdatedAt); err != nil {
			return nil, err
		}
		_ = json.Unmarshal(content, &block.Content)
		blocks = append(blocks, block)
	}
	return blocks, rows.Err()
}

func (r *LMSRepository) queryExams(ctx context.Context, query string, args ...any) ([]models.Exam, error) {
	rows, err := r.db.Query(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	exams := make([]models.Exam, 0)
	for rows.Next() {
		exam, err := scanExam(rows)
		if err != nil {
			return nil, err
		}
		exam.Questions, _ = r.listQuestions(ctx, exam.ID, false)
		exams = append(exams, exam)
	}
	return exams, rows.Err()
}

func (r *LMSRepository) listQuestions(ctx context.Context, examID string, includeCorrect bool) ([]models.Question, error) {
	return r.listQuestionsWithQuerier(ctx, r.db, examID, includeCorrect)
}

func (r *LMSRepository) listQuestionsWithQuerier(ctx context.Context, q queryer, examID string, includeCorrect bool) ([]models.Question, error) {
	rows, err := q.Query(ctx, `
		SELECT id, exam_id, type::text, question_text, explanation, position, points, created_at, updated_at
		FROM questions
		WHERE exam_id = $1
		ORDER BY position
	`, examID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	questions := make([]models.Question, 0)
	for rows.Next() {
		var question models.Question
		if err := rows.Scan(&question.ID, &question.ExamID, &question.Type, &question.QuestionText, &question.Explanation, &question.Position, &question.Points, &question.CreatedAt, &question.UpdatedAt); err != nil {
			return nil, err
		}
		options, err := r.listOptionsWithQuerier(ctx, q, question.ID, includeCorrect)
		if err != nil {
			return nil, err
		}
		question.Options = options
		questions = append(questions, question)
	}
	return questions, rows.Err()
}

func (r *LMSRepository) listOptionsWithQuerier(ctx context.Context, q queryer, questionID string, includeCorrect bool) ([]models.QuestionOption, error) {
	rows, err := q.Query(ctx, `
		SELECT id, question_id, option_text, position, is_correct, created_at, updated_at
		FROM question_options
		WHERE question_id = $1
		ORDER BY position
	`, questionID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	options := make([]models.QuestionOption, 0)
	for rows.Next() {
		var option models.QuestionOption
		if err := rows.Scan(&option.ID, &option.QuestionID, &option.OptionText, &option.Position, &option.IsCorrect, &option.CreatedAt, &option.UpdatedAt); err != nil {
			return nil, err
		}
		if !includeCorrect {
			option.IsCorrect = false
		}
		options = append(options, option)
	}
	return options, rows.Err()
}

func defaultString(value, fallback string) string {
	if value == "" {
		return fallback
	}
	return value
}
