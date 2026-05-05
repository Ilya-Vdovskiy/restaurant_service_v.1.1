CREATE TABLE IF NOT EXISTS examAttempt (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    user_id UUID NOT NULL,
    exam_id UUID NOT NULL,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finish_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    attempts INTEGER NOT NULL,
    answer_text TEXT NOT NULL, - ответы на каждый вопрос надо еще как то записать
    is_final BOOLEAN NOT NULL DEFAULT false,
    points INTEGER
);