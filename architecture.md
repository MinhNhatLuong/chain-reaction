# Chain Reaction Reborn - Technical Architecture

Version: 1.3.0  
Last updated: February 7, 2026

## 1. Purpose and Scope

This document is the implementation-accurate architecture reference for the current codebase in `lib/`.

It covers:
- Runtime bootstrap and platform wiring
- Module boundaries and dependency flow
- State management and provider graph
- Core game engine and AI architecture
- Persistence and in-app purchase systems
- Rendering/performance strategy
- Testing coverage and known constraints

It intentionally describes what the code does today, not aspirational design.

## 2. Architectural Style

The project uses a pragmatic Feature-First Clean Architecture variant:

- Feature-first module boundaries:
  - `features/game`
  - `features/home`
  - `features/settings`
  - `features/shop`
- Layering inside features where it is useful:
  - `domain` for rules/entities/contracts
  - `data` for persistence/store integration
  - `presentation` for widgets/providers/screens
- Global cross-cutting modules in `core/`:
  - constants, theme, reusable widgets, utilities, services

### 2.1 Dependency direction

Preferred direction:
- `presentation -> domain`
- `data -> domain`
- `core` is shared utility infrastructure

Practical deviation:
- Domain entities use `freezed` and import `flutter/foundation.dart` for immutable diagnostics and assertions.
- This means domain is not strictly Flutter-free, but remains UI-framework agnostic in behavior.

## 3. Technology Stack

From `pubspec.yaml`:

