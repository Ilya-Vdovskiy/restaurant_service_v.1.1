-- Тип ENUM с проверкой
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'category') THEN
        CREATE TYPE category AS ENUM ('mandatory', 'urgent', 'additional');
    END IF;
END$$;

CREATE TABLE IF NOT EXISTS course (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    type category NOT NULL DEFAULT 'additional',
    description TEXT,
);