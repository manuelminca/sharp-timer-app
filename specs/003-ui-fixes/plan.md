# Implementation Plan: UI Fixes and Timer Enhancements

**Branch**: `003-ui-fixes` | **Date**: 2025-11-17 | **Spec**: [specs/003-ui-fixes/spec.md](specs/003-ui-fixes/spec.md)  
**Input**: Feature specification from `/specs/003-ui-fixes/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Deliver a hardened macOS menu-bar timer experience by (a) rebuilding the settings popover with adaptive SwiftUI stacks so every control remains usable across window sizes and dynamic type settings, (b) gating mode switches behind confirmation dialogs to prevent accidental timer loss, (c) persisting in-progress timer state when the user quits—complete with a quit confirmation dialog that offers three explicit outcomes—and (d) upgrading the alarm playback pipeline to a new custom MP3 with graceful fallbacks. Additionally, address three critical regression bugs: (e) restore alarm audio playback functionality that has stopped working, (f) fix settings stepper controls that cause window minimization when clicked, and (g) add a visible quit button next to Settings for proper app lifecycle management. Implementation centers on AppState/TimerEngine enhancements, refreshed SwiftUI layouts, persistence plus audio subsystems, and critical bug fixes that respect newly ratified constitutional principles (8–10).

## Technical Context

**Language/Version**: Swift 5.9 (Xcode 15, macOS 13 deployment target)  
**Primary Dependencies**: SwiftUI, Combine, AppKit bridge (`NSStatusItem`, `NSAlert`, `NSWindow`), UserNotifications, AVFoundation (`AVAudioPlayer`), Foundation (`Timer`, `DispatchSourceTimer`)  
**Storage**: `UserDefaults` for settings + timer metadata, JSON snapshot under `~/Library/Application Support/Sharp Timer/timer-state.json` for crash-safe persistence  
**Testing**: XCTest (unit + integration), XCUITest for menu bar flow & responsive settings verification, audio playback harness via `AVAudioPlayer` stubs  
**Target Platform**: macOS 13+ (menu bar app only)  
**Project Type**: Single macOS SwiftUI app (`Sharp Timer App/Sharp Timer App/*.swift`)  
**Performance Goals**: <1% CPU while idle, menu bar popover open within 100 ms, timer UI refresh within 100 ms of ticks, persistence writes <50 ms, alarm playback start <150 ms after timer completion, settings stepper response <50ms, quit button rendering <100ms
**Constraints**: Stay under 50 MB resident memory, no dock icon, dialogs must be VoiceOver friendly, persistence cannot block main thread, confirmation dialogs must be synchronous with user intent, alarm playback must work across all system volume levels
**Scale/Scope**: Single-user productivity utility; scope limited to three timer modes defined in constitution, no cloud sync or multi-user state, critical regression fixes for alarm audio, settings focus, and quit affordance

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle / Constraint | Mandate | Compliance Notes |
| --- | --- | --- |
| Principle 1 – Menu Bar Exclusive | No dock/app switcher presence; interactions via menu bar | All new dialogs triggered from menu bar popover or `NSApp` termination hooks; no windowed UI beyond popovers/sheets |
| Principle 2 – Minimal Resource Footprint | <1% idle CPU, memory budget 50 MB | Responsive layout refactor keeps SwiftUI lightweight; persistence uses incremental JSON/UserDefaults writes |
| Principle 3 – Native macOS Integration | Follow HIG, native notifications, VoiceOver-ready | Confirmation dialogs implemented with `NSAlert`/SwiftUI `Alert`, respecting accessibility |
| Principle 4 – Three-Mode Timer System | Single active timer with confirmation before switching | Mode switch confirmation gate enforces single active timer semantics |
| Principle 8 – Responsive UI and Code Quality | Settings must adapt to size & dynamic type, no vibe-code leftovers | Planned refactor introduces flexible stacks, layout tests, linting for hardcoded frames, stepper focus fixes |
| Principle 9 – Timer State Persistence & Continuity | Quit dialog with three options, restore state on relaunch | AppState persistence + resume pipeline ensures continuity, visible quit button added |
| Principle 10 – Enhanced Audio Experience | Use new MP3, fallback gracefully | AVAudioPlayer-backed alarm service with error handling + fallback notification, audio regression fixes |
| Architecture Constraints | TimerEngine/AppState separation, persistence <50 ms | Persistence handled in AppState background queue; TimerEngine remains UI-agnostic |
| Development Workflow | Tests for engine, persistence, UI responsiveness, audio | Plan includes XCTest & XCUITest coverage plus audio regression tests |

**Gate Result**: PASS — No violations identified; no additional approvals required.

## Project Structure

### Documentation (this feature)

```text
specs/003-ui-fixes/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── spec.md
├── checklists/
│   └── requirements.md
└── contracts/
    ├── mode-switching.yaml
    └── quit-confirmation.yaml
```

### Source Code (repository root)

```text
Sharp Timer App/
└── Sharp Timer App/
    ├── App/
    │   ├── AppState.swift
    │   ├── AppState+Notifications.swift
    │   └── NotificationPreference.swift
    ├── Engine/
    │   ├── TimerEngine.swift
    │   └── TimerMode.swift
    ├── Features/
    │   ├── MenuBar/
    │   │   ├── MenuBarController.swift
    │   │   └── TimerDisplayView.swift
    │   └── Settings/
    │       └── DurationSettingsView.swift
    ├── Persistence/
    │   └── TimerProfileStore.swift
    ├── Extensions/
    │   └── Label+Styles.swift
    └── sounds/
        └── alarm.mp3
tests/
├── Sharp Timer AppTests/
│   ├── TimerEngineTests.swift
│   ├── PersistenceTests.swift
│   └── Sharp_Timer_AppTests.swift
└── Sharp Timer AppUITests/
    ├── MenuBarFlowTests.swift
    ├── Sharp_Timer_AppUITests.swift
    └── Sharp_Timer_AppUITestsLaunchTests.swift
```

**Structure Decision**: Continue using the single macOS SwiftUI project housed in `Sharp Timer App/Sharp Timer App/`, extending existing AppState/TimerEngine/Settings modules plus persistence and audio directories. No additional packages or subprojects required.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
| --- | --- | --- |
| _None_ | – | – |
