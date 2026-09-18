# BossHunter — MVVM Architecture Plan (MVP)

## Goal

Define the MVVM structure and guidelines for the BossHunter MVP (boss, units,
levels, economy) so implementation can proceed unit by unit without inventing
interfaces mid-work.

## Success Criteria

- Every MVP feature (tap combat, levels, units, economy, persistence) has an
  assigned layer (Model / ViewModel / View) and a named type with known
  responsibilities.
- MVVM guidelines state what may reference what, so a reviewer can check any
  future file against them.
- The plan maps each work unit to a validation check.

## Context And Current Facts

- Template SwiftUI app: `BossHunterApp` launches `ContentView` ("Hello, world!").
  (`BossHunter/BossHunterApp.swift`, `BossHunter/ContentView.swift`)
- Swift 5.0, iPhone + iPad (`TARGETED_DEVICE_FAMILY = "1,2"`), from
  `BossHunter.xcodeproj/project.pbxproj`.
- Test targets exist but contain only template tests
  (`BossHunterTests/`, `BossHunterUITests/`).
- Branch: `development`, clean except untracked `docs/`.
- No networking, no backend, no dependencies — all state is local.

## Constraints And Non-goals

- SwiftUI only, no UIKit bridging in the MVP.
- No third-party dependencies.
- No server sync, accounts, or analytics in the MVP.
- Persistence is local JSON via `UserDefaults`; no SwiftData/CoreData migration
  in the MVP.
- This plan designs structure only; numbers tuning (exact HP/cost curves) happens
  during implementation playtesting.

## Key Decisions

1. **MVVM over MVP/MVC/Clean.** MVP/MVC are UIKit-era patterns; in SwiftUI the
   view struct plus an observable state object already provides that separation.
   Clean Architecture (use cases, repositories) pays off with networking or
   multiple data sources — none exist here. MVVM maps 1:1 onto SwiftUI and keeps
   the MVP to a handful of files.
2. **One `GameState` ViewModel owned by `ContentView`.** Single source of truth
   for boss, gold, tap damage, units, level. Owned via `@State`, passed down as
   `@Bindable`/bindings. One object avoids cross-ViewModel sync bugs at MVP scale.
3. **Pure value-type Models.** `Boss`, `Unit`, and balance formulas are structs /
   free functions with no UI imports — fully unit-testable without rendering.
4. **All economy formulas in `GameBalance.swift`.** HP scaling, cost growth, and
   kill rewards live in one file so tuning never touches UI code.
5. **Timer-driven DPS in the ViewModel.** A 1-second `Timer` in `GameState`
   applies unit DPS; Views never run game logic.

## Recommended Approach

```text
BossHunter/
  BossHunterApp.swift        # entry, launches ContentView
  Models/
    Boss.swift               # struct: level, maxHP, currentHP, reward
    Unit.swift               # struct: baseDPS, baseCost, ownedCount
    GameBalance.swift         # pure formulas: bossHP(level), unitCost(unit),
                             # killReward(level), tapUpgradeCost(level)
  ViewModels/
    GameState.swift           # @Observable: state + tap(), buyUnit(),
                             # upgradeTap(), advanceLevel(), tick()
  Views/
    ContentView.swift         # initializes and owns GameState via `@State`
    BossView.swift            # boss display, HP bar, tap target
    ShopView.swift            # units list + tap upgrade, buy buttons
```

MVVM guidelines:

- Views read state and call ViewModel methods; they never mutate game values,
  compute costs, or own timers.
- ViewModels hold all mutable game state and game rules execution; they never
  import or reference SwiftUI views.
- Models are dumb data + pure logic; they never reference the ViewModel.
- New features follow the same path: formula → `GameBalance`, state →
  `GameState`, presentation → a View.

## Work Plan

1. **Models + balance** — `Boss.swift`, `Unit.swift`, `GameBalance.swift`.
   No UI. Depends on nothing.
2. **GameState** — state, `tap()`, `buyUnit()`, `upgradeTap()`,
   `advanceLevel()`, DPS timer, `UserDefaults` save/load. Depends on unit 1.
3. **BossView + ContentView wiring** — tap combat playable end-to-end.
   Depends on unit 2.
4. **ShopView** — units and tap upgrade purchases. Depends on unit 2.
5. **Levels polish** — timed every-5th-level boss fight, kill rewards.
   Depends on units 2–3.
6. **Tests** — scaling/cost/advance unit tests + launch-tap-buy UI smoke test.
   Follows the units it covers.

## Validation Plan

- Unit 1: `swift test`-equivalent via Xcode unit tests asserting
  `bossHP(level)` grows monotonically and `unitCost` grows per copy owned.
- Unit 2: tests for kill → reward → `advanceLevel()` flow and save/load
  round-trip.
- Units 3–4: build in Xcode (`⌘B`), manual check — tap reduces HP, kill
  advances level, shop purchase deducts gold and raises DPS.
- Unit 5: manual check — 5th-level fight enforces its timer, win and timeout
  paths both work.
- Unit 6: full `BossHunterTests` + `BossHunterUITests` suite green in Xcode.

## Risks / Rollback

- Risk: single `GameState` grows bloated if the MVP scope creeps. Mitigation:
  the `GameBalance.swift` split keeps formulas out; if the ViewModel still
  grows, split persistence into a `GameStore` type — no View changes needed.
- Risk: timer-based DPS drains battery or drifts. Mitigation: 1s coarse timer,
  compute damage from elapsed wall time rather than tick count.
- Rollback: each work unit is additive new files, except unit 3 rewires the
  existing `ContentView`; revert a unit by deleting its files and restoring any
  modified existing files to their pre-unit state.

## Open Questions

None — all material choices are resolved from workspace facts above. Economy
numbers (base HP, growth rates) are intentionally left to implementation
playtesting.
