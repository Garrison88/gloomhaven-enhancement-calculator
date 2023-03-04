import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/utils/app_theme.dart';
import 'viewmodels/app_model.dart';
import 'viewmodels/characters_model.dart';
import 'viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';
import 'shared_prefs.dart';
import 'ui/screens/home.dart';

class GloomhavenCompanion extends StatelessWidget {
  const GloomhavenCompanion({
    Key key,
  }) : super(key: key);

  Color getThemeColor() => Color(
        int.parse(
          SharedPrefs().themeColor,
        ),
      );

  Color getSwitchThumbColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected) ? getThemeColor() : null;

  Color getSwitchTrackColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? getThemeColor().withOpacity(0.5)
          : null;

  Color getCheckboxColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected) ? getThemeColor() : null;

  Color getCheckColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected) ? Colors.black87 : null;

  @override
  Widget build(BuildContext context) {
    final appModel = context.watch<AppModel>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      home: MultiProvider(
        providers: [
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
        child: const Home(),
      ),
      themeMode: appModel.themeMode,
      darkTheme: AppTheme.darkTheme.copyWith(
        buttonTheme: AppTheme.darkTheme.buttonTheme.copyWith(
          buttonColor: getThemeColor(),
        ),
        iconTheme: AppTheme.darkTheme.iconTheme.copyWith(
          color: getThemeColor(),
        ),
        floatingActionButtonTheme:
            AppTheme.darkTheme.floatingActionButtonTheme.copyWith(
          backgroundColor: getThemeColor(),
        ),
        colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
          primary: getThemeColor(),
          secondary: getThemeColor(),
          tertiary: getThemeColor(),
          surfaceTint: getThemeColor(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            getCheckboxColor,
          ),
          checkColor: MaterialStateProperty.resolveWith(
            getCheckColor,
          ),
        ),
        switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.resolveWith(
            getSwitchTrackColor,
          ),
          thumbColor: MaterialStateProperty.resolveWith(
            getSwitchThumbColor,
          ),
        ),
        chipTheme: ChipThemeData(
          selectedColor: getThemeColor(),
        ),
      ),
      theme: AppTheme.lightTheme.copyWith(
        bottomNavigationBarTheme:
            AppTheme.lightTheme.bottomNavigationBarTheme.copyWith(
          backgroundColor: Colors.white,
        ),
        iconTheme: AppTheme.lightTheme.iconTheme.copyWith(
          color: getThemeColor(),
        ),
        floatingActionButtonTheme:
            AppTheme.lightTheme.floatingActionButtonTheme.copyWith(
          backgroundColor: getThemeColor(),
        ),
        primaryColor: getThemeColor(),
        colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
          primary: getThemeColor(),
          secondary: getThemeColor(),
          tertiary: getThemeColor(),
          surfaceTint: getThemeColor(),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            getCheckboxColor,
          ),
        ),
        switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.resolveWith(
            getSwitchTrackColor,
          ),
          thumbColor: MaterialStateProperty.resolveWith(
            getSwitchThumbColor,
          ),
        ),
        chipTheme: ChipThemeData(
          selectedColor: getThemeColor(),
        ),
      ),
    );
  }
}
