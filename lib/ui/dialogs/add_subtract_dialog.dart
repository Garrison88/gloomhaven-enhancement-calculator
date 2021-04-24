import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';

class AddSubtractDialog extends StatelessWidget {
  AddSubtractDialog(
    this.currentValue,
    this.hintText,
  );

  final int currentValue;
  final String hintText;
  final TextEditingController _addSubtractTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          padding: EdgeInsets.only(top: smallPadding, bottom: smallPadding),
          child: Row(
            children: <Widget>[
              Expanded(
                child: IconButton(
                    icon: Icon(FontAwesomeIcons.minus),
                    onPressed: () => Navigator.pop(
                          context,
                          currentValue -
                              int.parse(_addSubtractTextEditingController.text),
                        )),
              ),
              Expanded(
                child: TextField(
                  enableInteractiveSelection: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp('[\\.|\\,|\\ |\\-]'))
                  ],
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(hintText: hintText),
                  controller: _addSubtractTextEditingController,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: titleFontSize,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.plus),
                  onPressed: () => Navigator.pop(
                    context,
                    currentValue +
                        int.parse(_addSubtractTextEditingController.text),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
