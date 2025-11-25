# Research: Bauhaus UI Redesign

**Feature**: 009-ui-redesign

## Technical Context & Decisions

### Design Translation (React to SwiftUI)

| Element | React Source | SwiftUI Implementation |
|---------|-------------|------------------------|
| **Colors** | Red `#E31C23`, Blue `#1F4690`, Yellow `#FFD300` | `Color(hex: "E31C23")`, etc. extended in `Color+Bauhaus` |
| **Background** | `#F0F0F0` | `Color(hex: "F0F0F0")` |
| **Icons** | `lucide-react`: Briefcase, Eye, Coffee | SF Symbols: `briefcase.fill`, `eye.fill`, `cup.and.saucer.fill` |
| **Layout** | Flexbox, full screen centered | `VStack`, `HStack`, fixed frame for Popover (approx 350x500) |
| **Shapes** | CSS clipped divs, rotated elements | SwiftUI `Circle()`, `Rectangle()`, `.rotationEffect()` |
| **Animations** | CSS transitions (`transition-all`) | SwiftUI `.animation(.spring(), value: mode)` |

### Architecture Alignment

- **Separation of Concerns**: The React `App.tsx` holds state (`timeLeft`, `mode`). In Swift, this remains in `AppState`. The Views (`TimerDisplayView`) will only observe and render.
- **Menu Bar Constraint**: The Figma design assumes a browser window. 
  - **Decision**: We will adapt the design to a fixed-size popover (e.g., width 320-360pt) to maintain the "Menu Bar Exclusive" principle.
  - **Implication**: Some whitespace from the desktop design will be reduced to fit the compact popover.

### Accessibility Strategy

- **Contrast**: The Bauhaus colors are bold.
  - Red `#E31C23` on White: 4.8:1 (Pass AA)
  - Blue `#1F4690` on White: 10.6:1 (Pass AAA)
  - Yellow `#FFD300` on White: 1.7:1 (Fail).
    - **Decision**: Yellow text on white is unreadable. The React design uses `#1A1A1A` text on Yellow background (approx 13:1, Pass AAA).
    - We must ensure text *on* yellow backgrounds is dark, and yellow text is only used on dark backgrounds (or not used for text at all).
- **VoiceOver**: All geometric decorations must be `.accessibilityHidden(true)` to avoid clutter.
