# Tasks: Sharp Timer Menu Bar Experience

**Input**: Design documents from `/specs/001-menu-bar-timer/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Constitution requires unit coverage for TimerEngine and persistence; include targeted test tasks where relevant.

**Organization**: Tasks grouped by user story (US1–US3) to keep increments independently deliverable.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Ensure the macOS project skeleton, build settings, and tooling align with the implementation plan.

- [x] T001 Align Xcode target for menu-bar-only deployment in `Sharp Timer App/Sharp Timer App.xcodeproj` (disable Dock icon, configure menu bar scene).
- [x] T002 Create Engine, Persistence, Features directories per plan inside `Sharp Timer App/Sharp Timer App/` (Engine/, Persistence/, Features/MenuBar/, Features/Settings/).
- [x] T003 [P] Configure Swift package + build settings for Swift 5.9/macOS 13 in `Sharp Timer App/Sharp Timer App.xcodeproj`.
- [x] T004 [P] Enable UserNotifications capability and requested permissions in `Sharp Timer App/Sharp Timer App.xcodeproj/project.pbxproj`.
- [x] T005 [P] Stub `AppState.swift` file under `Sharp Timer App/Sharp Timer App/App/` with ObservableObject scaffold.
- [x] T006 [P] Add shared test target plumbing (TimerEngineTests.swift, PersistenceTests.swift placeholders) in `Sharp Timer App/Sharp Timer AppTests/`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that every user story depends on.

- [x] T007 Define `TimerMode.swift` enum with metadata (icons, defaults) in `Sharp Timer App/Sharp Timer App/Engine/TimerMode.swift`.
- [x] T008 Implement `TimerEngine.swift` core (start/pause/resume/reset, single session guard) in `Sharp Timer App/Sharp Timer App/Engine/TimerEngine.swift`.
- [x] T009 Wire `TimerEngineTests.swift` to cover cadence, pause/resume, completion paths in `Sharp Timer App/Sharp Timer AppTests/TimerEngineTests.swift`.
- [x] T010 Build `TimerProfileStore.swift` using UserDefaults in `Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift`.
- [x] T011 Add `PersistenceTests.swift` validating duration bounds + last mode in `Sharp Timer App/Sharp Timer AppTests/PersistenceTests.swift`.
- [x] T012 Integrate `AppState.swift` with TimerEngine + TimerProfileStore, exposing published session/profile state in `Sharp Timer App/Sharp Timer App/App/AppState.swift`.
- [x] T013 [P] Implement notification helper (schedule/cancel, fallback flag) inside `Sharp Timer App/Sharp Timer App/App/AppState+Notifications.swift`.
- [x] T014 Update Quickstart sanity hooks (scripted steps) per new architecture in `specs/001-menu-bar-timer/quickstart.md` (checkpoint entry).

**Checkpoint**: Engine, persistence, and AppState ready; menu bar UI can consume these APIs.

---

## Phase 3: User Story 1 – Start a focused work session (Priority: P1) 🎯 MVP

**Goal**: Users can start/pause/reset a Work timer entirely from the menu bar.

**Independent Test**: Launch app, start Work timer, observe MM:SS countdown and pause/reset flow without touching other modes.

### Implementation

- [x] T015 [US1] Create `MenuBarController.swift` leveraging `MenuBarExtra` to host popover in `Sharp Timer App/Sharp Timer App/Features/MenuBar/MenuBarController.swift`.
- [x] T016 [P] [US1] Design `TimerDisplayView.swift` showing mode icon + MM:SS synced to AppState in `Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift`.
- [x] T017 [US1] Implement Start/Pause/Reset controls binding to AppState actions per `contracts/timer-control.yaml` in `TimerDisplayView.swift`.
- [x] T018 [US1] Ensure notifications fire on completion with restart/dismiss actions in `AppState+Notifications.swift`.
- [x] T019 [P] [US1] Add menu bar title formatting (💼 22:15 style) in `MenuBarController.swift`.
- [x] T020 [US1] Create US1 UI test verifying Work session flow in `Sharp Timer App/Sharp Timer AppUITests/MenuBarFlowTests.swift`.
- [x] T021 [US1] Document Work session path + verification steps in `specs/001-menu-bar-timer/quickstart.md`.

**Checkpoint**: Work timer fully operational and testable—forms scope of MVP handoff.

---

## Phase 4: User Story 2 – Protect vision with short eye breaks (Priority: P2)

**Goal**: Users can trigger Rest Your Eyes timers, receive completion notifications, and switch modes seamlessly.

**Independent Test**: From idle state, run Rest Your Eyes, receive notification, switch back to Work without relaunch.

### Implementation

- [ ] T022 [US2] Extend MenuBar mode picker to surface Rest Your Eyes + Long Rest icons with immediate state sync in `TimerDisplayView.swift`.
- [ ] T023 [P] [US2] Handle mid-session mode switch in `TimerEngine.swift` (stop prior session gracefully before starting new mode).
- [ ] T024 [US2] Add Rest Your Eyes completion notification copy and fallback banner in `AppState+Notifications.swift`.
- [ ] T025 [P] [US2] Update contracts doc if mode-switch semantics changed in `specs/001-menu-bar-timer/contracts/timer-control.yaml`.
- [ ] T026 [US2] Write UITest covering Rest Your Eyes completion + switch scenario in `Sharp Timer App/Sharp Timer AppUITests/MenuBarFlowTests.swift`.
- [ ] T027 [US2] Update Quickstart edge-case section (sleep/wake, repeated mode switch) in `specs/001-menu-bar-timer/quickstart.md`.

**Checkpoint**: Eye-break flow independent and validated; Work flow unaffected.

---

## Phase 5: User Story 3 – Configure and persist personalized durations (Priority: P3)

**Goal**: Users adjust per-mode durations via Settings and see changes persist across relaunch without disrupting running timers.

**Independent Test**: Change durations in settings, relaunch app, verify new values as defaults, confirm in-progress timer unaffected.

### Implementation

- [ ] T028 [US3] Build `DurationSettingsView.swift` with sliders/steppers (1–240 mins) in `Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift`.
- [ ] T029 [US3] Add menu bar Settings entry (gear icon) presenting the settings sheet in `MenuBarController.swift`.
- [ ] T030 [US3] Wire settings edits to `TimerProfileStore` with debounced persistence in `AppState.swift`.
- [ ] T031 [P] [US3] Ensure ongoing timer session remains stable when other mode durations change in `TimerEngine.swift`.
- [ ] T032 [US3] Extend persistence tests to cover custom duration round trips in `Sharp Timer App/Sharp Timer AppTests/PersistenceTests.swift`.
- [ ] T033 [P] [US3] Document customization workflow and relaunch expectations in `specs/001-menu-bar-timer/quickstart.md`.

**Checkpoint**: Duration customization stable; all success criteria satisfied.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [ ] T034 [P] Audit accessibility labels/VoiceOver focus for menu bar components in `TimerDisplayView.swift`.
- [ ] T035 Optimize idle CPU/memory profile (profiling script + README updates) documented in `specs/001-menu-bar-timer/plan.md`.
- [ ] T036 [P] Update README or docs with independent test instructions referencing Quickstart.
- [ ] T037 Conduct final Constitution compliance review; note findings in `specs/001-menu-bar-timer/plan.md` and prep for `/speckit.analyze`.

---

## Dependencies & Execution Order

### Phase Dependencies

1. **Setup (Phase 1)** → prerequisite for foundational work.  
2. **Foundational (Phase 2)** → must reach checkpoint before any user story.  
3. **User Story Phases (3–5)** → each depends on Phase 2 completion; can proceed sequentially (P1→P2→P3) or in parallel with coordination.  
4. **Polish (Phase 6)** → runs after desired user stories complete.

### User Story Dependencies

- **US1**: Depends only on Phase 2.  
- **US2**: Depends on Phase 2 and optionally US1 artifacts but remains independently testable.  
- **US3**: Depends on Phase 2 and AppState wiring; does not require US2 to finish but benefits from shared components.

### Parallel Opportunities

- Setup tasks T003–T006.  
- Foundational parallel tasks T008–T011, T013.  
- Within stories, tasks marked [P] (e.g., T016, T019, T023, T025, T031, T033).  
- Different user stories can be staffed concurrently once foundational layer stable.

---

## Parallel Example: User Story 1

```bash
# UI pairing
T015 MenuBarController.swift implementation
T016 TimerDisplayView.swift layout/styling

