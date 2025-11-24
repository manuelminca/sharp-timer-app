# Tasks: Mode Auto-Start Setting

**Input**: Design documents from `/specs/008-mode-auto-start-setting/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: No test tasks included - not requested in feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **macOS app**: `Sharp Timer App/Sharp Timer App/` at repository root

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization - existing Swift project, no setup needed.

- [x] T001 Verify Swift 5.9 and Xcode environment ready

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data model changes that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 Add autoStartOnModeChange field to TimerProfile struct in Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift
- [x] T003 Update TimerProfile.init() to set autoStartOnModeChange default false in Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift
- [x] T004 Update TimerProfile.validating() to preserve autoStartOnModeChange in Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift
- [x] T005 Add updateAutoStartOnModeChange method to TimerProfileStore in Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Configure Auto-Start Setting (Priority: P1) 🎯 MVP

**Goal**: Add toggle in settings to control auto-start behavior on mode change

**Independent Test**: Open settings popover, verify toggle exists and can be toggled, setting persists across app restarts

### Implementation for User Story 1

- [x] T006 [US1] Add autoStartOnModeChange state variable to DurationSettingsView in Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift
- [x] T007 [US1] Load autoStartOnModeChange from appState.profile in DurationSettingsView.onAppear in Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift
- [x] T008 [US1] Add Toggle for "Auto-start timer on mode change" in ResponsiveSettingsGrid in Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift
- [x] T009 [US1] Save autoStartOnModeChange to appState in DurationSettingsView.saveSettings in Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift

**Checkpoint**: At this point, User Story 1 should be fully functional - toggle visible, persists, but no behavior yet

---

## Phase 4: User Story 2 - Auto-Start Behavior (Priority: P2)

**Goal**: When auto-start enabled, timer starts automatically on mode change if paused

**Independent Test**: Enable auto-start, pause timer, change mode - verify timer starts; disable auto-start, pause timer, change mode - verify timer stays paused

### Implementation for User Story 2

- [x] T010 [US2] Add changeMode method to TimerEngine in Sharp Timer App/Sharp Timer App/Engine/TimerEngine.swift
- [x] T011 [US2] Modify AppState.switchToMode to check autoStartOnModeChange setting in Sharp Timer App/Sharp Timer App/App/AppState.swift
- [x] T012 [US2] Implement auto-start logic: if idle/paused and setting enabled, start timer after mode change in Sharp Timer App/Sharp Timer App/App/AppState.swift
- [x] T013 [US2] Implement paused logic: if idle/paused and setting disabled, leave timer paused after mode change in Sharp Timer App/Sharp Timer App/App/AppState.swift

**Checkpoint**: At this point, User Stories 1 AND 2 should work - auto-start behavior functional

---

## Phase 5: User Story 3 - Paused Behavior (Priority: P3)

**Goal**: When auto-start disabled, timer remains paused on mode change

**Independent Test**: Disable auto-start, change mode while timer paused - verify stays paused

### Implementation for User Story 3

- [x] T014 [US3] Verify paused behavior implemented in AppState.switchToMode (covered by T013)

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final improvements and validation

- [x] T015 Run quickstart.md validation - test feature end-to-end
- [x] T016 Code cleanup and ensure no console errors

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories proceed in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Depends on User Story 1 completion - needs toggle to test behavior
- **User Story 3 (P3)**: Depends on User Story 2 completion - shares implementation

### Within Each User Story

- Models before services
- Services before UI
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, user stories proceed sequentially due to shared logic
- Different files within a story can be parallel if no dependencies

---

## Parallel Example: User Story 1

```bash
# No parallel tasks in US1 - sequential UI updates
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently - toggle works, persists
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP: toggle in settings)
3. Add User Story 2 → Test independently → Deploy/Demo (auto-start behavior)
4. Add User Story 3 → Test independently → Deploy/Demo (paused behavior)

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (UI)
   - Developer B: User Stories 2&3 (logic) after US1 complete
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence</content>
<parameter name="filePath">specs/001-mode-auto-start-setting/tasks.md