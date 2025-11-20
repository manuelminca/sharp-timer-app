# Tasks: Improve Quit Functionality

**Feature**: Improve Quit Functionality
**Status**: Pending
**Branch**: `005-improve-quit-functionality`

## Phase 1: Setup

- [ ] T001 Create `QuitOptionsView.swift` file structure in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift`

## Phase 2: Foundational

- [ ] T002 Implement `TimerPersistenceSnapshot` struct in `Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift`
- [ ] T003 Implement snapshot save/load logic in `Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift`

## Phase 3: User Story 1 - Quit When Idle

- [ ] T004 [US1] Verify and update `quitApplication` logic in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift` to ensure immediate quit when idle

## Phase 4: User Story 2 - Quit Options Window

- [ ] T005 [US2] Implement UI for `QuitOptionsView` with 3 buttons in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift`
- [ ] T006 [US2] Update `TimerDisplayView` to open `QuitOptionsView` as a new window when quit requested while running in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift`

## Phase 5: User Story 3 - Stop Timer and Quit

- [ ] T007 [US3] Implement "Stop and Quit" action in `QuitOptionsView` calling `NSApp.terminate` in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift`

## Phase 6: User Story 4 - Persist Timer State

- [ ] T008 [US4] Implement `persistState` method in `AppState` to save snapshot in `Sharp Timer App/Sharp Timer App/App/AppState.swift`
- [ ] T009 [US4] Implement "Persist and Quit" action in `QuitOptionsView` calling `AppState.persistState` then quit in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift`
- [ ] T010 [US4] Update `AppState` initialization to check for and restore snapshot in `Sharp Timer App/Sharp Timer App/App/AppState.swift`

## Phase 7: User Story 5 - Cancel Quit

- [ ] T011 [US5] Implement "Cancel" action in `QuitOptionsView` to close the window in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift`

## Phase 8: Polish

- [ ] T012 Verify window styling matches settings (no title bar, rounded) in `Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift`
- [ ] T013 Ensure snapshot file is deleted after successful restoration in `Sharp Timer App/Sharp Timer App/App/AppState.swift`

## Dependencies

- US2 depends on Setup
- US4 depends on Foundational
- US3, US4, US5 depend on US2 (UI existence)

## Implementation Strategy

- Start with the data model and persistence logic (Foundational).
- Build the UI for the new window.
- Wire up the simple actions (Stop, Cancel).
- Wire up the complex action (Persist & Restore).
