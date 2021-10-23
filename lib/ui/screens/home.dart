import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int _page = 0;

  void _navigationTapped(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  // void _onPageChanged(int page) {

  // }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharactersModel(context),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          CharactersModel charactersModel = context.watch<CharactersModel>();
          return Scaffold(
            // key: _scaffoldKey,
            appBar: AppBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
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
              ),
              actions: <IconButton>[
                // if (_page == 0)
                //   if (charactersModel.isEditMode)
                //     IconButton(
                //       tooltip: charactersModel.currentCharacter.isRetired
                //           ? 'Unretire'
                //           : 'Retire',
                //       icon: Icon(
                //         charactersModel.currentCharacter.isRetired
                //             ? Icons.directions_walk
                //             : Icons.elderly,
                //         color: ThemeData.estimateBrightnessForColor(
                //                         Theme.of(context).colorScheme.secondary) ==
                //                     Brightness.dark ||
                //                 Theme.of(context).brightness == Brightness.dark
                //             ? Colors.white
                //             : Colors.black,
                //       ),
                //       onPressed: () async {
                //         final String retiredCharactersName =
                //             charactersModel.currentCharacter.name;
                //         final bool retiredCharacterIsRetired =
                //             charactersModel.currentCharacter.isRetired;
                //         await charactersModel.retireCurrentCharacter(
                //           context,
                //         );
                //         // charactersModel.updateTheme(context);
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(
                //             content: Text(
                //                 '$retiredCharactersName ${retiredCharacterIsRetired ? 'unretired' : 'retired'}'),
                //             action: charactersModel.showRetired
                //                 ? null
                //                 : SnackBarAction(
                //                     label: 'Show',
                //                     onPressed: () {
                //                       // int index =
                //                       //     charactersModel.indexOfCurrentCharacter;
                //                       // setState(() {
                //                       //   charactersModel.showRetired = true;
                //                       //   charactersModel.setCurrentCharacter(context,
                //                       //       index: index);
                //                       //   // ..updateTheme(context);
                //                       // });
                //                     }),
                //           ),
                //         );
                //       },
                //     ),
                if (_page == 0 && !charactersModel.isEditMode)
                  // ? IconButton(
                  //     icon: Icon(
                  //       Icons.delete,
                  //       color: ThemeData.estimateBrightnessForColor(
                  //                       Theme.of(context).colorScheme.secondary) ==
                  //                   Brightness.dark ||
                  //               Theme.of(context).brightness == Brightness.dark
                  //           ? Colors.white
                  //           : Colors.black,
                  //     ),
                  //     onPressed: () {
                  //       showDialog<bool>(
                  //         context: context,
                  //         builder: (_) {
                  //           return AlertDialog(
                  //             content: const Text(
                  //               'Are you sure? This cannot be undone',
                  //             ),
                  //             actions: <Widget>[
                  //               TextButton(
                  //                 child: const Text(
                  //                   'Cancel',
                  //                 ),
                  //                 onPressed: () => Navigator.pop(context, false),
                  //               ),
                  //               ElevatedButton(
                  //                 style: ButtonStyle(
                  //                   backgroundColor:
                  //                       MaterialStateProperty.all<Color>(
                  //                           Colors.red),
                  //                 ),
                  //                 onPressed: () => Navigator.pop(context, true),
                  //                 child: const Text(
                  //                   'Delete',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               )
                  //             ],
                  //           );
                  //         },
                  //       ).then(
                  //         (result) async {
                  //           if (result) {
                  //             await charactersModel.deleteCurrentCharacter(
                  //               context,
                  //             );
                  //           }
                  //         },
                  //       );
                  //     },
                  //   )
                  // :
                  IconButton(
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
                  icon: SvgPicture.asset(
                    'images/class_icons/tinkerer.svg',
                    width: 20,
                    height: 20,
                    color: ThemeData.estimateBrightnessForColor(
                                    Theme.of(context).colorScheme.secondary) ==
                                Brightness.dark ||
                            Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () async {
                    // charactersModel.isEditMode = false;
                    int index = charactersModel.characters
                        .indexOf(charactersModel.currentCharacter);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          charactersModel: charactersModel,
                          updateTheme: () {
                            charactersModel.setCurrentCharacter(
                              // context,
                              index: index,
                            );
                          },
                        ),
                      ),
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
              onPageChanged: (index) {
                setState(() {
                  charactersModel
                    ..isEditMode = false
                    ..isDialOpen.value = false;
                  _page = index;
                });
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history_edu,
                  ),
                  label: 'CHARACTERS',
                  activeIcon: Icon(
                    Icons.history_edu,
                    size: 30,
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.auto_awesome_outlined,
                    ),
                    label: 'ENHANCEMENTS',
                    activeIcon: Icon(
                      Icons.auto_awesome,
                      size: 30,
                    )),
              ],
              onTap: _navigationTapped,
              currentIndex: _page,
            ),
          );
        },
      ),
    );
    // CharactersModel charactersModel = context.watch<CharactersModel>();
  }
}
