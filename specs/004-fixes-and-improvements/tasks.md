# Implementation Tasks: Fixes and Improvements

**Feature**: Fixes and Improvements
**Branch**: `004-fixes-and-improvements`
**Created**: 2025-11-19
**Status**: Ready for Implementation

## Overview

This feature implements bug fixes for quit logic and settings persistence, plus visual improvements to the menu bar and main interface. Tasks are organized by user story for independent implementation and testing.

## Dependencies

- **US1 (Safe Quit Logic)**: Foundational - must complete before other stories can be fully tested
- **US2 (Settings Persistence)**: Independent
- **US3 (Menu Bar Timer Display)**: Independent
- **US4 (Clean Main Interface)**: Independent

## Parallel Execution Opportunities

- US2, US3, and US4 can be implemented in parallel after US1
- Within each story, tasks marked [P] can be parallelized

## Implementation Strategy

- **MVP Scope**: US1 (Safe Quit Logic) - provides the core bug fix
- **Incremental Delivery**: Add US2, US3, US4 in any order
- **Testing**: Each user story has independent test criteria

## Phase 1: Setup

No setup tasks required - this feature modifies existing components.

## Phase 2: Foundational Tasks

- [x] T001 Update TimerState model to include targetDate field in Sharp Timer App/Sharp Timer App/Persistence/TimerProfileStore.swift

## Phase 3: User Story 1 - Safe Quit Logic (Priority: P1)

**Goal**: Implement quit confirmation dialog with three options, styled like Settings page.

**Independent Test**: Can be tested by attempting to quit with/without timer running, verifying dialog appearance and all three options work correctly.

- [x] T002 Create QuitConfirmationView with three buttons in Sharp Timer App/Sharp Timer App/Features/Settings/QuitConfirmationView.swift
- [x] T003 Update ApplicationDelegate to intercept quit requests and show confirmation when timer is running in Sharp Timer App/Sharp Timer App/App/ApplicationDelegate.swift
- [x] T004 Update AppState to handle "leave timer running" persistence logic in Sharp Timer App/Sharp Timer App/App/AppState.swift
- [x] T005 Update AppState to restore timer state on launch using targetDate calculation in Sharp Timer App/Sharp Timer App/App/AppState.swift

## Phase 4: User Story 2 - Settings Persistence (Priority: P2)

**Goal**: Ensure settings UI reflects persisted values on app relaunch.

**Independent Test**: Can be tested by changing settings, quitting, relaunching, and verifying displayed values match saved values.

- [x] T006 Fix DurationSettingsView to initialize bindings from persisted UserPreferences on view load in Sharp Timer App/Sharp Timer App/Features/Settings/DurationSettingsView.swift

## Phase 5: User Story 3 - Menu Bar Timer Display (Priority: P2)

**Goal**: Show countdown in menu bar icon when timer is running.

**Independent Test**: Can be tested by starting timer and observing menu bar shows countdown, reverts to icon when stopped.

- [x] T007 Update MenuBarController to display countdown in status item title when timer is active in Sharp Timer App/Sharp Timer App/Features/MenuBar/MenuBarController.swift
- [x] T008 Update MenuBarController to clear title when timer is stopped or paused in Sharp Timer App/Sharp Timer App/Features/MenuBar/MenuBarController.swift

## Phase 6: User Story 4 - Clean Main Interface (Priority: P3)

**Goal**: Remove redundant "Mode" text from main timer view.

**Independent Test**: Can be tested by inspecting main view - "Mode" text should not be visible.

- [x] T009 Remove "Mode" text label from TimerDisplayView in Sharp Timer App/Sharp Timer App/Features/MenuBar/TimerDisplayView.swift

## Final Phase: Polish & Cross-Cutting Concerns

- [x] T010 Test edge case: timer expiry while app is closed (should trigger completion on relaunch)
- [x] T011 Test edge case: menu bar display with very short durations (single-digit seconds)
- [x] T012 Test edge case: menu bar display with long durations (hours)
- [x] T013 Verify all quit scenarios work correctly (idle quit, stop and quit, leave running, cancel)
- [x] T014 Verify settings persistence across multiple app launches
- [x] T015 Verify menu bar updates at 1Hz during timer operation
