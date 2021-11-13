import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
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

class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('BUILD HOME');

    CharactersModel charactersModel = context.read<CharactersModel>();
    EnhancementCalculatorModel enhancementCalculatorModel =
        context.read<EnhancementCalculatorModel>();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
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
                      dotColor: Theme.of(context).brightness == Brightness.dark
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
                              : charactersModel.currentCharacter.isRetired
                                  ? Colors.white
                                  : Color(
                                      int.parse(SharedPrefs().themeColor),
                                    ),
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
            Tooltip(
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
                  await charactersModel.retireCurrentCharacter();
                },
              ),
            ),
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
                    : ThemeData.estimateBrightnessForColor(
                                    Theme.of(context).colorScheme.secondary) ==
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
                                onPressed: () => Navigator.pop(context, false),
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
                            await charactersModel.deleteCurrentCharacter();
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
                int index = charactersModel.characters.indexOf(
                  charactersModel.currentCharacter,
                );
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                      charactersModel: charactersModel,
                      enhancementCalculatorModel: enhancementCalculatorModel,
                      updateTheme: () => charactersModel.setCurrentCharacter(
                        index: index,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: PageView(
        children: const [
          CharactersScreen(),
          EnhancementCalculatorPage(),
        ],
        controller: context.read<AppModel>().pageController,
        onPageChanged: (index) {
          charactersModel.isEditMode = false;
          context.read<AppModel>().page = index;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
        ) {
          final TweenSequence<double> _tweenSequence = TweenSequence([
            TweenSequenceItem(
              tween: Tween(
                begin: 1.0,
                end: 1.1,
              ),
              weight: 1,
            ),
            TweenSequenceItem(
              tween: Tween(
                begin: 1.1,
                end: 1.0,
              ),
              weight: 1,
            ),
          ]);
          final Tween<double> _angle = Tween(
            begin: 0 / 180,
            end: -90 / 180,
          );
          return RotationTransition(
            turns: charactersModel.isEditMode
                ? _angle.animate(
                    animation,
                  )
                : _angle.animate(
                    ReverseAnimation(animation),
                  ),
            alignment: Alignment.center,
            child: ScaleTransition(
              scale: _tweenSequence.animate(animation),
              child: child,
            ),
          );
        },
        child: FloatingActionButton(
          // mini: MediaQuery.of(context).viewInsets.bottom != 0.0,
          heroTag: null,
          key: UniqueKey(),
          child: Transform.rotate(
            angle:
                context.watch<CharactersModel>().isEditMode ? math.pi / 2 : 0,
            child: Icon(
              context.read<AppModel>().page == 1
                  ? Icons.clear
                  : context.watch<CharactersModel>().characters.isEmpty
                      ? Icons.add
                      : context.watch<CharactersModel>().isEditMode
                          ? Icons.edit_off_outlined
                          : Icons.edit_outlined,
              color: ThemeData.estimateBrightnessForColor(
                          Theme.of(context).colorScheme.secondary) ==
                      Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          onPressed: context.watch<AppModel>().page == 1
              ? () => context.read<EnhancementCalculatorModel>().resetCost()
              : context.watch<CharactersModel>().characters.isEmpty
                  ? () async => await showDialog<void>(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          return CreateCharacterDialog(
                            charactersModel: context.watch<CharactersModel>(),
                          );
                        },
                      )
                  : () => charactersModel.toggleEditMode(),
        ),
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
                selectedIndex: context.watch<AppModel>().page,
                onDestinationSelected: (int page) {
                  context.read<AppModel>().page = page;
                  context.read<AppModel>().pageController.animateToPage(
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
