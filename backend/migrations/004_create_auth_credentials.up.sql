CREATE TABLE IF NOT EXISTS auth_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    login VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    password_changed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id),
    UNIQUE (login)
);

CREATE INDEX IF NOT EXISTS idx_auth_credentials_user_id ON auth_credentials(user_id);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_auth_credentials_updated_at'
    ) THEN
        CREATE TRIGGER update_auth_credentials_updated_at
            BEFORE UPDATE ON auth_credentials
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
