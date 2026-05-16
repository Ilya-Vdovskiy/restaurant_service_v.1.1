CREATE TABLE IF NOT EXISTS dishes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    layout_id UUID NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    cooking_method TEXT,
    components JSONB NOT NULL CHECK (jsonb_typeof(components) IN ('array', 'object')),
    position INTEGER NOT NULL DEFAULT 1 CHECK (position > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (layout_id, position)
);

CREATE INDEX IF NOT EXISTS idx_dishes_layout_position ON dishes(layout_id, position);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_dishes_updated_at'
    ) THEN
        CREATE TRIGGER update_dishes_updated_at
            BEFORE UPDATE ON dishes
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
