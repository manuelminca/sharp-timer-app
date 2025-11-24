# AGENTS.md

## Build/Test Commands

```bash
# Build the app
./scripts/dev.sh build

# Build and run the app
./scripts/dev.sh run

# Run all unit tests
./scripts/dev.sh test

# Run single test (replace TestName with actual test name)
cd "Sharp Timer App" && xcodebuild test -project "Sharp Timer App.xcodeproj" -scheme "Sharp Timer App" -destination 'platform=macOS' -only-testing:Sharp_Timer_AppTests/TimerEngineTests/TestName

# Clean build artifacts
./scripts/dev.sh clean

# Monitor logs in real-time
./scripts/dev.sh logs

# Show crash reports
./scripts/dev.sh crash
```

## Code Style Guidelines

### Swift Conventions
- Use SwiftUI with `@Observable` for state management
- Mark classes with `@MainActor` when working with UI
- Use `@Environment` for dependency injection in SwiftUI views
- Follow Swift naming conventions (camelCase for variables, PascalCase for types)
- Use `private` for internal implementation details
- Group code with `// MARK: -` comments for organization

### Architecture
- MVVM pattern with SwiftUI views and Observable classes
- Single responsibility principle for each class/struct
- Use Combine for reactive programming
- UserDefaults for data persistence
- UserNotifications for timer alerts

### Error Handling
- Use async/await for asynchronous operations
- Handle errors gracefully with do-catch blocks
- Provide fallback behavior when permissions are denied

### Testing
- Use Swift Testing framework
- Write unit tests for business logic in TimerEngine
- Test state transitions and edge cases
- Use @testable import for accessing internal types

## Active Technologies
- Swift 5.9 + SwiftUI, Combine, UserNotifications (001-mode-auto-start-setting)
- UserDefaults for profile settings, JSON file for timer state persistence (001-mode-auto-start-setting)
- UserDefaults (App Preferences), JSON (Timer State Persistence) (008-ui-redesign)

## Recent Changes
- 001-mode-auto-start-setting: Added Swift 5.9 + SwiftUI, Combine, UserNotifications
