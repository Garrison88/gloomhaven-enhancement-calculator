import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';

const String tableCharacterMasteries = 'CharacterMasteries';
// const String columnAssociatedCharacterUuid = 'CharacterUuid';
const String columnAssociatedMasteryId = 'MasteryID';
const String columnMasteryProgress = 'Progress';

class CharacterMastery {
  String associatedCharacterUuid;
  int associatedMasteryId;
  int masteryProgress = 0;

  CharacterMastery(
    this.associatedCharacterUuid,
    this.associatedMasteryId,
    this.masteryProgress,
  );

  CharacterMastery.fromMap(Map<String, dynamic> map) {
    associatedCharacterUuid = map[columnAssociatedCharacterUuid];
    associatedMasteryId = map[columnAssociatedMasteryId];
    masteryProgress = map[columnMasteryProgress];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAssociatedCharacterUuid: associatedCharacterUuid,
      columnAssociatedMasteryId: associatedMasteryId,
      columnMasteryProgress: masteryProgress,
    };
    return map;
  }
}
