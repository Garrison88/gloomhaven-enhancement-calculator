import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement_model.dart';

class EnhancementDropDownItem extends StatefulWidget {
  final Enhancement enhancement;

  EnhancementDropDownItem(this.enhancement);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EnhancementDropDownItemState(enhancement);
  }
}

class EnhancementDropDownItemState extends State<EnhancementDropDownItem> {
  Enhancement enhancement;

  EnhancementDropDownItemState(this.enhancement);

  @override
  Widget build(BuildContext context) {
    return enhancement.isSubtitle
        ? DropdownMenuItem(
            child: Center(
                child: Text(enhancement.name,
                    style: TextStyle(
                        fontFamily: 'PirataOne',
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold))),
            value: enhancement.cost)
        : DropdownMenuItem(
            child: Row(
              children: <Widget>[
                Image.asset('images/' + enhancement.icon, width: iconWidth),
                Text(
                    ' ' +
                        enhancement.name +
                        ' (' +
                        enhancement.cost.toString() +
                        'g)',
                    style: TextStyle(fontFamily: secondaryFontFamily))
              ],
            ),
            value: enhancement.cost);
  }
}
