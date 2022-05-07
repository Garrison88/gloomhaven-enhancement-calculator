import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'viewmodels/app_model.dart';
import 'viewmodels/characters_model.dart';
import 'viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';
import 'data/constants.dart';
import 'shared_prefs.dart';
import 'ui/screens/home.dart';

class GloomhavenCompanion extends StatelessWidget {
  const GloomhavenCompanion({
    Key key,
  }) : super(key: key);

  Color getSwitchThumbColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? Color(
              int.parse(
                SharedPrefs().themeColor,
              ),
            ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1)
          : null;

  Color getSwitchTrackColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? Color(
              int.parse(
                SharedPrefs().themeColor,
              ),
            ).withOpacity(0.5)
          : null;

  Color getCheckboxColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? Color(
              int.parse(
                SharedPrefs().themeColor,
              ),
            ).withOpacity(SharedPrefs().darkTheme ? 0.75 : 1)
          : null;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      // removes splash animation from InkWell on bottom app bar navigation destination
      splashFactory: NoSplash.splashFactory,

      fontFamily: highTower,
      textTheme: TextTheme(
        button: const TextStyle(fontSize: 20),
        subtitle1: const TextStyle(
          fontSize: 23.0,
        ),
        subtitle2: const TextStyle(
          fontSize: 15.0,
        ),
        bodyText2: const TextStyle(
          fontSize: 25.0,
          letterSpacing: 0.7,
          fontFamily: nyala,
        ),
        headline1: TextStyle(
          fontFamily: pirataOne,
          color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
        ),
        headline3: TextStyle(
          fontFamily: pirataOne,
          color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
          letterSpacing: 2.0,
        ),
        headline4: TextStyle(
          fontFamily: pirataOne,
          color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
          letterSpacing: 2.0,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontFamily: highTower,
          fontSize: 20,
          color: SharedPrefs().darkTheme ? Colors.black : Colors.white,
        ),
      ),
      brightness: SharedPrefs().darkTheme ? Brightness.dark : Brightness.light,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gloomhaven Companion',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => EnhancementCalculatorModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => AppModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => CharactersModel(
              context,
              pageController: PageController(
                initialPage: SharedPrefs().initialPage,
              ),
              showRetired: SharedPrefs().showRetiredCharacters,
            ),
          )
        ],
        child: const Home(),
      ),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      theme: theme.copyWith(
        iconTheme: IconThemeData(
          color: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
        colorScheme: theme.colorScheme.copyWith(
          primary: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
          secondary: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
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
      ),
    );
  }
}
