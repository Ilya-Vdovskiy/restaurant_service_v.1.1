CREATE TABLE IF NOT EXISTS subdivisions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255)
);

CREATE INDEX IF NOT EXISTS idx_subdivisions_name ON subdivisions(name);