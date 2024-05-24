import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/home.dart';
import 'package:gloomhaven_enhancement_calc/utils/app_theme.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();
  if (SharedPrefs().clearSharedPrefs) {
    SharedPrefs().removeAll();
    SharedPrefs().clearSharedPrefs = false;
  }
  SharedPrefs().showUpdate4Dialog = false;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarIconBrightness:
          SharedPrefs().darkTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: SharedPrefs().darkTheme
          ? const Color(
              0xff1c1b1f, //0xff121212
            )
          : Colors.white,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => EnhancementCalculatorModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CharactersModel(
            showRetired: SharedPrefs().showRetiredCharacters,
            databaseHelper: DatabaseHelper.instance,
          ),
        )
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title:
                Platform.isIOS ? 'Gloomhaven Utility' : 'Gloomhaven Companion',
            home: const Home(),
            themeMode: context.watch<AppModel>().themeMode,
            darkTheme: AppTheme.darkTheme(),
            theme: AppTheme.lightTheme(),
          );
        },
      ),
    ),
  );
}
