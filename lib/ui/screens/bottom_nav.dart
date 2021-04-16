import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/envelope_x.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/settings_screen.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characters_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancement_calculator_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // List<Character> characterList = [];
  DatabaseHelper db = DatabaseHelper.instance;
  PageController _pageController = PageController();

  int _page = 0;

  // void toggleTheme(bool value) {
  //   // setState(() => theme = value);
  //   SharedPrefs().darkTheme = value;
  //   EasyDynamicTheme.of(context).changeTheme(dynamic: true);
  // }

  void _navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void handleClick(Widget choice) {
    if (choice.runtimeType == Text) {
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

  Future<void> _envelopeXDialog() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => EnvelopeXDialog(),
    ).then((value) {
      if (value == null) {
        return;
      }
      SharedPrefs().envelopeX = value;
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'images/class_icons/bladeswarm.png',
                  color: SharedPrefs().darkTheme ? Colors.white : Colors.black,
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
          // PopupMenuButton<Widget>(
          //   onSelected: handleClick,
          //   itemBuilder: (_) {
          //     return {
          //       Text('Envelope X'),
          //       ThemeSwitch(
          //           onChanged: toggleTheme, value: SharedPrefs().darkTheme),
          //       ImagesSwitch(
          //           onChanged: (value) => SharedPrefs().showPerkImages = value,
          //           value: SharedPrefs().showPerkImages),
          //     }.map((Widget choice) {
          //       return PopupMenuItem<Widget>(
          //         value: choice,
          //         child: Container(child: choice),
          //       );
          //     }).toList();
          //   },
          // ),
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
        currentIndex: _page,
      ),
    );
  }
}

// class ThemeSwitch extends StatefulWidget {
//   final Function onChanged;
//   final bool value;

//   const ThemeSwitch({
//     this.onChanged,
//     this.value,
//   });
//   @override
//   _ThemeSwitchState createState() => _ThemeSwitchState();
// }

// class _ThemeSwitchState extends State<ThemeSwitch> {
//   bool _value;
//   initState() {
//     super.initState();
//     _value = widget.value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80.0,
//       child: FlutterSwitch(
//         width: 72.0,
//         height: 40.0,
//         toggleSize: 36.0,
//         value: _value,
//         borderRadius: 32.0,
//         padding: 3.0,
//         activeToggleColor: Colors.white70,
//         inactiveToggleColor: Colors.white,
//         activeColor: Colors.black45,
//         inactiveColor: Colors.black26,
//         activeIcon: Image.asset('images/elem_dark.png'),
//         inactiveIcon: Image.asset('images/elem_light.png'),
//         onToggle: (value) {
//           _value = value;
//           setState(() {
//             widget.onChanged(value);
//           });
//         },
//       ),
//     );
//   }
// }

class ImagesSwitch extends StatefulWidget {
  final Function onChanged;
  final bool value;

  const ImagesSwitch({
    this.onChanged,
    this.value,
  });
  @override
  _ImagesSwitchState createState() => _ImagesSwitchState();
}

class _ImagesSwitchState extends State<ImagesSwitch> {
  bool _value;
  initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.grey,
          thickness: 1,
        ),
        Text('Show Perk Icons?'),
        Switch(
          value: _value,
          onChanged: (value) {
            _value = value;
            setState(() {
              widget.onChanged(value);
            });
          },
        ),
      ],
    );
  }
}
