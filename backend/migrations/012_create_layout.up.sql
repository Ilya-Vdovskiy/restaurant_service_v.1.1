CREATE TABLE IF NOT EXISTS layout (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    subdivision_id UUID NOT NULL, -- но может быть одна раскладка и для нескольких подразделений сразу
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255)
);