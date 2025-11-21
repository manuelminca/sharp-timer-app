# Implementation Plan: Mode Auto-Start Setting

**Branch**: `008-mode-auto-start-setting` | **Date**: 2025-11-21 | **Spec**: specs/008-mode-auto-start-setting/spec.md
**Input**: Feature specification from `/specs/008-mode-auto-start-setting/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Add a tickbox in settings to control automatic timer start on mode change. When enabled, changing timer mode starts the timer if paused; when disabled, leaves it paused. Persist setting across sessions.

## Technical Context

**Language/Version**: Swift 5.9  
**Primary Dependencies**: SwiftUI, Combine, UserNotifications  
**Storage**: UserDefaults for profile settings, JSON file for timer state persistence  
**Testing**: XCTest  
**Target Platform**: macOS 13+  
**Project Type**: Mobile (macOS app)  
**Performance Goals**: <1% CPU idle, timer updates <100ms  
**Constraints**: Menu bar exclusive, 1 Hz timer cadence, <50MB memory  
**Scale/Scope**: Small feature adding one boolean setting

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Principle 1 - Menu Bar Exclusive**: PASS - Feature adds setting in existing popover, no Dock or app switcher changes.

**Principle 2 - Minimal Resource Footprint**: PASS - Adds one boolean setting, no impact on CPU/memory.

**Principle 3 - Native macOS Integration**: PASS - Uses SwiftUI Toggle, follows HIG.

**Principle 4 - Three-Mode Timer System**: PASS - No changes to modes.

**Principle 5 - Enhanced Visual Interface**: PASS - Adds simple toggle, no complex visuals.

**Principle 6 - Clean, Minimal SwiftUI UI**: PASS - Adds toggle in existing settings layout.

**Principle 7 - Keyboard Accessibility**: PASS - Toggle supports standard accessibility.

**Principle 8 - Responsive UI**: PASS - Settings view already responsive.

**Principle 9 - Timer State Persistence**: PASS - Uses existing persistence mechanism.

**Principle 10 - Enhanced Audio Experience**: PASS - No audio changes.

All gates pass. No violations.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
Sharp Timer App/
├── App/
│   ├── AppState.swift          # Modify switchToMode logic
│   └── ...
├── Engine/
│   ├── TimerEngine.swift       # Add changeMode method
│   └── ...
├── Features/
│   ├── Settings/
│   │   ├── DurationSettingsView.swift  # Add auto-start toggle
│   │   └── ...
│   └── ...
├── Persistence/
│   ├── TimerProfileStore.swift # Add autoStartOnModeChange to profile
│   └── ...
└── ...

Sharp Timer AppTests/
├── TimerEngineTests.swift      # Test changeMode
└── ...
```

**Structure Decision**: Single macOS app project. Modifications to existing files in App, Engine, Features/Settings, Persistence. No new directories needed.

## Complexity Tracking

No constitution violations. Feature fits within existing architecture.
