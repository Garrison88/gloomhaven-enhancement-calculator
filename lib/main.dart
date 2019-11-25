import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/providers/characters_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/character_sheet_list_data.dart';
import 'models/player_class.dart';
import 'ui/screens/bottom_nav.dart';
import 'ui/screens/character_sheet_page.dart';
import 'ui/screens/enhancement_calculator_page.dart';

SharedPreferences sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  PlayerClass _selectedClass =
      sp.getInt('selectedClass') != null && classList != null
          ? classList[sp.getInt('selectedClass')]
          : classList[0];
  runApp(DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
            accentColor: _selectedClass != null
                ? Color(int.parse(_selectedClass.classColor))
                : Color(0xff4e7ec1),
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
          title: 'Gloomhaven Companion',
          initialRoute: '/',
          routes: {
            '/': (context) => ChangeNotifierProvider<CharactersState>(
              builder: (_) => CharactersState(), child: BottomNav()),
            '/enhancementCalculatorPage': (context) => EnhancementCalculatorPage(),
            '/'
            '/characterSheetPage': (context) => CharacterSheetPage()
          },
          theme: theme,
        );
      }));
}

PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
final PageStorageBucket bucket = new PageStorageBucket();
