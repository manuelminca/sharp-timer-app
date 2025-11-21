# Research: Improve Quit Functionality

## Decision 1: Window Management for Quit Options

- **Decision**: Use a programmatic `NSWindow` managed by `MenuBarController` or a new `WindowController`.
- **Rationale**: Since the app is `LSUIElement` (agent), standard SwiftUI `WindowGroup` behavior is limited. Creating an `NSWindow` allows precise control over positioning (center screen), style (no title bar, rounded corners), and level (floating above other windows).
- **Alternatives considered**:
    - `WindowGroup`: Might not appear correctly or handle focus well in an agent app.
    - `NSAlert`: Too limited for the custom UI requirement (3 distinct large options).

## Decision 2: Persistence Strategy

- **Decision**: Use `JSONEncoder` to save a `TimerPersistenceSnapshot` struct to `Application Support`.
- **Rationale**: Simple, robust, and meets the < 50ms requirement. `UserDefaults` is okay for settings but a dedicated file is cleaner for state snapshots that are wiped on successful load.
- **Structure**:
    ```swift
    struct TimerPersistenceSnapshot: Codable {
        let mode: TimerMode
        let remainingSeconds: Int
        let timestamp: Date
    }
    ```

## Decision 3: Quit Interception

- **Decision**: Continue using `NSApplicationDelegate.applicationShouldTerminate`.
- **Rationale**: This is the only reliable place to intercept a quit request (Cmd+Q or menu item) and cancel it to show our custom window.
- **Flow**:
    1. User requests quit.
    2. `applicationShouldTerminate` checks `AppState`.
    3. If timer running: return `.terminateCancel`, open `QuitOptionsWindow`.
    4. User selects "Stop & Quit" -> `appState.stop()`, `NSApp.terminate()`.
    5. User selects "Persist & Quit" -> `appState.persist()`, `NSApp.terminate()`.
