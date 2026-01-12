import 'dart:io';

import 'package:device_region/device_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/home.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init();

  if (SharedPrefs().clearSharedPrefs) {
    SharedPrefs().removeAll();
    SharedPrefs().clearSharedPrefs = false;
  }
  SharedPrefs().showUpdate4Dialog = false;

  if (Platform.isAndroid) {
    try {
      final region = await DeviceRegion.getSIMCountryCode().timeout(
        const Duration(seconds: 3),
      );
      SharedPrefs().isUSRegion = region?.toUpperCase() == 'US';
    } catch (e) {
      // If region detection fails, default to false
      SharedPrefs().isUSRegion = false;
    }
  }

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: SharedPrefs().darkTheme
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: SharedPrefs().darkTheme
          ? const Color(0xff1c1b1f)
          : Colors.white,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        // ThemeProvider must come first
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            initialSeedColor: Color(SharedPrefs().primaryClassColor),
            initialDarkMode: SharedPrefs().darkTheme,
            initialDefaultFonts: SharedPrefs().useDefaultFonts,
          ),
        ),
        ChangeNotifierProvider(create: (_) => AppModel()),
        ChangeNotifierProvider(create: (_) => EnhancementCalculatorModel()),
        ChangeNotifierProxyProvider<ThemeProvider, CharactersModel>(
          create: (context) => CharactersModel(
            showRetired: SharedPrefs().showRetiredCharacters,
            databaseHelper: DatabaseHelper.instance,
            themeProvider: context.read<ThemeProvider>(),
          ),
          update: (context, themeProvider, previousCharactersModel) {
            return previousCharactersModel!;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = context.watch<ThemeProvider>();
          return AnimatedBuilder(
            animation: themeProvider,
            builder: (context, child) {
              return MaterialApp(
                title: Platform.isIOS
                    ? 'Gloomhaven Utility'
                    : 'Gloomhaven Companion',
                home: const Home(),
                themeMode: themeProvider.themeMode,
                darkTheme: themeProvider.darkTheme,
                theme: themeProvider.lightTheme,
                themeAnimationDuration: const Duration(milliseconds: 500),
                themeAnimationCurve: Curves.easeInOut,
              );
            },
          );
        },
      ),
    ),
  );
}
