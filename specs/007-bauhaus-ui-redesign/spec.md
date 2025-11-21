# Feature Specification: Bauhaus UI Redesign

**Feature Branch**: `007-bauhaus-ui-redesign`
**Created**: 2025-11-21
**Status**: Draft
**Input**: User description: "I want to improve the UI by changing the desing to follow Bauhaus style. I don't want to change any of the functionality that already exists in the app, just change how the app looks to make it more visually pleasant and atractive. Pretend you are an expert designer and come up with a good design for it. I don't have specific requests, you have artistic freedom as long as the functionality remains the same."

## Clarifications

### Session 2025-11-21
- Q: Dark Mode Strategy? → A: No Dark/Light themes. Just light Bauhaus theme is okay.
- Q: Responsiveness Scope? → A: The components have to be responsive, nothing super dynamic or customisable required.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Visual Refresh of Timer Display (Priority: P1)

As a user, I want the main timer interface to reflect a Bauhaus aesthetic so that the app feels modern, artistic, and visually distinct while remaining readable.

**Why this priority**: This is the primary view of the application and the main touchpoint for the user.

**Independent Test**: Can be tested by launching the app and verifying the new visual style of the timer, buttons, and labels without checking settings or other flows.

**Acceptance Scenarios**:

1. **Given** the app is running, **When** I open the menu bar popover, **Then** I see the timer display using geometric shapes, primary colors (or a Bauhaus-inspired palette), and sans-serif typography.
2. **Given** the timer is running, **When** I look at the display, **Then** the countdown is clearly legible against the new background/layout.
3. **Given** the control buttons (Start/Stop/Reset), **When** I interact with them, **Then** they maintain their function but exhibit the new geometric styling (e.g., square or circular buttons with flat design).

---

### User Story 2 - Bauhaus-Styled Settings (Priority: P2)

As a user, I want the settings menu to match the new design language so that the experience is consistent across the application.

**Why this priority**: Ensures visual consistency when the user customizes the app.

**Independent Test**: Can be tested by navigating to the settings view and verifying the styling of input fields, labels, and layout.

**Acceptance Scenarios**:

1. **Given** the settings view is open, **When** I view the duration controls, **Then** the steppers and text fields follow the Bauhaus theme (minimalist, geometric).
2. **Given** the settings view, **When** I look at the labels, **Then** they use the consistent sans-serif typography and color scheme.

---

### User Story 3 - Consistent Dialogs and Alerts (Priority: P3)

As a user, I want confirmation dialogs (like Quit) to follow the same style so that the immersion is not broken.

**Why this priority**: Completes the visual overhaul for less frequent interactions.

**Independent Test**: Can be tested by triggering the quit action and observing the confirmation window.

**Acceptance Scenarios**:

1. **Given** I attempt to quit the app, **When** the confirmation window appears, **Then** it uses the Bauhaus color palette and typography.

### Edge Cases

- What happens when the system is in Dark Mode?
  - The app will enforce the Light Bauhaus theme regardless of system settings, as per clarification.
- How does the design handle long text in different languages?
  - The geometric layout must allow for text expansion without breaking the grid (Responsive Components).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The UI MUST use a **Light** color palette inspired by the Bauhaus movement (e.g., #E31C23 Red, #1F4690 Blue, #FFD300 Yellow, #F0F0F0 White, #1A1A1A Black). Dark mode is explicitly excluded.
- **FR-002**: The UI MUST use a geometric sans-serif font (e.g., Futura, Helvetica, or a system font with similar characteristics) for all text.
- **FR-003**: Buttons MUST be shaped as distinct geometric forms (circles, squares, or rectangles with sharp edges) rather than standard rounded system buttons.
- **FR-004**: The layout MUST emphasize grid alignment and negative space.
- **FR-005**: All existing functionality (Timer logic, Start/Stop/Reset, Mode switching, Settings persistence) MUST remain unchanged.
- **FR-006**: The "Work", "Rest Eyes", and "Long Rest" modes MUST be visually distinguishable, potentially using the primary colors to code them (e.g., Red for Work, Blue for Rest, Yellow for Long Rest).
- **FR-007**: UI components MUST be responsive to content changes (e.g., text length) to ensure layout integrity without requiring complex window resizing logic.

### Key Entities

- **Theme**: A centralized definition of colors, fonts, and shapes to be applied across Views.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All UI components (Timer, Settings, Dialogs) adhere to the defined Bauhaus color palette and typography.
- **SC-002**: User can perform all core tasks (Start Timer, Change Mode, Edit Settings) with the same number of clicks as the previous version.
- **SC-003**: Text contrast ratios meet WCAG AA standards for accessibility despite the stylistic changes.
- **SC-004**: The app passes all existing regression tests for functionality.
