CREATE TABLE IF NOT EXISTS authData (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_user UUID NOT NULL,
    login VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL
);