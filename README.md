# Sharp Timer App

A macOS menu bar timer application built with SwiftUI, designed to help users manage work sessions with proper breaks.

## Features

- 🍎 Native macOS menu bar integration
- ⏰ Three timer modes: Work (25min), Rest Your Eyes (2min), Long Rest (15min)
- 🔄 Start, pause, resume, and reset functionality
- 🔔 macOS notifications for timer completion
- 💾 Persistent user preferences
- 🎨 Clean, intuitive interface

## Quick Start

### Prerequisites

- macOS 13.0 or later
- Xcode 15 or later

### Building and Running

The easiest way to build and run the app is using the development script:

```bash
# Build the app
./scripts/dev.sh build

# Build and run the app
./scripts/dev.sh run

# Monitor logs in real-time
./scripts/dev.sh logs

# Show crash reports
./scripts/dev.sh crash
```

For detailed development instructions, see [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md).

## Usage

1. **Launch the app** - The timer icon appears in your menu bar
2. **Select a mode** - Choose between Work, Rest Eyes, or Long Rest
3. **Start the timer** - Click Start to begin counting down
4. **Take breaks** - When the timer completes, you'll receive a notification
5. **Customize durations** - Settings allow you to adjust timer lengths (coming soon)

## Architecture

The app is built using modern SwiftUI practices:

- **SwiftUI** for the user interface
- **@Observable** for state management
- **Combine** for reactive programming
- **UserNotifications** for timer alerts
- **UserDefaults** for data persistence

### Key Components

- `AppState` - Central state management
- `TimerEngine` - Core timer logic
- `TimerDisplayView` - Main UI component
- `TimerProfileStore` - Data persistence
- `NotificationPreference` - Notification settings

## Development

### Project Structure

```
Sharp Timer App/
├── Sharp Timer App.xcodeproj/     # Xcode project
├── Sharp Timer App/               # Source code
│   ├── App/                       # App state and notifications
│   ├── Engine/                    # Timer engine and modes
│   ├── Features/MenuBar/          # Menu bar UI
│   ├── Persistence/               # Data storage
│   └── Assets.xcassets/           # App resources
├── Sharp Timer AppTests/          # Unit tests
└── Sharp Timer AppUITests/        # UI tests
```

### Build Commands

```bash
# Using xcodebuild
cd "Sharp Timer App"
xcodebuild -project "Sharp Timer App.xcodeproj" -scheme "Sharp Timer App" -configuration Debug build

# Using the dev script
./scripts/dev.sh build
```

### Log Monitoring

```bash
# Real-time logs
log stream --predicate 'processImagePath CONTAINS "Sharp Timer App"' --info

# Recent logs
log show --last 5m --predicate 'processImagePath CONTAINS "Sharp Timer App"' --info
```

## Troubleshooting

### App crashes on launch
- Check crash reports: `./scripts/dev.sh crash`
- Ensure Xcode command line tools are properly installed
- Verify all required files are present

### Menu bar icon not appearing
- Check System Settings > Privacy & Security > Extensions > Menu Bar
- Ensure the app has necessary permissions
- Try restarting the app

### Build errors
- Run `./scripts/dev.sh clean` to clean build artifacts
- Ensure Xcode 15+ is installed
- Check that macOS deployment target is correct

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using the development script
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built with SwiftUI and modern macOS development practices
- Follows Apple's Human Interface Guidelines for menu bar apps
- Inspired by productivity techniques like the Pomodoro Method
