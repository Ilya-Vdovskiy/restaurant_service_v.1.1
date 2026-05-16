CREATE TABLE IF NOT EXISTS exam_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    exam_id UUID NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    status exam_attempt_status NOT NULL DEFAULT 'in_progress',
    attempt_number INTEGER NOT NULL CHECK (attempt_number > 0),
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_at TIMESTAMPTZ,
    score_points INTEGER CHECK (score_points IS NULL OR score_points >= 0),
    score_percent INTEGER CHECK (score_percent IS NULL OR score_percent BETWEEN 0 AND 100),
    is_final BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, exam_id, attempt_number)
);

CREATE INDEX IF NOT EXISTS idx_exam_attempts_user_exam_finished_at
    ON exam_attempts(user_id, exam_id, finished_at DESC);
CREATE INDEX IF NOT EXISTS idx_exam_attempts_exam_id ON exam_attempts(exam_id);

CREATE TABLE IF NOT EXISTS exam_attempt_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id UUID NOT NULL REFERENCES exam_attempts(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    selected_option_id UUID REFERENCES question_options(id) ON DELETE SET NULL,
    answer_text TEXT,
    is_correct BOOLEAN,
    points_awarded INTEGER CHECK (points_awarded IS NULL OR points_awarded >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (attempt_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_exam_attempt_answers_attempt_id
    ON exam_attempt_answers(attempt_id);
CREATE INDEX IF NOT EXISTS idx_exam_attempt_answers_question_id
    ON exam_attempt_answers(question_id);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_exam_attempts_updated_at'
    ) THEN
        CREATE TRIGGER update_exam_attempts_updated_at
            BEFORE UPDATE ON exam_attempts
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_exam_attempt_answers_updated_at'
    ) THEN
        CREATE TRIGGER update_exam_attempt_answers_updated_at
            BEFORE UPDATE ON exam_attempt_answers
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
