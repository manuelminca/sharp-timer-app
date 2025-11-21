# Feature Specification: Improve Quit Functionality

**Feature Branch**: `005-improve-quit-functionality`
**Created**: 2025-11-20
**Status**: Draft
**Input**: User description: "Rework the quit button. If timer is running, open a new window with 3 options: Stop timer and quit, Quit and leave timer running, Cancel."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Quit When Idle (Priority: P1)

As a user, I want the application to quit immediately when I click the quit button if no timer is running, so that I can exit the app quickly without unnecessary steps.

**Why this priority**: Basic app functionality expectation.

**Independent Test**: Can be tested by ensuring the app terminates immediately upon clicking "Quit" when the timer is in an idle state.

**Acceptance Scenarios**:

1. **Given** the timer is not running (idle state), **When** I click the "Quit" button, **Then** the application terminates immediately without showing any confirmation window.

---

### User Story 2 - Quit Options Window (Priority: P1)

As a user, I want to be presented with clear options when I try to quit while a timer is running, so that I can decide how to handle my active session.

**Why this priority**: Prevents accidental data loss and provides the core feature value.

**Independent Test**: Can be tested by starting a timer and clicking "Quit", verifying the new window appears with the correct options.

**Acceptance Scenarios**:

1. **Given** a timer is running or paused, **When** I click the "Quit" button, **Then** a new window opens (styled like the settings window).
2. **Given** the quit options window is open, **When** I view the options, **Then** I see three distinct choices: "Stop timer and quit app", "Quit app and leave timer running", and "Cancel".

---

### User Story 3 - Stop Timer and Quit (Priority: P2)

As a user, I want to be able to stop the timer and quit the app completely, so that I can end my session and close the application.

**Why this priority**: Standard "force quit" equivalent for a timer app.

**Independent Test**: Can be tested by selecting "Stop timer and quit app" and verifying the app quits and does NOT resume the timer on next launch.

**Acceptance Scenarios**:

1. **Given** the quit options window is open, **When** I select "Stop timer and quit app", **Then** the application terminates.
2. **Given** I have quit using "Stop timer and quit app", **When** I relaunch the application, **Then** the timer is in an idle state (reset).

---

### User Story 4 - Persist Timer State (Priority: P1)

As a user, I want to quit the app but keep my timer "running" in the background (conceptually), so that I can close the app to save resources or clear the menu bar but resume my session later.

**Why this priority**: This is the key differentiator and "smart" feature requested.

**Independent Test**: Can be tested by quitting with a running timer, waiting a specific amount of time, relaunching, and verifying the remaining time has decreased correctly.

**Acceptance Scenarios**:

1. **Given** a timer is running with 20 minutes remaining, **When** I select "Quit app and leave timer running", **Then** the application terminates.
2. **Given** I quit with 20 minutes remaining and wait 10 minutes, **When** I relaunch the application, **Then** the timer resumes automatically with approximately 10 minutes remaining.
3. **Given** I quit with 5 minutes remaining and wait 10 minutes (timer would have finished), **When** I relaunch the application, **Then** the timer shows as completed (or 00:00).

---

### User Story 5 - Cancel Quit (Priority: P3)

As a user, I want to be able to cancel the quit action, so that I can return to the app if I changed my mind.

**Why this priority**: Standard UI pattern for destructive actions.

**Independent Test**: Can be tested by clicking "Cancel" and verifying the window closes and the timer continues running.

**Acceptance Scenarios**:

1. **Given** the quit options window is open, **When** I select "Cancel", **Then** the window closes and the application remains running with the timer active.

### Edge Cases

- **Timer completes while quit window is open**: The window should probably remain, or the timer completion notification should fire.
- **Relaunch after timer duration exceeded**: If the user quits with 5 mins left and returns in 1 hour, the timer should be in a "completed" state.
- **Multiple windows**: Ensure the quit window doesn't open multiple times if clicked repeatedly (though the button might be disabled or the window modal).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST quit immediately if the "Quit" button is clicked while the timer is in `idle` state.
- **FR-002**: System MUST open a dedicated window (not a native alert dialog) if the "Quit" button is clicked while the timer is `running` or `paused`.
- **FR-003**: The quit options window MUST present three options: "Stop timer and quit app", "Quit app and leave timer running", and "Cancel".
- **FR-004**: Selecting "Stop timer and quit app" MUST terminate the application and clear any active session state (so it starts fresh on next launch).
- **FR-005**: Selecting "Quit app and leave timer running" MUST persist the current timer state (mode, remaining time, timestamp) to disk and then terminate the application.
- **FR-006**: Selecting "Cancel" MUST close the quit options window and leave the application running.
- **FR-007**: On application launch, the system MUST check for persisted timer state.
- **FR-008**: If valid persisted state is found, the system MUST calculate the elapsed time since quit and adjust the remaining time accordingly.
- **FR-009**: If the calculated remaining time is greater than zero, the timer MUST auto-resume from that point.
- **FR-010**: If the calculated remaining time is zero or less, the timer MUST be set to the `completed` state.

### Key Entities

- **TimerPersistenceSnapshot**:
    - `mode`: The active TimerMode.
    - `remainingTime`: Time remaining when quit.
    - `timestamp`: Date/Time when the app was quit.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can quit the app immediately (1 click) when no timer is running.
- **SC-002**: Users are presented with the 3 specific options 100% of the time when quitting with an active timer.
- **SC-003**: Timer state is restored with < 5 seconds of drift after a "Quit and leave timer running" cycle (excluding app launch time).
