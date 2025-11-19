# Data Model: UI Fixes and Timer Enhancements

**Feature Branch**: 003-ui-fixes  
**Spec**: [specs/003-ui-fixes/spec.md](specs/003-ui-fixes/spec.md)  
**Research**: [specs/003-ui-fixes/research.md](specs/003-ui-fixes/research.md)  
**Date**: 2025-11-17

## Overview

This data model captures state and UI entities needed to deliver responsive settings, timer continuity, confirmation dialogs, and enhanced alarm playback. Core logic remains in `TimerEngine` (countdown) and `AppState` (observable state + persistence orchestration).

## Entities

### 1. TimerMode

| Field | Type | Description |
| --- | --- | --- |
| id | `String` | Unique identifier (`work`, `rest_eyes`, `long_rest`) |
| name | `String` | User-facing label (“Work”) |
| icon | `String` | Emoji or SF Symbol string for menu bar display |
| defaultDuration | `TimeInterval` | Default minutes converted to seconds |
| colorTheme | `Color?` | Optional color styling for future theming |

**Relationships**: Referenced by `TimerState.currentMode`. Stored centrally to keep UI, engine, and menus consistent.

### 2. TimerState

| Field | Type | Description |
| --- | --- | --- |
| currentMode | `TimerMode` | Active timer mode |
| remainingSeconds | `Int` | Remaining countdown seconds |
| isRunning | `Bool` | `true` if timer is running |
| startedAt | `Date?` | When the timer last started/resumed (for background refresh) |
| lastPausedAt | `Date?` | Used to calculate drift if needed |

**Behavior**:
- Mutated exclusively by `TimerEngine`.
- Observed by `AppState` to drive UI updates.
- Serialized into `TimerPersistenceSnapshot`.

### 3. TimerPersistenceSnapshot

| Field | Type | Description |
| --- | --- | --- |
| modeID | `String` | Matches `TimerMode.id` |
| remainingSeconds | `Int` | Persisted countdown |
| isRunning | `Bool` | Captures running state |
| resumedAt | `Date?` | Equivalent to `startedAt` for rehydration |
| savedAt | `Date` | Timestamp of snapshot creation |
| schemaVersion | `Int` | Facilitates migrations |

**Validation**:
- Ensure `remainingSeconds` between 0 and 60 minutes (per constitution).
- Discard snapshot if schemaVersion mismatches and no migration exists.

### 4. SettingsLayoutState

Captures responsive UI metadata for SwiftUI layout tests.

| Field | Type | Description |
| --- | --- | --- |
| popoverWidth | `CGFloat` | Current popover width |
| isCompact | `Bool` | Derived flag when width < 360 px |
| dynamicTypeSize | `DynamicTypeSize` | System font scaling |
| layoutMode | `enum { grid, stacked }` | Actual layout used by `ViewThatFits` |

**Usage**: Only lives in view models/tests to verify responsiveness; not persisted.

### 5. ModeSwitchIntent

Represents the pending mode change while a timer is active.

| Field | Type | Description |
| --- | --- | --- |
| requestedMode | `TimerMode` | Mode user selected |
| initiatedAt | `Date` | Timestamp for analytics/debug |
| confirmationState | `enum { pending, confirmed, cancelled }` | Result of dialog |
| originatingView | `enum { popover, settings }` | Where change originated |

**Flow**:
1. User taps new mode → `ModeSwitchIntent` created.
2. Confirmation dialog resolves state.
3. `AppState` either cancels intent or forwards to `TimerEngine`.

### 6. QuitIntent

Represents the user’s response to the quit confirmation dialog.

| Field | Type | Description |
| --- | --- | --- |
| action | `enum { stopAndQuit, persistAndQuit, cancel }` | Selected option |
| handled | `Bool` | Prevents duplicate handling |
| snapshot | `TimerPersistenceSnapshot?` | Exists only for persist-and-quit |

**Usage**: `AppState` listens for `QuitIntent` results, ensuring termination response and persistence align.

### 7. AlarmPlaybackState

| Field | Type | Description |
| --- | --- | --- |
| fileURL | `URL` | Points to `sounds/alarm.mp3` |
| status | `enum { idle, playing, failed }` | Current audio state |
| lastError | `Error?` | Captures playback issues |
| fallbackUsed | `Bool` | Indicates system sound fallback triggered |

**Purpose**: Enables diagnostics/tests to assert Principle 10 compliance.

## Relationships Diagram (Textual)

```
TimerMode 1<--* TimerState
TimerState 1<-->1 TimerPersistenceSnapshot (serialization)
TimerState 1<--1 ModeSwitchIntent (pending change)
QuitIntent 1<--1 TimerPersistenceSnapshot (persist-and-quit)
AppState owns TimerState, ModeSwitchIntent, QuitIntent, AlarmPlaybackState
```

## Validation & Constraints

- `TimerMode` definitions are immutable and centralized.
- `TimerPersistenceSnapshot` rejects invalid durations and stale schema versions.
- Layout logic must not hardcode widths; instead rely on `SettingsLayoutState` signals.
- Mode switching and quit intents must be nilled out after completion to avoid stale dialogs.
- Alarm playback attempts must log failures and toggle `fallbackUsed`.

## Derived/Computed Values

- `TimerState.displayTime`: Formats `remainingSeconds` into `MM:SS`.
- `SettingsLayoutState.isCompact`: `popoverWidth < 360`.
- `ModeSwitchIntent.requiresConfirmation`: true if `TimerState.isRunning`.
- `QuitIntent.shouldDelayTermination`: true if `action == persistAndQuit` and persistence pending.

## Mapping to Files

- `AppState.swift`: Owns TimerState, handles persistence, exposes intents.
- `TimerEngine.swift`: Operates on TimerState; agnostic of UI/persistence.
- `DurationSettingsView.swift`: Reads `SettingsLayoutState` to adjust layout.
- `TimerProfileStore.swift`: Extended to read/write `TimerPersistenceSnapshot`.
- New `AlarmPlayerService.swift` (to be created) holds `AlarmPlaybackState`.

## Open Questions / Assumptions

- Force-quit scenarios cannot guarantee persistence (documented in assumptions for spec).
- No schema migration needed yet; `schemaVersion == 1`.
- Only one pending `ModeSwitchIntent` or `QuitIntent` at a time; enforced by AppState.
