-- Тип ENUM с проверкой
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'type_question') THEN
        CREATE TYPE type_question AS ENUM ('option', 'free');
    END IF;
END$$;

CREATE TABLE IF NOT EXISTS question (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    exam_id UUID NOT NULL,
    question_text TEXT NOT NULL,
    question_type type_question NOT NULL DEFAULT 'free',
    points INTEGER NOT NULL,
    attempt_count INTEGER NOT NULL,
    answer TEXT,  -- вопросы могут быть как с вариантами ответов, так и со свободным вводом
    is_correct BOOLEAN NOT NULL DEFAULT true
);