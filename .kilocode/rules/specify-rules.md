# sharp-timer-app Development Guidelines

Auto-generated from all feature plans. Last updated: 2025-11-17

## Active Technologies
- Swift 5.9 (Xcode 15, macOS 13 deployment target) + SwiftUI, Combine, AppKit bridge (`NSStatusItem`, `NSAlert`, `NSWindow`), UserNotifications, AVFoundation (`AVAudioPlayer`), Foundation (`Timer`, `DispatchSourceTimer`) (003-ui-fixes)
- `UserDefaults` for settings + timer metadata, JSON snapshot under `~/Library/Application Support/Sharp Timer/timer-state.json` for crash-safe persistence (003-ui-fixes)
- Swift 5.9 + SwiftUI, Combine, AppKit, Foundation (004-fixes-and-improvements)
- UserDefaults (Settings), JSON (Timer State) (004-fixes-and-improvements)
- Swift 5.9 + SwiftUI, AppKit, Combine (005-improve-quit-functionality)
- JSON file (`timer-state.json`) for persistence (005-improve-quit-functionality)
- UserDefaults (Settings), JSON (Timer State) - *Existing, Unchanged* (007-bauhaus-ui-redesign)

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
- 007-bauhaus-ui-redesign: Added Swift 5.9 + SwiftUI, AppKit, Combine
- 005-improve-quit-functionality: Added Swift 5.9 + SwiftUI, AppKit, Combine
- 004-fixes-and-improvements: Added Swift 5.9 + SwiftUI, Combine, AppKit, Foundation


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
