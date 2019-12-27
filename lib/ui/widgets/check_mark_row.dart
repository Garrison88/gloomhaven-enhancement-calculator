import 'package:flutter/material.dart';

class CheckMarkRow extends StatefulWidget {
  final int index;

  CheckMarkRow(this.index);

  @override
  _CheckMarkRowState createState() => _CheckMarkRowState();
}

class _CheckMarkRowState extends State<CheckMarkRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      child: Row(
        mainAxisAlignment: (widget.index % 2) == 0
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: <Widget>[
          Checkbox(
            value: false,
            onChanged: (bool value) => setState(() {
              value = true;
            }),
          ),
          Checkbox(
            value: false,
            onChanged: (bool value) => setState(() {
              value = value;
            }),
          ),
          Checkbox(
            value: false,
            onChanged: (bool value) => setState(() {
              value = value;
            }),
          )
        ],
      ),
    );
  }
}
