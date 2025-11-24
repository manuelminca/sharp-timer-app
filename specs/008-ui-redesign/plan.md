# Implementation Plan: Bauhaus UI Redesign

**Branch**: `008-ui-redesign` | **Date**: 2025-11-24 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/008-ui-redesign/spec.md`

## Summary

Implement a comprehensive Bauhaus-inspired UI redesign for the Sharp Timer App, translating the provided React/Figma design into native SwiftUI. The redesign features geometric shapes, a primary color palette (Red/Blue/Yellow), and animated visual feedback, while strictly adhering to the menu-bar-only architecture and performance constraints. This implements the previously deferred "Enhanced Visual Interface" work.

## Technical Context

**Language/Version**: Swift 5.9  
**Primary Dependencies**: SwiftUI, Combine, UserNotifications  
**Storage**: UserDefaults (App Preferences), JSON (Timer State Persistence)  
**Testing**: Swift Testing (Unit), XCTest (UI)  
**Target Platform**: macOS 13+  
**Project Type**: macOS Menu Bar Application  
**Performance Goals**: UI updates < 100ms, Idle CPU < 1%  
**Constraints**: < 50MB Memory Footprint, Menu Bar Popover Constraints (approx 350x500pt)  
**Scale/Scope**: Complete styling overhaul of the main timer view and settings.  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle 1 (Menu Bar Exclusive)**: ✅ The Bauhaus design, originally full-screen web, is adapted to a fix-sized popover layout. No Dock icon or independent windows (except Quit Confirmation).
- **Principle 2 (Minimal Resource Footprint)**: ✅ Using standard SwiftUI shapes (`Circle`, `Rectangle`) and native animations (`.spring()`) ensures low overhead compared to bitmap interactions.
- **Principle 3 (Native macOS Integration)**: ✅ While stylized, the app uses standard controls and interactions where possible.
- **Principle 4 (Three-Mode Timer)**: ✅ The new UI explicitly supports and visually differentiates the three mandated modes.
- **Principle 5 (Enhanced Visual Interface)**: ⚠️ **AMENDMENT/ACTIVATION**: This feature 008 explicitly implements the "Enhanced Visual Interface" work that was deferred in MVP 001. The Constitution allows this as post-MVP work. We are proceeding as this feature IS the implementation of that future work.
- **Principle 9 (Timer Persistence)**: ✅ The Quit Confirmation dialog will be restyled to match the Bauhaus theme but preserve the required logic.
- **Principle 10 (Audio)**: ✅ Existing audio logic is preserved; UI changes do not impact audio playback.

## Project Structure

### Documentation (this feature)

```text
specs/008-ui-redesign/
├── plan.md              # This file
├── research.md          # Design translation and decisions
├── data-model.md        # Visual theme configuration models
├── quickstart.md        # Guide to running the redesigned app
├── contracts/           # Theme interface definition
│   └── theme.yaml
└── tasks.md             # Implementation tasks
```

### Source Code (repository root)

```text
Sharp Timer App/
└── Sharp Timer App/
    ├── App/
    │   └── Sharp_Timer_AppApp.swift  # Entry point
    ├── Features/
    │   ├── MenuBar/
    │   │   ├── TimerDisplayView.swift       # MAIN UI (Redesigned)
    │   │   ├── ModeSelectorView.swift       # New subview
    │   │   └── ControlButtonsView.swift     # New subview
    │   ├── Settings/
    │   │   └── DurationSettingsView.swift   # Redesigned settings
    │   └── Theme/                           # NEW DIRECTORY
    │       ├── BauhausTheme.swift           # Theme constants
    │       ├── Color+Bauhaus.swift          # Color extensions
    │       ├── Font+Bauhaus.swift           # Font extensions
    │       └── Shapes/                      # Geometric shapes
    │           └── RotatedSquare.swift
    ├── Engine/
    │   └── TimerEngine.swift             # Unchanged logic
    └── Assets.xcassets/                  # Updated app icon if needed
```

**Structure Decision**: Option 1 (Single project). The existing structure is flat; we are organizing new UI components into `Features/Theme` to centralize the design system.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Custom Shape Drawing | Required for Bauhaus aesthetic | Standard system shapes don't support the specific geometric compositions (rotated/clipped overlays) needed for the design identification. |
