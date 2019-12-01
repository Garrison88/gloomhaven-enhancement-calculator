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

  CharacterPerk(
    this.associatedCharacterId,
      this.associatedPerkId,
      this.characterPerkIsSelected);

  // // convenience constructor to create a CharacterPerk object
  // CharacterPerk.fromMap(Map<String, dynamic> map) {
  //   perkId = map[columnPerkId];
  //   perkClass = map[columnPerkClass];
  //   perkDetails = map[columnPerkDetails];
  // }

  // // convenience method to create a Map from this CharacterPerk object
  // Map<String, dynamic> toMap() {
  //   var map = <String, dynamic>{
  //     columnPerkId: perkId,
  //     columnPerkClass: perkClass,
  //     columnPerkDetails: perkDetails
  //   };
  //   if (perkId != null) {
  //     map[columnPerkId] = perkId;
  //   }
  //   return map;
  // }
}
