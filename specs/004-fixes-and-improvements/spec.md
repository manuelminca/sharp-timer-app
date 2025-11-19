# Feature Specification: Fixes and Improvements

**Feature Branch**: `004-fixes-and-improvements`
**Created**: 2025-11-19
**Status**: Draft
**Input**: User description: "Bug fixes (quit button logic, settings persistence) and visual changes (remove mode text, timer in menu bar icon)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Simple Quit Confirmation (Priority: P1)

As a user, I want a simple two-step confirmation when quitting the app to prevent accidental closures, without complex dialogs.

**Why this priority**: Prevents accidental app termination while maintaining a quick exit flow.

**Independent Test**: Can be tested by clicking the Quit button and verifying the text change and termination behavior.

**Acceptance Scenarios**:

1.  **Given** the main timer view is open, **When** I view the bottom buttons, **Then** I should see a button labeled "Quit".
2.  **Given** the button says "Quit", **When** I click it, **Then** the button text should change to "Confirm Quit" and the app should **not** close.
3.  **Given** the button says "Confirm Quit", **When** I click it, **Then** the application should terminate immediately, regardless of timer state.
4.  **Given** the button says "Confirm Quit", **When** I close/minimize the main window and reopen it, **Then** the button should reset to display "Quit".

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

-   **Very Short Durations**: How does the menu bar display handle single-digit seconds (e.g., "0:05")? It should remain readable.
-   **Long Durations**: How does the menu bar display handle hours (e.g., "1:00:00")? It should fit within reasonable menu bar constraints.

## Requirements *(mandatory)*

### Functional Requirements

-   **FR-001**: The Quit button MUST implement a two-step confirmation state ("Quit" -> "Confirm Quit").
-   **FR-002**: The Quit button state MUST reset to "Quit" whenever the main view appears (e.g., when the menu bar popover is opened).
-   **FR-003**: The application MUST terminate immediately upon clicking "Confirm Quit", regardless of whether a timer is running.
-   **FR-004**: The Settings view MUST initialize its state bindings from the persisted user preferences on load, ensuring it reflects the saved values.
-   **FR-005**: The Menu Bar controller MUST be able to update the status item's title or view to show the formatted countdown string when the timer is active.
-   **FR-006**: The Main Timer view MUST NOT render the "Mode" text label.

### Key Entities

-   **TimerState**: Represents the current status (running, paused, stopped) and remaining time.
-   **UserPreferences**: Stores the custom durations for each mode.

## Success Criteria *(mandatory)*

### Measurable Outcomes

-   **SC-001**: Users can quit the app with exactly two clicks on the same button.
-   **SC-002**: The Quit button always resets to its initial state when the window is reopened.
-   **SC-003**: The menu bar item updates the displayed time at 1Hz when the timer is running.
-   **SC-004**: Settings UI matches the actual stored values 100% of the time after an app restart.
