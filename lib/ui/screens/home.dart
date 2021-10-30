import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
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
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _page = 0;
  CharactersModel _charactersModel;

  void _navigationTapped(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _charactersModel = CharactersModel(
      context,
      hideAddCharacterAnimationController:
          AnimationController(vsync: this, duration: kThemeAnimationDuration)
            ..forward(),
      pageController: PageController(
        initialPage: SharedPrefs().initialPage,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<CharactersModel>(context, listen: false)
        .hideAddCharacterAnimationController
        .dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _charactersModel,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          CharactersModel charactersModel = context.watch<CharactersModel>();
          return Scaffold(
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
                            dotColor: SharedPrefs().darkTheme
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
                            activeDotColor: !SharedPrefs().darkTheme
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
                ScaleTransition(
                  scale: charactersModel.hideAddCharacterAnimationController,
                  child: IconButton(
                    icon: Icon(
                      Icons.person_add,
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
                IconButton(
                  icon: SvgPicture.asset(
                    'images/class_icons/tinkerer.svg',
                    width: 20,
                    height: 20,
                    color: ThemeData.estimateBrightnessForColor(
                                    Theme.of(context).colorScheme.secondary) ==
                                Brightness.dark ||
                            Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () async {
                    int index = charactersModel.characters
                        .indexOf(charactersModel.currentCharacter);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          charactersModel: charactersModel,
                          updateTheme: () {
                            charactersModel.setCurrentCharacter(
                              index: index,
                            );
                          },
                        ),
                      ),
                    );
                    setState(() {});
                  },
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
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history_edu,
                  ),
                  label: 'CHARACTERS',
                  activeIcon: Icon(
                    Icons.history_edu,
                    size: 30,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.auto_awesome_outlined,
                    ),
                    label: 'ENHANCEMENTS',
                    activeIcon: Icon(
                      Icons.auto_awesome,
                      size: 30,
                    )),
              ],
              onTap: _navigationTapped,
              currentIndex: _page,
            ),
          );
        },
      ),
    );
  }
}
