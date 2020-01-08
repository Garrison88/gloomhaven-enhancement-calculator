import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/config/provider.dart';
import 'package:gloomhaven_enhancement_calc/core/constants/app_constants.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/router.dart';
import 'package:gloomhaven_enhancement_calc/view_model/app_model.dart';
import 'package:gloomhaven_enhancement_calc/view_model/characterList_model.dart';
import 'package:gloomhaven_enhancement_calc/view_model/characterPerks_model.dart';
import 'package:gloomhaven_enhancement_calc/view_model/character_model.dart';
import 'package:provider/provider.dart';

class GloomhavenCompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppModel>(context);
    return MultiProvider(
        providers: [
          Provider<CharacterListModel>(
            create: (_) => CharacterListModel(),
          ),
          Provider<CharacterModel>(
            create: (_) => CharacterModel(),
          ),
          Provider<CharacterPerksModel>(
            create: (_) => CharacterPerksModel(),
          )
        ],
        child: MaterialApp(
          title: 'Gloomhaven Companion',
          initialRoute: RoutePaths.Home,
          onGenerateRoute: Router.generateRoute,
          // routes: {
          //   RoutePaths.: (context) => BottomNav(),
          //   '/enhancementCalculator': (context) =>
          //       EnhancementCalculatorPage(),
          //   '/characterSheetPage': (context) => CharacterSheetPage(),
          //   '/characterDetailsPage': (context) => CharacterPage()
          // },
          theme: ThemeData(
              accentColor: appState.accentColor,
              //     ? Color(int.parse(_selectedClass.classColor))
              //     : Color(0xff4e7ec1),
              primaryColor: appState.accentColor,
              // brightness: brightness,
              // Define the default Font Family
              fontFamily: 'PirataOne',

              // Define the default TextTheme. Use this to specify the default
              // text styling for headlines, titles, bodies of text, and more.
              textTheme: TextTheme(
                // DropDownButton text
                subhead: TextStyle(fontSize: 23.0),
                // Text widgets
                body1: TextStyle(fontSize: 23.0, letterSpacing: 0.7),
              )),
          // )
        ));
  }
}
