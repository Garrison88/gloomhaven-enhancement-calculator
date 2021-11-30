import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../viewmodels/characters_model.dart';
import '../dialogs/create_character_dialog.dart';
import 'characters_screen.dart';
import 'enhancement_calculator_page.dart';
import 'settings_screen.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Future<List<Character>> future;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
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
  Widget build(BuildContext context) {
    print('BUILD HOME');

    EnhancementCalculatorModel enhancementCalculatorModel =
        context.read<EnhancementCalculatorModel>();
    AppModel appModel = context.read<AppModel>();
    return Builder(
      builder: (context) {
        CharactersModel charactersModel = context.read<CharactersModel>();
        return Scaffold(
          extendBody: true,
          key: scaffoldMessengerKey,
          appBar: AppBar(
            // must watch
            bottom: context.watch<AppModel>().page == 0 &&
                    charactersModel.characters.length > 1
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(28),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: SmoothPageIndicator(
                        controller: charactersModel.pageController,
                        count: charactersModel.characters.length,
                        effect: ScrollingDotsEffect(
                          dotColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey
                                  : ThemeData.estimateBrightnessForColor(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary) ==
                                          Brightness.dark
                                      ? Colors.grey[400]
                                      : Colors.black45,
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? ThemeData.estimateBrightnessForColor(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary) ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.white,
                        ),
                      ),
                    ),
                  )
                : null,
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                'Gloomhaven Companion',
                style: TextStyle(
                  fontSize: 25.0,
                  color: ThemeData.estimateBrightnessForColor(
                                  Theme.of(context).colorScheme.secondary) ==
                              Brightness.dark ||
                          Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
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
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary) ==
                                    Brightness.dark ||
                                Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () async {
                        final String message =
                            '${charactersModel.currentCharacter.name} ${charactersModel.currentCharacter.isRetired ? 'unretired' : 'retired'}';
                        await charactersModel.retireCurrentCharacter();
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(message),
                              action: charactersModel.showRetired
                                  ? null
                                  : SnackBarAction(
                                      label: 'Show',
                                      onPressed: () =>
                                          charactersModel.toggleShowRetired(),
                                    ),
                            ),
                          );
                      },
                    ),
                  ),
                ),
              // ScaleTransition(
              //   scale: charactersModel.toggleAddDeleteAnimationController,
              //   child:
              if (appModel.page == 0)
                Tooltip(
                  message:
                      charactersModel.isEditMode ? 'Delete' : 'New Character',
                  child: IconButton(
                    icon: Icon(
                      charactersModel.isEditMode
                          ? Icons.delete_outlined
                          : Icons.person_add_outlined,
                      color: charactersModel.isEditMode &&
                              Theme.of(context).brightness == Brightness.dark
                          ? Colors.red[400]
                          : ThemeData.estimateBrightnessForColor(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary) ==
                                      Brightness.dark ||
                                  Theme.of(context).brightness ==
                                      Brightness.dark
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
                                      onPressed: () =>
                                          Navigator.pop(context, true),
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
                                  await charactersModel
                                      .deleteCurrentCharacter();
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
              // ),
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
                          enhancementCalculatorModel:
                              enhancementCalculatorModel,
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
          floatingActionButton:
              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 300),
              //   transitionBuilder: (
              //     Widget child,
              //     Animation<double> animation,
              //   ) {
              //     final TweenSequence<double> _tweenSequence = TweenSequence(
              //       [
              //         TweenSequenceItem(
              //           tween: Tween(
              //             begin: 1.0,
              //             end: 1.1,
              //           ),
              //           weight: 1,
              //         ),
              //         TweenSequenceItem(
              //           tween: Tween(
              //             begin: 1.1,
              //             end: 1.0,
              //           ),
              //           weight: 1,
              //         ),
              //       ],
              //     );
              //     final Tween<double> _angle = Tween(
              //       begin: 0 / 180,
              //       end: -90 / 180,
              //     );
              //     return RotationTransition(
              //       turns: charactersModel.isEditMode
              //           ? _angle.animate(
              //               animation,
              //             )
              //           : _angle.animate(
              //               ReverseAnimation(animation),
              //             ),
              //       alignment: Alignment.center,
              //       child: ScaleTransition(
              //         scale: _tweenSequence.animate(animation),
              //         child: child,
              //       ),
              //     );
              //   },
              //   child:
              FloatingActionButton(
            mini: MediaQuery.of(context).viewInsets.bottom != 0.0,
            heroTag: null,
            // key: UniqueKey(),
            child:
                // Transform.rotate(
                //   angle: charactersModel.isEditMode ? math.pi / 1 : 0,
                //   child:
                Icon(
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
            // ),
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
          // ),
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
      },
    );
  }
}
