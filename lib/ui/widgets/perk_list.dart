import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character_perk.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';

class PerkList extends StatefulWidget {
  final List<CharacterPerk> perkList;

  PerkList({Key key, this.perkList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PerkListState();
}

class PerkListState extends State<PerkList> {
  List<CharacterPerk> _perkList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _perkList = widget.perkList;
    });
  }

  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 1,
      childAspectRatio: 5,
      children: List.generate(
        _perkList.length,
        (index) => PerkRow(
          characterPerk: _perkList[index],
        ),
      ),
    )
    ;
  }
}
