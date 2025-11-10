# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based iOS stress and anxiety management app focused on self-reflection and wellness tracking. The app uses modern Flutter architecture patterns with local SQLite storage for data persistence.

**Working Directory**: `/Users/davidvasquez/capstone-2/Stress-and-Anxiety-Management-App-iOS/stress_and_anxiety_management_app_ios/`

## Project Structure

```
stress_and_anxiety_management_app_ios/
├── lib/
│   ├── Components/          # Reusable UI components (6 files)
│   │   ├── MainScaffold.dart    # Central layout wrapper with NavBar
│   │   ├── NavBar.dart          # App navigation bar with drawer
│   │   ├── QuestionCard.dart    # Self-reflection question cards
│   │   ├── ActionButton.dart    # Reusable button component
│   │   ├── CalendarComponent.dart # Calendar widget component
│   │   └── AboutTextBox.dart    # Text display component
│   ├── Database/            # Data persistence layer
│   │   └── LocalDatabase.dart   # SQLite DatabaseHelper singleton
│   ├── Screens/             # Application screens (7 files)
│   │   ├── HomeScreen.dart      # Landing page
│   │   ├── DashboardScreen.dart # Analytics and recent activity
│   │   ├── SelfReflectionScreen.dart # 5W questionnaire with congrats dialog
│   │   ├── BreathingExerciseScreen.dart # Guided breathing exercise (4-4 pattern)
│   │   ├── CalendarScreen.dart  # Calendar view
│   │   ├── CalendarScreenWithCallback.dart # Date selection flow
│   │   └── AboutScreen.dart     # App information
│   ├── ViewModels/          # Business logic layer
│   │   └── HomeViewModel.dart   # Home screen data management
│   └── main.dart           # App entry point and routing
├── assets/
│   └── logo.png           # App branding
├── ios/                   # iOS platform configuration
├── android/              # Android platform configuration
└── pubspec.yaml         # Dependencies and Flutter configuration
```

## Development Commands

### Essential Setup
```bash
# Navigate to project directory
cd /Users/davidvasquez/capstone-2/Stress-and-Anxiety-Management-App-iOS/stress_and_anxiety_management_app_ios/

# Install dependencies
flutter pub get
```

### Running the App
```bash
flutter run                    # Run on connected device/simulator
flutter run --debug           # Debug mode with hot reload
flutter run --release         # Release mode for performance testing
flutter run -d ios           # Specifically target iOS simulator
```

### Building and Deployment
```bash
flutter build ios             # Build for iOS deployment
open ios/Runner.xcworkspace   # Open in Xcode for final iOS build
```

### Development Tools
```bash
flutter test                  # Run unit tests
flutter analyze              # Static code analysis with linting
flutter doctor              # Verify development environment setup
flutter devices             # List available devices/simulators
flutter logs               # View device logs for debugging
```

### Dependencies Management
```bash
flutter pub get             # Install dependencies
flutter pub upgrade         # Upgrade dependencies
flutter pub outdated        # Check for dependency updates
```

## Architecture Patterns

### Component-Based Architecture
- **MainScaffold**: Central layout wrapper providing consistent NavBar and drawer navigation across all screens
- **Reusable UI Components**: QuestionCard, ActionButton, CalendarComponent for consistent design patterns
- **Screen Separation**: Each major feature is a separate screen in `Screens/` directory with clear responsibility
- **MVVM Pattern**: ViewModels separate business logic from UI components

### Data Persistence Layer
- **SQLite Local Storage**: Uses `sqflite` package with DatabaseHelper singleton pattern
- **Database Versioning**: Supports schema migrations (currently v2 with date column)
- **Date-Based Data Model**: Reflections associated with calendar dates for temporal organization
- **CRUD Operations**: Full create, read, delete operations with date-based filtering

### Navigation Architecture
- **Named Routes**: Centralized routing configuration in `main.dart`
- **Route Structure**:
  - `/` → HomeScreen (landing page)
  - `/dashboard` → DashboardScreen (analytics and recent activity)
  - `/breathing-exercise` → BreathingExerciseScreen (guided breathing)
  - `/about` → AboutScreen (app information)
  - Future placeholder routes: membership, settings, logout
- **Navigation Flow**: Home → Calendar → Reflection → Success Dialog → Home

## Key Dependencies

### Core Dependencies
- **sqflite**: ^2.3.0 - SQLite database for local data persistence
- **path_provider**: ^2.0.15 - Access to device file system paths for database
- **path**: ^1.8.3 - Path manipulation utilities
- **table_calendar**: ^3.0.9 - Interactive calendar widget for date selection
- **cupertino_icons**: ^1.0.8 - iOS-style icons and design elements

