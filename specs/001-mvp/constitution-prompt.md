# Sharp Timer MVP Swift Constitution Prompt

You are implementing the Sharp Timer MVP in Swift for macOS 13+. Your work must strictly follow this Constitution and the 001 MVP Swift specification.

## Core Mandates (Non‑Negotiable)

### 1. Menu Bar Exclusive Philosophy
- The app MUST appear only as a menu bar icon—never in the dock or app switcher.
- All user interaction happens via clicking the menu bar icon.
- Use SwiftUI `MenuBarExtra` or `NSStatusItem` + `NSPopover`.

### 2. Minimal Resource Footprint
- Target: < 1% CPU when idle, < 50MB memory.
- Use lightweight timers (`Timer` or `DispatchSourceTimer`) ticking once per second.
- Lazy initialization; no heavy work at startup.

### 3. Native macOS Integration
- Follow macOS design language.
- Use native notifications for timer completion.
- Respect system lifecycle events.

### 4. Three‑Mode Timer System
- Work (default 25 min), Rest Your Eyes (default 5 min), Long Rest (default 15 min).
- Modes: `.work`, `.restEyes`, `.longRest` with icons 💼👁️🌟.
- Allow start/pause/resume/reset.
- Only one timer runs at a time.

### 5. Configuration Persistence
- Store per‑mode durations in `UserDefaults` or small JSON in `~/Library/Application Support/Sharp Timer/`.
- Validate 1–60 minute range.
- No timer state persistence across restarts in MVP (that's 002).

### 6. Clean, Minimal SwiftUI UI
- Menu bar icon shows mode + remaining time (e.g., `💼 22:15`).
- Popover includes:
  - Large timer display (MM:SS).
  - Mode selector.
  - Start/Pause/Reset controls.
  - Settings entry (button or gear) leading to a secondary popover/sheet for duration adjustments.
- Design modularly to support future Bauhaus/Liquid Glass enhancements (003).

## Architecture Requirements

### Components
- **TimerEngine**: Pure countdown logic; Combine `@Published` or callbacks for state changes.
- **AppState**: `ObservableObject` owning `TimerEngine` and `TimerConfiguration`; handles persistence.
- **UI**: SwiftUI views reflecting `AppState`; invoke intents (start/pause/reset, change mode, update settings).

### Separation
- TimerEngine must not know about UI.
- AppState maps engine output to UI‑friendly models.
- UI only reflects state and forwards user actions.

## Performance & Quality
- Timer UI updates within 100 ms of each tick.
- Popover opens within 100 ms of click.
- No crashes when switching modes, adjusting settings, or rapid popover open/close.
- Basic VoiceOver support for main controls.

## Out of Scope for MVP
- Timer state persistence across app restarts.
- Quit confirmation dialog.
- 5‑second audio alerts.
- Automatic mode switching.
- Keyboard shortcuts.
- Advanced styling beyond clean, minimal SwiftUI.

## Constitution Alignment
- Preserve Principles 1–4 and 6 from the Constitution.
- Defer Principles 5 (Enhanced Visual Interface), 7 (Keyboard Accessibility), and related features to 002/003.

## Deliverables
- Swift project targeting macOS 13+.
- Core models: `TimerMode`, `TimerConfiguration`, `TimerState`.
- `TimerEngine`, `AppState`, and SwiftUI views (menu bar, popover, settings).
- Configuration persistence via `UserDefaults` or JSON.
- Unit tests for `TimerEngine` and persistence logic.


