import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../data/constants.dart';
import '../../models/character.dart';
import '../../viewmodels/app_model.dart';
import '../../viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../viewmodels/characters_model.dart';
import '../dialogs/create_character_dialog.dart';
import 'characters_screen.dart';
import 'enhancement_calculator_page.dart';
import 'settings_screen.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Future<List<Character>> future;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();

    context.read<CharactersModel>().hideRetireCharacterAnimationController =
        AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      reverseDuration: kThemeAnimationDuration,
    )..forward();
    future = context.read<CharactersModel>().loadCharacters();
  }

  @override
  void didChangeDependencies() {
    FlutterStatusbarcolor.setNavigationBarColor(
      Theme.of(context).colorScheme.surface,
    );
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(
      Theme.of(context).brightness == Brightness.dark,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final enhancementCalculatorModel =
        context.read<EnhancementCalculatorModel>();
    final appModel = context.read<AppModel>();
    final charactersModel = context.read<CharactersModel>();
    return Scaffold(
      extendBody: true,
      key: scaffoldMessengerKey,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : ThemeData.estimateBrightnessForColor(
                              Theme.of(context).colorScheme.secondary) ==
                          Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
          statusBarBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.dark
              : ThemeData.estimateBrightnessForColor(
                          Theme.of(context).colorScheme.secondary) ==
                      Brightness.dark
                  ? Brightness.dark
                  : Brightness.light,
          statusBarColor: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.secondary,
        ),
        centerTitle: true,
        // must watch
        title: context.watch<AppModel>().page == 0 &&
                charactersModel.characters.length > 1
            ? SmoothPageIndicator(
                controller: charactersModel.pageController,
                count: charactersModel.characters.length,
                effect: ScrollingDotsEffect(
                  dotColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey
                      : ThemeData.estimateBrightnessForColor(
                                  Theme.of(context).colorScheme.secondary) ==
                              Brightness.dark
                          ? Colors.grey[400]
                          : Colors.black45,
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Theme.of(context).brightness ==
                          Brightness.light
                      ? ThemeData.estimateBrightnessForColor(
                                  Theme.of(context).colorScheme.secondary) ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black
                      : Colors.white,
                ),
              )
            : context.watch<AppModel>().page == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/titles/gloomhaven.png', scale: 7),
                      Switch(
                        inactiveThumbColor: const Color(0xff4b2c20),
                        inactiveTrackColor: const Color(0xffa98274),
                        activeColor: const Color(0xff005cb2),
                        activeTrackColor: const Color(0xff6ab7ff),
                        value: !SharedPrefs().gloomhavenEnhancementCosts,
                        onChanged: (value) {
                          SharedPrefs().gloomhavenEnhancementCosts = !value;
                          Provider.of<EnhancementCalculatorModel>(context,
                                  listen: false)
                              .gameVersionToggled(value);
                          // SharedPrefs().gloomhavenEnhancementCosts = !value;
                          // Provider.of<EnhancementCalculatorModel>(context,
                          //         listen: false)
                          //     .calculateCost();
                          setState(() {});
                        },
                      ),
                      Image.asset('images/titles/frosthaven.png', scale: 7),

                      // ToggleSwitch(
                      //   activeFgColor: ThemeData.estimateBrightnessForColor(
                      //               Theme.of(context).colorScheme.secondary) ==
                      //           Brightness.dark
                      //       ? Colors.white
                      //       : Colors.black,
                      //   borderWidth: 1,
                      //   borderColor: [
                      //     SharedPrefs().darkTheme
                      //         ? Colors.transparent
                      //         : Colors.grey[700]
                      //   ],
                      //   activeBgColor: [
                      //     Color(
                      //       int.parse(
                      //         SharedPrefs().themeColor,
                      //       ),
                      //     )
                      //   ],
                      //   inactiveBgColor: Colors.grey,
                      //   inactiveFgColor: Colors.grey[900],
                      //   minWidth: 100,
                      //   minHeight: 30,
                      //   cornerRadius: 30,
                      //   initialLabelIndex:
                      //       SharedPrefs().gloomhavenEnhancementCosts ? 0 : 1,
                      //   totalSwitches: 2,
                      //   // labels: const [
                      //   //   'Gloomhaven',
                      //   //   'Frosthaven',
                      //   // ],

                      //   customIcons: [
                      //     // Icon(
                      //     //   Image.asset('images/titles/gloomhaven.png'),
                      //     // ),
                      //   ],
                      //   animate: true,
                      //   animationDuration: 250,
                      //   curve: Curves.easeIn,
                      //   onToggle: (index) {
                      //     setState(() {
                      //       SharedPrefs().gloomhavenEnhancementCosts =
                      //           index == 0;
                      //       Provider.of<EnhancementCalculatorModel>(context,
                      //               listen: false)
                      //           .calculateCost();
                      //     });
                      //   },
                      // ),
                    ],
                  )
                : null,
        actions: <Widget>[
          if (charactersModel.isEditMode)
            ScaleTransition(
              scale: charactersModel.hideRetireCharacterAnimationController,
              child: Tooltip(
                message: charactersModel.currentCharacter.isRetired
                    ? 'Unretire'
                    : 'Retire',
                child: IconButton(
                  icon: Icon(
                    charactersModel.currentCharacter.isRetired
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                    color: ThemeData.estimateBrightnessForColor(
                                    Theme.of(context).colorScheme.secondary) ==
                                Brightness.dark ||
                            Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () async {
                    final String message =
                        '${charactersModel.currentCharacter.name} ${charactersModel.currentCharacter.isRetired ? 'unretired' : 'retired'}';
                    int index = await charactersModel.retireCurrentCharacter();
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(message),
                          action: charactersModel.showRetired
                              ? null
                              : SnackBarAction(
                                  label: 'Show',
                                  onPressed: () {
                                    charactersModel.toggleShowRetired(
                                        index: index);
                                  },
                                ),
                        ),
                      );
                  },
                ),
              ),
            ),
          if (appModel.page == 0)
            Tooltip(
              message: charactersModel.isEditMode ? 'Delete' : 'New Character',
              child: IconButton(
                icon: Icon(
                  charactersModel.isEditMode
                      ? Icons.delete_outlined
                      : Icons.person_add_outlined,
                  color: charactersModel.isEditMode &&
                          Theme.of(context).brightness == Brightness.dark
                      ? Colors.red[400]
                      : ThemeData.estimateBrightnessForColor(Theme.of(context)
                                      .colorScheme
                                      .secondary) ==
                                  Brightness.dark ||
                              Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
                onPressed: charactersModel.isEditMode
                    ? () {
                        showDialog<bool>(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: const Text(
                                'Are you sure? This cannot be undone',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Cancel',
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red[400]),
                                  ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ).then(
                          (result) async {
                            if (result) {
                              final String characterName =
                                  charactersModel.currentCharacter.name;
                              await charactersModel.deleteCurrentCharacter();
                              ScaffoldMessenger.of(context)
                                ..clearSnackBars()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text('$characterName deleted'),
                                  ),
                                );
                            }
                          },
                        );
                      }
                    : () async {
                        await showDialog<bool>(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return CreateCharacterDialog(
                              charactersModel: charactersModel,
                            );
                          },
                        );
                      },
              ),
            ),
          Tooltip(
            message: 'Settings',
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: ThemeData.estimateBrightnessForColor(
                                Theme.of(context).colorScheme.secondary) ==
                            Brightness.dark ||
                        Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () async {
                if (charactersModel.isEditMode) {
                  charactersModel.toggleEditMode();
                }
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                      // must watch
                      charactersModel: context.watch<CharactersModel>(),
                      enhancementCalculatorModel: enhancementCalculatorModel,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: PageView(
        children: [
          FutureBuilder<List<Character>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return const CharactersScreen();
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Text('Please wait...'),
                        SizedBox(height: smallPadding),
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
              }),
          const EnhancementCalculatorPage(),
        ],
        controller: appModel.pageController,
        onPageChanged: (index) {
          charactersModel.isEditMode = false;
          appModel.page = index;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        mini: MediaQuery.of(context).viewInsets.bottom != 0.0,
        heroTag: null,
        child: Icon(
          appModel.page == 1
              ? Icons.clear
              : charactersModel.characters.isEmpty
                  ? Icons.add
                  : charactersModel.isEditMode
                      ? Icons.edit_off_outlined
                      : Icons.edit_outlined,
          color: ThemeData.estimateBrightnessForColor(
                      Theme.of(context).colorScheme.secondary) ==
                  Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        onPressed: appModel.page == 1
            ? () => enhancementCalculatorModel.resetCost()
            // must watch
            : context.watch<CharactersModel>().characters.isEmpty
                ? () async => await showDialog<void>(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return CreateCharacterDialog(
                          charactersModel: charactersModel,
                        );
                      },
                    )
                : () => charactersModel.toggleEditMode(),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width / 6),
            Expanded(
              child: NavigationBar(
                backgroundColor: Colors.transparent,
                selectedIndex: appModel.page,
                onDestinationSelected: (int page) {
                  appModel.page = page;
                  appModel.pageController.animateToPage(
                    page,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.history_edu_outlined),
                      label: 'CHARACTERS'),
                  NavigationDestination(
                      icon: Icon(Icons.auto_awesome_outlined),
                      label: 'ENHANCEMENTS'),
                ],
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width / 6),
          ],
        ),
      ),
    );
  }
}
