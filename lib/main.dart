import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/gloomhaven_companion.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  if (SharedPrefs().clearSharedPrefs) {
    SharedPrefs().removeAll();
    SharedPrefs().clearSharedPrefs = false;
  }
  runApp(
    EasyDynamicThemeWidget(
      child: GloomhavenCompanion(),
    ),
  );
}
