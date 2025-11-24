# Data Model: Mode Auto-Start Setting

**Date**: 2025-11-21

## Entities

### TimerProfile (Modified)

**Purpose**: Stores user preferences for timer configuration.

**Fields**:
- `workMinutes: Int` - Duration for work sessions (1-240 minutes)
- `restEyesMinutes: Int` - Duration for rest your eyes (1-60 minutes)  
- `longRestMinutes: Int` - Duration for long rest (1-240 minutes)
- `lastSelectedMode: TimerMode` - Last selected timer mode
- `autoStartOnModeChange: Bool` - Whether to auto-start timer when changing modes (NEW)
- `updatedAt: Date` - Last update timestamp

**Validation Rules**:
- Durations clamped to valid ranges
- autoStartOnModeChange defaults to false
- updatedAt set on any change

**Relationships**: None

**State Transitions**: None (static configuration)

## Schema Changes

- Add `autoStartOnModeChange: Bool` to TimerProfile struct
- Update init() to set default false
- Update validating() to preserve boolean value
- Add updateAutoStartOnModeChange(_: Bool) method to TimerProfileStore