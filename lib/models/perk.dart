// database table and column names
final String tablePerks = 'PerksTable';
final String columnPerkId = '_id';
final String columnPerkClass = 'Class';
final String columnPerkDetails = 'Details';

// data model class
class Perk {
  int perkId;
  String perkClassCode;
  int numOfPerks;
  String perkDetails;

  Perk(
      // this.id,
      this.perkClassCode,
      this.numOfPerks,
      this.perkDetails);

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
