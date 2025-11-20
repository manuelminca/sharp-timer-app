# Research: Fixes and Improvements

**Feature**: Fixes and Improvements
**Status**: Complete

## Summary

No specific research was required for this feature as the requirements are well-defined and map directly to the existing architecture and codebase. The changes involve standard SwiftUI and AppKit patterns already in use within the project.

## Decisions

- **Quit Confirmation**: Will use a SwiftUI view presented as a popover (same as Settings) to ensure visual consistency and proper integration with the menu bar UI.
- **Persistence**: Will leverage the existing `TimerProfileStore` and `AppState` logic, ensuring that the "expected end time" is calculated and saved when "Leave timer running" is selected.
- **Menu Bar Icon**: Will update the `NSStatusItem.button.title` property in the `MenuBarController` to show the countdown.

## Alternatives Considered

- **System Alert for Quit**: Considered using a standard `NSAlert`, but the requirement explicitly stated "same type of window and same style as the settings page", so a custom view is necessary.
