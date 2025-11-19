# sharp-timer-app Development Guidelines

Auto-generated from all feature plans. Last updated: 2025-11-17

## Active Technologies
- Swift 5.9 (Xcode 15, macOS 13 deployment target) + SwiftUI, Combine, AppKit bridge (`NSStatusItem`, `NSAlert`, `NSWindow`), UserNotifications, AVFoundation (`AVAudioPlayer`), Foundation (`Timer`, `DispatchSourceTimer`) (003-ui-fixes)
- `UserDefaults` for settings + timer metadata, JSON snapshot under `~/Library/Application Support/Sharp Timer/timer-state.json` for crash-safe persistence (003-ui-fixes)

- Swift 5.9 (Xcode 15, macOS 13 deployment target) + SwiftUI, Combine, UserNotifications, Foundation (Timer/DispatchSourceTimer), AppKit bridge for `NSStatusItem` behaviors (001-menu-bar-timer)

## Project Structure

```text
src/
tests/
```

## Commands

# Add commands for Swift 5.9 (Xcode 15, macOS 13 deployment target)

## Code Style

Swift 5.9 (Xcode 15, macOS 13 deployment target): Follow standard conventions

## Recent Changes
- 003-ui-fixes: Added Swift 5.9 (Xcode 15, macOS 13 deployment target) + SwiftUI, Combine, AppKit bridge (`NSStatusItem`, `NSAlert`, `NSWindow`), UserNotifications, AVFoundation (`AVAudioPlayer`), Foundation (`Timer`, `DispatchSourceTimer`)

- 001-menu-bar-timer: Added Swift 5.9 (Xcode 15, macOS 13 deployment target) + SwiftUI, Combine, UserNotifications, Foundation (Timer/DispatchSourceTimer), AppKit bridge for `NSStatusItem` behaviors

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
