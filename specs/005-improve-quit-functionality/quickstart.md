# Quickstart: Improve Quit Functionality

## Overview
This feature introduces a new quit flow that allows users to persist their timer state when quitting the app.

## Testing Steps

### 1. Quit Options Window
1. Start a timer (e.g., Work mode).
2. Click the "Quit" button in the menu bar popover.
3. **Verify**: A new window opens with 3 options: "Stop timer and quit app", "Quit app and leave timer running", "Cancel".

### 2. Stop and Quit
1. Open the quit options window.
2. Click "Stop timer and quit app".
3. **Verify**: App quits immediately.
4. Relaunch the app.
5. **Verify**: Timer is in `idle` state (reset).

### 3. Persist and Quit
1. Start a timer with ~20 minutes remaining.
2. Open the quit options window.
3. Click "Quit app and leave timer running".
4. **Verify**: App quits immediately.
5. Wait for 1 minute.
6. Relaunch the app.
7. **Verify**: Timer resumes automatically with ~19 minutes remaining.

### 4. Cancel
1. Open the quit options window.
2. Click "Cancel".
3. **Verify**: Window closes, app remains running, timer continues ticking.

### 5. Idle Quit
1. Ensure timer is stopped (idle).
2. Click "Quit".
3. **Verify**: App quits immediately without showing the window.
