# Implementation Plan: Improve Quit Functionality

**Branch**: `005-improve-quit-functionality` | **Date**: 2025-11-20 | **Spec**: [link](spec.md)
**Input**: Feature specification from `/specs/005-improve-quit-functionality/spec.md`

## Summary

Implement a new quit flow for the Sharp Timer App. When the user attempts to quit while a timer is running, a dedicated window will appear offering three options: "Stop timer and quit", "Quit and leave timer running" (persisting state), and "Cancel". This replaces the generic confirmation dialog.

## Technical Context

**Language/Version**: Swift 5.9
**Primary Dependencies**: SwiftUI, AppKit, Combine
**Storage**: JSON file (`timer-state.json`) for persistence
**Testing**: XCTest (Unit), XCUITest (UI)
**Target Platform**: macOS 13+
**Project Type**: Single macOS Application (Menu Bar)
**Performance Goals**: Window open < 100ms, Persistence < 50ms
**Constraints**: App is `LSUIElement` (no dock icon), must handle window lifecycle manually.
**Scale/Scope**: Small feature, touches AppState and UI.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle 1 (Menu Bar Exclusive)**: The new quit window is a secondary dialog, similar to settings, which is permitted.
- **Principle 9 (Timer State Persistence)**: This feature directly implements the updated Principle 9 requirements.
- **Principle 2 (Resource Footprint)**: Persistence must be lightweight (JSON) to meet the < 50ms requirement.

## Project Structure

### Documentation (this feature)

```text
specs/005-improve-quit-functionality/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
Sharp Timer App/Sharp Timer App/
├── App/
│   ├── AppState.swift           # Update: Handle persistence logic
│   └── ApplicationDelegate.swift # Update: Handle quit interception
├── Features/
│   └── MenuBar/
│       ├── QuitOptionsView.swift # New: The 3-option window
│       └── TimerDisplayView.swift # Update: Trigger new window
└── Persistence/
    └── TimerProfileStore.swift  # Update: Add snapshot persistence
```

**Structure Decision**: Standard feature addition within existing architecture.
