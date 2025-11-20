# Implementation Tasks: Fixes and Improvements

**Feature**: Fixes and Improvements
**Branch**: `004-fixes-and-improvements`
**Created**: 2025-11-19
**Status**: Ready for Implementation

## Overview

This feature implements a simplified quit logic, settings persistence fixes, and visual improvements. Tasks are organized by user story for independent implementation and testing.

## Dependencies

- **US1 (Simple Quit Confirmation)**: Foundational - changes core app exit behavior
- **US2 (Settings Persistence)**: Independent
- **US3 (Menu Bar Timer Display)**: Independent
- **US4 (Clean Main Interface)**: Independent

## Parallel Execution Opportunities

- US2, US3, and US4 can be implemented in parallel after US1
- Within each story, tasks marked [P] can be parallelized

## Implementation Strategy

- **MVP Scope**: US1 (Simple Quit Confirmation)
- **Incremental Delivery**: Add US2, US3, US4 in any order
- **Testing**: Each user story has independent test criteria

## Phase 1: Setup

No setup tasks required - this feature modifies existing components.

## Phase 2: Foundational Tasks

No foundational tasks required.

## Phase 3: User Story 1 - Simple Quit Confirmation (Priority: P1)

**Goal**: Implement a two-step quit button ("Quit" -> "Confirm Quit") in the main view.

**Independent Test**: Can be tested by clicking Quit, verifying text change, clicking again to quit, or closing window to reset.

- [ ] T001 [US1] Update TimerDisplayView to implement two-step quit button logic in Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift
- [ ] T002 [US1] Remove QuitConfirmationView and related code if it exists in Sharp Timer App/Sharp Timer App/Features/Settings/QuitConfirmationView.swift
- [ ] T003 [US1] Ensure AppState terminates app immediately on quit without saving running state in Sharp Timer App/Sharp Timer App/App/AppState.swift

## Phase 4: User Story 2 - Settings Persistence (Priority: P2)

**Goal**: Ensure settings UI reflects persisted values on app relaunch.

**Independent Test**: Can be tested by changing settings, quitting, relaunching, and verifying displayed values match saved values.

- [ ] T004 [US2] Fix DurationSettingsView to initialize bindings from persisted UserPreferences on view load in Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift

## Phase 5: User Story 3 - Menu Bar Timer Display (Priority: P2)

**Goal**: Show countdown in menu bar icon when timer is running.

**Independent Test**: Can be tested by starting timer and observing menu bar shows countdown, reverts to icon when stopped.

- [ ] T005 [US3] Update MenuBarController to display countdown in status item title when timer is active in Sharp Timer App/Sharp Timer App/Features/MenuBar/MenuBarController.swift
- [ ] T006 [US3] Update MenuBarController to clear title when timer is stopped or paused in Sharp Timer App/Sharp Timer App/Features/MenuBar/MenuBarController.swift

## Phase 6: User Story 4 - Clean Main Interface (Priority: P3)

**Goal**: Remove redundant "Mode" text from main timer view.

**Independent Test**: Can be tested by inspecting main view - "Mode" text should not be visible.

- [ ] T007 [US4] Remove "Mode" text label from TimerDisplayView in Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift

## Final Phase: Polish & Cross-Cutting Concerns

- [ ] T008 Verify quit button behavior (text change, reset on close, termination)
- [ ] T009 Verify settings persistence across multiple app launches
- [ ] T010 Verify menu bar updates at 1Hz during timer operation
- [ ] T011 Test edge case: menu bar display with very short durations (single-digit seconds)
- [ ] T012 Test edge case: menu bar display with long durations (hours)