# Engine/UI glue
T017 contract-driven bindings
T019 menu bar title formatting

# Verification
T020 MenuBarFlowTests.swift scenario
```

All five tasks can proceed with coordination since files differ and dependencies minimal.

---

## Implementation Strategy

### MVP First (US1 Only)

1. Complete Phases 1–2.  
2. Ship Phase 3 (US1).  
3. Validate via unit/UITests + Quickstart instructions.  
4. Soft launch for focused work timers.

### Incremental Delivery

- After MVP, layer US2 for eye breaks, verifying notifications + mode switching.  
- Finally deliver US3 for customization and persistence improvements.  
- Each increment should pass independent tests before continuing.

### Parallel Team Strategy

- Developer A: Engine + AppState (Phases 2 & 3).  
- Developer B: Menu bar UI/Settings (Phases 3 & 5).  
- Developer C: Notifications/testing + documentation (Phases 2, 4, 6).  
- Stand-ups ensure constitution compliance at each checkpoint.

---

## Notes

- `[P]` indicates tasks operating on disjoint files that can run simultaneously.  
- `[US#]` tracks alignment to user stories for traceability.  
- Tests must fail before implementation where applicable (TimerEngine/persistence).  
- Each user story phase culminates in a checkpoint verifying independent test criteria.  
- Keep commits scoped per task for easier review and potential cherry-picks.
