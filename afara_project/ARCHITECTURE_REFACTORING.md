<!-- @format -->

# Afara Project - Architecture Refactoring & Enhancement Summary

## Overview

This document summarizes the comprehensive refactoring and improvements made to the Afara Flutter frontend project, including clean architecture implementation, GoRouter integration, and the addition of a forgot password flow.

---

## 1. Architecture Refactoring - Clean Architecture Implementation

### Folder Structure

The project now follows Clean Architecture principles with proper separation of concerns:

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_data_source.dart      # Remote API calls
│   ├── models/
│   │   ├── user_model.dart                   # User data model
│   │   ├── login_request_model.dart          # Login request DTO
│   │   └── forgot_password_request_model.dart # Forgot password request DTO
│   └── repositories/
│       └── auth_repository_impl.dart         # Repository implementation
├── domain/
│   ├── entities/
│   │   └── user_entity.dart                  # Core domain entity
│   ├── repositories/
│   │   └── auth_repository.dart              # Abstract repository
│   └── usecases/
│       └── auth_usecases.dart                # Business logic use cases
└── presentation/
    ├── providers/
    │   └── auth_provider.dart                # State management with Provider
    ├── screens/
    │   └── forgot_password_screen.dart       # Forgot password UI
    ├── widgets/
    └── ...
```

### Layer Responsibilities

**Data Layer** (`data/`):

- Handles all data retrieval and persistence
- `datasources/`: Direct API communication via HTTP client
- `models/`: Data models that mirror API responses
- `repositories/`: Implements abstract repositories with data access logic

**Domain Layer** (`domain/`):

- Contains pure business logic, free from framework dependencies
- `entities/`: Core domain objects (UserEntity)
- `repositories/`: Abstract repository interfaces
- `usecases/`: Encapsulates business logic (LoginIndividualUseCase, ForgotPasswordUseCase, etc.)

**Presentation Layer** (`presentation/`):

- UI components and state management
- `providers/`: AuthNotifier for state management + ServiceLocator for DI
- `screens/`: Screen components (ForgotPasswordScreen)
- `widgets/`: Reusable UI widgets

### Dependency Injection (ServiceLocator)

All dependencies are registered in `ServiceLocator` (in `auth_provider.dart`):

```dart
// Initialize at app startup in main.dart
ServiceLocator.setupServices();

// Create notifier
final authNotifier = ServiceLocator.createAuthNotifier();
```

---

## 2. GoRouter Integration - Declarative Routing

### Updated Route Structure

All navigation is now handled by GoRouter with declarative route definitions:

```
/                                    → Landing Page
/pricing                             → Pricing Page
/resources                           → Resources Page
/auth/
  ├── individual/
  │   ├── login                      → Individual Login
  │   ├── register                   → Individual Registration
  │   ├── verification               → Individual Verification
  │   └── forgot-password            → Forgot Password (NEW)
  ├── business/
  │   ├── login                      → Business Login
  │   ├── register                   → Business Registration
  │   ├── verification               → Business Verification
  │   └── forgot-password            → Forgot Password (NEW)
```

### Legacy Route Compatibility

Old routes redirect to new routes:

- `/personal-registration` → `/auth/individual/register`
- `/individual-login` → `/auth/individual/login`
- `/bussiness-singup` → `/auth/business/register`
- `/bussiness-login` → `/auth/business/login`
- `/verificationpage` → `/auth/business/verification`
- `/PersonalVerification` → `/auth/individual/verification`

### Navigation Usage

All imperative navigation (`Navigator.push/pop`) has been replaced with GoRouter:

```dart
// Navigate to forgot password
context.go('/auth/individual/forgot-password');

// Navigate back to login
context.go('/auth/individual/login');

// Use named routes (optional)
context.goNamed('individual-forgot-password');
```

---

## 3. Forgot Password Flow

### New Components

#### ForgotPasswordScreen (`presentation/screens/forgot_password_screen.dart`)

- Email input field with validation
- Integrated with AuthNotifier for state management
- Three states:
  1. **Form State**: Shows email input field and submit button
  2. **Loading State**: Shows loading indicator
  3. **Success/Error State**: Shows confirmation or error message

#### Routes Added

- `/auth/individual/forgot-password` - Individual user forgot password
- `/auth/business/forgot-password` - Business user forgot password

### Updated Login Pages

#### Individual Login (`individuals_login.dart`)

- Added "Forgot Password?" link that navigates to forgot password screen
- Link is styled consistently with the design

#### Business Login (`business_login.dart`)

- Added "Forgot Password?" link
- Maintains design consistency

### Authentication Flow

```
1. User clicks "Forgot Password?" link
   ↓
2. Navigate to ForgotPasswordScreen
   ↓
3. User enters email and submits
   ↓
4. AuthNotifier calls forgotPasswordUseCase
   ↓
5. Use case calls repository.forgotPassword(email)
   ↓
6. Repository calls remoteDataSource.forgotPassword(email)
   ↓
7. Remote data source makes POST request to /api/auth/forgot-password
   ↓
8. On success: Show success message with "Back to Login" button
   ↓
