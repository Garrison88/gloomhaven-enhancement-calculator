import 'package:flutter/material.dart';
import 'package:gloomhaven_companion/data/constants.dart';
import 'package:gloomhaven_companion/models/item.dart';

class GridItem extends StatefulWidget {
  final Item item;

  GridItem(this.item);

  @override
  State<StatefulWidget> createState() => GridItemState();
}

class GridItemState extends State<GridItem> {
  Item _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.withOpacity(0.75),
        height: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Text('${_item.name}'),
            ),
            Image.asset(
              'images/equipment_slots/${_item.slot.icon}',
              width: iconWidth,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
//              widget.onDelete(_item);
              },
            )
          ],
        ));
  }
}
