CREATE TABLE IF NOT EXISTS restaurants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),,
    name VARCHAR(255) NOT NULL,
    address     TEXT,
    phone       VARCHAR(50),
    logo_url    TEXT,
    is_active   BOOLEAN NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_restaurant_name ON restaurant(name);
CREATE INDEX IF NOT EXISTS idx_restaurant_is_active ON restaurant(is_active);

-- Триггер обновления даты
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Триггер обновления даты с условием
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger 
        WHERE tgname = 'update_restaurants_updated_at'
    ) THEN
        CREATE TRIGGER update_restaurants_updated_at 
            BEFORE UPDATE ON restaurants 
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;