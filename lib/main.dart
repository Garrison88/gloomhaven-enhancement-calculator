import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'gloomhaven_companion.dart';
import 'shared_prefs.dart';

bool includeFrosthaven = false;
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
