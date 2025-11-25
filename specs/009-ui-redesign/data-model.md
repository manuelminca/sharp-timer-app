# Data Model: Bauhaus UI Redesign

## Visual Theme Configuration

### Color Palette (`Color+Bauhaus.swift`)

| Variable | Hex Value | Use Case |
|----------|-----------|----------|
| `bauhausRed` | `#E31C23` | Work Mode Primary |
| `bauhausBlue` | `#1F4690` | Rest Mode Primary |
| `bauhausYellow` | `#FFD300` | Long Rest Primary |
| `bauhausBackground` | `#F0F0F0` | Main View Background |
| `bauhausText` | `#1A1A1A` | Primary Text |
| `bauhausWhite` | `#FFFFFF` | Secondary Text / Accents |

### Typography (`Font+Bauhaus.swift`)

| Font Style | System Font Equivalent | Use Case |
|------------|------------------------|----------|
| `bauhausHeader` | System, Bold, Size 48+ | Timer Display |
| `bauhausLabel` | System, Medium, Uppercase | Mode Labels, Buttons |
| `bauhausBody` | System, Regular | General Text |

## View State Models

### `TimerDisplayViewModel` (Implicit in View)

- **Properties**:
  - `mode`: Current timer mode (determines color scheme)
  - `remainingTime`: Formatted string
  - `isRunning`: Boolean (triggers animations)
  - `progress`: Float (0.0-1.0) for geometric transitions

### `ModeConfig` (UI Representation)

| Property | Type | Description |
|----------|------|-------------|
| `mode` | `TimerMode` | The engine mode |
| `color` | `Color` | Bauhaus primary color |
| `iconName` | `String` | SF Symbol Name |
| `shape` | `ShapeType` | Circle, Rectangle, or RotatedSquare |
