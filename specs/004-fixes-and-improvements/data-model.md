# Data Model: Fixes and Improvements

## Entities

### TimerState (Existing)

Represents the snapshot of the timer when the app is closed or state is saved.

| Field | Type | Description |
|-------|------|-------------|
| `mode` | `TimerMode` | The active mode (Work, Rest Eyes, Long Rest). |
| `remainingSeconds` | `Int` | Seconds remaining at the time of snapshot. |
| `isRunning` | `Bool` | Whether the timer was running. |

### UserPreferences (Existing)

Stores user configuration.

| Field | Type | Description |
|-------|------|-------------|
| `workDuration` | `Int` | Duration for Work mode in seconds. |
| `restEyesDuration` | `Int` | Duration for Rest Eyes mode in seconds. |
| `longRestDuration` | `Int` | Duration for Long Rest mode in seconds. |

## Persistence

- **Format**: JSON
- **Location**: `~/Library/Application Support/Sharp Timer/timer-state.json`
- **Strategy**:
    - **Settings**: `UserPreferences` are saved to UserDefaults whenever changed.
    - **Timer State**: `TimerState` is NOT saved on quit. The app always starts with a fresh state or default state on relaunch.
