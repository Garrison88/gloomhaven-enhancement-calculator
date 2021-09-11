import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'viewmodels/characters_model.dart';
import 'package:provider/provider.dart';
import 'gloomhaven_companion.dart';
import 'shared_prefs.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  if (SharedPrefs().clearSharedPrefs) {
    SharedPrefs().removeAll();
    SharedPrefs().clearSharedPrefs = false;
  }
  runApp(
    Phoenix(
      child: EasyDynamicThemeWidget(
        child: ChangeNotifierProvider(
          child: GloomhavenCompanion(),
          create: (context) => CharactersModel(),
        ),
      ),
    ),
  );
}
