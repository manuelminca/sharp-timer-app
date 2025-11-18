# Tasks: UI Fixes and Timer Enhancements

**Input**: Design documents from `/specs/003-ui-fixes/`  
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are included where mandated by constitution (UI responsiveness, persistence, audio, engine).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Ensure the development environment, branch, and baseline project assets are ready.

- [x] T001 Confirm branch `003-ui-fixes` is checked out and Xcode workspace `Sharp Timer App/Sharp Timer App.xcodeproj` opens without package resolution errors.
- [x] T002 Clean build artifacts (`Shift+Cmd+K`) and ensure `Sharp Timer App/Sharp Timer App.xcodeproj` builds without warnings.
- [x] T003 Audit git status to verify only feature-specific files in `specs/003-ui-fixes/` are modified before implementation work begins.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented.

- [x] T004 Define shared layout state helpers in `Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift` (or companion file) to expose `SettingsLayoutState`.
- [x] T005 Extend persistence utilities in `Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift` to serialize/deserialize `TimerPersistenceSnapshot` with schemaVersion.
- [x] T006 Create `AlarmPlayerService` in `Sharp Timer App/Sharp Timer App/Features/MenuBar/` (or new Services folder) wrapping `AVAudioPlayer` for `sounds/alarm.mp3`.
- [x] T007 Wire `AlarmPlayerService` and persistence snapshot references into `Sharp Timer App/Sharp Timer App/App/AppState.swift` without altering business logic yet.
- [x] T008 Add test fixtures for persistence and audio under `Sharp Timer App/Sharp Timer AppTests/` (utility helpers shared by later story tests).

---

## Phase 3: User Story 1 - Responsive Settings UI (Priority: P1) 🎯 MVP

**Goal**: Make the settings popover fully responsive across window widths and dynamic type sizes.

**Independent Test**: Resize settings between 280–800 px and across dynamic type sizes; all controls stay visible/aligned.

### Implementation

