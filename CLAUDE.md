# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Allpass is a Flutter-based password manager for Android and iOS. The app uses Provider for state management, GetIt for dependency injection, Fluro for routing, and sqflite (SQLite) for local storage. All sensitive data is encrypted with AES256.

## Development Commands

```bash
# Run app in development mode
flutter run

# Build release APK
flutter build apk --release

# Build release AppBundle
flutter build appbundle --release

# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code for issues
flutter analyze

# Generate localization files
flutter gen-l10n

# Clean build artifacts
flutter clean

# Get/upgrade dependencies
flutter pub get
flutter pub upgrade
```

## Architecture

### Core Patterns
- **State Management**: Provider pattern with `ChangeNotifier` and `Selector` for efficient rebuilds
- **Dependency Injection**: GetIt singleton service locator with `inject<T>()` helper
- **Repository Pattern**: Data sources are abstracted (e.g., `PasswordRepository` with `PasswordLocalDataSource`, `PasswordMemoryDataSource`)
- **Reactive Updates**: StreamController for real-time UI updates from repositories

### Directory Structure
- `lib/main.dart` - App entry point, initializes DI, router, providers
- `lib/core/` - Core services (AuthService, AllpassService), DI setup, enums, models
- `lib/classification/` - Folder/category management (CategoryProvider)
- `lib/password/` - Password management (PasswordProvider, PasswordBean, pages, widgets)
- `lib/card/` - Credit/debit card management
- `lib/login/` - Authentication pages
- `lib/webdav/` - WebDAV sync backup/restore
- `lib/database/` - DBManager and migrations
- `lib/navigation/` - Fluro route definitions and handlers
- `lib/util/` - Utilities (encryption, file handling, CSV import)

### Key Services
- `AuthService` - Biometric and master password authentication
- `AllpassService` - Core app service for data operations
- `WebDavSyncService` - WebDAV backup/restore synchronization
- `EncryptUtil` - AES256 encryption using flutter_secure_storage for key storage

### Database
- SQLite via sqflite, version 6 with migration support
- Tables prefixed with `allpass_` (e.g., `allpass_password`, `allpass_card`)
- Table columns use `camelCase` to match model properties

## Conventions

### Naming
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/Functions: `camelCase`
- Import aliases: `lowercase_with_underscores`
- DB tables: `allpass_*`

### Key Patterns
- Use `Selector<ProviderType>` for efficient widget rebuilds
- Use `inject<T>()` for dependency injection (defined in `lib/core/di/di.dart`)
- Stream-based data updates from repositories to providers
- LRU cache for frequently used usernames in `lib/common/arch/`

## Important Implementation Notes

- **ThemeProvider**: Wrapped in `Selector` in main.dart for efficient theme switching
- **ScreenUtilInit**: App uses `flutter_screenutil` for responsive design - wrap new pages with it
- **Localization**: ARB files in `l10n/`, regenerate with `flutter gen-l10n`
- **Encryption**: Master password stored encrypted in flutter_secure_storage
- **Routing**: All routes defined centrally in `lib/navigation/routes.dart`
