CREATE TABLE IF NOT EXISTS dish (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    layout_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    cooking_method TEXT NOT NULL,
    components TEXT NOT NULL
);