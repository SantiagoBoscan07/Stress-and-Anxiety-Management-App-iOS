# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

This is a Flutter-based iOS stress and anxiety management app with the following architecture:

```
stress_and_anxiety_management_app_ios/
├── lib/
│   ├── Components/          # Reusable UI components
│   │   ├── MainScaffold.dart    # Main layout wrapper with NavBar and Drawer
│   │   ├── NavBar.dart          # App bar with hamburger menu
│   │   ├── QuestionCard.dart    # Card component for reflection questions
│   │   └── ActionButton.dart    # Reusable button component
│   ├── Database/            # Local SQLite database layer
│   │   └── LocalDatabase.dart   # DatabaseHelper singleton for reflection data
│   ├── Screens/             # Main application screens
│   │   ├── HomeScreen.dart      # Landing page with action buttons
│   │   ├── SelfReflectionScreen.dart # 5W reflection questionnaire
│   │   ├── CalendarScreen.dart  # Calendar view
│   │   └── AboutScreen.dart     # App information
│   ├── ViewModels/          # Business logic layer
│   │   └── HomeViewModel.dart   # Home screen button configuration
│   └── main.dart           # App entry point and route configuration
├── assets/
│   └── logo.png           # App logo asset
└── pubspec.yaml          # Dependencies and Flutter configuration
```

## Development Commands

### Running the App
```bash
cd stress_and_anxiety_management_app_ios
flutter run
```

### Building for iOS
```bash
flutter build ios
```

### Testing
```bash
flutter test
```

### Dependencies Management
```bash
flutter pub get        # Install dependencies
flutter pub upgrade    # Upgrade dependencies
```

### Code Analysis
```bash
flutter analyze        # Static code analysis
```

## Architecture Patterns

### Component-Based UI Structure
- **MainScaffold**: Consistent layout wrapper used across screens, provides NavBar and Drawer navigation
- **Reusable Components**: QuestionCard, ActionButton, etc. for consistent UI patterns
- **Screen Separation**: Each major view is a separate screen in the `Screens/` directory

### Database Layer
- **SQLite Local Storage**: Uses `sqflite` package for local data persistence
- **DatabaseHelper Singleton**: Centralized database operations in `Database/LocalDatabase.dart`
- **Reflection Data Model**: Stores self-reflection responses with date association

### Navigation Structure
- **Named Routes**: Defined in `main.dart` for consistent navigation
- **Route Structure**:
  - `/` → HomeScreen (default)
  - `/about` → AboutScreen
  - Placeholder routes for future features (dashboard, membership, settings)

## Key Dependencies

- **sqflite**: ^2.3.0 - SQLite database for local storage
- **path_provider**: ^2.0.15 - Access to device file system paths
- **table_calendar**: ^3.0.9 - Calendar widget for date selection
- **cupertino_icons**: ^1.0.8 - iOS-style icons

## Database Schema

### Reflections Table
```sql
CREATE TABLE reflections(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  who TEXT NOT NULL,
  what TEXT NOT NULL,
  when_question TEXT NOT NULL,
  where_question TEXT NOT NULL,
  why_question TEXT NOT NULL,
  date TEXT NOT NULL,
  createdAt TEXT NOT NULL
)
```

## App Features

### Self-Reflection System
- **5W Questions**: Who, What, When, Where, Why reflection prompts
- **Date-Based Storage**: Reflections are associated with selected calendar dates
- **Persistence**: Local SQLite storage ensures data survives app restarts
- **CRUD Operations**: Create, read, and delete reflections by date

### Navigation Flow
1. HomeScreen → Select "Awareness Questions"
2. CalendarScreenWithCallback → Select target date
3. SelfReflectionScreen → Answer 5W questions and save

## Color Scheme
- Primary Background: `Color(0xFF708694)` (blue-grey)
- Dark Background: `Color(0xFF2F3941)` (dark grey)
- AppBar/NavBar: `Color(0xFF546E7A)` (darker blue-grey)
- Card Backgrounds: `Color(0xFF2F3941)` and `Colors.blueGrey[700]`

## Current Branch Status
Working on `UI-redesign` branch with modifications to iOS configuration, Flutter configs, and core components including NavBar, QuestionCard, LocalDatabase, and SelfReflectionScreen implementations.