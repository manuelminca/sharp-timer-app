# Implementation Plan: Bauhaus UI Redesign

**Branch**: `007-bauhaus-ui-redesign` | **Date**: 2025-11-21 | **Spec**: [specs/007-bauhaus-ui-redesign/spec.md](spec.md)
**Input**: Feature specification from `/specs/007-bauhaus-ui-redesign/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Redesign the application UI to follow Bauhaus design principles (geometric shapes, primary colors, minimalism) without altering existing functionality. This involves updating SwiftUI views for the Timer, Settings, and Quit dialogs to use a centralized Theme definition.

## Technical Context

**Language/Version**: Swift 5.9
**Primary Dependencies**: SwiftUI, AppKit, Combine
**Storage**: UserDefaults (Settings), JSON (Timer State) - *Existing, Unchanged*
**Testing**: XCTest, XCUITest
**Target Platform**: macOS 13+
**Project Type**: macOS Menu Bar App
**Performance Goals**: < 1% CPU idle, < 50MB memory (Constitution Principle 2)
**Constraints**: Menu bar exclusive, Sandboxed, Light Theme Only (per Spec)
**Scale/Scope**: UI Layer Redesign (~5-10 Views)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle 1 (Menu Bar Exclusive)**: ✅ Compliant. Redesign targets the menu bar popover and settings window.
- **Principle 2 (Minimal Resource Footprint)**: ✅ Compliant. Static geometric shapes and colors have negligible performance impact.
- **Principle 3 (Native macOS Integration)**: ✅ Compliant. Built with standard SwiftUI components styled to look Bauhaus.
- **Principle 4 (Three-Mode Timer System)**: ✅ Compliant. Modes remain unchanged; visual distinction will be enhanced via color.
- **Principle 5 (Enhanced Visual Interface)**: ✅ Compliant. Bauhaus style is inherently minimalist and clean, aligning with the requirement to avoid "heavy animations" or "custom blur effects". This is a stylistic refinement, not a complexity increase.
- **Principle 6 (Clean, Minimal SwiftUI UI)**: ✅ Compliant.
- **Principle 8 (Responsive UI)**: ✅ Compliant. Spec explicitly requires responsive components (FR-007).
- **Principle 9 (Persistence)**: ✅ Compliant. No changes to persistence logic.
- **Principle 10 (Audio)**: ✅ Compliant. No changes to audio.

## Project Structure

### Documentation (this feature)

```text
specs/007-bauhaus-ui-redesign/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (N/A for this UI-only feature)
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
Sharp Timer App/
├── Sharp Timer App/
│   ├── App/
│   │   ├── AppState.swift
│   │   └── ...
│   ├── Features/
│   │   ├── MenuBar/
│   │   │   ├── TimerDisplayView.swift  # Target for redesign
│   │   │   └── ...
│   │   ├── Settings/
│   │   │   ├── DurationSettingsView.swift # Target for redesign
│   │   │   └── ...
│   │   └── Theme/                      # NEW: Centralized Theme Logic
│   │       ├── BauhausTheme.swift
│   │       ├── Color+Bauhaus.swift
│   │       └── Font+Bauhaus.swift
│   └── ...
```

**Structure Decision**: Adding a `Theme` directory under `Features` (or `App` depending on preference, `Features/Theme` seems appropriate for a visual feature) to centralize the design system. Existing Views will be modified in place.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | N/A |
