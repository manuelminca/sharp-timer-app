# Data Model: Bauhaus UI Redesign

## Theme System

The application will introduce a `Theme` system to manage the Bauhaus aesthetic.

### Entities

#### `BauhausColor`
Defines the semantic color palette.

| Field | Type | Description | Value (Hex) |
|-------|------|-------------|-------------|
| `primaryRed` | `Color` | Main accent color | `#E31C23` |
| `primaryBlue` | `Color` | Secondary accent color | `#1F4690` |
| `primaryYellow` | `Color` | Highlight color | `#FFD300` |
| `background` | `Color` | App background | `#F0F0F0` |
| `text` | `Color` | Main text color | `#1A1A1A` |
| `surface` | `Color` | Component background | `#FFFFFF` |

#### `BauhausFont`
Defines the typography hierarchy.

| Field | Type | Description |
|-------|------|-------------|
| `header` | `Font` | Large geometric font for timer display |
| `body` | `Font` | Standard readable font for labels |
| `button` | `Font` | Bold font for controls |

#### `BauhausShape`
Defines the geometric shapes for UI components.

| Component | Shape | Description |
|-----------|-------|-------------|
| `StartButton` | `Circle` | Play button |
| `StopButton` | `Square` | Stop button |
| `ModeSelector` | `Rectangle` | Segmented control replacement |
| `InputField` | `Rectangle` | Sharp-edged input field |

### Relationships

- `AppState` does **not** store the Theme, as it is currently a static, single-theme implementation. The Theme is applied directly via SwiftUI View Modifiers or Environment values.
