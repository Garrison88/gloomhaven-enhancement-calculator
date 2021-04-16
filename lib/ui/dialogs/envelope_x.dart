import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class EnvelopeXDialog extends StatefulWidget {
  @override
  _EnvelopeXDialogState createState() => _EnvelopeXDialogState();
}

class _EnvelopeXDialogState extends State<EnvelopeXDialog> {
  bool isOpen = SharedPrefs().envelopeX;

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
            "${isOpen ? 'Open' : 'Close'} 'Envelope X'?",
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                visible: !isOpen,
                child: Icon(Icons.mail),
              ),
              Switch(
                value: isOpen,
                onChanged: (value) => setState(
                  () => isOpen = value,
                ),
              ),
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                visible: isOpen,
                child: Icon(Icons.drafts),
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: secondaryFontSize,
            ),
          ),
        ),
        !isOpen
            ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () => Navigator.pop(context, false),
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
                onPressed: () => Navigator.pop(context, true),
                label: Text(
                  'Save',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.black),
                ),
              ),
      ],
    );
  }
}
