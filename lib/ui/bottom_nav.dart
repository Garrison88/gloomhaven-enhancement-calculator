import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_companion/data/constants.dart';
import 'package:gloomhaven_companion/data/strings.dart';
import 'package:gloomhaven_companion/ui/character_sheet_page.dart';
import 'package:gloomhaven_companion/ui/enhancement_calculator_page.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNav extends StatefulWidget {
  BottomNav({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomNavState();
  }
}

class BottomNavState extends State<BottomNav> {
  PageController pageController;
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

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
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
        body: PageView(
            children: [CharacterSheetPage(), EnhancementCalculatorPage()],
            controller: pageController,
            onPageChanged: _onPageChanged),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.content_paste),
              title: AutoSizeText(
                'CHARACTER\nSHEET',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: highTower, fontWeight: FontWeight.bold),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              title: AutoSizeText(
                'ENHANCEMENT\nCALCULATOR',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: highTower, fontWeight: FontWeight.bold),
              )),
        ], onTap: _navigationTapped, currentIndex: page));
  }
}
