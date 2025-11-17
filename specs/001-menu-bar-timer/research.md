# Research Summary: Sharp Timer Menu Bar Experience

## Decision 1: Timer Engine Cadence

- **Decision**: Use `DispatchSourceTimer` driven off the main queue for 1 Hz ticks, wrapped in a pure Swift `TimerEngine`.
- **Rationale**: `DispatchSourceTimer` keeps jitter low, integrates with run loop pauses (sleep/wake), and avoids SwiftUI `Timer` view invalidations when the popover closes. Keeping the engine UI-agnostic supports Constitution Principle 2 (resource) and Architecture guidance.
- **Alternatives considered**:
  - `Timer.publish` + Combine: simple but stops when no SwiftUI subscriber is active (popover closed) and complicates background ticks.
  - `CADisplayLink`: unnecessary 60 Hz resolution, exceeds resource targets.

## Decision 2: Persistence Mechanism

- **Decision**: Store per-mode durations and last-selected mode in `UserDefaults` via a dedicated `TimerProfileStore`.
- **Rationale**: Data volume is small (minutes + mode enum), `UserDefaults` is built-in, fast, and satisfies spec requirement for persistence without extra frameworks.
- **Alternatives considered**:
  - JSON file in Application Support: more control but redundant given simple schema.
  - CoreData: excessive setup for three scalar values.

## Decision 3: Notification Delivery

- **Decision**: Use `UNUserNotificationCenter` with category actions (“Dismiss”, “Restart”) and fall back to in-app visual cues if permission denied.
- **Rationale**: Constitution Principle 3 mandates native notifications. Category actions let users restart flows directly from banners; fallback ensures success criteria SC-002 when notifications disabled.
- **Alternatives considered**:
  - Custom NSAlert windows: violates menu-bar-only philosophy and is intrusive.
  - Silent notifications only: fails UX requirements.

## Decision 4: Menu Bar Presentation

- **Decision**: Implement menu bar UI using SwiftUI `MenuBarExtra` (macOS 13+) showing `💼 22:15`-style title plus popover containing timer display, mode picker, controls, and Settings gear.
- **Rationale**: Built-in support meets Principle 1; aligns with ContentView blueprint already in project; ensures accessibility and future theme expansion.
- **Alternatives considered**:
  - Legacy `NSStatusItem` + storyboard nib: more boilerplate, reduces SwiftUI reuse.
  - Dock-based app with hidden window: violates Constitution.

## Decision 5: Settings Flow

- **Decision**: Present duration editing via secondary SwiftUI sheet inside the popover, updating AppState immediately and persisting asynchronously.
- **Rationale**: Keeps all interaction within menu bar, honors requirement for real-time updates without timer restart, and avoids multi-window complexity.
- **Alternatives considered**:
  - Separate Preferences window: adds dock icon or extra UI context.
  - Inline text fields in main popover: clutters primary timer flow.

## Decision 6: Testing Strategy

- **Decision**: Cover TimerEngine and persistence store with XCTest unit tests using expectation-based timers and UserDefaults suite injection; add minimal UITest for menu bar flows using Xcode’s menu bar automation hooks.
- **Rationale**: Constitution mandates tests for engine + persistence; approach gives deterministic coverage without flakey UI reliance.
- **Alternatives considered**:
  - Snapshot tests for popover: deferred until future visual specs.
  - Manual QA only: insufficient for constitution gate.

All open questions resolved; no remaining NEEDS CLARIFICATION items.
