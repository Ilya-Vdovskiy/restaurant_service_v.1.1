CREATE TABLE IF NOT EXISTS courseData (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id course UUID NOT NULL,
    name_module VARCHAR(255) NOT NULL,
    text_data TEXT,
    media_data_url TEXT,
    serial_numder_in_course INTEGER NOT NULL
);