# Data Model – Sharp Timer Menu Bar Experience

## 1. TimerMode

| Attribute | Type | Description | Validation / Notes |
|-----------|------|-------------|--------------------|
| `id` | enum (`work`, `restEyes`, `longRest`) | Canonical identifier for each timer mode. | Enum locked to Constitution Principle 4 (exactly 3 modes). |
| `displayName` | String | User-facing label (e.g., “Work”). | Localized strings; immutable per mode. |
| `icon` | String (emoji) | Menu bar glyph to show alongside time. | Must match spec icons 💼/👁️/🌟. |
| `defaultMinutes` | Int | Factory default minutes (25/2/15). | Range 1–240 minutes; validated on load. |
| `colorStyle` | Semantic enum | Optional accent color for future themes. | Defaults to neutral palette in MVP. |

**Relationships**: Referenced by `TimerProfile` (to override durations) and `TimerSession` (active mode pointer).

---

## 2. TimerProfile

Stores user-customizable durations and metadata.

| Attribute | Type | Description | Validation / Notes |
|-----------|------|-------------|--------------------|
| `workMinutes` | Int | Custom Work duration. | 1–240 minutes; invalid values coerced to defaults. |
| `restEyesMinutes` | Int | Custom Rest Your Eyes duration. | Same validation bounds. |
| `longRestMinutes` | Int | Custom Long Rest duration. | Same validation bounds. |
| `lastSelectedMode` | `TimerMode.id` | Mode highlighted when popover opens. | Defaults to `work`. |
| `updatedAt` | Date | Timestamp of last settings change. | Used for debugging/support only. |

**Storage**: Serialized to `UserDefaults` under namespace `com.sharp-timer.profile`. Updates are synchronous to ensure persistence before timers rely on new durations.

---

## 3. TimerSession

Represents an in-flight countdown.

| Attribute | Type | Description | Validation / Notes |
|-----------|------|-------------|--------------------|
| `mode` | `TimerMode.id` | Which mode the session belongs to. | Required. |
| `configuredSeconds` | Int | Total seconds at session start. | Derived from `TimerProfile` minutes × 60. |
| `remainingSeconds` | Int | Countdown state exposed to UI. | Clamped >= 0, decremented by engine. |
| `state` | Enum (`idle`, `running`, `paused`, `completed`) | Lifecycle of the session. | Transitions described below. |
| `startedAt` | Date? | Timestamp when countdown began. | Present in `running` state, nil otherwise. |
| `pausedAt` | Date? | Timestamp when paused. | Used to calculate resume offsets. |
| `notificationId` | String? | Identifier of scheduled macOS notification. | Cleared when session resets. |

### State Transitions

```
idle --start--> running
running --pause--> paused
paused --resume--> running
running --tick to 0--> completed
completed --reset--> idle
running/paused --reset--> idle
running --switch mode--> idle (new session begins)
```

All transitions enforced by `TimerEngine` with observable callbacks to `AppState`.

---

## 4. TimerEngine (Domain Service)

Although not persisted, its interface is part of the model layer.

| Function | Description | Inputs/Outputs |
|----------|-------------|----------------|
| `start(mode: TimerMode, duration: Int)` | Initializes `TimerSession` and schedules ticks. | Emits first tick immediately for UI sync. |
| `pause()` / `resume()` | Mutate session state without altering remaining time beyond tick adjustments. | No-ops when in incompatible state. |
| `reset()` | Stops timer, clears notification, returns to idle. | Broadcasts idle session snapshot. |
| `advance(by seconds: Int)` | Internal method triggered by `DispatchSourceTimer`. | Ensures single active session; triggers completion events. |

**Guarantees**: Engine never references SwiftUI; communicates via delegate or Combine publisher returning new `TimerSession` snapshots.

---

## 5. NotificationPreference

Tracks notification capability to satisfy fallback requirements.

| Attribute | Type | Description |
|-----------|------|-------------|
| `authorizationStatus` | Enum (`unknown`, `granted`, `denied`) pulled from `UNUserNotificationCenter`. |
| `lastRequestDate` | Date | Avoids spamming permission prompts. |
| `needsFallbackBanner` | Bool | True when status is denied or delivery failed. |
| `lastFailureReason` | String? | Debug info (e.g., “notifications disabled globally”). |

`AppState` uses this entity to decide between macOS notification and in-app banner.

---

## 6. Derived View Models

### MenuBarDisplayModel

| Attribute | Source | Notes |
|-----------|--------|-------|
| `iconText` | `TimerMode.icon` + state | Example: `💼 22:15`. |
| `isRunning` | `TimerSession.state` | Drives Start/Pause button label. |
| `progress` | Remaining ÷ configured | For optional ring indicator. |

### SettingsFormModel

Wraps `TimerProfile` with validation errors and dirty flags so edits never destabilize an active timer.

---

## Validation Rules Recap

1. Durations must stay within 1–240 minutes; UI enforces slider/stepper bounds, persistence double-checks.
2. Only one session may be in `running` state; `TimerEngine` resets existing session before accepting `start`.
3. Notification state must be refreshed on app launch and whenever system settings change; fallback banner toggles when `needsFallbackBanner == true`.
4. TimerSession resets automatically when macOS sleep spans longer than remaining seconds to avoid negative durations.

---

## Relationships Diagram (text)

```
TimerMode (3 records, static)
      ▲            ▲
      |            |
TimerProfile ----> TimerSession
      |               |
      ▼               ▼
NotificationPreference   MenuBarDisplayModel (derived)
```

This schema ensures the MVP remains deterministic, testable, and compliant with the Constitution’s separation-of-concerns mandate.
