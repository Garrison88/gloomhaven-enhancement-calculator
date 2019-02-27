import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/ui/character_sheet_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/enhancement_calculator_page.dart';
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
  void navigationTapped(int page) {
    // Animating to the page
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
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
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
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
                      style: TextStyle(
                          fontFamily: secondaryFontFamily, fontSize: 20.0),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: PageView(
            children: [EnhancementCalculatorPage(), CharacterSheetPage()],
            controller: pageController,
            onPageChanged: onPageChanged),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), title: Text('ENHANCEMENT CALCULATOR')),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.location_on), title: Text('CHARACTER SHEET')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('CHARACTER SHEET'))
        ], onTap: navigationTapped, currentIndex: page));
  }
}