- [ ] T009 [US1] Replace hardcoded stacks with adaptive `Grid` + `ViewThatFits` layout in `Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift`.
- [ ] T010 [US1] Introduce layout measurement modifiers (dynamic type, layoutPriority) in `DurationSettingsView.swift` to prevent clipping.
- [ ] T011 [P] [US1] Add `SettingsLayoutState` preview/test hooks in `Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift` for snapshot previews.
- [ ] T012 [US1] Update menu bar popover sizing logic in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift` to support responsive settings container.
- [ ] T013 [US1] Create UI tests covering min/median/max widths and dynamic type in `Sharp Timer App/Sharp Timer AppUITests/MenuBarFlowTests.swift`.

---

## Phase 4: User Story 2 - Timer Mode Switching Confirmation (Priority: P1)

**Goal**: Prevent accidental timer loss by requiring confirmation before switching modes while a timer is running.

**Independent Test**: Start timer, switch modes, observe blocking dialog with Switch/Cancel options.

### Implementation

- [ ] T014 [US2] Implement `ModeSwitchIntent` handling in `Sharp Timer App/Sharp Timer App/App/AppState.swift`, checking `TimerState.isRunning`.
- [ ] T015 [US2] Present confirmation dialog via `NSAlert` bridge (`AppState+Notifications.swift`) mirroring state back to SwiftUI `.alert`.
- [ ] T016 [US2] Ensure `TimerEngine.swift` respects confirmed mode switches by stopping current timer before starting requested mode.
- [ ] T017 [US2] Add regression tests simulating running-timer mode switches in `Sharp Timer App/Sharp Timer AppTests/TimerEngineTests.swift`.
- [ ] T018 [US2] Add UI test verifying confirmation dialog lifecycle in `Sharp Timer App/Sharp Timer AppUITests/MenuBarFlowTests.swift`.

---

## Phase 5: User Story 3 - Timer State Persistence on App Quit (Priority: P1)

**Goal**: Provide three-option quit dialog and resume timers when requested.

**Independent Test**: Start timer, quit app selecting each option, relaunch to confirm expected state.

### Tests

- [ ] T019 [US3] Add persistence integration tests covering stop-and-quit vs persist-and-quit flows in `Sharp Timer App/Sharp Timer AppTests/PersistenceTests.swift`.

### Implementation

- [ ] T020 [US3] Hook `NSApplicationDelegate.applicationShouldTerminate(_:)` in `Sharp Timer App/Sharp Timer App/Sharp_Timer_AppApp.swift` (or App delegate bridge) to intercept quits.
- [ ] T021 [US3] Implement quit confirmation dialog UI per contract in `Sharp Timer App/Sharp Timer App/App/AppState+Notifications.swift`.
- [ ] T022 [US3] Serialize `TimerPersistenceSnapshot` and write to `~/Library/Application Support/Sharp Timer/timer-state.json` inside `TimerProfileStore.swift` when user selects “Quit and leave timer running”.
- [ ] T023 [US3] Restore timer state before SwiftUI view creation by loading snapshot in `AppState.swift` initializer.
- [ ] T024 [US3] Update menu bar/menu state restoration logic in `TimerDisplayView.swift` to display resumed timer immediately after launch.
- [ ] T025 [US3] Add UI test covering quit dialog options and relaunch verification in `Sharp Timer App/Sharp Timer AppUITests/MenuBarFlowTests.swift`.

---

## Phase 6: User Story 4 - Enhanced Alarm Sound (Priority: P2)

**Goal**: Play the new `alarm.mp3` reliably with fallbacks for failures.

**Independent Test**: Let timer complete foreground/background, confirm `alarm.mp3` plays; rename file to trigger fallback.

### Implementation

- [ ] T026 [US4] Integrate `AlarmPlayerService` with `AppState.swift` to trigger playback when timer finishes.
- [ ] T027 [US4] Add error handling + fallback to default notification sound in `AlarmPlayerService` (new file under `Features/MenuBar` or `Services`).
- [ ] T028 [US4] Expose volume/mute respect logic using system APIs in `AlarmPlayerService`.
- [ ] T029 [US4] Write audio playback unit tests using AVAudioPlayer stubs in `Sharp Timer App/Sharp Timer AppTests/Sharp_Timer_AppTests.swift`.
- [ ] T030 [US4] Extend quickstart checklist doc `specs/003-ui-fixes/quickstart.md` with verification steps results (update doc after implementation).

---

## Phase 7: User Story 5 - Alarm Playback Regression Fix (Priority: P0) 🔥 CRITICAL

**Goal**: Restore basic alarm audio functionality that has stopped working completely.

**Independent Test**: Start any timer, let it complete, confirm audio plays through system speakers.

### Implementation

- [ ] T036 [US5] Diagnose alarm playback failure in `AlarmPlayerService.swift` - check AVAudioPlayer initialization, session configuration, and file path resolution.
- [ ] T037 [US5] Fix audio session setup and activation in `AlarmPlayerService` to ensure proper playback even when app is in background.
- [ ] T038 [US5] Add comprehensive error logging and fallback mechanisms in `AlarmPlayerService` for debugging future audio issues.
- [ ] T039 [US5] Test alarm playback across all three timer modes (Work, Rest Your Eyes, Long Break) in `Sharp_Timer_AppTests.swift`.
- [ ] T040 [US5] Add system volume/mute detection and visual notification fallback in `AlarmPlayerService`.

---

## Phase 8: User Story 6 - Settings Stepper Focus Bug Fix (Priority: P0) 🔥 CRITICAL

**Goal**: Fix settings stepper controls that cause window minimization when clicked.

**Independent Test**: Open settings, click +/- steppers repeatedly, confirm window stays focused and responsive.

### Implementation

- [ ] T041 [US6] Investigate focus management in `DurationSettingsView.swift` - identify why stepper clicks trigger window minimization.
- [ ] T042 [US6] Fix stepper button event handling to prevent focus loss and window state changes.
- [ ] T043 [US6] Add proper focus retention logic for settings popover interactions.
- [ ] T044 [US6] Test stepper functionality across different window sizes and system font scales in `MenuBarFlowTests.swift`.
- [ ] T045 [US6] Verify keyboard navigation works correctly with steppers after focus fixes.

---

## Phase 9: User Story 7 - Application Quit Affordance (Priority: P1)

**Goal**: Add visible quit button next to Settings button for proper app lifecycle management.

**Independent Test**: Open menu bar popover, verify quit button is visible and triggers confirmation dialog.

### Implementation

- [ ] T046 [US7] Design and implement quit button UI component positioned next to Settings button in `TimerDisplayView.swift`.
- [ ] T047 [US7] Wire quit button to existing quit confirmation dialog logic in `AppState+Notifications.swift`.
- [ ] T048 [US7] Ensure quit button has proper accessibility labels and keyboard navigation support.
- [ ] T049 [US7] Add visual feedback (hover states, active states) for quit button interaction.
- [ ] T050 [US7] Test quit button functionality and dialog flow in `MenuBarFlowTests.swift`.

---

## Phase 10: Integration & Testing (All Stories)

**Purpose**: Verify all critical fixes work together and don't introduce regressions.

- [ ] T051 Run comprehensive test suite covering all new user stories and existing functionality.
- [ ] T052 Perform manual regression testing of timer start/stop, mode switching, and settings adjustment.
- [ ] T053 Verify alarm audio works across different system configurations (volume levels, background/foreground).
- [ ] T054 Test settings stepper focus behavior with rapid clicking and keyboard navigation.
- [ ] T055 Confirm quit button integration doesn't break existing menu bar popover functionality.
- [ ] T056 Update documentation with troubleshooting steps for common audio and focus issues.

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Final refinements across multiple stories.

- [ ] T031 Run full XCTest + XCUITest suite via `xcodebuild` command documented in `specs/003-ui-fixes/quickstart.md`.
- [ ] T032 Review `sounds/alarm.mp3` file inclusion and confirm it’s bundled in `Sharp Timer App/Sharp Timer App.xcodeproj` Copy Resources phase.
- [ ] T033 Audit accessibility (VoiceOver labels) across updated views in `DurationSettingsView.swift` and confirmation dialogs.
- [ ] T034 Update documentation (`README.md` and `specs/003-ui-fixes/quickstart.md`) with any implementation nuances discovered.
- [ ] T035 Final regression pass ensuring menu bar popover open time and persistence writes meet performance budgets (<100 ms, <50 ms) by profiling via Instruments.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Must complete before any other phase to ensure clean environment.
- **Foundational (Phase 2)**: Depends on Setup; blocks all user story work.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers MVP responsive UI.
- **User Story 2 (Phase 4)**: Depends on Foundational; can run parallel with US1 after shared groundwork.
- **User Story 3 (Phase 5)**: Depends on Foundational; should start after US2 to reuse dialog patterns, but logic-wise only requires persistence groundwork.
- **User Story 4 (Phase 6)**: Depends on Foundational; can run parallel with US2/US3 once AlarmPlayer scaffolding exists.
- **User Story 5 (Phase 7)**: 🔥 CRITICAL - Depends on Foundational AlarmPlayer service; can run immediately after Phase 2.
- **User Story 6 (Phase 8)**: 🔥 CRITICAL - Depends on Foundational layout state; can run immediately after Phase 2.
- **User Story 7 (Phase 9)**: Depends on Foundational and US3 quit dialog logic; should run after US3 completion.
- **Integration & Testing (Phase 10)**: Depends on completion of all user stories; final verification phase.
- **Polish (Phase N)**: Depends on completion of targeted user stories and integration verification.

### User Story Dependencies

- **US1**: No dependency on other stories; foundational only.
- **US2**: Requires TimerState/intent structures from Foundational; otherwise independent.
- **US3**: Uses persistence scaffolding plus may reuse dialog styles from US2 but not blocked by UI.
- **US4**: Requires AlarmPlayer scaffolding from Foundational; independent of other stories' outcomes.
- **US5**: 🔥 CRITICAL - Depends on AlarmPlayer service from Foundational; blocks US4 enhanced audio work.
- **US6**: 🔥 CRITICAL - Depends on layout state from Foundational; independent of other stories.
- **US7**: Depends on US3 quit confirmation logic; should be implemented after US3.

---

## Parallel Execution Examples

- After Phase 2, **US1** layout work (T009–T013) can run in parallel with **US2** confirmation logic (T014–T018) because they touch different files.
- Persistence tasks (T019–T025) can overlap with audio tasks (T026–T029) since they involve different modules (Persistence vs Alarm service), provided AppState changes are coordinated via code reviews.
- During US1, responsive layout implementation (T009/T010) can run concurrently with preview/test harness (T011/T013) once layout scaffolding exists.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phases 1–2.
2. Implement Phase 3 (US1) to fix critical settings responsiveness bug.
3. Validate via UI tests and quick manual checks before moving forward.

### Critical Bug Fix First (US5 & US6)

1. Complete Phases 1–2 (Setup + Foundational).
2. **🔥 IMMEDIATE**: Implement Phase 7 (US5) - Alarm Playback Regression Fix to restore core functionality.
3. **🔥 IMMEDIATE**: Implement Phase 8 (US6) - Settings Stepper Focus Bug Fix to restore usability.
4. Validate critical fixes work before proceeding with other features.

### Incremental Delivery

1. **🔥 CRITICAL**: Deliver US5 & US6 first to restore basic app functionality.
2. Add US1 to restore responsive settings UI.
3. Add US2 to prevent accidental timer loss.
4. Add US7 quit affordance for proper app lifecycle.
5. Layer in US3 to guarantee persistence on quit.
6. Finish with US4 enhanced audio and final polish tasks.

### Parallel Team Strategy

- **Dev A**: 🔥 US5 Alarm Playback Regression Fix (CRITICAL - immediate priority)
- **Dev B**: 🔥 US6 Settings Stepper Focus Bug Fix (CRITICAL - immediate priority)
- **Dev C**: US1 responsive UI + US7 quit affordance.
- **Dev D**: US2 confirmation dialogs + US3 persistence flow.
- **Dev E**: US4 audio improvements (after US5 complete).
- QA cycles focus on US5/US6 validation first, then proceed with other stories.
