CREATE TABLE IF NOT EXISTS courseAssigment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id course UUID NOT NULL,
    subdivision_id  UUID,
    user_id UUID,
);

-- курс может быть назначен для всего персонала, для конкретного подразделения или человека