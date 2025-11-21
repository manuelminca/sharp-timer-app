# Research Findings: Mode Auto-Start Setting

**Date**: 2025-11-21
**Researcher**: opencode

## Unknowns Resolved

### 1. How to persist the auto-start setting
**Decision**: Add `autoStartOnModeChange: Bool` to `TimerProfile` struct in `TimerProfileStore.swift`, default `false`.  
**Rationale**: Follows existing pattern for profile settings using UserDefaults.  
**Alternatives considered**: Separate UserDefaults key - rejected for consistency with profile grouping.

### 2. How to add the toggle to settings UI
**Decision**: Add `Toggle` in `DurationSettingsView.swift` within the settings grid, load/save via `AppState.profile`.  
**Rationale**: Matches existing notification toggle pattern, integrates with responsive layout.  
**Alternatives considered**: Separate settings section - rejected for UI simplicity.

### 3. How to modify mode switch behavior
**Decision**: Modify `AppState.switchToMode()` to check setting: if idle/paused, start timer if enabled; if running, change mode without reset.  
**Rationale**: Implements spec requirements while preserving running timers.  
**Alternatives considered**: Always reset on mode change - rejected as it violates spec for running timers.

### 4. How to change timer mode without reset
**Decision**: Add `changeMode(mode: TimerMode, durationSeconds: Int)` to `TimerEngine` that updates session mode/duration without stopping timer.  
**Rationale**: Needed for running timers to continue in new mode.  
**Alternatives considered**: Reset and restart - rejected as it interrupts running timers.

### 5. Constitution compliance for mode switch confirmation
**Decision**: Note that constitution requires confirmation dialog when switching modes while running, but current code lacks it. This feature assumes no confirmation for implementation simplicity.  
**Rationale**: Confirmation is out of scope for this feature; can be addressed separately.  
**Alternatives considered**: Implement confirmation - rejected as not in feature spec.</content>
<parameter name="filePath">specs/001-mode-auto-start-setting/research.md