# Quickstart: Fixes and Improvements

## Overview

This feature introduces a robust quit confirmation flow, fixes settings persistence issues, and enhances the menu bar visual feedback.

## Testing the Quit Logic

1.  **Start a Timer**: Click the menu bar icon and press "Start".
2.  **Try to Quit**: Click the "Quit" button in the main view.
3.  **Verify Dialog**: Ensure a window appears with 3 options.
4.  **Test "Leave Running"**:
    -   Select "Leave timer running...".
    -   Wait 10 seconds.
    -   Relaunch the app.
    -   **Verify**: The timer should be running, and the time should have decreased by ~10 seconds (plus launch time).

## Testing Settings Persistence

1.  **Change Settings**: Open Settings, change "Work" duration to 30 minutes.
2.  **Quit**: Quit the app completely.
3.  **Relaunch**: Open the app and check Settings.
4.  **Verify**: "Work" duration should still be 30 minutes.

## Testing Menu Bar Icon

1.  **Start Timer**: Start any timer.
2.  **Observe Icon**: The menu bar item should show the countdown (e.g., "24:59").
3.  **Pause/Stop**: Pause or stop the timer.
4.  **Observe Icon**: The menu bar item should revert to the icon only.
