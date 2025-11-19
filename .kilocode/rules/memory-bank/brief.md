# Sharp Timer App - Project Brief

## Overview
Sharp Timer is a minimalist macOS menu bar timer application designed to help users manage work sessions with proper breaks. Built with SwiftUI, it lives exclusively in the menu bar without dock presence, providing instant access to focused time management.

## Core Features
- **Menu Bar Exclusive**: Native macOS menu bar integration with no dock icon
- **Three Timer Modes**: Work (25min), Rest Your Eyes (2min), and Long Rest (15min)
- **Timer Controls**: Start, pause, resume, and reset functionality
- **Customizable Durations**: User-configurable timer lengths for each mode
- **Smart Notifications**: Native macOS notifications with audio alerts
- **State Persistence**: Timer state preserved across app launches
- **Confirmation Dialogs**: Prevents accidental timer loss during mode switches or app quit

## Technical Architecture
- **Platform**: macOS 13.0+ (Swift 5.9, Xcode 15)
- **UI Framework**: SwiftUI with Combine for reactive programming
- **Core Components**: 
  - `TimerEngine`: Pure Swift countdown logic using DispatchSourceTimer
  - `AppState`: Observable state management and persistence orchestration
  - `MenuBarController`: Menu bar UI integration
  - `TimerProfileStore`: UserDefaults and JSON persistence
- **Audio**: AVFoundation for custom alarm sounds with fallback support
- **Testing**: XCTest unit tests and XCUITest for UI flows

## User Experience
- **Instant Access**: Single-click menu bar access to timer controls
- **Responsive Design**: Adaptive UI that works across different window sizes
- **Accessibility**: VoiceOver support and keyboard navigation
- **Minimal Resource Usage**: <1% CPU idle, <50MB memory footprint
- **Error Resilience**: Graceful handling of system volume, permissions, and file corruption

## Development Status
The app has undergone three major development phases:
1. **Menu Bar Timer** (001): Core timer functionality and menu bar integration
2. **Bug Fixes** (002): Logic improvements and stability enhancements
3. **UI Fixes & Enhancements** (003): Responsive settings, confirmation dialogs, state persistence, and enhanced audio

## Key Design Principles
- Menu bar exclusivity with no dock presence
- Minimal resource footprint and background efficiency
- Native macOS integration following Human Interface Guidelines
- Three-mode timer system with single active timer constraint
- Clean SwiftUI interface with responsive layouts
- Enhanced audio experience with graceful fallbacks

## Target Users
macOS users seeking a simple, distraction-free timer for productivity workflows like the Pomodoro Technique, who prefer menu bar utilities over traditional desktop applications.
