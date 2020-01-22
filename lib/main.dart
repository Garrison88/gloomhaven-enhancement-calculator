import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/app.dart';
import 'package:gloomhaven_enhancement_calc/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sp;

main() async {
  // Sqflite.devSetDebugModeOn(true);
  // Stetho.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  SharedPreferences.getInstance().then((prefs) {
    var _position = prefs.getInt('position') ?? 0;
    Color _accentColor =
        Color(int.parse(prefs.getString('themeColor') ?? '0xff4e7ec1'));
    runApp(
      ChangeNotifierProvider<AppState>(
        create: (_) => AppState(_position, _accentColor),
        child: App(),
      ),
    );
  });
}

// retrieveAppState() async {
//   var _prefs = await SharedPreferences.getInstance();

// }

PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
final PageStorageBucket bucket = new PageStorageBucket();
