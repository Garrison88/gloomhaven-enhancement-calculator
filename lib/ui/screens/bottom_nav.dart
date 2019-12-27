import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_list_state.dart';
import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/character_list_page.dart';
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
              ChangeNotifierProvider<CharacterListState>(
                builder: (context) => CharacterListState(),
              ),
              // ChangeNotifierProvider<CharacterState>(
              //   builder: (context) => CharacterState(),
              // ),
            ],
            child: CharacterListPage(),
          ),
          EnhancementCalculatorPage()
        ], controller: pageController, onPageChanged: _onPageChanged),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              title: Text(
                'CHARACTER\nSHEETS',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: highTower, fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
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