9. On error: Show error message with "Try Again" button
```

---

## 4. Key Files & Changes

### Core Architecture Files

| File                                                              | Purpose                                                   |
| ----------------------------------------------------------------- | --------------------------------------------------------- |
| `lib/main.dart`                                                   | App initialization with ServiceLocator and Provider setup |
| `lib/router/app_router.dart`                                      | GoRouter configuration with all routes                    |
| `lib/features/auth/presentation/providers/auth_provider.dart`     | State management, use cases, and DI                       |
| `lib/features/auth/domain/usecases/auth_usecases.dart`            | Business logic encapsulation                              |
| `lib/features/auth/data/datasources/auth_remote_data_source.dart` | API communication                                         |

### Updated Navigation Files

| File                                                 | Changes                            |
| ---------------------------------------------------- | ---------------------------------- |
| `lib/shared/navbar.dart`                             | Updated to use new GoRouter routes |
| `lib/features/landing/screen/hero.dart`              | Updated signup navigation routes   |
| `lib/features/auth/individuals_login.dart`           | Added forgot password link         |
| `lib/features/auth/business_login.dart`              | Added forgot password link         |
| `lib/features/auth/for_individual_registration.dart` | Updated all navigation routes      |
| `lib/features/auth/for_business_registration.dart`   | Updated all navigation routes      |

---

## 5. State Management (AuthNotifier)

The `AuthNotifier` extends `ChangeNotifier` and manages auth state:

```dart
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
}

class AuthNotifier extends ChangeNotifier {
  // Methods:
  Future<void> loginIndividual(String email, String password)
  Future<void> loginBusiness(String email, String password, String organizationUrl)
  Future<void> registerIndividual(...)
  Future<void> registerBusiness(...)
  Future<void> forgotPassword(String email)  // NEW
  Future<void> logout()
  void clearError()
}
```

### Usage in Widgets

```dart
Consumer<AuthNotifier>(
  builder: (context, authNotifier, _) {
    if (authNotifier.state.isLoading) {
      return LoadingWidget();
    }
    if (authNotifier.state.error != null) {
      return ErrorWidget(error: authNotifier.state.error);
    }
    // Show success or form
  },
)
```

---

## 6. API Integration

### Remote Data Source

Located in `data/datasources/auth_remote_data_source.dart`

**Endpoints Expected:**

- `POST /api/auth/login/individual` - Individual login
- `POST /api/auth/login/business` - Business login
- `POST /api/auth/register/individual` - Individual registration
- `POST /api/auth/register/business` - Business registration
- `POST /api/auth/forgot-password` - Request password reset (NEW)

**Base URL:**
Update in `ServiceLocator.setupServices()`:

```dart
baseUrl: 'http://localhost:8080/api' // Change to your API URL
```

### Request/Response Models

**Forgot Password Request:**

```json
{
  "email": "user@example.com"
}
```

**Expected Response (Success):**

```json
{
  "statusCode": 200,
  "message": "Password reset email sent successfully"
}
```

---

## 7. Configuration & Setup

### Dependencies

Ensure these packages are in `pubspec.yaml`:

- `go_router: ^17.1.0`
- `provider: ^6.0.6`
- `http: ^1.6.0`
- `google_fonts: ^8.1.0`
- `flutter_secure_storage: ^9.0.0` (for future token storage)

### Initialization

```dart
void main() {
  // Initialize services and routes
  ServiceLocator.setupServices();
  runApp(const AfaraApp());
}
```

### Provider Setup

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthNotifier>(
      create: (_) => ServiceLocator.createAuthNotifier(),
    ),
  ],
  child: MaterialApp.router(...),
)
```

---

## 8. Best Practices Implemented

✅ **Separation of Concerns**: Each layer has specific responsibilities  
✅ **Dependency Injection**: All dependencies managed via ServiceLocator  
✅ **Testability**: Use cases and repositories can be easily mocked  
✅ **Declarative Navigation**: No imperative navigation (Navigator.push/pop)  
✅ **State Management**: Centralized AuthNotifier for all auth state  
✅ **Error Handling**: Proper error states in UI with user feedback  
✅ **Validation**: Email validation in forgot password form  
✅ **Code Organization**: Clear folder structure following clean architecture

---

## 9. Next Steps & Future Improvements

### Immediate TODOs

1. **Update API Base URL**: Change `baseUrl` in `ServiceLocator` to your backend
2. **Implement Token Storage**: Use `flutter_secure_storage` to save JWT tokens
3. **Add Logout Logic**: Implement logout in `AuthRepositoryImpl.logout()`
4. **Add Loading/Error UI States**: Enhance screens with better error handling

### Future Enhancements

1. **Reset Password Screen**: Add screen to complete password reset with token
2. **Session Management**: Implement automatic token refresh
3. **Offline Support**: Add local caching with Hive or SQLite
4. **Unit Tests**: Write tests for use cases and repositories
5. **Error Recovery**: Add retry logic with exponential backoff
6. **Analytics**: Track auth flows for user insights
7. **Two-Factor Authentication**: Add optional 2FA support

---

## 10. Troubleshooting

### Routes Not Working

- Ensure `ServiceLocator.setupServices()` is called in `main.dart`
- Check that GoRouter is properly configured in `MaterialApp.router`

### State Not Updating

- Ensure widgets are wrapped with `Consumer<AuthNotifier>`
- Call `notifyListeners()` after state changes in AuthNotifier

### API Errors

- Verify API base URL is correct
- Check network connectivity
- Review backend API documentation for endpoint details
- Check error messages in console

---

## Conclusion

The Afara project now follows industry best practices with:

- ✨ Clean Architecture with proper layer separation
- 🎯 Declarative routing with GoRouter
- 🔐 Complete forgot password flow
- 📦 Centralized state management
- 🧪 Testable code structure
- 🚀 Scalable and maintainable codebase

All existing functionality is preserved while adding the new forgot password feature and improving the overall code quality and maintainability.
