# Feature Specification: Sharp Timer Menu Bar Experience

**Feature Branch**: `001-menu-bar-timer`
**Created**: 2025-11-17
**Status**: Draft
**Input**: User description: "Sharp Timer is a minimalist macOS menu bar timer with customizable Work, Rest Your Eyes, and Long Rest modes."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start a focused work session (Priority: P1)

Busy macOS users launch the Sharp Timer menu bar item, pick the Work mode, and run a distraction-free countdown without opening any traditional window.

**Why this priority**: Delivers the core value proposition—fast access to a work session timer from the menu bar only.

**Independent Test**: From a clean install, ensure a user can start, pause, and reset a Work session entirely from the menu bar popover.

**Acceptance Scenarios**:

1. **Given** the app is running in the top menu bar, **When** the user selects Work mode and presses Start, **Then** the timer displays MM:SS and counts down visibly.
2. **Given** a running Work timer, **When** the user clicks Pause, **Then** the countdown halts and can resume without resetting.
3. **Given** a paused Work timer, **When** the user selects Reset, **Then** the timer returns to the configured Work duration.

---

### User Story 2 - Protect vision with short eye breaks (Priority: P2)

Users quickly switch to Rest Your Eyes mode for frequent micro-breaks while staying in the menu bar.

**Why this priority**: Encourages healthy habits and differentiates the app through multi-mode support.

**Independent Test**: Verify a user can trigger a Rest Your Eyes countdown, receive completion notification, and return to work without relaunching the app.

**Acceptance Scenarios**:

1. **Given** the timer is idle, **When** the user picks Rest Your Eyes and starts it, **Then** the display switches to the shorter duration and counts down.
2. **Given** the Rest Your Eyes countdown finishes, **When** time hits zero, **Then** a native macOS notification appears and the menu bar resets to idle.
3. **Given** a Rest Your Eyes timer is running, **When** the user switches to Work mode, **Then** the current timer stops and the new mode’s duration loads.

---

### User Story 3 - Configure and persist personalized durations (Priority: P3)

Users adjust Work, Rest Your Eyes, and Long Rest durations to match their routines and expect those preferences to persist between sessions.

**Why this priority**: Long-term adoption depends on respecting personal workflows and avoiding repeated setup.

**Independent Test**: Modify durations, quit the app, relaunch, and confirm the updated values load instantly without manual re-entry.

**Acceptance Scenarios**:

1. **Given** the user opens Settings from the menu bar, **When** they change the Work duration to a custom value, **Then** the new value displays immediately in the timer selector.
2. **Given** custom durations are saved, **When** the app restarts, **Then** the timer defaults reflect the stored values without delay.
3. **Given** an in-progress timer, **When** the user edits durations for other modes, **Then** the current countdown continues unaffected while future sessions use the new values.

---

### Edge Cases

- Timer completion while the Mac is asleep or locked: ensure notifications queue and timers resume accurately on wake.
- Switching modes repeatedly within a few seconds: confirm only one timer runs and previous sessions cancel cleanly.
- Setting extreme durations (e.g., 1 minute or 4 hours): validate input constraints, formatting, and persistence boundaries.
- Quitting during an active timer: confirm the state resets safely on relaunch without phantom notifications.
- macOS notifications disabled: provide in-app visual cues so completions are still noticed.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The application MUST render exclusively in the macOS top menu bar with no dock icon or app switcher presence.
- **FR-002**: Users MUST be able to start, pause, resume, and reset a timer for each mode (Work, Rest Your Eyes, Long Rest) via a single popover.
- **FR-003**: The timer display MUST present remaining time in MM:SS and update once per second.
- **FR-004**: The system MUST ensure only one timer runs at a time; launching a new mode MUST stop the prior session gracefully.
- **FR-005**: Users MUST be able to customize the duration of all three modes independently with minute-level precision.
- **FR-006**: Custom durations and the last-selected mode MUST persist across app restarts using local storage.
- **FR-007**: Updates to durations MUST apply to future sessions immediately without requiring the user to restart the app.
- **FR-008**: The app MUST issue native macOS notifications when a timer completes, including the mode name and actionable controls (e.g., dismiss, restart).
- **FR-009**: The interface MUST expose Settings directly from the menu bar, reachable within a single click from the primary timer view.
- **FR-010**: The application MUST maintain a minimal resource footprint by idling cleanly when no timer is active.
- **FR-011**: If notifications are disabled at the OS level, the system MUST provide a fallback visual indicator in the menu bar or popover.

### Key Entities *(include if feature involves data)*

- **TimerMode**: Represents Work, Rest Your Eyes, or Long Rest, including label, default duration, and iconography used in the menu bar.
- **TimerProfile**: Stores user-defined durations per mode plus metadata such as last-updated timestamp and validation limits.
- **TimerSession**: Tracks an active countdown (mode, start time, remaining seconds, state such as running/paused/completed).
- **NotificationPreference**: Captures whether system notifications succeeded previously and whether fallback visual alerts are required.

## Assumptions

- Users operate macOS 13 or later with permission to display menu bar items and notifications.
- Reasonable duration limits are 1 minute minimum and 4 hours maximum per mode.
- Menu bar popover interactions comply with standard macOS accessibility defaults (keyboard navigation, VoiceOver labels).
- Persisted settings rely on local storage (e.g., system preferences) and do not sync across devices in this release.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 95% of first-time users can start a Work timer within 15 seconds of launching the app, measured via usability testing.
- **SC-002**: Timer completion notifications (system or fallback) are delivered within 1 second of countdown end in 99% of sessions.
- **SC-003**: Custom duration changes persist reliably, with less than 1% of relaunches reverting to defaults during beta testing.
- **SC-004**: Users report a ≥4/5 satisfaction score for clarity and minimalism of the menu bar UI during pilot surveys.
- **SC-005**: The application keeps background CPU utilization under 2% while idle on supported hardware.
- **SC-006**: At least 90% of recorded timer sessions complete without user-reported glitches such as double timers or missed notifications.
