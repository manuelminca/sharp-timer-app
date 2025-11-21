# Research: Bauhaus UI Redesign

## Design System Implementation

### Decision
Implement a centralized `Theme` struct that defines the Bauhaus color palette, typography, and shape modifiers.

### Rationale
- **Consistency**: Ensures all views use the exact same colors and fonts.
- **Maintainability**: Changing a color or font in one place updates the entire app.
- **Scalability**: Easy to add new themes later if needed (though currently restricted to Light Bauhaus).

### Alternatives Considered
- **Hardcoded Values**: Rejected. Hard to maintain and inconsistent.
- **Asset Catalog**: Good for colors, but doesn't handle fonts or shapes as cohesively as a code-based Theme struct for this specific stylistic overhaul. We will likely use Asset Catalog for the *values* but access them through the Theme struct.

## Geometric Shapes in SwiftUI

### Decision
Use standard SwiftUI `Shape` API (Rectangle, Circle) and custom `ViewModifier`s for buttons.

### Rationale
- **Native Performance**: Standard shapes are highly optimized.
- **Accessibility**: Standard controls can be styled while retaining accessibility traits.

### Implementation Details
- **Buttons**: Create a `BauhausButtonStyle` conforming to `ButtonStyle` that applies the geometric shape and color based on the Theme.
- **Typography**: Use `Font.custom` if a specific font is bundled, or `Font.system` with specific weights/designs (e.g., `.monospaced` or `.rounded` - though Bauhaus prefers sharp/geometric, so standard sans-serif is best).

## Responsiveness

### Decision
Use `ViewThatFits`, `GeometryReader` (sparingly), and flexible frames (`maxWidth: .infinity`) to ensure components adapt to content size.

### Rationale
- **Menu Bar Constraints**: Popovers have limited resizing capabilities. The UI must adapt to the content (e.g., longer text in different languages) without breaking layout.
- **Dynamic Type**: SwiftUI handles Dynamic Type automatically if using scaled fonts.

## Dark Mode Handling

### Decision
Explicitly override `preferredColorScheme` to `.light` in the root view.

### Rationale
- **Spec Requirement**: The user explicitly requested "Just light Bauhaus theme is okay" and "No Dark/light themes".
- **Aesthetic Integrity**: The specific Bauhaus palette (primary colors on white) is designed for light mode.
