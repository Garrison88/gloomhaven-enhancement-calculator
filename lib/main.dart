import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/gloomhaven_companion.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  // SharedPreferences.getInstance().then((prefs) {
  AppModel appModel = AppModel()
    //   ..pageController =
    //       PageController(initialPage: prefs.getInt('position') ?? 0)
    // ..position = prefs.getInt('position') ?? 0
    ..accentColor = prefs.getString('themeColor') ?? '0xff4e7ec1'
    ..envelopeX = prefs.getBool('envelope_x') ?? false;
  runApp(
    ChangeNotifierProvider<AppModel>(
      create: (_) => appModel,
      child: App(),
    ),
  );
  // });
}

// retrieveAppState() async {
//   var _prefs = await SharedPreferences.getInstance();

// }

PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
final PageStorageBucket bucket = new PageStorageBucket();
