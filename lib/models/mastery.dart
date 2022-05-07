const String tableMasteries = 'MasteriesTable';
const String columnMasteryId = '_id';
const String columnMasteryClass = 'Class';
const String columnMasteryDetails = 'Details';

class Mastery {
  String masteryClassCode;
  String description;
  int numOfChecks;
  // bool isComplete;

  Mastery({
    this.masteryClassCode,
    this.description,
    this.numOfChecks,

    // this.isComplete,
  });
}
