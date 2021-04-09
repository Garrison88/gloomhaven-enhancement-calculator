import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/gloomhaven_companion.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences prefs;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // prefs = await SharedPreferences.getInstance();
  await SharedPrefs().init();
  // SharedPreferences.getInstance().then((_prefs) {
  // prefs = _prefs;
  AppModel appModel = AppModel(
    SharedPrefs().themeColor,
    SharedPrefs().envelopeX,
  );
  //   ..pageController =
  //       PageController(initialPage: prefs.getInt('position') ?? 0)
  // ..position = prefs.getInt('position') ?? 0
  // ..accentColor =
  // ..envelopeX = ;
  runApp(
    EasyDynamicThemeWidget(
      child: ChangeNotifierProvider.value(
        value: appModel,
        child: GloomhavenCompanion(),
      ),
    ),
  );
  // });
}

// retrieveAppState() async {
//   var _prefs = await SharedPreferences.getInstance();

// }

// PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
// final PageStorageBucket bucket = new PageStorageBucket();
