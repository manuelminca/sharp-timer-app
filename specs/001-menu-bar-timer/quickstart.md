# Quickstart – Sharp Timer Menu Bar Experience

## 1. Prerequisites

- macOS 13 Ventura or later
- Xcode 15 or later (Swift 5.9 toolchain)
- Developer account configured for local notification entitlements (no signing changes needed for local runs)

```bash
xcode-select -p        # confirm Xcode command-line tools
swift --version        # should report Swift 5.9.x
```

## 2. Project Structure Recap

```
Sharp Timer App/
├── Sharp Timer App/            # SwiftUI target
├── Sharp Timer AppTests/       # Unit tests (TimerEngine + persistence)
└── Sharp Timer AppUITests/     # Minimal UI regression coverage
```

Supporting planning artifacts for this feature live under `specs/001-menu-bar-timer/`.

## 3. Install & Configure

No third-party dependencies required. After cloning the repo:

```bash
cd "Sharp Timer App"
open "Sharp Timer App.xcodeproj"
```

In Xcode:

1. Set the run destination to “My Mac (Designed for macOS)” or equivalent.
2. Ensure the “Sharp Timer App” scheme is selected.
3. First launch will prompt for notification permission—allow to verify completion alerts.

## 4. Running the Menu Bar App

1. Build & run (`⌘R`). The app launches directly into the menu bar (no Dock icon).
2. Click the menu bar item to open the SwiftUI popover.
3. Use the mode picker (Work / Rest Your Eyes / Long Rest) and Start/Pause/Reset controls.
4. Open Settings (gear icon) to adjust per-mode durations; changes persist immediately.

### Sleep/Wake & Notifications

- Let a timer finish to confirm native notification delivery.
- Toggle notification permission in System Settings → Notifications to test fallback banners.

## 5. Testing

### Unit Tests

```bash
cd "Sharp Timer App"
xcodebuild \
  -scheme "Sharp Timer App" \
  -destination 'platform=macOS' \
  test
```

- `TimerEngineTests`: validates tick cadence, pause/resume, single-session rule.
- `PersistenceTests`: verifies `TimerProfileStore` read/write bounds (1–240 minutes).

### UI Tests

Run `Sharp Timer AppUITests` to ensure the menu bar popover opens, timers start, and completion flow surfaces notifications or fallback indicators.

```bash
xcodebuild \
  -scheme "Sharp Timer AppUITests" \
  -destination 'platform=macOS' \
  test
```

## 6. Troubleshooting

| Symptom | Fix |
| ------- | --- |
| Menu bar item missing | Ensure `MenuBarExtra` scene is enabled; clean build folder (`Shift+⌘+K`). |
| Notifications not showing | Re-run app, grant permission, or verify fallback banner state (`NotificationPreference.needsFallbackBanner`). |
| Timers pause on popover close | Confirm `DispatchSourceTimer` is retained by `TimerEngine` and not tied to view lifecycle. |

This quickstart aligns with the `/speckit.plan` deliverables and prepares the team for `/speckit.tasks` planning.
