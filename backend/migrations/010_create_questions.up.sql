CREATE TABLE IF NOT EXISTS questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exam_id UUID NOT NULL REFERENCES exams(id) ON DELETE CASCADE,
    type question_type NOT NULL DEFAULT 'free_text',
    question_text TEXT NOT NULL,
    explanation TEXT,
    position INTEGER NOT NULL CHECK (position > 0),
    points INTEGER NOT NULL DEFAULT 1 CHECK (points > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (exam_id, position)
);

CREATE INDEX IF NOT EXISTS idx_questions_exam_position ON questions(exam_id, position);

CREATE TABLE IF NOT EXISTS question_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    position INTEGER NOT NULL CHECK (position > 0),
    is_correct BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (question_id, position)
);

CREATE INDEX IF NOT EXISTS idx_question_options_question_id ON question_options(question_id);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_questions_updated_at'
    ) THEN
        CREATE TRIGGER update_questions_updated_at
            BEFORE UPDATE ON questions
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_question_options_updated_at'
    ) THEN
        CREATE TRIGGER update_question_options_updated_at
            BEFORE UPDATE ON question_options
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
