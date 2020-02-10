import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characterList_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/character_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characterList_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancement_calculator_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNav extends StatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomNavState();
  }
}

class BottomNavState extends State<BottomNav> {
  List<Character> characterList = [];
  DatabaseHelper db = DatabaseHelper.instance;
  PageController pageController = PageController();
  int page = 0;

  /// Called when the user presses on of the
  /// [BottomNavigationBarItem] with corresponding
  /// page index
  void _navigationTapped(int page) {
    // Animating to the page
    pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onPageChanged(int page) {
    setState(() {
      this.page = page;
    });
  }

  void _menuItemSelected(String _choice) {
    if (_choice == 'Developer Website') {
      _launchUrl();
    }
  }

  void _launchUrl() async {
    if (await canLaunch(Strings.devWebsiteUrl)) {
      await launch(Strings.devWebsiteUrl);
    } else {
      throw 'Could not launch ${Strings.devWebsiteUrl}';
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   pageController = PageController();
  //   db.queryAllRows().then((characters) {
  //     setState(() {
  //       characters.forEach((character) {
  //         characterList.add(Character.fromMap(character));
  //         print("*************** BOTTOM NAV ONINIT RAN - CHARACTERS QUERIED: " + character.toString());
  //       });
  //     });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Gloomhaven Companion',
            style: TextStyle(fontSize: 25.0),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _menuItemSelected,
              itemBuilder: (BuildContext context) {
                return Strings.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(fontFamily: highTower, fontSize: 20.0),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: PageView(children: [
          MultiProvider(
            providers: [
              ChangeNotifierProvider<CharacterListModel>(
                create: (context) => CharacterListModel(),
              ),
              ChangeNotifierProvider<CharacterModel>.value(
                value: CharacterModel(),
              ),
            ],
            child: CharacterListPage(),
          ),
          EnhancementCalculatorPage()
        ], controller: pageController, onPageChanged: _onPageChanged),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.scroll),
              title: Text(
                'CHARACTER\nSHEETS',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: highTower, fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calculator),
              title: Text(
                'ENHANCEMENT\nCALCULATOR',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: highTower, fontWeight: FontWeight.bold),
              )),
        ], onTap: _navigationTapped, currentIndex: page));
  }
}