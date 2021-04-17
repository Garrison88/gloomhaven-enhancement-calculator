import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
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
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Gloomhaven Companion',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            ).then((_) => setState(() {})),
          )
        ],
      ),
      body: PageView(
        children: [
          ChangeNotifierProvider<CharactersModel>(
            create: (context) => CharactersModel(),
            child: CharactersScreen(),
          ),
          EnhancementCalculatorPage()
        ],
        controller: _pageController,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: smallPadding),
              child: Icon(FontAwesomeIcons.scroll),
            ),
            title: Text(
              'CHARACTERS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: smallPadding),
                child: Icon(FontAwesomeIcons.calculator),
              ),
              title: Text(
                'CALCULATOR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
