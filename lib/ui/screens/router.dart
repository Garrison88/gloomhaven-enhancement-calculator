import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/core/constants/app_constants.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/bottom_nav.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancementCalculator_page.dart';
import 'package:gloomhaven_enhancement_calc/view_model/character_model.dart';
import 'package:provider/provider.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (context) => BottomNav());
        break;

      case RoutePaths.EnhancementCalculator:
        return MaterialPageRoute(builder: (context) {
          return EnhancementCalculatorPage();
        });
        break;

      case RoutePaths.Character:
        return MaterialPageRoute(builder: (context) {
          return ChangeNotifierProvider<CharacterModel>(
              create: (context) => CharacterModel(),
              child: CharacterPage());
        });
        break;

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No route defined for ${settings.name}')),
                  ),
                ));
    }
  }
}
