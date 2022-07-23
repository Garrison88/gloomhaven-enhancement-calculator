const String tableMasteries = 'MasteriesTable';
const String columnMasteryId = '_id';
const String columnMasteryClass = 'Class';
const String columnMasteryDetails = 'Details';

class Mastery {
  int masteryId;
  String masteryClassCode;
  String masteryDetails;

  Mastery({
    this.masteryClassCode,
    this.masteryDetails,
  });

  Mastery.fromMap(Map<String, dynamic> map) {
    masteryId = map[columnMasteryId];
    masteryClassCode = map[columnMasteryClass];
    masteryDetails = map[columnMasteryDetails];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMasteryId: masteryId,
      columnMasteryClass: masteryClassCode,
      columnMasteryDetails: masteryDetails,
    };
    return map;
  }
}
