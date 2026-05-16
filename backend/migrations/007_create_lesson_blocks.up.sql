CREATE TABLE IF NOT EXISTS lesson_blocks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID NOT NULL REFERENCES course_modules(id) ON DELETE CASCADE,
    media_asset_id UUID REFERENCES media_assets(id) ON DELETE SET NULL,
    type lesson_block_type NOT NULL,
    position INTEGER NOT NULL CHECK (position > 0),
    content JSONB NOT NULL CHECK (
        jsonb_typeof(content) = 'object'
        AND content <> '{}'::jsonb
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (module_id, position)
);

CREATE INDEX IF NOT EXISTS idx_lesson_blocks_module_position ON lesson_blocks(module_id, position);
CREATE INDEX IF NOT EXISTS idx_lesson_blocks_media_asset_id ON lesson_blocks(media_asset_id);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_trigger
        WHERE tgname = 'update_lesson_blocks_updated_at'
    ) THEN
        CREATE TRIGGER update_lesson_blocks_updated_at
            BEFORE UPDATE ON lesson_blocks
            FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    END IF;
END$$;
