# Technology Stack

## Core Technologies
-   **Language**: Swift 5.9
-   **Framework**: SwiftUI
-   **Platform**: macOS 13.0+ (Ventura and later)
-   **IDE**: Xcode 15+

## Key Frameworks & Libraries
-   **Combine**: Used for reactive event handling and state observation.
-   **AVFoundation**: Powers the `AlarmPlayerService` for custom audio playback.
-   **UserNotifications**: Handles native macOS notification delivery.
-   **AppKit**: Bridged where necessary for window management (`NSStatusItem`, `NSAlert`, `NSApplicationDelegate`).
-   **Foundation**: Provides core utilities like `Timer`, `DispatchSourceTimer`, and `JSONEncoder`/`JSONDecoder`.

## Development Tools
-   **XCTest**: Unit testing framework for logic and persistence.
-   **XCUITest**: UI testing framework for verifying user flows.
-   **Instruments**: Used for profiling CPU and memory usage.

## Project Structure
-   **Single Target**: The app is built as a single macOS application target.
-   **Sandboxed**: The app runs within the macOS App Sandbox, restricting file access to its container.

## Dependencies
-   **None**: The project relies solely on standard Apple SDKs. No third-party dependencies (CocoaPods, Carthage, SPM) are currently used.

## Build & Deployment
-   **Deployment Target**: macOS 13.0
-   **Versioning**: Semantic versioning (currently tracking feature branches like `003-ui-fixes`).
