import 'dart:convert';

class SubGoal {
  String description;
  int numberRequired;
  SubGoal(
    this.description,
    this.numberRequired,
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'description': description,
      'numberRequired': numberRequired,
    };
    return map;

    // return {
    //   'description': description,
    //   'numberRequired': numberRequired,
    // };
  }

  factory SubGoal.fromMap(Map<String, dynamic> map) {
    return SubGoal(
      map['description'],
      map['numberRequired'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubGoal.fromJson(String source) =>
      SubGoal.fromMap(json.decode(source));
}
