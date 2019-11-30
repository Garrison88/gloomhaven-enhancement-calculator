// database table and column names
final String tablePerks = 'PerksTable';
final String columnPerkId = '_id';
final String columnPerkClass = 'PerkClass';
final String columnPerkDetails = 'Details';

// data model class
class PerkRow {
  int perkId;
  String perkClass;
  String perkDetails;

  PerkRow(
      // this.id,
      this.perkClass,
      this.perkDetails);

  // convenience constructor to create a PerkRow object
  PerkRow.fromMap(Map<String, dynamic> map) {
    perkId = map[columnPerkId];
    perkClass = map[columnPerkClass];
    perkDetails = map[columnPerkDetails];
  }

  // convenience method to create a Map from this PerkRow object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnPerkId: perkId,
      columnPerkClass: perkClass,
      columnPerkDetails: perkDetails
    };
    if (perkId != null) {
      map[columnPerkId] = perkId;
    }
    return map;
  }
}
