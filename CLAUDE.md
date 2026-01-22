# CLAUDE.md - Project Context for AI Assistants

## Project Overview

**Gloomhaven Enhancement Calculator** - A Flutter mobile app (iOS/Android) for the Gloomhaven board game series. It provides:
- Character sheet management (create, track, retire characters)
- Enhancement cost calculator
- Perk and mastery tracking
- Resource tracking (gold, XP, checkmarks, etc.)

## Build & Run Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Generate launcher icons
dart run flutter_launcher_icons

# Analyze code
flutter analyze
```

## Architecture

### State Management: Provider + ChangeNotifier

The app uses Provider with four main models set up in `main.dart`:

```
ThemeProvider          → Theme colors, dark mode, font preferences
AppModel               → Page navigation, app-level UI state
EnhancementCalculatorModel → Calculator page state
CharactersModel        → Character CRUD, perk/mastery state (uses ProxyProvider)
```

### Directory Structure

```
lib/
├── main.dart                 # App entry, Provider setup
├── models/                   # Data models (Character, Perk, Mastery, etc.)
├── data/                     # Repositories, database, static game data
│   ├── database_helpers.dart # SQLite singleton (sqflite)
│   ├── database_migrations.dart
│   ├── perks/               # Perk definitions by class
│   ├── masteries/           # Mastery definitions
│   └── player_classes/      # Class definitions
├── l10n/                    # Localization (ARB files + generated code)
│   ├── app_en.arb           # English strings (template)
│   ├── app_pt.arb           # Portuguese translations
│   └── app_localizations.dart # Generated - do not edit
├── viewmodels/              # ChangeNotifier models
├── ui/
│   ├── screens/             # Full-page views
│   ├── widgets/             # Reusable components
│   └── dialogs/             # Modal dialogs
├── theme/                   # Theme system (ThemeProvider, extensions)
├── utils/                   # Helpers, text parsing
└── shared_prefs.dart        # SharedPreferences wrapper (singleton)
```

### Data Persistence

- **SQLite** (`sqflite`) - Characters, perks, masteries (schema version 13)
- **SharedPreferences** - App settings, theme, calculator state

## Key Domain Concepts

### Game Editions (ClassCategory)
```dart
enum ClassCategory {
  gloomhaven,      // Original Gloomhaven
  jawsOfTheLion,   // Starter set
  frosthaven,      // Sequel
  crimsonScales,   // Fan expansion
  custom,          // User-created
  mercenaryPacks,  // Standalone character packs
}
```

### Class Variants
Some classes have different names/perks across game editions:
```dart
enum Variant { base, frosthavenCrossover, gloomhaven2E, v2, v3, v4 }
```
Example: "Brute" in base game → "Bruiser" in Gloomhaven 2E

### Character Data Flow
1. `PlayerClass` - Static class definition (race, name, icon, perks)
2. `Character` - Instance of a class (name, level, XP, gold, retirements)
3. `CharacterPerk` / `CharacterMastery` - Join tables tracking which perks/masteries are checked

## Conventions

### File Naming
- Models: `snake_case.dart` (e.g., `player_class.dart`)
- Screens: `*_screen.dart` or `*_page.dart`
- Widgets: Descriptive names (e.g., `perk_row.dart`, `resource_card.dart`)

### Widget Patterns
- Screens use `context.watch<Model>()` for reactive rebuilds
- One-time reads use `context.read<Model>()`
- Complex widgets are StatefulWidget with local controllers

### Database
- UUID for character IDs (with legacy migration for old int IDs)
- Migrations in `database_migrations.dart` - append new migrations, don't modify old ones

## Known Technical Debt

1. **Large data files** - `perks_repository.dart` (3000+ lines) should be split by edition
2. **Oversized screens** - `settings_screen.dart` (1000+ lines) needs extraction
3. **Legacy files** - `*_legacy.dart` files exist for backward compatibility
4. **No tests** - Test suite needed for models and viewmodels

## Assets

- Class icons: `images/class_icons/*.svg`
- Attack modifiers: `images/attack_modifiers/`
- Custom fonts: PirataOne (headers), HighTower, Nyala, Roboto, OpenSans, Inter

## SVG Theming

The app uses `flutter_svg` for rendering SVG icons. Icons adapt to light/dark themes automatically.

### ThemedSvg Widget (`lib/utils/themed_svg.dart`)

Use the `ThemedSvg` widget to render theme-aware SVG icons:

```dart
// Basic usage - just pass an asset key
ThemedSvg(assetKey: 'MOVE', width: 24)

// With custom color override
ThemedSvg(assetKey: 'ATTACK', width: 24, color: Colors.red)

// With +1 overlay badge (for enhancements)
ThemedSvgWithPlusOne(assetKey: 'MOVE', width: 24)
```

The widget automatically:
- Looks up the asset key in `asset_config.dart` to get the file path
- Detects light/dark theme from `Theme.of(context)`
- Applies appropriate coloring based on the asset's configuration

### Asset Configuration (`lib/utils/asset_config.dart`)

All SVG assets are configured here with their file paths and theming behavior:

```dart
// SVG uses fill="currentColor" - only those parts change with theme
'MOVE': AssetConfig('move.svg', themeMode: CurrentColorTheme())

// No theming needed - renders as-is in both themes
'hex': AssetConfig('hex.svg')
```

### Adding a New SVG Icon

1. Add the SVG file to `images/`
2. Edit the SVG to use `currentColor` for theme-aware parts:
   - `fill="currentColor"` or `style="fill:currentColor"`
   - `stroke="currentColor"` for strokes
3. Add an entry in `asset_config.dart`:
   ```dart
   'MY_ICON': AssetConfig('my_icon.svg', themeMode: CurrentColorTheme())
   ```
4. Use it with `ThemedSvg(assetKey: 'MY_ICON', width: 24)`

### How It Works

- **`themeMode: CurrentColorTheme()`**: Uses `SvgTheme` so only SVG elements with `fill="currentColor"` change color. Other colors in the SVG are preserved. This is ideal for multi-color icons where only some parts should adapt to the theme.

## Android System Navigation Bar

The Android system navigation bar (soft buttons at bottom of screen) color is managed by `ThemeProvider`.

### Key Implementation Details

1. **Single source of truth**: `ThemeProvider._updateSystemUI()` is the only place that sets the navigation bar style. Don't duplicate this in `main.dart` or elsewhere.

2. **Post-frame callback required**: The system UI style must be set after the first frame renders, otherwise Flutter may override it during initialization:
   ```dart
   // In ThemeProvider constructor:
   SchedulerBinding.instance.addPostFrameCallback((_) {
     _updateSystemUI();
   });
   ```

3. **Colors used**:
   - Dark mode: `AppThemeBuilder.darkSurface` (0xff1c1b1f)
   - Light mode: `Colors.white`

4. **Icon brightness**: Set `systemNavigationBarIconBrightness` to ensure buttons are visible:
   - Dark mode: `Brightness.light` (white icons on dark background)
   - Light mode: `Brightness.dark` (dark icons on light background)

### Common Pitfalls

- **Don't set system UI in `main.dart`**: It will be overridden by Flutter before ThemeProvider initializes
- **Don't use transparent nav bar** unless you want app content to show through (requires edge-to-edge mode)
- **Always call `SystemChrome.setSystemUIOverlayStyle()`**: Creating a `SystemUiOverlayStyle` object without passing it to this method does nothing

## Localization (i18n)

The app uses Flutter's official `gen_l10n` system for internationalization. Currently supports English (default) and Portuguese.

### Configuration

- **`l10n.yaml`** (project root) - Localization settings
- **`pubspec.yaml`** - Requires `flutter_localizations` dependency and `generate: true`

### Using Localized Strings

```dart
import 'package:gloomhaven_enhancement_calc/l10n/app_localizations.dart';

// In build methods:
Text(AppLocalizations.of(context).close)
Text(AppLocalizations.of(context).gold)

// With parameters:
Text(AppLocalizations.of(context).pocketItemsAllowed(count))
Text(AppLocalizations.of(context).savedTo(filePath))
```

### Adding New Strings

1. Add the string to `lib/l10n/app_en.arb` (English template):
   ```json
   "myNewString": "Hello world",
   ```

2. For strings with parameters, add metadata:
   ```json
   "greeting": "Hello {name}!",
   "@greeting": {
     "placeholders": {
       "name": { "type": "String" }
     }
   }
   ```

3. Add translation to `lib/l10n/app_pt.arb`:
   ```json
   "myNewString": "Olá mundo",
   "greeting": "Olá {name}!"
   ```

4. Run `flutter pub get` or `flutter gen-l10n` to regenerate

### What's NOT Localized (By Design)

- **`strings.dart`** - Complex markdown content with inline icons (`{ATTACK}`, `{MOVE}`) used by `GameTextParser`. These are tightly coupled with icon rendering and should be localized in a future phase.
- **`perks_repository.dart`** - Perk descriptions with icon placeholders. Game-specific terminology that players recognize across languages.

### Adding a New Language

1. Create `lib/l10n/app_XX.arb` (where XX is the locale code)
2. Copy all keys from `app_en.arb` and translate values
3. Run `flutter pub get` - the language is automatically detected
4. For iOS: Add the language to Xcode project (Runner > Info > Localizations)

## Cost Bottom Sheet (`lib/ui/widgets/cost_bottom_sheet.dart`)

The enhancement calculator uses a custom bottom sheet with a "reveal from behind" effect where the total cost stays fixed while the breakdown slides up behind it.

### Architecture

The widget uses a `Stack` with three layers:
1. **Scrim** - Semi-transparent overlay when expanded
2. **DraggableScrollableSheet** - Contains drag handle + breakdown content
3. **Fixed cost overlay** - Positioned at bottom, displays total cost

### Key Design Decisions

1. **Drag handle moves with sheet**: The drag handle is part of the `DraggableScrollableSheet`, not the fixed overlay. This provides natural affordance that the sheet is draggable.

2. **Cost overlay is separate**: The total cost display is a `Positioned` widget stacked on top. It uses `IgnorePointer` so touches pass through to the sheet underneath.

3. **Bottom padding for last item**: The breakdown content has extra padding (`_costOverlayHeight + 24`) at the bottom so the last item can scroll above the fixed overlay.

4. **Conditional shadow**: The overlay shows an upward shadow only when:
   - Sheet is expanded (`_isExpanded`)
   - User hasn't scrolled to the end (`!_isScrolledToEnd`)

   This indicates there's content "behind" the overlay.

### Scroll Controller Tracking

The `DraggableScrollableSheet` provides a new `ScrollController` in its builder. To track scroll position:

```dart
builder: (context, scrollController) {
  // Store reference and add listener when controller changes
  if (_scrollController != scrollController) {
    _scrollController?.removeListener(_onScrollChanged);
    _scrollController = scrollController;
    _scrollController!.addListener(_onScrollChanged);
  }
  // ...
}
```

### State Management

- `_isExpanded` - True when sheet is above threshold (20% of screen)
- `_isScrolledToEnd` - True when scrolled to bottom (hides shadow)
- Reset `_isScrolledToEnd` when collapsing so shadow shows on next expand

### Important: Default Shadow Visibility

When the sheet first expands, scroll metrics aren't immediately available (`maxScrollExtent` is 0). The logic defaults to showing the shadow (`_isScrolledToEnd = false`) and only hides it once we confirm the user has scrolled to the end. This avoids the shadow being hidden on first expand.

## Tips for AI Assistants

1. **Read before modifying** - Always read files before suggesting changes
2. **Check variants** - Many features branch based on `ClassCategory` or `Variant`
3. **SharedPrefs keys** - Settings stored in `shared_prefs.dart` - check existing keys before adding
4. **Database migrations** - New schema changes need migration code in `database_migrations.dart`
5. **Theme awareness** - Use `Theme.of(context)` and ThemeProvider for colors/styling
6. **SVG icons** - Use `ThemedSvg` widget with asset keys, not direct `SvgPicture` calls
7. **Localization** - Use `AppLocalizations.of(context).xxx` for UI strings, not hardcoded text. Add new strings to ARB files.
8. **User interaction** - When speaking with the developer who is working on this project, push back again their ideas if they aren't technically sound. Don't just do whatever they want - think about it in the context of the app and if you think there's a better way to do something, suggest it.
