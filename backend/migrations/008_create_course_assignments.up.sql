CREATE TABLE IF NOT EXISTS course_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    target_restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    subdivision_id UUID REFERENCES subdivisions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    assigned_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    status assignment_status NOT NULL DEFAULT 'assigned',
    due_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (num_nonnulls(target_restaurant_id, subdivision_id, user_id) = 1)
);

CREATE INDEX IF NOT EXISTS idx_course_assignments_user_status_due_at
    ON course_assignments(user_id, status, due_at);
CREATE INDEX IF NOT EXISTS idx_course_assignments_subdivision_status_due_at
    ON course_assignments(subdivision_id, status, due_at);
CREATE INDEX IF NOT EXISTS idx_course_assignments_restaurant_status_due_at
    ON course_assignments(target_restaurant_id, status, due_at);
CREATE INDEX IF NOT EXISTS idx_course_assignments_course_id ON course_assignments(course_id);

CREATE TABLE IF NOT EXISTS user_course_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    module_id UUID REFERENCES course_modules(id) ON DELETE CASCADE,
    lesson_block_id UUID REFERENCES lesson_blocks(id) ON DELETE CASCADE,
    status progress_status NOT NULL DEFAULT 'not_started',
    progress_percent INTEGER NOT NULL DEFAULT 0 CHECK (progress_percent BETWEEN 0 AND 100),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE NULLS NOT DISTINCT (user_id, course_id, module_id, lesson_block_id)
);

CREATE INDEX IF NOT EXISTS idx_user_course_progress_user_course
    ON user_course_progress(user_id, course_id);
CREATE INDEX IF NOT EXISTS idx_user_course_progress_course_status
    ON user_course_progress(course_id, status);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_course_assignments_updated_at'
    ) THEN
        CREATE TRIGGER update_course_assignments_updated_at
            BEFORE UPDATE ON course_assignments
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_user_course_progress_updated_at'
    ) THEN
        CREATE TRIGGER update_user_course_progress_updated_at
            BEFORE UPDATE ON user_course_progress
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
