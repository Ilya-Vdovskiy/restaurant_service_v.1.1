ALTER TABLE courses
    ADD COLUMN IF NOT EXISTS created_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS published_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS published_by_user_id UUID REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE exams
    ADD COLUMN IF NOT EXISTS shuffle_questions BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN IF NOT EXISTS shuffle_options BOOLEAN NOT NULL DEFAULT false;

CREATE TABLE IF NOT EXISTS exam_attempt_answer_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_answer_id UUID NOT NULL REFERENCES exam_attempt_answers(id) ON DELETE CASCADE,
    option_id UUID NOT NULL REFERENCES question_options(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (attempt_answer_id, option_id)
);

CREATE INDEX IF NOT EXISTS idx_exam_attempt_answer_options_answer_id
    ON exam_attempt_answer_options(attempt_answer_id);

DO $$
DECLARE
    v_restaurant_id UUID;
    v_subdivision_id UUID;
    v_manager_id UUID;
    v_employee_id UUID;
    v_course_id UUID;
    v_module_id UUID;
    v_exam_id UUID;
    v_question_id UUID;
BEGIN
    INSERT INTO restaurants (name, address, phone, logo_url)
    VALUES ('Restaurant Service Demo', 'Москва, ул. Демонстрационная, 1', '+7 999 000-00-00', NULL)
    ON CONFLICT DO NOTHING;

    SELECT id INTO v_restaurant_id
    FROM restaurants
    WHERE name = 'Restaurant Service Demo'
    ORDER BY created_at
    LIMIT 1;

    INSERT INTO subdivisions (restaurant_id, name, description)
    VALUES (v_restaurant_id, 'Зал', 'Сотрудники зала обслуживания')
    ON CONFLICT (restaurant_id, name) DO UPDATE SET description = EXCLUDED.description
    RETURNING id INTO v_subdivision_id;

    INSERT INTO users (
        restaurant_id, subdivision_id, email, phone, role, status,
        last_name, first_name, middle_name, position, hired_at
    )
    VALUES (
        v_restaurant_id, v_subdivision_id, 'manager@restaurant.local', '+7 999 100-00-00',
        'manager', 'active', 'Курсов', 'Руководитель', NULL, 'Руководитель', CURRENT_DATE
    )
    ON CONFLICT (restaurant_id, email) DO UPDATE SET
        role = EXCLUDED.role,
        status = EXCLUDED.status,
        last_name = EXCLUDED.last_name,
        first_name = EXCLUDED.first_name,
        position = EXCLUDED.position
    RETURNING id INTO v_manager_id;

    INSERT INTO users (
        restaurant_id, subdivision_id, email, phone, role, status,
        last_name, first_name, middle_name, position, hired_at
    )
    VALUES (
        v_restaurant_id, v_subdivision_id, 'employee@restaurant.local', '+7 999 200-00-00',
        'employee', 'training', 'Соколова', 'Анна', NULL, 'Су-шеф', CURRENT_DATE
    )
    ON CONFLICT (restaurant_id, email) DO UPDATE SET
        status = EXCLUDED.status,
        position = EXCLUDED.position
    RETURNING id INTO v_employee_id;

    INSERT INTO auth_credentials (user_id, login, password_hash, password_changed_at)
    VALUES (v_manager_id, 'manager@restaurant.local', crypt('manager123', gen_salt('bf')), NOW())
    ON CONFLICT (login) DO UPDATE SET
        user_id = EXCLUDED.user_id,
        password_hash = EXCLUDED.password_hash,
        password_changed_at = NOW();

    INSERT INTO auth_credentials (user_id, login, password_hash, password_changed_at)
    VALUES (v_employee_id, 'employee@restaurant.local', crypt('employee123', gen_salt('bf')), NOW())
    ON CONFLICT (login) DO UPDATE SET
        user_id = EXCLUDED.user_id,
        password_hash = EXCLUDED.password_hash,
        password_changed_at = NOW();

    INSERT INTO courses (
        restaurant_id, title, description, category, status,
        estimated_duration_minutes, created_by_user_id, published_at, published_by_user_id
    )
    VALUES (
        v_restaurant_id,
        'Пищевая безопасность HACCP',
        'Базовый курс по санитарным стандартам и безопасному хранению продуктов.',
        'mandatory',
        'published',
        240,
        v_manager_id,
        NOW(),
        v_manager_id
    )
    RETURNING id INTO v_course_id;

    INSERT INTO course_modules (course_id, title, description, position)
    VALUES (v_course_id, 'Введение', 'Основные правила пищевой безопасности.', 1)
    RETURNING id INTO v_module_id;

    INSERT INTO lesson_blocks (module_id, type, position, content)
    VALUES
        (v_module_id, 'text', 1, '{"text":"Проверяйте сроки годности, температуру хранения и маркировку продуктов."}'::jsonb),
        (v_module_id, 'warning', 2, '{"text":"Готовые блюда должны храниться при безопасной температуре."}'::jsonb);

    INSERT INTO exams (
        course_id, title, description, passing_score_percent,
        max_attempts, time_limit_minutes, is_active, shuffle_questions, shuffle_options
    )
    VALUES (
        v_course_id,
        'Проверка HACCP',
        'Короткий тест по основам пищевой безопасности.',
        80,
        3,
        30,
        true,
        false,
        false
    )
    RETURNING id INTO v_exam_id;

    INSERT INTO questions (exam_id, type, question_text, explanation, position, points)
    VALUES (v_exam_id, 'single_choice', 'Какая температура хранения готовых блюд считается безопасной?', 'Горячие блюда должны поддерживаться выше +65 °C.', 1, 1)
    RETURNING id INTO v_question_id;

    INSERT INTO question_options (question_id, option_text, position, is_correct)
    VALUES
        (v_question_id, 'выше +65 °C', 1, true),
        (v_question_id, '+25 °C', 2, false),
        (v_question_id, 'ниже +12 °C', 3, false);

    INSERT INTO course_assignments (course_id, user_id, assigned_by_user_id, status, due_at)
    VALUES (v_course_id, v_employee_id, v_manager_id, 'assigned', NOW() + INTERVAL '14 days')
    ON CONFLICT DO NOTHING;
END$$;
