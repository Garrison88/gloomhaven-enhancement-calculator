import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnvelopeXDialog extends StatefulWidget {
  bool isOpen;
  final Function onChanged;
  EnvelopeXDialog({
    bool isOpen,
    Function onChanged,
  })  : this.isOpen = isOpen,
        this.onChanged = onChanged;
  @override
  _EnvelopeXDialogState createState() => _EnvelopeXDialogState();
}

class _EnvelopeXDialogState extends State<EnvelopeXDialog> {
  // bool isOpen = false;

  // Future<bool> getSwitchState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool('envelope_x');
  // }

  _toggleSwitch(bool _value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.isOpen = _value;
    });
    return prefs.setBool('envelope_x', _value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: smallPadding),
          ),
          Icon(
            Icons.warning,
            size: iconHeight,
          ),
          Padding(
            padding: EdgeInsets.only(right: smallPadding),
          ),
          Expanded(
            child: Text(
              "Major Spoilers Ahead!",
              style: TextStyle(fontSize: secondaryFontSize),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: smallPadding),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Open 'Envelope X'?",
            style: TextStyle(fontFamily: nyala),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                visible: !widget.isOpen,
                child: Icon(Icons.mail),
              ),
              // Text(
              //   'Close',
              //   style: TextStyle(fontFamily: nyala),
              // ),
              Switch(
                value: widget.isOpen,
                onChanged: (value) => _toggleSwitch(value),
              ),
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                visible: widget.isOpen,
                child: Icon(Icons.drafts),
              ),
              // Text(
              //   'Open',
              //   style: TextStyle(fontFamily: nyala),
              // ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: secondaryFontSize,
              fontFamily: highTower,
            ),
          ),
        ),
        !widget.isOpen
            ? RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  widget.onChanged(widget.isOpen);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: secondaryFontSize,
                    fontFamily: highTower,
                  ),
                ),
              )
            : RaisedButton.icon(
                icon: Icon(Icons.warning),
                color: Colors.yellow,
                onPressed: () {
                  widget.onChanged(widget.isOpen);
                  Navigator.of(context).pop();
                },
                label: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: secondaryFontSize,
                    fontFamily: highTower,
                  ),
                ),
              ),
        // RaisedButton(
        //   color: Colors.yellow,
        //   onPressed: () async {
        //     SharedPreferences prefs = await SharedPreferences.getInstance();
        //     prefs
        //         .setBool('envelope_x', true)
        //         .then((_) => Navigator.of(context).pop());
        //   },
        //   child: Text(
        //     'Yes!',
        //     style: TextStyle(
        //       fontSize: secondaryFontSize,
        //       fontFamily: highTower,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
      ],
    );
    //   } else {
    //     return Container();
    //   }
    // });
  }
}
