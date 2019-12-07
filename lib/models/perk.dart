// database table and column names
final String tablePerks = 'PerksTable';
final String columnPerkId = '_id';
final String columnPerkClass = 'PerkClass';
final String columnPerkDetails = 'Details';

// data model class
class Perk {
  int perkId;
  String perkClassCode;
  String perkDetails;
  int numOfPerks;

  Perk(
      // this.id,
      this.perkClassCode,
      this.perkDetails,
      this.numOfPerks);

  // convenience constructor to create a Perk object
  Perk.fromMap(Map<String, dynamic> map) {
    perkId = map[columnPerkId];
    perkClassCode = map[columnPerkClass];
    perkDetails = map[columnPerkDetails];
  }

  // convenience method to create a Map from this Perk object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnPerkId: perkId,
      columnPerkClass: perkClassCode,
      columnPerkDetails: perkDetails
    };
    // if (perkId != null) {
    //   map[columnPerkId] = perkId;
    // }
    return map;
  }
}
