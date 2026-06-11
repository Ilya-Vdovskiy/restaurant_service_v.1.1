# Restaurant Service LMS

Production-ready MVP сервиса для обучения сотрудников ресторана.

Репозиторий содержит:

- `backend` - Go API с PostgreSQL, JWT-авторизацией, миграциями и LMS-эндпоинтами.
- `web_admin_app` - веб-панель менеджера/администратора на Vue 3 + Vite.
- `mobile_app` - мобильное приложение сотрудника на Flutter.
- `docker-compose.yml` - локальный production-like стек: PostgreSQL, backend API и веб-панель.

## Объем MVP

Текущий MVP покрывает основной процесс обучения:

- вход менеджера и авторизованный доступ к API;
- сотрудники, курсы, модули и блоки уроков;
- экзамены с вопросами и вариантами ответов;
- назначение курсов сотрудникам;
- мобильный список курсов, отслеживание прогресса, старт и завершение экзамена;
- сводная аналитика и отчеты для ролей менеджера/администратора.

## Демо-доступы

Миграция `015_mvp_auth_and_seed` создает демо-данные:

| Роль | Логин | Пароль |
| --- | --- | --- |
| Менеджер | `manager@restaurant.local` | `manager123` |
| Сотрудник | `employee@restaurant.local` | `employee123` |

## Backend

### Окружение

Скопируйте `backend/.env.example` и при необходимости измените значения:

```bash
cd backend
cp .env.example .env
```

Важные переменные:

- `DATABASE_URL` - строка подключения к PostgreSQL.
- `PORT` - порт API, по умолчанию `8080`.
- `JWT_SECRET` - секрет для подписи JWT-токенов.
- `CORS_ORIGINS` - список разрешенных origins через запятую, например `http://localhost:5173,http://localhost:8088`.

### Локальный запуск

Сначала запустите PostgreSQL отдельно, затем:

```bash
cd backend
go mod download
go run ./cmd/server
```

Запуск тестов:

```bash
cd backend
go test ./...
```

Health checks:

```bash
curl http://localhost:8080/healthz
curl http://localhost:8080/readyz
```

### Smoke-тест авторизации

```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"login\":\"manager@restaurant.local\",\"password\":\"manager123\"}"
```

Используйте полученный токен:

```bash
curl http://localhost:8080/me -H "Authorization: Bearer <TOKEN>"
```

## Web Admin

Веб-панель использует `VITE_API_BASE_URL` для запросов к API.

```bash
cd web_admin_app
npm install
npm run dev
```

Production-сборка:

```bash
cd web_admin_app
npm run build
```

Локальный URL по умолчанию обычно `http://localhost:5173`.

## Flutter Mobile

Запуск проверок:

```bash
cd mobile_app
flutter pub get
flutter analyze
flutter test
```

Запуск на эмуляторе:

```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter devices
flutter run
```

Для Android-эмулятора используйте `http://10.0.2.2:8080` как URL backend, если приложение настроено на локальный backend.

## Docker

Собрать и запустить весь стек:

```bash
docker compose up --build
```

Сервисы:

- PostgreSQL: `localhost:5432`
- Backend API: `http://localhost:8080`
- Web admin: `http://localhost:8088`

Остановить стек:

```bash
docker compose down
```

Удалить локальный volume базы данных:

```bash
docker compose down -v
```

## Основные API-контракты

Публичные:

- `POST /auth/login`

Авторизованные:

- `GET /me`
- `GET /users`
- `POST /users`
- `GET /courses`
- `POST /courses`
- `GET /courses/{id}`
- `PATCH /courses/{id}`
- `POST /courses/{id}/archive`
- `GET /exams`
- `POST /exams`
- `GET /exams/{id}`
- `PATCH /exams/{id}`
- `GET /assignments`
- `POST /assignments`
- `GET /analytics/summary`
- `GET /reports`

Mobile:

- `GET /mobile/courses`
- `GET /mobile/courses/{id}`
- `POST /mobile/courses/{id}/progress`
- `POST /mobile/exams/{id}/start`
- `POST /mobile/exam-attempts/{id}/finish`

## Заметки по деплою

Для деплоя на небольшой VPS:

1. Задайте надежные `POSTGRES_PASSWORD` и `JWT_SECRET`.
2. Ограничьте `CORS_ORIGINS` публичным доменом веб-панели.
3. Запустите `docker compose up -d --build`.
4. Поставьте Nginx, Caddy или другой reverse proxy перед web и backend сервисами.
5. Завершайте HTTPS на reverse proxy.
6. Регулярно делайте резервные копии PostgreSQL volume.

Рекомендуемая схема reverse proxy:

- `/` -> web container на порту `80`.
- `/api/*` -> backend container на порту `8080`.

## Smoke-чеклист

После деплоя:

- Откройте web admin и войдите как `manager@restaurant.local`.
- Проверьте `/healthz` и `/readyz`.
- Откройте Dashboard, Employees, Training, Tests, Assignments, Analytics и Reports.
- Создайте или отредактируйте курс минимум с одним модулем и блоком урока.
- Создайте или отредактируйте экзамен с вопросами и вариантами ответов.
- Назначьте курс сотруднику.
- Войдите как сотрудник через mobile/API и получите назначенные курсы.
- Отметьте прогресс курса и завершите попытку экзамена.
- Снова откройте analytics/reports и проверьте обновленные результаты.
