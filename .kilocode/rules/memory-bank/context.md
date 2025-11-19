# Project Context

## Current Focus
We are currently finalizing **Phase 3: UI Fixes and Timer Enhancements** (Branch `003-ui-fixes`). The primary goal is to harden the application against data loss, improve usability across different screen sizes, and enhance the audio experience.

## Recent Achievements
-   **Responsive Settings**: Rebuilt the settings UI to adapt to various window sizes and dynamic type settings.
-   **Safety Rails**: Implemented confirmation dialogs for mode switching and application quit to prevent accidental timer loss.
-   **Persistence**: Added robust state saving to JSON on app quit, ensuring timers resume correctly on relaunch.
-   **Audio Engine**: Integrated a new `AlarmPlayerService` with custom MP3 support and system sound fallbacks.
-   **Bug Fixes**: Resolved critical issues with settings stepper focus and alarm playback regressions.

## Active Tasks
-   [ ] Verify integration of all Phase 3 features.
-   [ ] Perform final regression testing on audio and persistence.
-   [ ] Polish accessibility labels for new UI elements.
-   [ ] Prepare for release/merge of `003-ui-fixes`.

## Upcoming Goals
-   **Code Cleanup**: Refactor any "vibe-coded" legacy patterns into strict, testable components.
-   **Documentation**: Ensure all new features are fully documented in the `README` and developer guides.
-   **Performance Tuning**: Verify CPU and memory usage meets the <1% idle / <50MB footprint targets.

## Known Issues / Constraints
-   **Sandboxing**: File access is restricted; persistence relies on standard Application Support directories.
-   **Audio**: Background playback relies on correct `AVAudioSession` configuration; need to ensure it doesn't conflict with other media apps.
-   **Window Management**: Menu bar popovers have unique focus behaviors; custom gesture handling was required for steppers to prevent window dismissal.
