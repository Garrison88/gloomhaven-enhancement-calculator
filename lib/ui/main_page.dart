import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/ui/enhancements.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
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
        appBar: AppBar(
            title:
                Text('Gloomhaven Companion', style: TextStyle(fontSize: 25.0))),
        body: EnhancementsPage());
//        body: PageView(children: [
//          EnhancementsPage(),
////          Container(color: Colors.green),
//          CharacterSheetPage()
//        ], controller: pageController, onPageChanged: onPageChanged),
//        bottomNavigationBar: BottomNavigationBar(items: [
//          BottomNavigationBarItem(
//              icon: Icon(Icons.add), title: Text('ENHANCEMENTS')),
////          BottomNavigationBarItem(
////              icon: Icon(Icons.location_on), title: Text('CHARACTER SHEET')),
//          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('MORE'))
//        ], onTap: navigationTapped, currentIndex: page));
  }
}
