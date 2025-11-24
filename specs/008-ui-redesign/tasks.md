---
description: "Task list for Bauhaus UI Redesign implementation"
---

# Tasks: Bauhaus UI Redesign

**Input**: Design documents from `/specs/008-ui-redesign/`
**Prerequisites**: plan.md, spec.md, data-model.md, research.md
**Checks**: Constitution compliance (Menu Bar Exclusive, Minimal Resource Footprint)

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel
- **[Story]**: US1, US2, US3, US4

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initialize the theme directory structure.

- [ ] T001 Create theme directory at Sharp Timer App/Sharp Timer App/Features/Theme/
- [ ] T002 Create shapes directory at Sharp Timer App/Sharp Timer App/Features/Theme/Shapes/

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Define the Bauhaus visual language (Colors, Fonts, Shapes) required by all stories.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T003 [P] Create Color+Bauhaus.swift in Sharp Timer App/Sharp Timer App/Features/Theme/Color+Bauhaus.swift
- [ ] T004 [P] Create Font+Bauhaus.swift in Sharp Timer App/Sharp Timer App/Features/Theme/Font+Bauhaus.swift
- [ ] T005 [P] Create RotatedSquare.swift in Sharp Timer App/Sharp Timer App/Features/Theme/Shapes/RotatedSquare.swift
- [ ] T006 Create BauhausTheme.swift in Sharp Timer App/Sharp Timer App/Features/Theme/BauhausTheme.swift

**Checkpoint**: Theme constants and basic shapes are available.

---

## Phase 3: User Story 1 - Modern Bauhaus Timer Interface (Priority: P1) 🎯 MVP

**Goal**: Implement the main timer display using the Bauhaus aesthetic, replacing the existing UI while maintaining functionality.

**Independent Test**: Launch app, verify popover shows Bauhaus background colors and geometric layout. Timer tick updates time display.

### Implementation for User Story 1

- [ ] T007 [US1] Implement main layout structure in Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift
- [ ] T008 [P] [US1] Apply Bauhaus background colors and shapes to TimerDisplayView.swift
- [ ] T009 [P] [US1] Update timer text typography using Bauhaus fonts in TimerDisplayView.swift
- [ ] T010 [US1] Ensure layout respects fixed popover size (approx 350x500pt) in TimerDisplayView.swift

**Checkpoint**: The main view looks like the Figma design (static or basic state).

---

## Phase 4: User Story 2 - Enhanced Visual Mode Indication (Priority: P2)

**Goal**: Visual distinction between Work, Rest, and Long Rest modes using specific colors/icons.

**Independent Test**: Switch modes -> UI changes color (Red/Blue/Yellow) and icons (Briefcase/Eye/Coffee).

### Implementation for User Story 2

- [ ] T011 [P] [US2] Create ModeSelectorView in Sharp Timer App/Sharp Timer App/Features/MenuBar/ModeSelectorView.swift
- [ ] T012 [US2] Integrate ModeSelectorView into Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift
- [ ] T013 [US2] Implement color/shape state transitions based on `selectedMode` in TimerDisplayView.swift
- [ ] T014 [P] [US2] Add SF Symbol icons (briefcase, eye, cup.and.saucer) to ModeSelectorView.swift

**Checkpoint**: Changing modes updates the entire UI theme dynamically.

---

## Phase 5: User Story 3 - Responsive Control Interface (Priority: P2)

**Goal**: Interactive buttons with hover states for Start/Pause/Reset.

**Independent Test**: Hover over buttons -> Scale/Color change. Click buttons -> Timer starts/stops.

### Implementation for User Story 3

- [ ] T015 [P] [US3] Create ControlButtonsView in Sharp Timer App/Sharp Timer App/Features/MenuBar/ControlButtonsView.swift
- [ ] T016 [US3] Integrate ControlButtonsView into Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift
- [ ] T017 [US3] Implement hover effects and scaling animations in ControlButtonsView.swift

**Checkpoint**: Controls are interactive and visually responsive.

---

## Phase 6: User Story 4 - Settings and Quit Dialog Redesign (Priority: P3)

**Goal**: Apply Bauhaus styling to secondary screens (Settings, Quit).

**Independent Test**: Open Settings -> Bauhaus style. Open Quit (while running) -> Bauhaus style.

### Implementation for User Story 4

- [ ] T018 [P] [US4] Apply Bauhaus styling to Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift
- [ ] T019 [P] [US4] Apply Bauhaus styling to Sharp Timer App/Sharp Timer App/Features/MenuBar/QuitOptionsView.swift
- [ ] T020 [US4] Ensure QuitOptionsView maintains window controller logic in QuitWindowController.swift if needed (Visuals only)

**Checkpoint**: All app windows share the consistent design language.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Accessibility, cleanup, and final verification.

- [ ] T021 [P] Audit accessibility labels and hide decorative shapes in all views
- [ ] T022 [P] Verify color contrast for text in Yellow (Long Rest) mode
- [ ] T023 Run quickstart.md verification steps

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: BLOCKS all user stories.
- **User Stories (Phase 3+)**: Depend on Foundational.
  - US1 (Layout) is the container for US2 and US3 components.
  - US2 and US3 can be developed in parallel but integrate into US1.
  - US4 is independent (separate views).

### Parallel Opportunities

1. **Asset Creation**: T003, T004, T005 (Colors, Fonts, Shapes) can run in parallel.
2. **Component Development**: Once T006 (Theme) is done:
   - Developer A: T011 (ModeSelector)
   - Developer B: T015 (ControlButtons)
   - Developer C: T018/T019 (Settings/Quit)

## Implementation Strategy

### MVP First (User Story 1+2+3)

1. Complete Phases 1 & 2 (Theme Foundation).
2. Implement existing TimerDisplayView with new Layout (US1).
3. Add Mode Selector (US2) and Controls (US3).
4. **Verify**: Main timer loop is beautiful and functional.

### Incremental Delivery

1. Foundation -> Theme ready.
2. US1 -> Main view structure ready.
3. US2 -> Modes work.
4. US3 -> Interactable.
5. US4 -> Consistency across app.
