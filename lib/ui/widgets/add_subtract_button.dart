import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddSubtractButton extends StatelessWidget {
  AddSubtractButton({this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext context) => InkWell(
          child: Center(
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.minus,
                  color: Theme.of(context).accentColor,
                  size: 15,
                ),
                Text(
                  '/',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Icon(
                  FontAwesomeIcons.plus,
                  color: Theme.of(context).accentColor,
                  size: 15,
                ),
              ],
            ),
          ),
          onTap: onTap,
        
      );
}
