import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/gloomhaven_companion.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sp;

main() async {
  // Sqflite.devSetDebugModeOn(true);
  // Stetho.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  SharedPreferences.getInstance().then((prefs) {
    int _position = prefs.getInt('position') ?? 0;
    Color _accentColor =
        Color(int.parse(prefs.getString('themeColor') ?? '0xff4e7ec1'));
    bool _envelopeX = prefs.getBool('envelope_x') ?? false;
    runApp(
      ChangeNotifierProvider<AppModel>(
        create: (_) => AppModel(_position, _accentColor, _envelopeX),
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
