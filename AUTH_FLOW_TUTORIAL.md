<!-- @format -->

# afara_auth Full-Stack Auth Tutorial

This guide explains how the authentication flow is wired together in the current workspace, based on the frontend app in `afara_project` and the backend in `backend`.

---

## 1) Architecture Overview

The auth module is split into three parts:

1. **Frontend (Flutter + Riverpod + GoRouter)**
   - Handles screens, form input, and UI state.
   - Uses Riverpod to manage auth state globally.
   - Uses Dio to call the backend API.

2. **Backend (Go + Gin)**
   - Exposes auth endpoints.
   - Validates requests.
   - Uses Keycloak for identity and token handling.
   - Uses PostgreSQL to track user activation status.

3. **Infrastructure**
   - Docker Compose runs PostgreSQL, Keycloak, Mailpit, and the API.

### High-level flow

- User registers → backend creates a disabled account in Keycloak + stores inactive user in DB → OTP is emailed.
- User verifies OTP → backend activates account.
- User logs in → backend validates credentials with Keycloak → returns tokens.
- Frontend stores tokens securely and attaches them to future API requests.
- Protected routes use JWT middleware on the backend.

---

## 2) Dependencies & Environment

### Frontend dependencies

The main Flutter dependencies are declared in `afara_project/pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^3.3.2
  dio: ^5.9.2
  flutter_secure_storage: ^9.0.0
  go_router: ^17.1.0
  provider: ^6.0.6
  http: ^1.6.0
```

### Backend dependencies

The backend dependencies are defined in `backend/go.mod`.

### Environment variables

The config loader is in `backend/internal/config/config.go`.

| Variable                 | Purpose           |
| ------------------------ | ----------------- |
| `PORT`                   | API port          |
| `DB_HOST`                | PostgreSQL host   |
| `DB_PORT`                | PostgreSQL port   |
| `DB_USER`                | DB username       |
| `DB_PASSWORD`            | DB password       |
| `DB_NAME`                | DB name           |
| `KEYCLOAK_URL`           | Keycloak base URL |
| `KEYCLOAK_REALM`         | Realm name        |
| `KEYCLOAK_CLIENT_ID`     | Client id         |
| `KEYCLOAK_CLIENT_SECRET` | Client secret     |
| `SMTP_HOST`              | Mail server host  |
| `SMTP_PORT`              | Mail server port  |
| `SMTP_SENDER`            | Sender email      |

---

## 3) Step-by-Step Implementation

### Step 1: Start all infrastructure services

Use Docker Compose to run the database, Keycloak, Mailpit, and API.

Typical command:

```bash
docker compose up -d
```

### Step 2: Configure backend settings

The backend reads environment values in `backend/internal/config/config.go`.

### Step 3: Initialize the Gin server

The main server setup is in `backend/cmd/api/main.go`.

### Step 4: Create the auth handler logic

The auth handlers are in `backend/internal/handler/auth.go`.

### Step 5: Implement JWT protection middleware

The middleware is in `backend/internal/middleware/jwt.go`.

### Step 6: Set up API constants on the frontend

The constants file is `afara_project/lib/core/constants.dart`.

### Step 7: Build the API client

The Dio client is in `afara_project/lib/core/api_client.dart`.

### Step 8: Securely store session data

The storage helper is in `afara_project/lib/core/local_storage.dart`.

### Step 9: Create the auth service

The service is in `afara_project/lib/features/auth/auth_service.dart`.

### Step 10: Add Riverpod auth state

The provider logic is in `afara_project/lib/features/auth/auth_providers.dart`.

### Step 11: Connect login screens to shared auth state

Relevant screens are in:

- `afara_project/lib/auth page/individuals_login.dart`
- `afara_project/lib/auth page/business_login.dart`

### Step 12: Add protected UI navigation

The navbar logic is in `afara_project/lib/shared/navbar.dart`.

---

## 4) Data Flow & State Management

### Registration flow

1. User enters email + password.
2. Flutter sends `POST /api/auth/register`.
3. Backend creates the account and sends OTP.
4. User is redirected to verification.

### OTP verification flow

1. User enters a code.
2. Flutter posts to `POST /api/auth/verify-otp`.
3. Backend checks the code and activates the account.

### Login flow

1. User enters email + password.
2. Flutter posts to `POST /api/auth/login`.
3. Backend returns tokens.
4. Frontend stores tokens and fetches profile data.

### Token maintenance

- access token is used for API calls.
- refresh token is used when the access token expires.
- API client attaches the access token automatically.

---

## 5) Testing & Verification

### Manual verification checklist

1. Start services with `docker compose up -d`.
2. Run the backend with `go run ./cmd/api`.
3. Run the frontend with `flutter run`.
4. Open Mailpit at `http://localhost:8025`.
5. Test registration, OTP verification, login, and protected routes.

---

## Final takeaway

The auth module works as a pipeline:

UI form → provider/state → API client → backend → Keycloak/DB → response → secure token storage → protected requests
