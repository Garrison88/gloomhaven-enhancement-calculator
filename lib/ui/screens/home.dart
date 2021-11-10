import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
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
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _page = 0;
  CharactersModel _charactersModel;
  double _navBarPadding;

  void _navigationTapped(int page) {
    // _notifier.value = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  // @override
  // void initState() {
  //   super.initState();

  //   _charactersModel = CharactersModel(
  //     context,
  //     hideRetireCharacterAnimationController: AnimationController(
  //       vsync: this,
  //       duration: kThemeAnimationDuration,
  //     )..forward(),
  //     pageController: PageController(
  //       initialPage: SharedPrefs().initialPage,
  //     ),
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
    Provider.of<CharactersModel>(context, listen: false)
        .hideRetireCharacterAnimationController
        .dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD HOME');
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(
        //   value: _charactersModel,
        // ),
        ChangeNotifierProvider(
          create: (_) => CharactersModel(
            context,
            hideRetireCharacterAnimationController: AnimationController(
              vsync: this,
              duration: kThemeAnimationDuration,
            )..forward(),
            pageController: PageController(
              initialPage: SharedPrefs().initialPage,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => EnhancementCalculatorModel(),
        )
      ],
      child: Builder(
        builder: (BuildContext context) {
          print('STATEFUL BUILDER HOME');
          CharactersModel charactersModel = context.watch<CharactersModel>();
          EnhancementCalculatorModel enhancementCalculatorModel =
              context.read<EnhancementCalculatorModel>();
          return Scaffold(
            // resizeToAvoidBottomInset: false,
            extendBody: true,
            appBar: AppBar(
              bottom: _page == 0 && charactersModel.characters.length > 1
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
                  ScaleTransition(
                    scale:
                        charactersModel.hideRetireCharacterAnimationController,
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
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () async {
                          await charactersModel.retireCurrentCharacter();
                        },
                      ),
                    ),
                  ),
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
                                  await charactersModel
                                      .deleteCurrentCharacter();
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
                                      Theme.of(context)
                                          .colorScheme
                                          .secondary) ==
                                  Brightness.dark ||
                              Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    // icon: SvgPicture.asset(
                    //   'images/class_icons/tinkerer.svg',
                    //   width: 20,
                    //   height: 20,
                    //   color: ThemeData.estimateBrightnessForColor(
                    //                   Theme.of(context)
                    //                       .colorScheme
                    //                       .secondary) ==
                    //               Brightness.dark ||
                    //           Theme.of(context).brightness == Brightness.dark
                    //       ? Colors.white
                    //       : Colors.black,
                    // ),
                    onPressed: () async {
                      int index = charactersModel.characters.indexOf(
                        charactersModel.currentCharacter,
                      );
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            charactersModel: charactersModel,
                            enhancementCalculatorModel:
                                enhancementCalculatorModel,
                            updateTheme: () =>
                                charactersModel.setCurrentCharacter(
                              index: index,
                            ),
                          ),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            body: PageView(
              children: [
                CharactersScreen(),
                EnhancementCalculatorPage(),
              ],
              controller: _pageController,
              onPageChanged: (index) => setState(() {
                charactersModel.isEditMode = false;
                _page = index;
              }),
            ),
            floatingActionButtonLocation:
                // MediaQuery.of(context).viewInsets.bottom == 0.0
                //     ? FloatingActionButtonLocation.centerDocked
                // :
                FloatingActionButtonLocation.endDocked,
            floatingActionButton:
                // AnimatedSwitcher(
                // duration: const Duration(milliseconds: 300),
                // transitionBuilder: (
                //   Widget child,
                //   Animation<double> animation,
                // ) {
                // final TweenSequence<double> _tweenSequence = TweenSequence([
                //   TweenSequenceItem(
                //     tween: Tween(
                //       begin: 1.0,
                //       end: 1.1,
                //     ),
                //     weight: 1,
                //   ),
                //   TweenSequenceItem(
                //     tween: Tween(
                //       begin: 1.1,
                //       end: 1.0,
                //     ),
                //     weight: 1,
                //   ),
                // ]);
                // final Tween<double> _angle = Tween(
                //   begin: 0 / 180,
                //   end: -90 / 180,
                // );
                //   return RotationTransition(
                //     turns: charactersModel.isEditMode
                //         ? _angle.animate(
                //             animation,
                //           )
                //         : _angle.animate(
                //             ReverseAnimation(animation),
                //           ),
                //     alignment: Alignment.center,
                //     child: ScaleTransition(
                //       scale: _tweenSequence.animate(animation),
                //       child: child,
                //     ),
                //   );
                // },
                // child:
                FloatingActionButton(
              // mini: MediaQuery.of(context).viewInsets.bottom != 0.0,
              heroTag: null,
              key: UniqueKey(),
              child: Icon(
                _page == 1
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
              onPressed: _page == 1
                  ? () => enhancementCalculatorModel.resetCost()
                  : charactersModel.characters.isEmpty
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
            // bottomNavigationBar: BottomNavigationBar(
            //   items: const [
            //     BottomNavigationBarItem(
            //       icon: Icon(
            //         Icons.history_edu,
            //       ),
            //       label: 'CHARACTERS',
            //       activeIcon: Icon(
            //         Icons.history_edu,
            //         size: 30,
            //       ),
            //     ),
            //     BottomNavigationBarItem(
            //         icon: Icon(
            //           Icons.auto_awesome_outlined,
            //         ),
            //         label: 'ENHANCEMENTS',
            //         activeIcon: Icon(
            //           Icons.auto_awesome,
            //           size: 30,
            //         )),
            //   ],
            //   onTap: _navigationTapped,
            //   currentIndex: _page,
            // ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  SizedBox(width: 56),
                  Expanded(
                    child: NavigationBar(
                      backgroundColor: Colors.transparent,
                      selectedIndex: _page,
                      onDestinationSelected: _navigationTapped,
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
                  SizedBox(width: 56),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
