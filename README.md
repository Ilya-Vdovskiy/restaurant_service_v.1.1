# Restaurant Service LMS

Production-oriented MVP for a restaurant learning management service.

The repository contains:

- `backend` - Go API with PostgreSQL storage, JWT auth, migrations and LMS endpoints.
- `web_admin_app` - Vue 3 + Vite manager/admin web panel.
- `mobile_app` - Flutter employee application.
- `docker-compose.yml` - local production-like stack: PostgreSQL, backend API and web panel.

## MVP Scope

The current MVP covers the core training flow:

- manager login and authenticated API access;
- employees, courses, modules and lesson blocks;
- exams with questions and answer options;
- course assignments for employees;
- mobile course list, progress tracking, exam start and finish;
- analytics summary and reports for manager/admin roles.

## Demo Credentials

Migration `015_mvp_auth_and_seed` seeds demo data:

| Role | Login | Password |
| --- | --- | --- |
| Manager | `manager@restaurant.local` | `manager123` |
| Employee | `employee@restaurant.local` | `employee123` |

## Backend

### Environment

Copy `backend/.env.example` and adjust values if needed:

```bash
cd backend
cp .env.example .env
```

Important variables:

- `DATABASE_URL` - PostgreSQL connection string.
- `PORT` - API port, default `8080`.
- `JWT_SECRET` - signing secret for JWT tokens.
- `CORS_ORIGINS` - comma-separated allowed origins, for example `http://localhost:5173,http://localhost:8088`.

### Local Run

Start PostgreSQL separately, then:

```bash
cd backend
go mod download
go run ./cmd/server
```

Run tests:

```bash
cd backend
go test ./...
```

Health checks:

```bash
curl http://localhost:8080/healthz
curl http://localhost:8080/readyz
```

### Auth Smoke Test

```bash
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"login\":\"manager@restaurant.local\",\"password\":\"manager123\"}"
```

Use the returned token:

```bash
curl http://localhost:8080/me -H "Authorization: Bearer <TOKEN>"
```

## Web Admin

The web panel uses `VITE_API_BASE_URL` for API calls.

```bash
cd web_admin_app
npm install
npm run dev
```

For production build:

```bash
cd web_admin_app
npm run build
```

Default local URL is usually `http://localhost:5173`.

## Flutter Mobile

Run checks:

```bash
cd mobile_app
flutter pub get
flutter analyze
flutter test
```

Run on an emulator:

```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter devices
flutter run
```

For Android emulator networking, use `http://10.0.2.2:8080` as the backend URL when the app is configured for a local backend.

## Docker

Build and start the full stack:

```bash
docker compose up --build
```

Services:

- PostgreSQL: `localhost:5432`
- Backend API: `http://localhost:8080`
- Web admin: `http://localhost:8088`

Stop the stack:

```bash
docker compose down
```

Remove local database volume:

```bash
docker compose down -v
```

## Main API Contracts

Public:

- `POST /auth/login`

Authenticated:

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

## Deployment Notes

For a small VPS deployment:

1. Set strong `POSTGRES_PASSWORD` and `JWT_SECRET`.
2. Restrict `CORS_ORIGINS` to the public web domain.
3. Run `docker compose up -d --build`.
4. Put Nginx, Caddy or another reverse proxy in front of the web and backend services.
5. Terminate HTTPS at the reverse proxy.
6. Back up the PostgreSQL volume regularly.

Recommended reverse proxy layout:

- `/` -> web container on port `80`.
- `/api/*` -> backend container on port `8080`.

## Smoke Checklist

After deployment:

- Open web admin and login as `manager@restaurant.local`.
- Check `/healthz` and `/readyz`.
- Open Dashboard, Employees, Training, Tests, Assignments, Analytics and Reports.
- Create or edit a course with at least one module and lesson block.
- Create or edit an exam with questions and answer options.
- Assign a course to an employee.
- Login as employee through mobile/API and fetch assigned courses.
- Mark course progress and finish an exam attempt.
- Reopen analytics/reports and verify updated results.

