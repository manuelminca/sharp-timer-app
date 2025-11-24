# Feature Specification: Mode Auto-Start Setting

**Feature Branch**: `008-mode-auto-start-setting`  
**Created**: 2025-11-21  
**Status**: Completed  
**Input**: User description: "I want to add a tickbox element in the setting that specifies if changing the mode should automatically start the timer or change it but leave it paused."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Configure Auto-Start Setting (Priority: P1)

As a user, I want to access the settings to configure whether changing the timer mode should automatically start the timer or leave it paused, so that I can customize the timer behavior to my preference.

**Why this priority**: This is the core functionality that enables user control over timer behavior, providing the primary value of the feature.

**Independent Test**: Can be fully tested by navigating to settings, locating the tickbox, and verifying it can be toggled.

**Acceptance Scenarios**:

1. **Given** the app is running, **When** user opens settings, **Then** a tickbox labeled "Auto-start timer on mode change" is visible
2. **Given** the tickbox is visible, **When** user clicks the tickbox, **Then** the setting toggles between checked and unchecked states

---

### User Story 2 - Auto-Start Behavior (Priority: P2)

As a user with auto-start enabled, I want the timer to start automatically when I change modes, so that I don't have to manually start it each time.

**Why this priority**: This implements the primary desired behavior when the setting is enabled.

**Independent Test**: Can be fully tested by enabling the setting, changing timer mode, and verifying the timer starts automatically.

**Acceptance Scenarios**:

1. **Given** auto-start is enabled and timer is paused, **When** user changes timer mode, **Then** the timer resets to full duration of new mode and starts automatically
2. **Given** auto-start is enabled and timer is running, **When** user changes timer mode, **Then** the timer resets to full duration of new mode and continues running

---

### User Story 3 - Paused Behavior (Priority: P3)

As a user with auto-start disabled, I want the timer to remain paused when I change modes, so that I can review the new mode before starting.

**Why this priority**: This implements the alternative behavior when the setting is disabled.

**Independent Test**: Can be fully tested by disabling the setting, changing timer mode, and verifying the timer remains paused.

**Acceptance Scenarios**:

1. **Given** auto-start is disabled and timer is paused, **When** user changes timer mode, **Then** the timer resets to full duration of new mode and remains paused
2. **Given** auto-start is disabled and timer is running, **When** user changes timer mode, **Then** the timer resets to full duration of new mode and becomes paused

---

### Edge Cases

- What happens when timer is already running and mode is changed? The timer resets to the new mode's full duration, then either continues running (if auto-start enabled) or becomes paused (if auto-start disabled).
- How does system handle rapid mode changes? Each mode change applies the current setting state and resets the timer to the new mode's full duration.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Settings view MUST include a tickbox labeled "Auto-start timer on mode change"
- **FR-002**: When tickbox is checked, changing timer mode MUST reset timer to new mode's full duration and start it if it was paused
- **FR-003**: When tickbox is checked, changing timer mode MUST reset timer to new mode's full duration and continue running if it was already running
- **FR-004**: When tickbox is unchecked, changing timer mode MUST reset timer to new mode's full duration and leave it paused regardless of previous state
- **FR-005**: The auto-start setting MUST be persisted across app sessions using user preferences

### Key Entities *(include if feature involves data)*

- **AutoStartSetting**: Represents the user's preference for auto-starting timer on mode change, with boolean value (enabled/disabled)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can locate and toggle the auto-start setting in settings within 30 seconds
- **SC-002**: 100% of timer mode changes respect the current auto-start setting state
- **SC-003**: The auto-start setting persists correctly across app restarts without user intervention