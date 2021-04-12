import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/envelope_x.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characters_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancement_calculator_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNav extends StatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Character> characterList = [];
  DatabaseHelper db = DatabaseHelper.instance;
  PageController pageController = PageController();
  int page = 0;

  void _navigationTapped(int page) {
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
    } else if (_choice == 'Envelope X') {
      _envelopeXDialog();
    }
  }

  void _launchUrl() async {
    if (await canLaunch(Strings.devWebsiteUrl)) {
      await launch(Strings.devWebsiteUrl);
    } else {
      throw 'Could not launch ${Strings.devWebsiteUrl}';
    }
  }

  void _envelopeXDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => EnvelopeXDialog(
              isOpen: SharedPrefs().envelopeX,
              onChanged: (bool value) {
                SharedPrefs().envelopeX = value;
                if (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'images/class_icons/bladeswarm.png',
                            color: Colors.white,
                          ),
                          Text(
                            'Bladeswarm Unlocked!',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontFamily: nyala,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ));
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Gloomhaven Companion',
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: nyala,
          ),
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
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                );
              }).toList();
            },
          ),
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
        controller: pageController,
        onPageChanged: _onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.scroll),
              title: Text(
                'CHARACTER\nSHEETS',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calculator),
              title: Text(
                'ENHANCEMENT\nCALCULATOR',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
        onTap: _navigationTapped,
        currentIndex: page,
      ),
      // ),
    );
  }
}
