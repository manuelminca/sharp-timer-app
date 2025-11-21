<!--
Sync Impact Report
Version change: 1.1.0 → 1.2.0
Modified principles:
- Principle 9: Updated to specify a dedicated window for quit options instead of a generic dialog.
Added sections:
- None
Removed sections:
- None
Templates reviewed:
- ✅ .specify/templates/plan-template.md — Constitution Check gates remain derived from this constitution; no structural change required.
- ✅ .specify/templates/spec-template.md — Generic; no constitution-specific constraints baked in; remains aligned.
- ✅ .specify/templates/tasks-template.md — Generic; no constitution-specific constraints baked in; remains aligned.
- ⚠ .specify/templates/commands/* — Directory not present in this repo; no command templates to review.
Deferred items:
- None
-->

# Sharp Timer App Constitution

## Core Principles

### Principle 1 – Menu Bar Exclusive Philosophy

- The Sharp Timer app MUST present itself exclusively as a **menu bar** app on macOS.
- The app MUST NOT appear in the Dock or application switcher while running, except where macOS enforces this for system reasons outside our control.
- All primary user interaction (starting, pausing, resetting timers; changing modes; opening settings) MUST be initiated via the menu bar item.
- Implementation MUST use native mechanisms such as SwiftUI `MenuBarExtra` or an `NSStatusItem` with an `NSPopover`.
- Any future feature proposals MUST demonstrate compatibility with a menu-bar-only interaction model or include an explicit, approved constitution amendment.

### Principle 2 – Minimal Resource Footprint

- When idle, the app MUST target **< 1% CPU usage** on a typical development machine for macOS 13+.
- Under normal operation, the app SHOULD remain under **50 MB of resident memory**; exceeding this budget requires explicit justification and issue tracking.
- Timer ticking MUST be implemented using lightweight mechanisms such as `Timer` or `DispatchSourceTimer` with a **1 Hz** cadence; higher-frequency timers are prohibited unless justified by a future spec.
- The app MUST avoid heavy work at startup and MUST lazily initialize components that are not required for showing the initial menu bar item and opening the popover.
- Plans and specs MUST state any known trade-offs that could impact CPU or memory, and tasks implementing such changes MUST include measurement or profiling steps.

### Principle 3 – Native macOS Integration

- The app MUST follow macOS Human Interface Guidelines for layout, typography, and interaction where feasible within SwiftUI.
- Timer completion notifications MUST use the native macOS notification system.
- The app MUST respect system lifecycle events (login, sleep/wake, fast user switching) and MUST avoid crashes or corrupted state during these transitions.
- Visual and behavioral elements MUST feel like a first-class macOS app, avoiding cross-platform UI widgets that break platform expectations.
- Accessibility support for core controls (start, pause, reset, mode selection, settings) MUST be compatible with VoiceOver in the MVP.

### Principle 4 – Three-Mode Timer System

- The app MUST provide exactly three timer modes in the MVP:
  - **Work** (default 25 minutes, icon 💼)
  - **Rest Your Eyes** (default 2 minutes, icon 👁️)
  - **Long Rest** (default 15 minutes, icon 🌟)
- The app MUST allow users to start, pause, resume, and reset the current timer.
- At most **one timer** MAY be running at any given time; starting a timer in one mode MUST stop any active timer in another mode but only after a confirmation from the user to stop current timer and start new mode.
- Timer mode definitions (durations, labels, icons) MUST be centralized in configuration models to keep the UI and engine consistent.
- Future additional modes or automatic mode switching are allowed only via later specs and MUST not be introduced in the 001 MVP implementation.

### Principle 5 – Enhanced Visual Interface (Deferred for MVP 001)

- The long-term design direction includes richer visual treatments (for example, Bauhaus- or liquid-glass-inspired styling) and advanced animation.
- Enhanced visual treatments that increase complexity (custom blur effects, heavy animations, advanced theming systems) MUST be treated as **post-MVP** work.
- For the 001 MVP, the UI MUST remain visually clean and minimal; any proposal that significantly increases visual complexity MUST be explicitly deferred to a later spec (002 or 003) unless this constitution is amended.
- Specifications and tasks for MVP 001 MUST NOT introduce non-trivial visual effects beyond what is required to achieve a clear, legible SwiftUI interface.

### Principle 6 – Clean, Minimal SwiftUI UI

- The menu bar icon MUST show the current mode and remaining time in a concise format (for example, `💼 22:15`).
- The primary popover MUST include:
  - A prominent timer display (MM:SS),
  - A mode selector for Work, Rest Your Eyes, and Long Rest,
  - Start/Pause/Resume/Reset controls,
  - An entry point to settings (button or gear icon) that opens a secondary popover or sheet for duration adjustments.
- Layout and components MUST remain simple and legible; the UI MUST prioritize clarity and low cognitive load over visual ornamentation.
- The SwiftUI view hierarchy SHOULD be modular, separating concerns such as timer display, mode selection, and settings into composable subviews that can evolve in later versions without breaking the MVP.

### Principle 7 – Keyboard Accessibility and Advanced Shortcuts (Deferred for MVP 001)

- Long-term, the app is expected to provide rich keyboard accessibility, including global shortcuts and fully keyboard-navigable controls.
- For MVP 001, only basic accessibility requirements are enforced: VoiceOver compatibility for core controls as stated in Principle 3.
- Keyboard shortcuts, system-wide hotkeys, or complex focus management beyond standard SwiftUI behavior MUST be explicitly deferred to later specs (002 or 003) unless this constitution is amended.
- Any future spec introducing keyboard shortcuts MUST describe how they remain consistent with the menu-bar-only philosophy and resource constraints defined in Principles 1 and 2.

### Principle 8 – Responsive UI and Code Quality

- The settings UI MUST be responsive and adapt properly to window resizing and system font size changes.
- All SwiftUI views MUST use proper layout constraints and avoid hardcoded sizes or positions.
- Code generated by AI tools ("vibe coding") MUST be reviewed and refactored to meet established architectural patterns and quality standards.
- Any UI component that fails responsiveness tests MUST be refactored before release; temporary workarounds are prohibited.
- Views MUST be modular and composable, with clear separation between layout, styling, and behavior logic.

### Principle 9 – Timer State Persistence and Continuity

- When a user attempts to quit the application while a timer is active, the app MUST open a dedicated window (styled consistently with the settings window) presenting three options:
  1. **Stop timer and quit app**: Terminates the app and resets the timer state.
  2. **Quit app and leave timer running**: Terminates the app but persists the current timer state (remaining time, mode). On next launch, the timer MUST resume from the persisted state (e.g., if 20 mins remained and user returns 10 mins later, timer shows 10 mins remaining).
  3. **Cancel**: Closes the quit window and keeps the app running with the timer active.
- If the timer is NOT running, the app MUST quit immediately without showing this window.
- Timer persistence MUST include remaining time, current mode, and running state.
- The app MUST validate restored timer state on launch and handle corruption gracefully by falling back to a safe default state.
- When switching timer modes while a timer is running, the app MUST display a confirmation dialog asking if the user wants to switch modes and lose the current running timer.

### Principle 10 – Enhanced Audio Experience

- Timer completion alarms MUST use the enhanced alarm sound file located at `sounds/alarm.mp3`.
- Audio playback MUST handle errors gracefully and fall back to system notification sounds if the custom sound file is unavailable.
- Volume controls for alarm sounds MUST respect system audio settings and provide user-configurable volume levels.
- The app MUST support audio playback even when the application is in the background or the menu bar popover is closed.

## Architecture, Performance, and Quality Constraints

- The architecture MUST separate concerns into:
  - A **TimerEngine** responsible solely for countdown logic and state transitions, free of any UI framework dependencies.
  - An **AppState** (for example, an `ObservableObject`) that owns the `TimerEngine`, holds current configuration and timer mode, and handles persistence.
  - A **SwiftUI UI layer** composed of views that observe `AppState`, render state, and forward user intents (start, pause, reset, change mode, update settings).
- The TimerEngine MUST NOT import UI modules or directly handle presentation concerns; it MUST be deterministic and testable via unit tests.
- The AppState layer MUST map engine state into UI-friendly models and MUST be the only layer allowed to coordinate persistence and engine control.
- Timer UI updates MUST occur within approximately **100 ms** of each tick under normal conditions.
- The menu bar popover MUST open within approximately **100 ms** of the user clicking the menu bar icon under normal conditions.
- The app MUST NOT crash when switching modes, adjusting settings, or rapidly opening and closing the popover; regressions in these flows MUST be treated as blocking issues for release.
- Persistence of per-mode durations MUST use either `UserDefaults` or a small JSON file located under the user's `~/Library/Application Support/Sharp Timer/` directory.
- Persisted durations MUST be validated to remain within a **1–60 minute** range; invalid values MUST be corrected to safe defaults or rejected with clear behavior.
- Timer state (remaining time, mode, running state) MUST be persisted when the user quits the application with an active timer and chooses "Quit and leave timer running".
- Persistence operations MUST complete within **50 ms** to avoid blocking the main thread during application termination.

## Development Workflow and Constitution Compliance

- All feature specifications for Sharp Timer MUST declare how they respect each applicable core principle and MUST explicitly call out any proposed deviations.
- Implementation plans MUST include a **Constitution Check** gate that evaluates architecture, performance, and UX decisions against this document before deep design or implementation begins.
- Tasks derived from specs MUST trace back to principles where relevant (for example, performance-related tasks referencing Principle 2, or UI tasks referencing Principles 1, 3, and 6).
- Unit tests for the TimerEngine and configuration persistence are REQUIRED for the MVP; these tests MUST cover normal behavior, boundary durations, and invalid configuration handling.
- UI tests for responsive behavior in settings views are REQUIRED to ensure proper adaptation to different window sizes and system configurations.
- Integration tests for timer state persistence and restoration are REQUIRED to verify continuity across application launches.
- Audio playback tests are REQUIRED to ensure enhanced alarm sounds function correctly in various system states.
- Any proposed feature that would:
  - introduce additional timer modes,
  - change resource budgets,
  - alter the menu-bar-only behavior,
  - or enable advanced visual or keyboard features
  MUST either be explicitly deferred or accompanied by a proposal to amend this constitution.
- Pull requests and code reviews touching timer logic, persistence, or the primary user interface MUST include a brief note on constitution compliance in their description.

## Governance

- This constitution governs the design and implementation of the Sharp Timer app and supersedes conflicting local practices or historical code patterns.
- The constitution applies in particular to the **001 MVP Swift** specification targeting macOS 13+; future specs (002, 003, etc.) MUST either comply with the current version or explicitly propose amendments.
- Amendments to this constitution MUST:
  - be documented in a dedicated spec or RFC,
  - explain the motivation and impact on existing principles,
  - classify the change as a **MAJOR**, **MINOR**, or **PATCH** version update,
  - and include a migration or rollout plan when behavior changes are user-visible.
- Versioning follows semantic rules:
  - **MAJOR**: Backward-incompatible changes to principles or governance (for example, removing or redefining a core principle, or relaxing a non-negotiable constraint).
  - **MINOR**: Addition of new principles or sections, or substantial expansion of existing guidance without breaking existing guarantees.
  - **PATCH**: Clarifications, corrections, or non-semantic refinements that do not change obligations, budgets, or guarantees.
- Any spec or implementation that cannot comply with the current constitution MUST first secure an amendment; "temporary" violations are not allowed without a tracked amendment plan.
- Compliance with this constitution MUST be checked at key milestones:
  - During feature specification (`spec.md` creation),
  - During implementation planning (`plan.md` Constitution Check),
  - Before release of new app versions.

**Version**: 1.2.0 | **Ratified**: 2025-11-17 | **Last Amended**: 2025-11-20
