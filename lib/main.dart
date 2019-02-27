import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/ui/bottom_nav.dart';
import 'package:gloomhaven_enhancement_calc/ui/character_sheet_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/enhancement_calculator_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sp;

void main() async {
  sp = await SharedPreferences.getInstance();
  PlayerClass _selectedClass =
      sp.getInt('selectedClass') != null && classList != null
          ? classList[sp.getInt('selectedClass')]
          : null;
  runApp(DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
            accentColor:
                _selectedClass != null ? _selectedClass.color : Color(0xff4e7ec1),
            primarySwatch: Colors.brown,
            brightness: brightness,
            // Define the default Font Family
            fontFamily: 'PirataOne',

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              // DropDownButton text
              subhead: TextStyle(fontSize: 23.0),
              // Text widgets
              body1: TextStyle(fontSize: 23.0, letterSpacing: 0.7),
            ),
          ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Enhancement Calculator',
          routes: <String, WidgetBuilder>{
            '/enhancementCalculatorPage': (BuildContext context) =>
                EnhancementCalculatorPage(),
//            '/noCharacterPage': (BuildContext context) => NoCharacterPage(),
            '/characterSheetPage': (BuildContext context) =>
                CharacterSheetPage()
          },
          theme: theme,
          home: BottomNav(),
        );
      }));
}

PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
final PageStorageBucket bucket = new PageStorageBucket();
