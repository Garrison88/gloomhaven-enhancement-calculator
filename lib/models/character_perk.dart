// database table and column names
final String tableCharacterPerks = 'CharacterPerks';
final String columnAssociatedCharacterId = 'CharacterID';
final String columnAssociatedPerkId = 'PerkID';
final String columnCharacterPerkIsSelected = 'IsSelected';

// data model class
class CharacterPerk {
  int associatedCharacterId;
  int associatedPerkId;
  bool characterPerkIsSelected;

  CharacterPerk(this.associatedCharacterId, this.associatedPerkId,
      this.characterPerkIsSelected);

  // convenience constructor to create a CharacterPerk object
  CharacterPerk.fromMap(Map<String, dynamic> map) {
    associatedCharacterId = map[columnAssociatedCharacterId];
    associatedPerkId = map[columnAssociatedPerkId];
    characterPerkIsSelected = map[characterPerkIsSelected ? 1 : 0];
  }

  // convenience method to create a Map from this CharacterPerk object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAssociatedCharacterId: associatedCharacterId,
      columnAssociatedPerkId: associatedPerkId,
      columnCharacterPerkIsSelected: characterPerkIsSelected ? 1 : 0
    };
    // if (associatedCharacterId != null) {
    //   map[columnAssociatedPerkId] = associatedPerkId;
    // }
    return map;
  }
}
