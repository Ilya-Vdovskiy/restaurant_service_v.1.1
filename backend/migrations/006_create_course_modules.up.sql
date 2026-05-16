CREATE TABLE IF NOT EXISTS course_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    position INTEGER NOT NULL CHECK (position > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (course_id, position)
);

CREATE INDEX IF NOT EXISTS idx_course_modules_course_position ON course_modules(course_id, position);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_course_modules_updated_at'
    ) THEN
        CREATE TRIGGER update_course_modules_updated_at
            BEFORE UPDATE ON course_modules
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
