# Feature Specification: UI Fixes and Timer Enhancements

**Feature Branch**: `003-ui-fixes`  
**Created**: 2025-11-17  
**Status**: Draft  
**Input**: User description: "Fix responsive settings UI, add timer mode switching confirmation, implement timer state persistence on app quit, and enhance alarm sound"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Responsive Settings UI (Priority: P1)

As a user, I want the settings page to be responsive and adapt properly to different window sizes so that I can easily adjust timer durations regardless of my screen size or system font settings.

**Why this priority**: This is a critical bug fix that impacts core usability. Users currently cannot properly use settings on different screen configurations, making the app effectively unusable for configuration tasks.

**Independent Test**: Can be fully tested by resizing the settings window and verifying all controls remain accessible and properly laid out across different window sizes and system font scales.

**Acceptance Scenarios**:

1. **Given** the settings popover is open, **When** I resize the window to minimum width, **Then** all controls remain visible and usable without horizontal scrolling
2. **Given** the settings popover is open, **When** I increase system font size, **Then** the layout adapts and all text remains readable without overlapping
3. **Given** the settings popover is open, **When** I resize the window to various dimensions, **Then** the input fields and labels maintain proper alignment and spacing

---

### User Story 2 - Timer Mode Switching Confirmation (Priority: P1)

As a user, I want to be warned when I try to switch timer modes while a timer is running so that I don't accidentally lose my progress.

**Why this priority**: Prevents user frustration and data loss. Users frequently lose timer progress accidentally when switching modes, which breaks concentration and workflow.

**Independent Test**: Can be fully tested by starting a timer in one mode, then attempting to switch to another mode and verifying the confirmation dialog appears and functions correctly.

**Acceptance Scenarios**:

1. **Given** a timer is running in Work mode, **When** I click on Rest Your Eyes mode, **Then** a confirmation dialog appears asking if I want to switch modes and lose the current timer
2. **Given** the mode switching confirmation dialog is displayed, **When** I select "Switch Mode", **Then** the current timer stops and the new mode is selected
3. **Given** the mode switching confirmation dialog is displayed, **When** I select "Cancel", **Then** the dialog closes and the original timer continues running unchanged
4. **Given** no timer is running, **When** I switch modes, **Then** the mode changes immediately without showing a confirmation dialog

---

### User Story 3 - Timer State Persistence on App Quit (Priority: P1)

As a user, I want my timer progress to be preserved when I quit the application so that I can continue my work session later without losing track of time.

**Why this priority**: Critical for user workflow continuity. Users often need to quit the app temporarily but want to maintain their timer state for productivity tracking.

**Independent Test**: Can be fully tested by starting a timer, quitting the app with different confirmation options, then relaunching and verifying the timer state is correctly preserved or stopped as expected.

**Acceptance Scenarios**:

1. **Given** a timer is running, **When** user attempts to quit the application, **Then** a confirmation dialog appears with the message "Timer is active now. Are you sure you want to quit the app?"
2. **Given** the confirmation dialog is displayed, **When** user selects "Stop timer and Quit", **Then** the timer stops and the application quits
3. **Given** the confirmation dialog is displayed, **When** user selects "Quit and leave timer running", **Then** the application quits but timer state is preserved for next launch
4. **Given** the confirmation dialog is displayed, **When** user selects "Cancel", **Then** the dialog closes and the application continues running with the timer active
5. **Given** the app was quit with timer running, **When** the app is relaunched, **Then** the timer resumes with the correct remaining time and mode
6. **Given** the confirmation dialog is displayed, **When** user selects "Quit and leave timer running", **Then** the application quits immediately without showing the confirmation dialog again

---

### User Story 4 - Enhanced Alarm Sound (Priority: P2)

As a user, I want a clearer and more pleasant alarm sound when my timer completes so that I can immediately recognize when my work session ends.

