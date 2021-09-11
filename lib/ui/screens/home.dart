import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
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

class HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int _page = 0;

  void _navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onPageChanged(int page) {
    setState(() {
      Provider.of<CharactersModel>(context, listen: false).isEditMode = false;
      _page = page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = Provider.of<CharactersModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
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
        actions: <Widget>[
          if (_page == 0)
            Provider.of<CharactersModel>(context).isEditMode
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
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
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: const Text(
                                'Are you sure? There\'s no going back!',
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
                                            Colors.red),
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
                          }).then((result) async {
                        if (result) {
                          await charactersModel.deleteCharacter(
                            context,
                            charactersModel.currentCharacter.uuid,
                          );
                        }
                      });
                    },
                  )
                : IconButton(
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
          IconButton(
            icon: Icon(
              Icons.settings,
              color: ThemeData.estimateBrightnessForColor(
                              Theme.of(context).colorScheme.secondary) ==
                          Brightness.dark ||
                      Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: smallPadding),
              child: Icon(FontAwesomeIcons.scroll),
            ),
            label: 'CHARACTERS',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: smallPadding),
              child: Icon(FontAwesomeIcons.calculator),
            ),
            label: 'CALCULATOR',
          ),
        ],
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
