import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

// Database table and column names for Worlds
const String tableWorlds = 'Worlds';
const String columnWorldId = 'WorldID';
const String columnWorldUuid = 'WorldUUID';
const String columnWorldName = 'WorldName';
const String columnWorldGameVariant = 'GameVariant';
const String columnWorldCreatedAt = 'CreatedAt';
const String columnWorldIsActive = 'IsActive';
const String columnWorldNotes = 'Notes';

// World model - represents a game box/universe
class World {
  int? id;
  String uuid;
  String name;
  Variant gameVariant;
  DateTime createdAt;
  bool isActive;
  String notes;

  World({
    this.id,
    required this.uuid,
    required this.name,
    this.gameVariant = Variant.base,
    DateTime? createdAt,
    this.isActive = true,
    this.notes = '',
  }) : createdAt = createdAt ?? DateTime.now();

  World.fromMap(Map<String, dynamic> map)
      : id = map[columnWorldId],
        uuid = map[columnWorldUuid],
        name = map[columnWorldName],
        gameVariant = Variant.values.firstWhere(
          (v) => v.name == map[columnWorldGameVariant],
          orElse: () => Variant.base,
        ),
        createdAt = DateTime.parse(map[columnWorldCreatedAt]),
        isActive = map[columnWorldIsActive] == 1,
        notes = map[columnWorldNotes] ?? '';

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnWorldUuid: uuid,
      columnWorldName: name,
      columnWorldGameVariant: gameVariant.name,
      columnWorldCreatedAt: createdAt.toIso8601String(),
      columnWorldIsActive: isActive ? 1 : 0,
      columnWorldNotes: notes,
    };
    if (id != null) {
      map[columnWorldId] = id;
    }
    return map;
  }

  World copyWith({
    int? id,
    String? uuid,
    String? name,
    Variant? gameVariant,
    DateTime? createdAt,
    bool? isActive,
    String? notes,
  }) {
    return World(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      gameVariant: gameVariant ?? this.gameVariant,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }
}