**Why this priority**: Improves user experience and timer effectiveness. The current alarm may not be distinctive enough to cut through ambient noise or may be unpleasant to hear repeatedly.

**Independent Test**: Can be fully tested by letting timers complete in each mode and verifying the enhanced alarm sound plays correctly and handles error conditions gracefully.

**Acceptance Scenarios**:

1. **Given** a Work timer completes, **When** the alarm triggers, **Then** the enhanced alarm sound from 'sounds/alarm.mp3' plays
2. **Given** the alarm sound file is missing or corrupted, **When** a timer completes, **Then** the system falls back to the default macOS notification sound
3. **Given** the app is in the background, **When** a timer completes, **Then** the alarm sound plays at the system volume level
4. **Given** multiple timers complete in quick succession, **When** each alarm triggers, **Then** the sound plays without overlapping or distortion

---

### User Story 5 - Alarm Playback Regression Fix (Priority: P0)

As a user, I want the alarm to play sound when my timer completes so that I can be notified when my work session ends.

**Why this priority**: Critical regression that breaks core functionality. Users rely on audio notifications to know when timers complete, and without sound the timer becomes ineffective for time management.

**Independent Test**: Can be fully tested by starting timers in each mode and verifying that audio playback occurs when the timer completes.

**Acceptance Scenarios**:

1. **Given** a Work timer completes, **When** the alarm triggers, **Then** audio sound plays through the system speakers
2. **Given** a Rest Your Eyes timer completes, **When** the alarm triggers, **Then** audio sound plays through the system speakers
3. **Given** a Long Break timer completes, **When** the alarm triggers, **Then** audio sound plays through the system speakers
4. **Given** the system volume is muted, **When** a timer completes, **Then** a visual notification is displayed as fallback
5. **Given** the app is in the background, **When** a timer completes, **Then** the alarm sound plays and brings the app to user's attention

---

### User Story 6 - Settings Stepper Focus Bug Fix (Priority: P0)

As a user, I want to use the +/- stepper controls in settings without the settings window or popover minimizing, closing, or losing focus so that I can adjust timer durations smoothly and efficiently.

**Why this priority**: Critical usability bug that prevents users from configuring the app. The current behavior where clicking stepper buttons causes the settings window to minimize or close makes settings adjustment frustrating and potentially impossible, blocking users from basic app configuration.

**Independent Test**: Can be fully tested by opening settings and repeatedly clicking the stepper controls to verify the window remains visible, open, and responsive without any minimization, closure, or focus loss.

**Acceptance Scenarios**:

1. **Given** the settings popover is open, **When** I click the "+" button for Work duration, **Then** the value increases by 1 minute AND the settings window remains fully visible without minimizing or closing
2. **Given** the settings popover is open, **When** I click the "-" button for Rest Your Eyes duration, **Then** the value decreases by 1 minute AND the settings window remains fully visible without minimizing or closing
3. **Given** the settings popover is open, **When** I rapidly click multiple stepper controls (5+ clicks in quick succession), **Then** all clicks are registered, values update correctly, AND the window stays open and visible throughout without any minimization or closure
4. **Given** the settings popover is open, **When** I alternate between "+" and "-" buttons on different duration fields, **Then** each click registers correctly AND the window never minimizes, closes, or loses focus
5. **Given** the settings popover is open, **When** I use keyboard navigation (Tab + Space/Enter) to interact with steppers, **Then** the window maintains focus and visibility without minimizing
6. **Given** the settings popover is open, **When** I click a stepper button and immediately click another stepper button, **Then** both clicks register and the window remains stable without any visual flickering or minimization

---

### User Story 7 - Application Quit Affordance (Priority: P1)

As a user, I want a visible quit button in the app interface so that I can properly exit the application when needed.

**Why this priority**: Essential for proper app lifecycle management. Users currently have no clear way to quit the app, leading to confusion and force-quit attempts.

**Independent Test**: Can be fully tested by verifying the quit button is visible, clickable, and properly triggers the quit confirmation flow.

