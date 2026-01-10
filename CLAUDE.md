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

## Tips for AI Assistants

1. **Read before modifying** - Always read files before suggesting changes
2. **Check variants** - Many features branch based on `ClassCategory` or `Variant`
3. **SharedPrefs keys** - Settings stored in `shared_prefs.dart` - check existing keys before adding
4. **Database migrations** - New schema changes need migration code in `database_migrations.dart`
5. **Theme awareness** - Use `Theme.of(context)` and ThemeProvider for colors/styling
