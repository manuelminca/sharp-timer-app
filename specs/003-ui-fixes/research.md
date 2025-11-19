# Research: UI Fixes and Timer Enhancements

**Date:** 2025-11-17  
**Feature Branch:** 003-ui-fixes  
**Spec:** [specs/003-ui-fixes/spec.md](specs/003-ui-fixes/spec.md)

## Decision 1 – Responsive SwiftUI Layout Architecture
- **Decision**: Rebuild `DurationSettingsView` with a `Grid`-based form that auto-aligns labels and inputs, wrap it in `ViewThatFits` to collapse into a vertical stack at narrower widths, and apply `LayoutPriority` plus `dynamicTypeSize(_:)` modifiers to respect accessibility settings.
- **Rationale**: `Grid` provides deterministic spacing without hardcoded frames, `ViewThatFits` keeps the UI usable down to 280 px widths, and respecting dynamic type prevents clipping when users increase system fonts.
- **Alternatives considered**:
  - `GeometryReader` + manual frame math — proved brittle in previous “vibe-coded” attempts and caused overlapping controls when the window shrank.
  - Embedding an AppKit `NSStackView` via `NSHostingView` — added cross-framework complexity and hurt SwiftUI testability.

## Decision 2 – Mode Switching Confirmation UX
- **Decision**: Surface a blocking confirmation dialog whenever a timer is running and the user selects a new mode by launching an `NSAlert` from `NSApp` (to guarantee it survives menu-bar popover dismissal) and mirroring the state to SwiftUI via `.alert` for previews/tests.
- **Rationale**: `NSAlert` can halt the quit/mode-switch pipeline until the user responds, ensuring no silent timer cancellation. Propagating the result back through `AppState` keeps TimerEngine unaware of UI.
- **Alternatives considered**:
  - Custom overlay inside the menu-bar popover — popovers auto-close when another mode is tapped, so overlays could vanish mid-interaction.
  - Passive notification banners — do not block the destructive action and would still lose timer progress if ignored.

## Decision 3 – Timer State Persistence Strategy
- **Decision**: Persist `TimerPersistenceSnapshot` (`mode`, `remainingSeconds`, `startedAt`, `isRunning`) as a `Codable` JSON file under `~/Library/Application Support/Sharp Timer/timer-state.json` alongside mirroring critical flags in `UserDefaults` for quick checks; writes happen on a background queue capped at 50 ms.
- **Rationale**: JSON keeps the structure inspectable for debugging, guards against vibe-coded corruption, and satisfies Principle 9 continuity while leaving per-mode duration storage untouched.
- **Alternatives considered**:
  - Storing the full snapshot in `UserDefaults` only — risk of partial writes and limited space for future metadata.
  - Introducing Core Data — heavy for a single record and would inflate memory footprint beyond the constitution’s intent.

## Decision 4 – Quit Interception and Recovery
- **Decision**: Hook `NSApplicationDelegate.applicationShouldTerminate(_:)` to present the three-option quit confirmation, defer the `NSApplication.TerminateReply` until persistence completes, and on next launch load the snapshot before initializing `TimerEngine`.
- **Rationale**: Only `applicationShouldTerminate` allows us to block termination while the dialog is visible and while writes finalize. Rehydrating AppState before SwiftUI view creation ensures the UI shows the restored timer immediately.
- **Alternatives considered**:
  - Listening to `scenePhase` or `NSNotification.Name.NSApplicationWillTerminate` — those fire too late to stop termination.
  - Auto-saving on every tick — unnecessary disk churn and still fails to give users explicit choices.

## Decision 5 – Enhanced Alarm Audio Pipeline
- **Decision**: Use `AVAudioSession` + `AVAudioPlayer` to preload `sounds/alarm.mp3`, expose a lightweight `AlarmPlayer` service in AppState, and fall back to `UNUserNotificationCenter` default sounds if playback fails.
- **Rationale**: `AVAudioPlayer` handles background playback, honors system volume, and supports future fade-in/out effects. Preloading avoids latency when timers finish, fulfilling Principle 10.
- **Alternatives considered**:
  - `NSSound` — deprecated and unreliable for background playback.
  - Using only notification sounds — lacks control over the custom MP3 and provides no error visibility.

## Decision 6 – Settings Stepper Focus Management & Window Minimization Prevention
- **Decision**: Replace standard SwiftUI `Button` and `Stepper` controls with custom gesture-based stepper buttons that use `DragGesture(minimumDistance: 0)` wrapped in `.simultaneousGesture()` modifier to intercept taps without triggering macOS window focus management. Present settings via `.popover()` instead of `.sheet()` to maintain attachment to parent window. Implement custom `StepperButton` view that captures user interaction through gestures rather than button actions, preventing the window minimization behavior.
- **Rationale**: Standard SwiftUI buttons in popovers/sheets on macOS can trigger window focus changes through the responder chain, causing the settings window to minimize or lose focus. Using gesture recognizers bypasses this by handling touch events directly without involving the button action system that interacts with window management. Popovers are more stable than sheets for menu bar apps as they maintain attachment to the status item window. The gesture-based approach provides immediate visual feedback while preventing any window manager intervention.
- **Alternatives considered**:
  - `.buttonStyle(.borderless)` or `.buttonStyle(.plain)` — these still use the standard button action system and can trigger focus changes depending on macOS window management state.
  - AppKit `NSButton` via `NSViewRepresentable` — adds cross-framework complexity, breaks SwiftUI preview/testing, and still requires careful event handling to prevent focus loss.
  - Disabling window focus management globally — would break other legitimate focus behaviors and violate macOS HIG for proper window handling.
  - Using `.onTapGesture()` modifier instead of buttons — similar to our chosen approach but less accessible and harder to style consistently with existing UI patterns.
  - Custom `UIViewRepresentable` wrapper (iOS-style) — not available on macOS and wouldn't address the fundamental window management issue.

## Test & Tooling Considerations
- UI snapshot & XCUITests will resize the settings popover across min/median/max widths and dynamic type sizes to guarantee responsive compliance.
- Persistence flow tests will simulate quit selections to assert JSON integrity and restart behavior.
- Audio regression tests will stub `AVAudioPlayer` to verify fallback activation when the MP3 is missing or corrupt.
- Stepper focus retention tests will perform rapid click sequences (10+ clicks in 2 seconds) and verify zero window minimization events across all three timer duration controls.
- Automated UI tests will measure window visibility state before/during/after stepper clicks to detect any transient minimization or focus loss.
