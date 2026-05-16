CREATE TABLE IF NOT EXISTS exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    passing_score_percent INTEGER NOT NULL CHECK (passing_score_percent BETWEEN 0 AND 100),
    max_attempts INTEGER CHECK (max_attempts IS NULL OR max_attempts > 0),
    time_limit_minutes INTEGER CHECK (time_limit_minutes IS NULL OR time_limit_minutes > 0),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_exams_course_id ON exams(course_id);
CREATE INDEX IF NOT EXISTS idx_exams_course_active ON exams(course_id, is_active);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_exams_updated_at'
    ) THEN
        CREATE TRIGGER update_exams_updated_at
            BEFORE UPDATE ON exams
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
