// database table and column names
const String tableCharacterPerks = 'CharacterPerks';
const String columnAssociatedCharacterId = 'CharacterID';
const String columnAssociatedPerkId = 'PerkID';
const String columnCharacterPerkIsSelected = 'IsSelected';

// data model class
class CharacterPerk {
  int associatedCharacterId;
  int associatedPerkId;
  bool characterPerkIsSelected = false;

  CharacterPerk(this.associatedCharacterId, this.associatedPerkId,
      this.characterPerkIsSelected);

  // convenience constructor to create a CharacterPerk object
  CharacterPerk.fromMap(Map<String, dynamic> map) {
    associatedCharacterId = map[columnAssociatedCharacterId];
    associatedPerkId = map[columnAssociatedPerkId];
    characterPerkIsSelected =
        map[columnCharacterPerkIsSelected] == 1 ? true : false;
  }

  // convenience method to create a Map from this CharacterPerk object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAssociatedCharacterId: associatedCharacterId,
      columnAssociatedPerkId: associatedPerkId,
      columnCharacterPerkIsSelected: characterPerkIsSelected ? 1 : 0
    };
    return map;
  }
}
