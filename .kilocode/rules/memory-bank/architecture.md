# System Architecture

## High-Level Overview
Sharp Timer follows a clean **MVVM (Model-View-ViewModel)** pattern adapted for a SwiftUI menu bar application. It emphasizes separation of concerns between the core timer logic, state management, and the user interface.

## Core Components

### 1. Application Layer
-   **`Sharp_Timer_AppApp`**: The entry point. Configures the `MenuBarExtra` and injects the global environment.
-   **`AppState`**: The central source of truth (`@Observable`). It orchestrates communication between the `TimerEngine`, persistence layer, and UI. It handles business logic for mode switching and notifications.
-   **`ApplicationDelegate`**: Bridges AppKit lifecycle events (like `applicationShouldTerminate`) to the SwiftUI lifecycle.

### 2. Domain Layer
-   **`TimerEngine`**: A pure Swift class responsible for the countdown logic.
    -   Uses `DispatchSourceTimer` for accurate, low-jitter 1Hz ticks.
    -   Decoupled from UI; communicates via callbacks/publishers.
    -   Manages `TimerSession` state (running, paused, completed).
-   **`TimerMode`**: Defines the three immutable modes (Work, Rest Eyes, Long Rest).

### 3. Persistence Layer
-   **`TimerProfileStore`**: Manages data storage.
    -   **UserDefaults**: Stores user preferences (custom durations, last selected mode).
    -   **JSON File**: Stores the active timer snapshot (`timer-state.json`) in `Application Support` for crash-safe persistence.

### 4. Presentation Layer (SwiftUI)
-   **`MenuBarController`**: Manages the status item and popover presentation.
-   **`TimerDisplayView`**: The main view shown in the menu bar popover.
-   **`DurationSettingsView`**: The settings interface. Uses adaptive layouts (`Grid`, `ViewThatFits`) for responsiveness.
-   **`QuitConfirmationView`**: Custom dialog for safe app termination.

### 5. Infrastructure / Services
-   **`AlarmPlayerService`**: Handles audio playback using `AVAudioPlayer`. Manages session activation and fallbacks to system sounds.
-   **`NotificationPreference`**: Manages user notification permissions and fallback logic.

## Data Flow

1.  **User Action**: User clicks "Start" in `TimerDisplayView`.
2.  **State Update**: View calls `AppState.startTimer()`.
3.  **Logic Execution**: `AppState` delegates to `TimerEngine.start()`.
4.  **Tick Loop**: `TimerEngine` fires 1Hz ticks.
5.  **State Propagation**: `TimerEngine` updates its internal state and notifies `AppState`.
6.  **UI Refresh**: `AppState` publishes changes; SwiftUI views redraw automatically.
7.  **Completion**: When timer hits zero, `TimerEngine` notifies `AppState`, which triggers `AlarmPlayerService` and posts a notification.

## Key Design Decisions

-   **Menu Bar Exclusive**: Uses `MenuBarExtra` API (macOS 13+) for a lightweight, native feel.
-   **Reactive State**: Leverages Swift 5.9 `@Observable` macro for efficient UI updates.
-   **Robust Persistence**: Combines `UserDefaults` for lightweight prefs with JSON serialization for complex state snapshots, ensuring data integrity on crash or quit.
-   **Audio Resilience**: Preloads audio buffers and gracefully falls back to system sounds if the custom asset fails or volume is muted.
