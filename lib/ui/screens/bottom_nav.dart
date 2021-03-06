import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/create_character_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/settings_screen.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characters_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancement_calculator_page.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
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
        title: const Text(
          'Gloomhaven Companion',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
        actions: <Widget>[
          if (_page == 0)
            Provider.of<CharactersModel>(context).isEditMode
                ? IconButton(
                    icon: const Icon(
                      Icons.delete,
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
                            charactersModel.currentCharacter.id,
                          );
                        }
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.person_add),
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
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            ).then((_) => setState(() {})),
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
