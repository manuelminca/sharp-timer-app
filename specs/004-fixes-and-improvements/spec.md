# Feature Specification: Fixes and Improvements

**Feature Branch**: `004-fixes-and-improvements`
**Created**: 2025-11-19
**Status**: Draft
**Input**: User description: "Bug fixes (quit button logic, settings persistence) and visual changes (remove mode text, timer in menu bar icon)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Safe Quit Logic (Priority: P1)

As a user, I want the app to handle quitting intelligently so that I don't accidentally lose my active timer session or get confused by the interface.

**Why this priority**: Prevents data loss (active timer) and improves the core user experience of exiting the app.

**Independent Test**: Can be tested by attempting to quit the app with and without a timer running.

**Acceptance Scenarios**:

1.  **Given** the timer is **not** running, **When** I click the "Quit" button on the main page, **Then** the application should terminate immediately without showing any confirmation window.
2.  **Given** the timer **is** running, **When** I click the "Quit" button, **Then** a confirmation window (styled like the Settings page) should appear with three options.
3.  **Given** the quit confirmation window is open, **When** I select "Stop timer and quit app", **Then** the timer should stop, and the application should terminate.
4.  **Given** the quit confirmation window is open, **When** I select "Leave timer running and quit app", **Then** the application should terminate, and upon relaunch, the timer should resume from the correct remaining time (accounting for the time elapsed while closed).
5.  **Given** the quit confirmation window is open, **When** I select "Cancel", **Then** the confirmation window should close, and the timer should continue running normally.

---

### User Story 2 - Settings Persistence (Priority: P2)

As a user, I want my custom timer durations to be correctly displayed in the settings menu after I restart the app, so that I know my preferences are saved.

**Why this priority**: Fixes a confusing bug where the UI doesn't reflect the actual state of the application.

**Independent Test**: Can be tested by changing settings, quitting, relaunching, and verifying the displayed values.

**Acceptance Scenarios**:

1.  **Given** I have changed the duration for a specific mode in Settings, **When** I quit and relaunch the application, **Then** the main page should display the updated duration value, not the default.
2.  **Given** I have changed the duration, **When** I start a timer, **Then** it should use the updated duration (this is already working, but ensures no regression).

---

### User Story 3 - Menu Bar Timer Display (Priority: P2)

As a user, I want to see the remaining time directly in the menu bar icon so that I can check my progress without clicking the menu.

**Why this priority**: Enhances the "glanceability" of the app, a key value proposition for menu bar tools.

**Independent Test**: Can be tested by starting a timer and observing the menu bar item.

**Acceptance Scenarios**:

1.  **Given** a timer is running, **When** I look at the menu bar, **Then** the status item should display the remaining time (e.g., "19:58") alongside or instead of the static icon.
2.  **Given** the timer is stopped, **When** I look at the menu bar, **Then** the status item should revert to its default state (icon only).
3.  **Given** the timer is paused, **When** I look at the menu bar, **Then** the status item should display the remaining time (e.g., "19:58").

---

### User Story 4 - Clean Main Interface (Priority: P3)

As a user, I want a cleaner main interface without redundant text so that the app looks modern and minimal.

**Why this priority**: Visual polish that aligns with the "minimalist" product vision.

**Independent Test**: Can be tested by inspecting the main view.

**Acceptance Scenarios**:

1.  **Given** the main timer view is open, **When** I view the interface, **Then** the text label "Mode" should not be visible.

### Edge Cases

-   **Timer Expiry while Closed**: What happens if the user selects "Leave timer running", quits, and reopens the app *after* the timer would have naturally expired? The app should handle this gracefully (e.g., show 00:00 or trigger the completion state immediately).
-   **Very Short Durations**: How does the menu bar display handle single-digit seconds (e.g., "0:05")? It should remain readable.
-   **Long Durations**: How does the menu bar display handle hours (e.g., "1:00:00")? It should fit within reasonable menu bar constraints.

## Requirements *(mandatory)*

### Functional Requirements

-   **FR-001**: The Quit confirmation view MUST use the same presentation method (popover) and visual style as the existing Settings page.
-   **FR-002**: The Quit action MUST check the timer state before deciding whether to show the confirmation view or terminate immediately.
-   **FR-003**: The "Leave timer running" quit option MUST calculate the expected end time and save it to persistence so that the system can restore the correct remaining time on launch.
-   **FR-004**: The Settings view MUST initialize its state bindings from the persisted user preferences on load, ensuring it reflects the saved values.
-   **FR-005**: The Menu Bar controller MUST be able to update the status item's title or view to show the formatted countdown string when the timer is active.
-   **FR-006**: The Main Timer view MUST NOT render the "Mode" text label.

### Key Entities

-   **TimerState**: Represents the current status (running, paused, stopped) and remaining time.
-   **UserPreferences**: Stores the custom durations for each mode.

## Success Criteria *(mandatory)*

### Measurable Outcomes

-   **SC-001**: Users can quit the app when the timer is idle with a single click (0 additional steps).
-   **SC-002**: Users can restore a "running" timer session after a restart with < 1 second of perceived drift (logic handles the elapsed time).
-   **SC-003**: The menu bar item updates the displayed time at 1Hz when the timer is running.
-   **SC-004**: Settings UI matches the actual stored values 100% of the time after an app restart.
