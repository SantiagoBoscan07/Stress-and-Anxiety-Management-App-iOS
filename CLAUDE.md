# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based stress and anxiety management app called "HOWRU.LIFE" built for iOS (and cross-platform). The app helps users track their mental health through various features including mood tracking, breathing exercises, self-reflection questions, and stress management tools.

## Common Commands

### Flutter Development Commands
- `flutter run` - Run the app on connected device/simulator (use from `stress_and_anxiety_management_app_ios/` directory)
- `flutter build ios` - Build for iOS release
- `flutter test` - Run unit tests (Note: Default widget test needs updating for actual app structure)
- `flutter analyze` - Static analysis using flutter_lints package
- `flutter clean` - Clean build cache when encountering build issues
- `flutter pub get` - Install dependencies from pubspec.yaml
- `flutter pub upgrade` - Update dependencies to latest versions
- `flutter doctor` - Check Flutter installation and dependencies

### iOS-Specific Commands
- `cd ios && pod install` - Install iOS dependencies (run from `stress_and_anxiety_management_app_ios/ios/`)
- Open `ios/Runner.xcworkspace` (not .xcodeproj) in Xcode for iOS-specific configuration
- `flutter build ios --release` - Build optimized iOS release
- `flutter build ios --debug` - Build debug version for testing

## Architecture

### Project Structure
The app follows a layered architecture pattern:

- **`lib/main.dart`** - Entry point with MaterialApp setup, routes, and database initialization
- **`lib/Screens/`** - All screen/page widgets (LoginScreen, DashboardScreen, etc.)
- **`lib/Components/`** - Reusable UI components (ActionButton, NavBar, etc.)
- **`lib/Database/LocalDatabase.dart`** - SQLite database layer using sqflite package
- **`lib/ViewModels/`** - Business logic and state management (currently only HomeViewModel)

### Database Schema
The app uses SQLite with the following main tables:
- `reflections` - Self-reflection entries with 5W questions (who, what, when, where, why)
- `moods` - Daily mood tracking entries
- `users` - Basic user authentication
- `user` - Single user profile/name storage
- `control_gauge` - Control level tracking (1-10 scale)
- `stressors` - Stressor categorization and details

### Key Packages Used
- `sqflite` ^2.3.0 - Local SQLite database for data persistence
- `path_provider` ^2.0.15 - File system paths for database location
- `path` ^1.8.3 - Path manipulation utilities
- `table_calendar` ^3.0.9 - Calendar widget for date selection
- `cupertino_icons` ^1.0.8 - iOS-style icons
- `flutter_lints` ^6.0.0 - Recommended linting rules

### Navigation
The app uses named routes defined in main.dart:
- `/` (LoginScreen) - Entry point
- `/dashboard` - Main dashboard with metrics
- `/breathing-exercise` - Guided breathing exercises
- `/about` - App information
- Additional routes for signup, FAQ, settings, etc.

### State Management
- Uses basic ValueNotifier pattern in DatabaseHelper for username changes
- ViewModels contain business logic for screens
- Database operations are asynchronous and use singleton pattern

## Development Notes

### Database Operations
- Database is recreated on app startup for development (see main.dart:23-26)
- All database operations are in `DatabaseHelper` singleton class (lib/Database/LocalDatabase.dart)
- Uses version-based migrations for schema updates (currently version 3)
- Database file location: `{AppDocuments}/reflections.db`
- ValueNotifier pattern used for username state updates across widgets

### Authentication
- Simple email/password authentication stored locally in SQLite
- No external authentication service integration

### Working Directory
All Flutter commands should be run from: `stress_and_anxiety_management_app_ios/`

### Linting and Code Quality
- Uses `flutter_lints` package with standard Flutter linting rules
- Analysis options configured in `analysis_options.yaml`
- Run `flutter analyze` before committing changes

### iOS Configuration
- AppDelegate.swift is minimal Flutter integration
- Uses standard Flutter iOS configuration
- Icon assets located in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Launch images in `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- CocoaPods integration for iOS dependencies (Podfile.lock tracks versions)

### Testing
- Widget tests located in `test/` directory
- Current test file needs updating to match actual app structure (not counter app)
- Run specific test: `flutter test test/widget_test.dart`

### Theme and UI
- Primary color scheme based on orange (#FFA726) and yellow (#FFCC02)
- Material Design with custom color scheme
- App logo asset: `assets/logo.png`