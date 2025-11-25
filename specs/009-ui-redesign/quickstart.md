# Quickstart: Bauhaus UI Redesign

## Prerequisites

- Xcode 15+
- macOS 13+
- No external package dependencies required (uses standard SwiftUI assets).

## Running the Redesign

1. **Open the Project**:
   ```bash
   open "Sharp Timer App/Sharp Timer App.xcodeproj"
   ```

2. **Build Scheme**:
   Select "Sharp Timer App" scheme.

3. **Run**:
   Press `Cmd+R`. The app will launch in the menu bar.

4. **Verify UI**:
   - Click the menu bar icon.
   - Ensure the popover displays the new Bauhaus-style interface (white background, geometric shapes).
   - Switch modes and verify color changes (Red -> Blue -> Yellow).
   - Use the timeline/preview in Xcode using `TimerDisplayView_Previews`.

## Key Files

- `Features/Theme/Color+Bauhaus.swift`: Central location for theme colors.
- `Features/Theme/BauhausTheme.swift`: Theme constants and helpers.
- `Features/MenuBar/TimerDisplayView.swift`: Main UI implementation.
