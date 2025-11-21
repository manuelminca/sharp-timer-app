# Tasks: Bauhaus UI Redesign

**Feature Branch**: `007-bauhaus-ui-redesign`
**Spec**: [specs/007-bauhaus-ui-redesign/spec.md](spec.md)

## Phase 1: Setup & Foundation

**Goal**: Establish the Bauhaus design system (Theme) and core UI components.

- [ ] T001 Create Theme directory structure at `Sharp Timer App/Sharp Timer App/Features/Theme/`
- [ ] T002 [P] Implement Bauhaus Color Palette in `Sharp Timer App/Sharp Timer App/Features/Theme/Color+Bauhaus.swift`
- [ ] T003 [P] Implement Bauhaus Typography in `Sharp Timer App/Sharp Timer App/Features/Theme/Font+Bauhaus.swift`
- [ ] T004 Implement `BauhausTheme` struct to centralize access in `Sharp Timer App/Sharp Timer App/Features/Theme/BauhausTheme.swift`
- [ ] T005 Implement `BauhausButtonStyle` for geometric buttons in `Sharp Timer App/Sharp Timer App/Features/Theme/BauhausButtonStyle.swift`
- [ ] T006 Enforce Light Mode globally in `Sharp Timer App/Sharp Timer App/Sharp_Timer_AppApp.swift`

## Phase 2: User Story 1 - Timer Display (P1)

**Goal**: Apply Bauhaus aesthetic to the main timer interface.
**Independent Test**: Launch app, verify timer popover uses geometric shapes and primary colors.

- [ ] T007 [US1] Update `TimerDisplayView` background and layout to use Bauhaus grid in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift`
- [ ] T008 [US1] Apply Bauhaus typography to Timer text in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift`
- [ ] T009 [US1] Replace standard buttons with `BauhausButtonStyle` (Start/Stop/Reset) in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift`
- [ ] T010 [US1] Update Mode Selector to use geometric shapes (Rectangles) in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift`

## Phase 3: User Story 2 - Settings (P2)

**Goal**: Apply Bauhaus aesthetic to the settings menu.
**Independent Test**: Open Settings, verify steppers and labels match the theme.

- [ ] T011 [US2] Update `DurationSettingsView` background and labels to use Bauhaus Theme in `Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift`
- [ ] T012 [US2] Style Steppers and TextFields with geometric borders in `Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift`

## Phase 4: User Story 3 - Dialogs (P3)

**Goal**: Apply Bauhaus aesthetic to confirmation dialogs.
**Independent Test**: Trigger Quit, verify confirmation window matches the theme.

- [ ] T013 [US3] Update `QuitOptionsView` to use Bauhaus Theme (colors, fonts, buttons) in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift`
- [ ] T014 [US3] Ensure Quit Window background matches theme in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitWindowController.swift`

## Phase 5: Polish & Verification

**Goal**: Ensure consistency and accessibility.

- [ ] T015 Verify text contrast ratios against WCAG AA standards (manual check or UI test adjustment)
- [ ] T016 Verify responsiveness of all views (Timer, Settings) by testing with different text lengths (simulated)

## Dependencies

- Phase 1 must be completed before Phase 2, 3, and 4.
- Phase 2, 3, and 4 can technically be done in parallel, but sequential is recommended to ensure consistency.

## Implementation Strategy

1.  **Foundation**: Build the `Theme` struct and helpers first. This is the source of truth.
2.  **MVP (US1)**: Tackle the main Timer View. This delivers the biggest visual impact immediately.
3.  **Consistency (US2, US3)**: Propagate the theme to secondary screens.
