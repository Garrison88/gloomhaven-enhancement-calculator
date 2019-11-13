// database table and column names
final String tableCharacters = 'characters';
final String columnId = '_id';
final String columnName = 'name';
final String columnClassCode = 'classCode';
final String columnXp = 'xp';
final String columnGold = 'gold';
final String columnNotes = 'notes';
final String columnCheckMarks = 'checkMarks';

// data model class
class Character {
  int id;
  String name;
  String classCode;
  int xp;
  int gold;
  String notes;
  int checkMarks;

  Character();

  // convenience constructor to create a Character object
  Character.fromMap(Map<String, dynamic> map) {
    name = map[columnName];
    classCode = map[columnClassCode];
    xp = map[columnXp];
    gold = map[columnGold];
    notes = map[columnNotes];
    checkMarks = map[columnCheckMarks];
  }

  // convenience method to create a Map from this Character object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnClassCode: classCode,
      columnXp: xp,
      columnGold: gold,
      columnNotes: notes,
      columnCheckMarks: checkMarks
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}