# Implementation Plan: Sharp Timer Menu Bar Experience

**Branch**: `001-menu-bar-timer` | **Date**: 2025-11-17 | **Spec**: [Feature Specification](specs/001-menu-bar-timer/spec.md)  
**Input**: Feature specification from `/specs/001-menu-bar-timer/spec.md`

## Summary

Deliver a minimalist macOS 13+ menu-bar-only timer that lets users run Work, Rest Your Eyes, and Long Rest sessions with second-level feedback, native notifications, and persistent per-mode durations. The build will follow the Constitution’s separation of concerns: a pure Swift TimerEngine, an ObservableObject AppState that mediates persistence/notifications, and SwiftUI menu bar views built with `MenuBarExtra` for instant access.

## Technical Context

**Language/Version**: Swift 5.9 (Xcode 15, macOS 13 deployment target)  
**Primary Dependencies**: SwiftUI, Combine, UserNotifications, Foundation (Timer/DispatchSourceTimer), AppKit bridge for `NSStatusItem` behaviors  
**Storage**: `UserDefaults` via `AppStorage` wrapper for per-mode durations and last-selected mode  
**Testing**: XCTest with async expectations for TimerEngine cadence + UserDefaults persistence tests  
**Target Platform**: macOS 13+ (menu bar application, no dock presence)  
**Project Type**: Single native macOS SwiftUI target with test bundles  
**Performance Goals**: Timer tick updates within 100 ms; popover open latency <100 ms; background CPU <2% idle and <1% when timer paused; memory footprint <50 MB steady-state  
**Constraints**: Menu bar only (Principle 1), single timer at a time (Principle 4), native notifications + VoiceOver labels (Principles 3 & 6), persistence limited to local device (spec assumptions)  
**Scale/Scope**: Single-user utility with three timer modes, <10 Swift source files touched in MVP, <5 view components, <5 unit tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| P1 Menu Bar Exclusive | PASS | App runs solely as `MenuBarExtra`; no dock icon or cmd-tab presence. |
| P2 Resource Footprint | PASS | TimerEngine built on `DispatchSourceTimer`; persistence is lightweight; profiling tasks planned. |
| P3 Native Integration | PASS | SwiftUI + UserNotifications + macOS HIG-compliant popovers; accessibility labels planned. |
| P4 Three-Mode System | PASS | Exactly Work/Rest Your Eyes/Long Rest supported with centralized configs. |
| P5 Deferred Visual Enhancements | PASS | MVP keeps minimal styling; advanced visuals deferred. |
| P6 Clean SwiftUI UI | PASS | Menu bar shows icon + MM:SS; popover contains timer display, mode picker, controls, settings link. |
| P7 Deferred Shortcuts | PASS | No global shortcuts introduced in MVP; VoiceOver only. |

## Project Structure

### Documentation (this feature)

```text
specs/001-menu-bar-timer/
├── plan.md              # This file (/speckit.plan output)
├── research.md          # Phase 0 deliverable
├── data-model.md        # Phase 1 deliverable
├── quickstart.md        # Phase 1 deliverable
├── contracts/           # Phase 1 deliverable (engine + UI contracts)
└── tasks.md             # Phase 2 deliverable (created by /speckit.tasks)
```

### Source Code (repository root)

```text
Sharp Timer App/
├── Sharp Timer App/
│   ├── App/
│   │   ├── Sharp_Timer_AppApp.swift
│   │   └── AppState.swift            # new ObservableObject orchestrating engine + persistence
│   ├── Engine/
│   │   ├── TimerEngine.swift         # pure countdown logic
│   │   └── TimerMode.swift           # enums + metadata
│   ├── Persistence/
│   │   └── TimerProfileStore.swift   # UserDefaults adapter
│   ├── Features/
│   │   ├── MenuBar/
│   │   │   ├── MenuBarController.swift
│   │   │   └── TimerDisplayView.swift
│   │   └── Settings/
│   │       └── DurationSettingsView.swift
│   ├── Scenes/
│   │   └── ContentView.swift
│   ├── Resources/
│   │   └── Assets.xcassets
│   └── Item.swift
├── Sharp Timer AppTests/
│   ├── TimerEngineTests.swift
│   └── PersistenceTests.swift
└── Sharp Timer AppUITests/
    └── MenuBarFlowTests.swift
```

**Structure Decision**: Single macOS SwiftUI target (`Sharp Timer App/Sharp Timer App/`) with supporting test bundles already scaffolded. New Engine, Persistence, and Feature subdirectories will host the TimerEngine, profile store, and menu bar/settings views, aligning with the Constitution’s separation-of-concerns guidance.

## Complexity Tracking

No constitution violations or extra projects anticipated; section intentionally left empty pending future changes.
