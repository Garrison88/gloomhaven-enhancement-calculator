import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:provider/provider.dart';
import 'gloomhaven_companion.dart';
import 'shared_prefs.dart';

bool includeFrosthaven = true;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  if (SharedPrefs().clearSharedPrefs) {
    SharedPrefs().removeAll();
    SharedPrefs().clearSharedPrefs = false;
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppModel(
        PageController(),
        SharedPrefs().darkTheme ? ThemeMode.dark : ThemeMode.light,
      ),
      child: const GloomhavenCompanion(),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarIconBrightness:
          SharedPrefs().darkTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: SharedPrefs().darkTheme
          ? Color(
              int.parse(
                '0xff424242',
              ),
            )
          : Colors.white,
    ),
  );
}