**Acceptance Scenarios**:

1. **Given** the menu bar popover is open, **When** I look at the interface, **Then** I see a quit button positioned next to the Settings button
2. **Given** the quit button is visible, **When** I click it, **Then** the quit confirmation dialog appears with the three options
3. **Given** the quit button is visible, **When** I hover over it, **Then** it provides visual feedback indicating it's clickable
4. **Given** the quit button is visible, **When** I use keyboard navigation, **Then** I can access and activate the quit button
5. **Given** the quit button is clicked, **When** I select "Cancel" from the confirmation dialog, **Then** the dialog closes and I return to the main interface

---

### Edge Cases

- What happens when the user force-quits the application (Cmd+Q, Activity Monitor) instead of using the normal quit flow?
- How does the system handle corrupted timer state data when restoring after a crash?
- What happens when the system volume is muted when a timer completes?
- How does the settings UI respond to extreme window sizes (very small or very large)?
- What happens when the user switches modes rapidly multiple times?
- What happens when the user clicks stepper buttons while the app is in the background or partially obscured by other windows?
- How do stepper controls behave when clicked in rapid succession (stress testing focus retention)?
- What happens if the user holds down a stepper button to rapidly increment/decrement values?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST make the settings UI responsive and adaptable to different window sizes and system font scales
- **FR-002**: System MUST display a confirmation dialog when switching timer modes while a timer is active
- **FR-003**: System MUST preserve timer state (remaining time, mode, running status) when user quits application with "Quit and leave timer running" option
- **FR-004**: System MUST provide three options in the quit confirmation dialog: "Stop timer and Quit", "Quit and leave timer running", and "Cancel"
- **FR-005**: System MUST use the enhanced alarm sound file located at 'sounds/alarm.mp3' for timer completion notifications
- **FR-006**: System MUST validate and restore timer state on application launch with proper error handling for corrupted data
- **FR-007**: System MUST prevent timer mode switching without confirmation when a timer is running
- **FR-008**: System MUST handle missing or corrupted alarm sound files gracefully with fallback to system sounds
- **FR-009**: System MUST play audio sound when any timer completes (Work, Rest Your Eyes, or Long Break)
- **FR-010**: System MUST maintain settings window/popover in a fully visible, open, and focused state when users interact with stepper controls, explicitly preventing any window minimization, closure, hiding, or focus loss behavior regardless of click frequency or pattern
- **FR-011**: System MUST provide a visible quit button positioned next to the Settings button in the main interface
- **FR-012**: System MUST ensure the quit button is accessible via both mouse click and keyboard navigation

### Key Entities

- **TimerState**: Represents the current timer configuration including remaining time, mode, and running status
- **ConfirmationDialog**: Represents the dialog presented to users for mode switching and application quit scenarios
- **SettingsLayout**: Represents the responsive layout configuration for the settings UI
- **AlarmAudio**: Represents the audio playback system for timer completion notifications

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Settings UI remains fully functional across window sizes from 280px to 800px width
- **SC-002**: 100% of timer mode switch attempts while running show confirmation dialog
- **SC-003**: Timer state preservation and restoration works correctly in 95% of quit/relaunch cycles
- **SC-004**: Enhanced alarm sound plays successfully in 98% of timer completion events
- **SC-005**: User error rate for accidental timer loss decreases by 90% after implementation
- **SC-006**: Settings accessibility improves with 100% of controls remaining visible at minimum window size
- **SC-007**: Audio alarm playback works in 100% of timer completion events across all modes
- **SC-008**: Settings stepper controls maintain full window visibility and prevent minimization/closure in 100% of click interactions, including rapid clicking, alternating between buttons, and sustained interaction patterns
- **SC-009**: Quit button is visible and accessible in 100% of app sessions
- **SC-010**: Quit confirmation dialog appears correctly in 100% of quit button activations
