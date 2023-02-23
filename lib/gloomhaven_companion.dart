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
  Color getSwitchThumbColor(Set<MaterialState> states) =>
      states.contains(MaterialState.selected)
          ? Color(
              int.parse(
                SharedPrefs().themeColor,
              ),
            ).withOpacity(
              SharedPrefs().darkTheme ? 0.75 : 1,
            )
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
            ).withOpacity(
              SharedPrefs().darkTheme ? 0.75 : 1,
            )
          : null;

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
              // context,
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
          buttonColor: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
        iconTheme: AppTheme.darkTheme.iconTheme.copyWith(
          color: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
        floatingActionButtonTheme:
            AppTheme.darkTheme.floatingActionButtonTheme.copyWith(
          backgroundColor: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
        colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
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
          tertiary: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
          surfaceTint: Colors.white54,
        ),
        navigationBarTheme: AppTheme.darkTheme.navigationBarTheme.copyWith(
          elevation: 0,
          indicatorColor: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ).withOpacity(.25),
          backgroundColor: Color(
            int.parse(
              '0xff424242',
            ),
          ),
        ),
        appBarTheme: AppTheme.darkTheme.appBarTheme.copyWith(
          color: AppTheme.darkTheme.scaffoldBackgroundColor,
        ),
        // iconTheme: AppTheme.darkTheme.iconTheme.copyWith(
        //   color: Color(
        //     int.parse(
        //       SharedPrefs().themeColor,
        //     ),
        //   ),
        // ),
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
          selectedColor: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
      ),
      theme: AppTheme.lightTheme.copyWith(
        iconTheme: AppTheme.darkTheme.iconTheme.copyWith(
          color: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
        floatingActionButtonTheme:
            AppTheme.lightTheme.floatingActionButtonTheme.copyWith(
                backgroundColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        )),
        primaryColor: Color(
          int.parse(
            SharedPrefs().themeColor,
          ),
        ),
        colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
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
          tertiary: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
          surfaceTint: AppTheme.lightTheme.brightness == Brightness.dark
              ? Colors.white54
              : Colors.black54,
        ),
        navigationBarTheme: AppTheme.lightTheme.navigationBarTheme.copyWith(
          elevation: 0,
          indicatorColor: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ).withOpacity(.25),
          // backgroundColor: AppTheme.lightTheme.brightness == Brightness.dark
          //     ? Color(
          //         int.parse(
          //           '0xff424242',
          //         ),
          //       )
          //     : Colors.white,
        ),
        appBarTheme: AppTheme.lightTheme.appBarTheme.copyWith(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
        ),
        // iconTheme: AppTheme.lightTheme.iconTheme.copyWith(
        //   color: Color(
        //     int.parse(
        //       SharedPrefs().themeColor,
        //     ),
        //   ),
        // ),
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
          selectedColor: Color(
            int.parse(
              SharedPrefs().themeColor,
            ),
          ),
        ),
      ),
    );
  }
}