### Development Dependencies
- **flutter_test**: SDK testing framework
- **flutter_lints**: ^6.0.0 - Code quality and linting rules

### Environment Requirements
- **Dart SDK**: ^3.9.2
- **Flutter**: Latest stable version
- **iOS**: 13.0+ target deployment

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
- **5W Questionnaire**: Who, What, When, Where, Why reflection prompts with dropdown selections
- **Date-Based Storage**: Reflections associated with calendar dates for temporal tracking
- **Success Feedback**: Congratulations dialog with celebration icon after saving reflection
- **Auto-Navigation**: Automatic redirect to home screen after successful reflection completion
- **Data Persistence**: Local SQLite storage ensures data survives app restarts
- **CRUD Operations**: Create, read, and delete reflections by specific dates

### Dashboard Analytics
- **Welcome Cards**: Time-based greetings (morning, afternoon, evening)
- **Statistics Display**: Total reflections count and weekly activity metrics
- **Recent Activity**: Display of last 3-5 reflections with formatted dates
- **Quick Actions**: Direct navigation buttons to key app features

### Breathing Exercise
- **4-4 Breathing Pattern**: 4 seconds inhale, 4 seconds exhale guided breathing
- **Visual Animation**: Expanding/contracting circle for breathing guidance
- **Progress Tracking**: 5 breathing cycles with linear progress indicator
- **Timer Integration**: Coordinated timing for breath phases

### Calendar Integration
- **Interactive Calendar**: Table calendar widget for date selection
- **Date Highlighting**: Visual feedback for selected dates
- **Callback Architecture**: Date selection triggers reflection workflow

### Primary User Journey
1. **HomeScreen** → Select "Awareness Questions" or view Dashboard
2. **CalendarScreenWithCallback** → Choose reflection date
3. **SelfReflectionScreen** → Complete 5W questionnaire and save
4. **Success Dialog** → Congratulations message with celebration
5. **Auto-Redirect** → Return to HomeScreen to view updated dashboard

## Color Scheme
- Primary Background: `Color(0xFF708694)` (blue-grey)
- Dark Background: `Color(0xFF2F3941)` (dark grey)
- AppBar/NavBar: `Color(0xFF546E7A)` (darker blue-grey)
- Card Backgrounds: `Color(0xFF2F3941)` and `Colors.blueGrey[700]`

## UI Design System

### Color Scheme
- **Primary Background**: `Color(0xFF708694)` (blue-grey theme)
- **Dark Backgrounds**: `Color(0xFF2F3941)` (dark grey for cards)
- **AppBar/NavBar**: `Color(0xFF546E7A)` (darker blue-grey)
- **Card Backgrounds**: `Colors.blueGrey[700]` and gradient variations
- **Accent Colors**: Green for success, red for errors, amber for celebrations

### Design Patterns
- **Material Design**: Consistent card elevations, rounded corners (12-20px radius)
- **Gradient Themes**: Linear gradients from `Color(0xFF546E7A)` to `Color(0xFF78909C)`
- **Icon Integration**: Mix of Cupertino and Material Design icons
- **Typography**: White text on dark backgrounds with size hierarchy (12-24px)
- **Responsive Layout**: SingleChildScrollView for various screen sizes

## Development Environment

### Prerequisites
1. **Flutter SDK**: Latest stable version
2. **Xcode**: For iOS development and simulation (macOS required)
3. **CocoaPods**: iOS dependency management
4. **Git**: Version control (repository already initialized)

### IDE Setup
- **VS Code**: With Flutter/Dart extensions recommended
- **Android Studio**: Alternative with full Flutter support
- **Xcode**: Required for iOS-specific debugging and final builds

## Testing Infrastructure

### Current State
- **Location**: `/test/widget_test.dart`
- **Framework**: flutter_test package
- **Coverage**: Basic widget testing (needs expansion for app-specific features)

### Testing Opportunities
- Database operations and CRUD functionality
- Navigation flow and route testing
- Component unit tests for UI widgets
- Integration tests for complete reflection workflow

## Git Workflow

### Current Branch Status
- **Active Branch**: `UI-redesign` (clean working tree)
- **Main Branch**: `main` (for pull requests)
- **Recent Commits**: Dashboard implementation, breathing exercises, calendar functionality

### Recent Development
- Dashboard screen with analytics and recent reflections
- Breathing exercise with 4-4 pattern and visual guidance
- Enhanced self-reflection flow with success dialog and auto-redirect
- Calendar integration for date-based reflection selection