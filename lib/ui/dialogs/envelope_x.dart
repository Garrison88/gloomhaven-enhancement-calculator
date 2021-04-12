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
              'Major Spoilers Ahead!',
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
            "${widget.isOpen ? 'Open' : 'Close'} 'Envelope X'?",
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
            ),
          ),
        ),
        !widget.isOpen
            ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  widget.onChanged(widget.isOpen);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                ),
              )
            : ElevatedButton.icon(
                icon: Icon(
                  Icons.warning,
                  color: Colors.black,
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.yellow),
                ),
                onPressed: () {
                  widget.onChanged(widget.isOpen);
                  Navigator.of(context).pop();
                },
                label: Text(
                  'Save',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.black),
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
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
