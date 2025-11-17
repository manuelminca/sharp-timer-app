# Quickstart: UI Fixes and Timer Enhancements

## Purpose

Guide contributors through setting up the environment, validating responsive layouts, testing timer persistence, and verifying the enhanced alarm flow for feature branch `003-ui-fixes`.

## Prerequisites

- macOS 13 or later with Xcode 15 installed
- Command Line Tools enabled (`xcode-select --install`)
- Access to repository branch `003-ui-fixes`
- Audio output available for alarm validation
- Notifications permission granted to Sharp Timer App

## Setup Steps

1. **Install Dependencies**
   ```bash
   cd "Sharp Timer App"
   open Sharp\ Timer\ App.xcodeproj
   ```
   Xcode will resolve Swift Package Manager dependencies automatically.

2. **Select Scheme**
   - Choose `Sharp Timer App` scheme.
   - Target `My Mac (Designed for iPad)` is **not** supported; use `My Mac`.

3. **Configure Run Options**
   - Enable “Launch Automatically After Install”.
   - In Run > Options, check “Allow Location Simulation” (not used but prevents warnings).

4. **Build & Run**
   - `Cmd+B` to build; ensure no warnings.
   - `Cmd+R` to launch the menu-bar app.
   - Grant notification and audio permissions when prompted.

## Validation Checklist

### 1. Responsive Settings UI
1. Open menu bar popover → click gear icon for settings.
2. Drag popover edges between ~280 px and ~600 px; ensure inputs stay visible.
3. System Settings > Accessibility > Display > increase text size → relaunch app.
4. Confirm layout switches from grid to stacked view when narrow, without overlapping text.

### 2. Mode Switching Confirmation
1. Start Work timer; while running, select Rest Your Eyes.
2. Verify confirmation dialog with “Switch Mode” and “Cancel”.
3. Choose “Cancel” → timer continues.
4. Repeat and choose “Switch Mode” → timer resets to new mode with explicit consent.
5. Ensure no dialog appears when timer is idle.

### 3. Quit Confirmation & Persistence
1. Start Long Rest timer.
2. Press `Cmd+Q`; dialog must show:
   - “Stop timer and Quit”
   - “Quit and leave timer running”
   - “Cancel”
3. Select each option in separate runs:
   - **Stop timer and Quit** → relaunch app; timer idle.
   - **Quit and leave timer running** → relaunch; timer resumes with correct remaining time.
   - **Cancel** → app stays open.
4. Inspect `~/Library/Application Support/Sharp Timer/timer-state.json` for valid JSON after persist-and-quit path.

### 4. Enhanced Alarm Sound
1. Shorten Work timer to 1 minute in settings.
2. Start timer, let it finish with app in background and foreground.
3. Confirm `alarm.mp3` plays at system volume.
4. Temporarily rename `sounds/alarm.mp3` to simulate missing file → ensure fallback notification sound triggers and log mentions fallback.

### 5. Automated Tests
1. **Unit Tests**
   ```bash
   cd "Sharp Timer App"
   xcodebuild test \
     -project "Sharp Timer App.xcodeproj" \
     -scheme "Sharp Timer App" \
     -destination 'platform=macOS'
   ```
2. **UI Tests**
   - Run `Sharp Timer AppUITests` suite focusing on `MenuBarFlowTests`.
   - Ensure tests covering responsive settings and quit dialog pass.

## Troubleshooting

| Symptom | Resolution |
| --- | --- |
| Settings UI still clips controls | Confirm you are on branch `003-ui-fixes`; clean build folder (`Shift+Cmd+K`) |
| Quit dialog not appearing | Verify AppState intercepts `applicationShouldTerminate`; check logs for delegate wiring |
| Timer not resuming after persist | Inspect JSON snapshot for invalid `schemaVersion` or negative `remainingSeconds` |
| Alarm sound silent | Ensure system volume not muted and `alarm.mp3` present; check Console for AVAudioPlayer errors |

## Next Steps

- After validation, proceed with `/speckit.tasks` to generate implementation tasks.
- Document any deviations or additional findings in `specs/003-ui-fixes/research.md` before moving to development.
