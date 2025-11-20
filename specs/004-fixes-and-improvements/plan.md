# Implementation Plan: Fixes and Improvements

**Branch**: `004-fixes-and-improvements` | **Date**: 2025-11-19 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/004-fixes-and-improvements/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

This plan covers the implementation of a simplified two-step quit button, settings persistence fixes, and visual improvements to the menu bar icon and main view. The approach involves modifying the `TimerDisplayView` to handle the quit button state locally, enhancing the `TimerProfileStore` for reliable settings loading, and updating the `MenuBarController` to display the countdown.

## Technical Context

**Language/Version**: Swift 5.9
**Primary Dependencies**: SwiftUI, Combine, AppKit, Foundation
**Storage**: UserDefaults (Settings), JSON (Timer State)
**Testing**: XCTest (Logic), XCUITest (UI Flows)
**Target Platform**: macOS 13.0+
**Project Type**: Single macOS Application
**Performance Goals**: < 1% CPU idle, < 50MB memory, 1Hz timer updates
**Constraints**: Menu bar exclusive, App Sandbox
**Scale/Scope**: Small feature update

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **Principle 1 (Menu Bar Exclusive)**: Changes maintain the menu-bar-only model.
- [x] **Principle 2 (Resource Footprint)**: Menu bar timer updates will use the existing 1Hz tick to minimize impact.
- [x] **Principle 3 (Native Integration)**: Quit button behaves predictably within the menu bar popover.
- [x] **Principle 6 (Clean UI)**: Removing "Mode" text simplifies the interface.

## Project Structure

### Documentation (this feature)

```text
specs/004-fixes-and-improvements/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
Sharp Timer App/
├── Sharp Timer App/
│   ├── App/
│   │   ├── AppState.swift          # Update for persistence logic
│   │   └── ApplicationDelegate.swift # Handle quit requests
│   ├── Features/
│   │   ├── MenuBar/
│   │   │   ├── MenuBarController.swift # Update for icon timer display
│   │   │   └── TimerDisplayView.swift  # Remove "Mode" text, implement 2-step quit button
│   │   └── Settings/
│   │       └── DurationSettingsView.swift # Fix persistence binding
│   └── Persistence/
│       └── TimerProfileStore.swift # Ensure reliable loading
```

**Structure Decision**: Standard SwiftUI app structure, modifying existing components.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | N/A |
