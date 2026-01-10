import 'dart:convert';

import 'goal.dart';

const String tablePersonalGoals = 'PersonalGoals';
const String columnPersonalGoalId = 'ID';
const String columnSubGoals = 'SubGoals';
const String columnPersonalGoalTitle = 'Title';
const String columnRewardClassCode = 'RewardClassCode';

class PersonalGoal {
  int id;
  List<SubGoal> subGoals;
  String title;
  String rewardClassCode;

  PersonalGoal(this.id, this.subGoals, this.title, this.rewardClassCode);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnPersonalGoalId: id,
      columnSubGoals: subGoals.map((x) => x.toMap()),
      columnPersonalGoalTitle: title,
      rewardClassCode: rewardClassCode,
    };
    return map;

    // return {
    //   'id': id,
    //   'subGoals': subGoals?.map((x) => x.toMap())?.toList(),
    //   'title': title,
    //   'rewardClassCode': rewardClassCode,
    // };
  }

  factory PersonalGoal.fromMap(Map<String, dynamic> map) {
    return PersonalGoal(
      map['id'],
      List<SubGoal>.from(map['subGoals']?.map((x) => SubGoal.fromMap(x))),
      map['title'],
      map['rewardClassCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalGoal.fromJson(String source) =>
      PersonalGoal.fromMap(json.decode(source));
}
