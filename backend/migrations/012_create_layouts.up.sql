CREATE TABLE IF NOT EXISTS layouts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_layouts_restaurant_active ON layouts(restaurant_id, is_active);

CREATE TABLE IF NOT EXISTS layout_subdivisions (
    layout_id UUID NOT NULL REFERENCES layouts(id) ON DELETE CASCADE,
    subdivision_id UUID NOT NULL REFERENCES subdivisions(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (layout_id, subdivision_id)
);

CREATE INDEX IF NOT EXISTS idx_layout_subdivisions_subdivision_id
    ON layout_subdivisions(subdivision_id);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_layouts_updated_at'
    ) THEN
        CREATE TRIGGER update_layouts_updated_at
            BEFORE UPDATE ON layouts
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