- Framework: Flutter (Dart SDK `^3.10.7`)
- State management: `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
- Routing: `go_router`
- Immutability/data classes: `freezed`, `freezed_annotation`
- Serialization: `json_annotation`, `json_serializable`
- Persistence:
  - `shared_preferences` (game state, settings, legacy purchases)
  - `flutter_secure_storage` (purchase state ledger)
- IAP: `in_app_purchase`
- External links: `url_launcher`
- Desktop integration: `window_manager`
- Display mode tuning: `flutter_displaymode`
- Haptics: `vibration`
- Analysis/linting: `flutter_lints`, `very_good_analysis`

## 4. Runtime Bootstrap (`lib/main.dart`)

Startup sequence:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. Desktop window initialization on Windows:
   - `window_manager.ensureInitialized()`
   - window options: default `1024x768`, min `800x600`
3. Orientation policy on mobile only:
   - phones: portrait up/down
   - tablets: unrestricted
4. Initialize `SharedPreferences`
5. Launch `ProviderScope` with root overrides:
   - `sharedPreferencesProvider`
   - `gameRepositoryProvider` -> `GameRepositoryImpl`
6. Build `MaterialApp.router` with:
   - `goRouterProvider`
   - localization delegates (`en` currently)
   - theme bound to `themeProvider`
   - custom `FluidFadePageTransitionsBuilder`
   - `DesktopIntegrationWrapper`

## 5. Module Map

### 5.1 Core (`lib/core`)

- `constants/`
  - `app_dimensions.dart` (spacing, grid sizes, timing constants)
  - `breakpoints.dart` (responsive breakpoint model)
  - `constants.dart` (`AppConstants.appVersion`)
- `theme/`
  - `app_theme.dart` (theme definitions, premium flags)
  - `providers/theme_provider.dart` (theme + settings flags state)
  - `custom_transitions.dart`, `responsive_theme.dart`
- `presentation/widgets/`
  - reusable UI primitives (`PillButton`, `GameSelector`, wrappers, dialogs)
  - `desktop_integration_wrapper.dart` (menu bar + keyboard shortcuts)
- `services/`
  - `haptic/haptic_service.dart`
  - `storage/storage_service.dart` (utility wrapper, not the main persistence abstraction)
- `errors/`
  - `domain_exceptions.dart` (AI/move/state exceptions)
- `utils/`
  - `fluid_dialog.dart`, `json_converters.dart`

### 5.2 Game Feature (`lib/features/game`)

- `domain/`
  - `entities/`: `GameState`, `Cell`, `Player`, `FlyingAtom`
  - `logic/game_rules.dart`: rule primitives and turn progression
  - `usecases/place_atom.dart`: explosion propagation stream
  - `ai/`: `AIService`, strategy implementations
  - `repositories/game_repository.dart` contract
- `data/repositories/game_repository_impl.dart`
- `presentation/`
  - `providers/game_state_provider.dart` (`GameNotifier`)
  - grid/cell/atom widgets and screens

### 5.3 Home Feature (`lib/features/home`)

- mode/configuration flow (local multiplayer vs AI)
- AI difficulty + grid size selectors
- responsive single-column / two-pane home layout

### 5.4 Settings Feature (`lib/features/settings`)

- settings repository contract + SharedPreferences impl
- settings screen for:
  - dark mode
  - haptic toggle
  - atom rotation/vibration/breathing toggles
  - cell highlight toggle
  - player name editing trigger

### 5.5 Shop Feature (`lib/features/shop`)

- theme ownership and IAP orchestration
- purchase validation service and purchase state ledger
- shop screens (`purchase_screen`, `palette_screen`, preview dialog)

## 6. Routing (`lib/routing/app_router.dart`)

Routes:
- `/` -> `HomeScreen`
- `/game` -> `GameScreen`
- `/winner` -> `WinnerScreen`
- `/settings` -> `SettingsScreen`
- `/shop` -> `PurchaseScreen`
- `/palette` -> `PaletteScreen`
- `/info` -> `InfoScreen`

Notes:
- Uses `CustomTransitionPage` fade transition in router.
- Error route renders a fallback scaffold with error text.

## 7. State Management

The app uses Riverpod with both manual providers and code-generated providers (`@riverpod`).

### 7.1 Key providers by responsibility

- App/theme/settings:
  - `themeProvider` (`NotifierProvider<ThemeNotifier, ThemeState>`)
  - derived selectors: `isDarkModeProvider`, `isHapticOnProvider`, etc.
- Home setup flow:
  - `homeProvider` (`@riverpod` codegen)
- Game runtime:
  - `gameProvider` (`GameNotifier`, `@riverpod` codegen)
  - selectors: `gridProvider`, `playersProvider`, `currentPlayerProvider`, etc.
- Shop:
  - `shopProvider` (`ShopNotifier`, async codegen provider)
  - `iapServiceProvider`, `shopRepositoryProvider`
- Settings infra:
  - `sharedPreferencesProvider` (root override required)
  - `settingsRepositoryProvider`

### 7.2 Game state update path

For a user move:

1. `GameScreen` tap -> `GameNotifier.placeAtom(x,y)`
2. `GameNotifier` subscribes to `PlaceAtomUseCase` stream
3. Intermediate states emitted during explosion waves update UI
4. On stream completion:
   - advance turn via `GameRules.nextTurn`
   - trigger AI if next player is AI
   - persist state (if game not over)

## 8. Domain Model and Rules

### 8.1 Entities

- `Cell`
  - `capacity`: stable max atoms (`1` corner, `2` edge, `3` center)
  - `isAtCriticalMass`: `atomCount > capacity`
- `Player`
  - `type`: human/ai
  - `difficulty`: `easy|medium|hard|extreme|god` (nullable for humans)
- `GameState`
  - full grid snapshot, players, turn pointers, totals, winner/game-over flags
  - `isProcessing` gates input while chain/AI logic runs

### 8.2 Explosion propagation (`PlaceAtomUseCase`)

- Uses queue-based wave propagation.
- Each explosion wave has two animation phases:
  - source decrement + emit `flyingAtoms`
  - delay (`flightDurationMs`) + neighbor landing/capture
- Winner short-circuit:
  - After each landing phase, `_winnerAfterExplosionWave` checks ownership.
  - If only one owner remains after opening-turn rules, stream emits terminal game-over state and returns immediately.

### 8.3 Turn and winner rules (`GameRules`)

- Early-game protection: no winner before all players have had opening turns.
- `nextTurn`:
  - increments `turnCount`
  - skips eliminated players after opening phase
  - marks game over if only one owner remains

## 9. AI Architecture (`lib/features/game/domain/ai`)

`AIService` runs move calculation in a background isolate via `compute(...)`.

Difficulty mapping:
- `easy` -> `RandomStrategy`
- `medium` -> `GreedyStrategy`
- `hard` -> `StrategicStrategy`
- `extreme` -> `ExtremeStrategy`
- `god` -> `GodStrategy`

### 9.1 Strategy behavior summary

- Easy (`RandomStrategy`)
  - uniform random valid move.
- Medium (`GreedyStrategy`)
  - prioritizes immediate explosions (`atomCount == capacity`)
  - avoids cells adjacent to enemy primed cells (`atomCount >= capacity`)
  - reinforcement bias toward own cells
- Hard (`StrategicStrategy`)
  - 1-ply simulation scoring with heuristics (material, territory, chain gains, vulnerability)
  - 25% humanization/randomness (`_difficultyFactor = 0.75`)
- Extreme (`ExtremeStrategy`)
  - depth-2 minimax + alpha-beta pruning at minimizing layer
  - opening-round-aware next-player selection
  - tie randomness on exact-equal score
- God (`GodStrategy`)
  - stronger depth-limited minimax with alpha-beta and move ordering
  - adaptive depth (`3` typically, falls back to `2` for high branching)
  - no intentional blunder factor

Important correctness note:
- "God" is maximum-strength in this app, but not mathematically perfect in all states because search is depth-limited.

## 10. Rendering and Performance

### 10.1 Grid update granularity

- `GameGrid` builds board layout and animation master clock.
- `ScopedCellWidget` watches only one cell via `gridProvider.select((g) => g?[row][col])`.
- This minimizes rebuild scope to changed cells instead of full-grid reactive churn.

### 10.2 Atom rendering

- Stable cell atoms rendered by `AtomWidget`/`AtomPainter`.
- Flying projectiles are separate overlay widgets (`FlyingAtomWidget`) in a `Stack`.

### 10.3 Input model

- Pointer tap support plus keyboard navigation (arrows + Enter/Space).
- `GameScreen` blocks move input while `isProcessing` or AI turn is active.

## 11. Persistence and Data Management

### 11.1 Game persistence

- Contract: `GameRepository`
- Impl: `GameRepositoryImpl` + SharedPreferences
- Key: `active_game_state`
- Value: full `GameState` JSON

### 11.2 Settings persistence

- Contract: `SettingsRepository`
- Impl: `SettingsRepositoryImpl` + SharedPreferences
- Includes theme name + multiple visual/haptic toggles

### 11.3 Player names

- Managed by `playerNamesProvider` in memory.
- Not persisted across app restarts.

## 12. Shop and IAP Architecture

### 12.1 Entitlement model

- Premium themes identified by theme names (`Earthy`, `Pastel`, `Amoled`)
- Support product id: `support_coffee`

### 12.2 Services and stores

- Store API: `in_app_purchase`
- Purchase ledger: `PurchaseStateManager` (`flutter_secure_storage`)
- Legacy compatibility: also reads/writes historical SharedPreferences list for theme purchases

### 12.3 Validation pipeline

- `IAPService` receives purchase stream updates.
- Purchases saved as `PurchaseInfo` with explicit state transitions.
- `PurchaseValidationService`:
  - platform checks + local verification-data checks
  - backend credentials via dart defines:
    - `ANDROID_PUBLISHER_API_KEY`
- Fallback behavior:
  - local validation fallback allowed only in debug or when explicitly enabled via `ALLOW_LOCAL_IAP_VALIDATION_FALLBACK=true`

### 12.4 UX fallback for support purchase

If `support_coffee` product is unavailable, the app opens an external support URL. If URL launch fails, it copies the link to clipboard and shows snackbar feedback.

## 13. Platform-Specific Behavior

### 13.1 Mobile (Android)

- Orientation locked for phone form factors only.
- Haptics via `vibration` package (`lightImpact`, `heavyImpact`, explosion pattern).
- Android high-refresh-rate request via `flutter_displaymode`.

### 13.2 Desktop (Windows)

- Native window configuration through `window_manager`.
- Desktop wrapper adds:
  - menu bar
  - keyboard shortcuts (`Esc`, `Ctrl+Q`, `F11`)
  - mouse back-button handling

## 14. Testing Strategy and Coverage

Current automated tests in `test/` include:

- Domain rules and invariants:
  - `game_rules_test.dart`
  - `game_rules_extended_test.dart`
  - `domain_assertion_test.dart`
- Move propagation and game-over edge cases:
  - `place_atom_test.dart`
- Deterministic progression checks:
  - `determinism_test.dart`
- Provider/integration behavior:
  - `game_notifier_test.dart`
- Screen-level smoke/behavior tests:
  - `game_screen_test.dart`
  - `winner_screen_test.dart`
  - `widget_test.dart`

## 15. Known Constraints and Tradeoffs

- AI correctness vs latency:
  - Stronger strategies are depth-limited for responsiveness.
- Domain purity tradeoff:
  - entities rely on Flutter foundation utilities.
- Localization scope:
  - only English (`en`) currently shipped.
- Shop behavior in debug:
  - premium themes are unlocked in debug mode (`kDebugMode`) for development convenience.

## 16. How to Extend Safely

Recommended extension patterns:

- New AI difficulty:
  1. Add enum case in `AIDifficulty`
  2. Implement strategy in `features/game/domain/ai/strategies/`
  3. Wire mapping in `AIService`
  4. Update selector label and serialization map
- New setting toggle:
  1. Add key + getter/setter in `SettingsRepository` + impl
  2. Add state field/mutator in `ThemeState`/`ThemeNotifier`
  3. Expose in `SettingsScreen`
- New route/screen:
  1. Add route constants
  2. Register GoRoute in `app_router.dart`
  3. Navigate using named routes
