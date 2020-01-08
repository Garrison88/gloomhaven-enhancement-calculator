import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/gloomhavenCompanion.dart';
import 'package:gloomhaven_enhancement_calc/view_model/app_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sp;

main() async {
  // Stetho.initialize();
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  SharedPreferences.getInstance().then((prefs) {
    var _position = prefs.getInt('position') ?? 0;
    Color _accentColor =
        Color(int.parse(prefs.getString('themeColor') ?? '0xff4e7ec1'));
    runApp(
      ChangeNotifierProvider<AppModel>(
        create: (_) => AppModel(_position, _accentColor),
        child: GloomhavenCompanion(),
      ),
    );
  });
}

PageStorageKey enhancementKey = new PageStorageKey('enhancementKey');
final PageStorageBucket bucket = new PageStorageBucket();
