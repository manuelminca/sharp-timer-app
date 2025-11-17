# Sharp Timer App - Development Guide

This guide covers how to build, run, and debug the Sharp Timer App project.

## Prerequisites

- macOS 13.0 or later (deployment target)
- Xcode 15 or later
- Swift 5.9

## Project Structure

```
Sharp Timer App/
├── Sharp Timer App.xcodeproj/     # Xcode project file
├── Sharp Timer App/               # Main source code
│   ├── App/                       # App state and notifications
│   ├── Engine/                    # Timer engine and modes
│   ├── Features/MenuBar/          # Menu bar UI components
│   ├── Persistence/               # Data persistence
│   └── Assets.xcassets/           # App assets
├── Sharp Timer AppTests/          # Unit tests
└── Sharp Timer AppUITests/        # UI tests
```

## Building the App

### Method 1: Using xcodebuild (Command Line)

Navigate to the Sharp Timer App directory and run:

```bash
cd "Sharp Timer App"
xcodebuild -project "Sharp Timer App.xcodeproj" -scheme "Sharp Timer App" -configuration Debug build
```

To save build output to a log file:
```bash
xcodebuild -project "Sharp Timer App.xcodeproj" -scheme "Sharp Timer App" -configuration Debug build | tee build.log
```

### Method 2: Using Xcode IDE

1. Open `Sharp Timer App.xcodeproj` in Xcode
2. Select the "Sharp Timer App" scheme
3. Choose "Debug" configuration
4. Press `Cmd+B` to build or `Cmd+R` to build and run

## Running the App

### Method 1: Direct Execution

```bash
cd "Sharp Timer App"
"/Users/valutico/Library/Developer/Xcode/DerivedData/Sharp_Timer_App-dqcdjekvnfcrboekjfmhmgmmhdlj/Build/Products/Debug/Sharp Timer App.app/Contents/MacOS/Sharp Timer App"
```

### Method 2: Using open Command (Recommended)

```bash
cd "Sharp Timer App"
open "/Users/valutico/Library/Developer/Xcode/DerivedData/Sharp_Timer_App-dqcdjekvnfcrboekjfmhmgmmhdlj/Build/Products/Debug/Sharp Timer App.app"
```

### Method 3: Using Xcode

1. Open the project in Xcode
2. Press `Cmd+R` to build and run
3. The app will appear in your menu bar

## Log Visualization and Debugging

### 1. Real-time Log Monitoring

Monitor logs for the Sharp Timer App in real-time:

```bash
log stream --predicate 'processImagePath CONTAINS "Sharp Timer App"' --info
```

### 2. Viewing Recent Logs

Show logs from the last few minutes:

```bash
log show --last 5m --predicate 'processImagePath CONTAINS "Sharp Timer App"' --info
```

### 3. Crash Reports

Find crash reports when the app crashes:

```bash
find ~/Library/Logs/DiagnosticReports -name "*Sharp Timer App*" -type f | head -5
```

View the most recent crash report:
```bash
open "$(find ~/Library/Logs/DiagnosticReports -name "*Sharp Timer App*" -type f | head -1)"
```

### 4. Filtering Logs by Type

Show only errors and crashes:
```bash
log show --last 1h --predicate 'processImagePath CONTAINS "Sharp Timer App" AND (eventMessage CONTAINS "crash" OR eventMessage CONTAINS "fault" OR eventMessage CONTAINS "error")' --info
```

### 5. Console App

Use the Console app for comprehensive log viewing:
1. Open Console.app
2. Search for "Sharp Timer App"
3. Filter by process or use the search bar

## Common Issues and Solutions

### 1. Build Errors

**Issue**: Missing `NotificationPreference` type
**Solution**: Ensure `NotificationPreference.swift` exists in the App folder

**Issue**: Xcode command line tools not found
**Solution**: Run `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

### 2. Runtime Crashes

**Issue**: Segmentation fault on launch
**Solution**: Check crash reports for null pointer access, often related to `@Observable` initialization

**Issue**: Menu bar extra not appearing
**Solution**: Ensure the app has proper permissions and isn't being blocked by macOS

### 3. Environment Object Issues

**Issue**: `@Environment` objects not properly injected
**Solution**: Ensure proper environment setup in `Sharp_Timer_AppApp.swift`

## Development Workflow

1. **Make Changes**: Edit source files in the `Sharp Timer App/` directory
2. **Build**: Run `xcodebuild` command to compile
3. **Test**: Launch the app and test functionality
4. **Debug**: Monitor logs using `log stream` if issues occur
5. **Iterate**: Repeat the cycle

## Key Files to Understand

- `Sharp_Timer_AppApp.swift`: Main app entry point and menu bar setup
- `AppState.swift`: Central app state management
- `TimerEngine.swift`: Core timer logic
- `TimerDisplayView.swift`: Main UI component
- `TimerMode.swift`: Timer mode definitions

## Testing

### Unit Tests
```bash
cd "Sharp Timer App"
xcodebuild test -project "Sharp Timer App.xcodeproj" -scheme "Sharp Timer App" -destination 'platform=macOS'
```

### UI Tests
UI tests are located in `Sharp Timer AppUITests/` and can be run through Xcode.

## Architecture Notes

- Uses SwiftUI with `@Observable` for state management
- Menu bar extra implementation using `MenuBarExtra`
- Combine framework for reactive programming
- UserNotifications for timer completion alerts
- UserDefaults for persistence

## Performance Monitoring

Monitor CPU and memory usage:
```bash
ps aux | grep "Sharp Timer App"
```

Check for memory leaks during development by monitoring long-running sessions.
