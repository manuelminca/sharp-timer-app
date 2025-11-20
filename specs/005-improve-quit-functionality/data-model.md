# Data Model: Improve Quit Functionality

## Entities

### TimerPersistenceSnapshot

Represents the state of the timer at the moment the application was quit.

| Field | Type | Description |
|-------|------|-------------|
| `mode` | `TimerMode` | The active timer mode (Work, Rest Eyes, Long Rest). |
| `remainingSeconds` | `Int` | The number of seconds remaining on the timer. |
| `timestamp` | `Date` | The exact date and time when the snapshot was created. |

## Persistence

- **File**: `~/Library/Application Support/Sharp Timer/timer-state.json`
- **Format**: JSON
- **Lifecycle**:
    - Created when user selects "Quit and leave timer running".
    - Read on application launch.
    - Deleted after successful restoration (or if invalid).
