CREATE TABLE IF NOT EXISTS exam (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    description TEXT NOT NULL,
    persent_change INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    course_id UUID,
    time_limit TIME
);