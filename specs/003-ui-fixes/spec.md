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

### Edge Cases

- What happens when the user force-quits the application (Cmd+Q, Activity Monitor) instead of using the normal quit flow?
- How does the system handle corrupted timer state data when restoring after a crash?
- What happens when the system volume is muted when a timer completes?
- How does the settings UI respond to extreme window sizes (very small or very large)?
- What happens when the user switches modes rapidly multiple times?

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
