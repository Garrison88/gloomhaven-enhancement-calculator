import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/ui/enhancements.dart';

void main() => runApp(MaterialApp(
    title: 'Enhancement Calculator',
    theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
        primaryColor: Colors.brown,
        accentColor: Colors.blueGrey,

        // Define the default Font Family
        fontFamily: 'PirataOne',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          // DropDownButton text
          subhead: TextStyle(fontSize: 23.0),
          // Text widgets
          body1: TextStyle(fontSize: 23.0),
        )),
    home: EnhancementsPage()));
PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
final PageStorageBucket bucket = new PageStorageBucket();
