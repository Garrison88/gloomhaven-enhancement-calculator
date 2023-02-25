import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/create_character_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/settings_screen.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GHCAppBar extends StatefulWidget implements PreferredSizeWidget {
  const GHCAppBar({
    Key key,
  }) : super(
          key: key,
        );

  @override
  State<GHCAppBar> createState() => _GHCAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _GHCAppBarState extends State<GHCAppBar> {
  @override
  void initState() {
    context
        .read<CharactersModel>()
        .enhancementCalcScrollController
        .addListener(_enhancementCalcScrollListener);
    context
        .read<CharactersModel>()
        .charScreenScrollController
        .addListener(_charScreenScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    context.read<CharactersModel>().charScreenScrollController.dispose();
    context.read<CharactersModel>().enhancementCalcScrollController.dispose();
    super.dispose();
  }

  _charScreenScrollListener() {
    ScrollController scrollController =
        context.read<CharactersModel>().charScreenScrollController;
    if (scrollController.hasClients &&
        scrollController.positions.length == 1 &&
        scrollController.offset <= scrollController.position.minScrollExtent) {
      //call setState only when values are about to change
      if (!context.read<CharactersModel>().isScrolledToTop) {
        setState(() {
          //reach the top
          context.read<CharactersModel>().isScrolledToTop = true;
        });
      }
    } else {
      //call setState only when values are about to change
      if (context.read<CharactersModel>().isScrolledToTop) {
        setState(() {
          //not the top
          context.read<CharactersModel>().isScrolledToTop = false;
        });
      }
    }
  }

  _enhancementCalcScrollListener() {
    ScrollController scrollController =
        context.read<CharactersModel>().enhancementCalcScrollController;
    if (scrollController.hasClients &&
        scrollController.positions.length == 1 &&
        scrollController.offset <= scrollController.position.minScrollExtent) {
      //call setState only when values are about to change
      if (!context.read<CharactersModel>().isScrolledToTop) {
        setState(() {
          //reach the top
          context.read<CharactersModel>().isScrolledToTop = true;
        });
      }
    } else {
      //call setState only when values are about to change
      if (context.read<CharactersModel>().isScrolledToTop) {
        setState(() {
          //not the top
          context.read<CharactersModel>().isScrolledToTop = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final enhancementCalculatorModel =
        context.read<EnhancementCalculatorModel>();
    final appModel = context.read<AppModel>();
    final charactersModel = context.watch<CharactersModel>();
    return AppBar(
      elevation: charactersModel.isScrolledToTop ? 0 : 4,
      centerTitle: true,
      title: context.watch<AppModel>().page == 0 &&
              charactersModel.characters.length > 1
          ? SmoothPageIndicator(
              controller: charactersModel.pageController,
              count: charactersModel.characters.length,
              effect: ScrollingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            )
          : context.watch<AppModel>().page == 1 && includeFrosthaven
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/titles/gloomhaven.png',
                      scale: 7,
                    ),
                    Switch(
                      inactiveThumbColor: const Color(0xff4b2c20),
                      inactiveTrackColor: const Color(0xffa98274),
                      activeColor: const Color(0xff005cb2),
                      activeTrackColor: const Color(0xff6ab7ff),
                      value: !SharedPrefs().gloomhavenMode,
                      onChanged: (value) {
                        SharedPrefs().gloomhavenMode = !value;
                        Provider.of<EnhancementCalculatorModel>(context,
                                listen: false)
                            .gameVersionToggled(value);
                        setState(() {});
                      },
                    ),
                    Image.asset(
                      'images/titles/frosthaven.png',
                      scale: 7,
                    ),
                  ],
                )
              : Container(),
      actions: <Widget>[
        if (charactersModel.isEditMode)
          // ScaleTransition(
          //   scale: charactersModel.hideRetireCharacterAnimationController,
          // child:
          Tooltip(
            message: charactersModel.currentCharacter.isRetired
                ? 'Unretire'
                : 'Retire',
            child: IconButton(
              icon: Icon(
                charactersModel.currentCharacter.isRetired
                    ? Icons.unarchive_outlined
                    : Icons.archive_outlined,
              ),
              onPressed: () async {
                final String message =
                    '${charactersModel.currentCharacter.name} ${charactersModel.currentCharacter.isRetired ? 'unretired' : 'retired'}';
                // int index =
                await charactersModel.retireCurrentCharacter();
                context.read<AppModel>().updateTheme();
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(message),
                      action: charactersModel.showRetired
                          ? null
                          : SnackBarAction(
                              label: 'Show',
                              onPressed: () {
                                charactersModel.toggleShowRetired(
                                  index: charactersModel.characters.indexOf(
                                    charactersModel.currentCharacter,
                                  ),
                                );
                              },
                            ),
                    ),
                  );
              },
            ),
          ),
        // ),
        if (appModel.page == 0)
          Tooltip(
            message: charactersModel.isEditMode ? 'Delete' : 'New Character',
            child: IconButton(
              icon: Icon(
                charactersModel.isEditMode
                    ? Icons.delete_outlined
                    : Icons.person_add_outlined,
                color: charactersModel.isEditMode
                    ? Colors.red[400]
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
              onPressed: charactersModel.isEditMode
                  ? () {
                      showDialog<bool>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: const Text(
                              'Are you sure? This cannot be undone',
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: Theme.of(context)
                                    .textButtonTheme
                                    .style
                                    .copyWith(
                                      foregroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) =>
                                            SharedPrefs().darkTheme
                                                ? Colors.grey[300]
                                                : Colors.black87,
                                      ),
                                    ),
                                child: const Text(
                                  'Cancel',
                                ),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              ElevatedButton.icon(
                                style: Theme.of(context)
                                    .textButtonTheme
                                    .style
                                    .copyWith(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) =>
                                            Colors.red.withOpacity(0.75),
                                      ),
                                    ),
                                onPressed: () => Navigator.pop(context, true),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ).then(
                        (result) async {
                          if (result) {
                            final String characterName =
                                charactersModel.currentCharacter.name;
                            await charactersModel.deleteCurrentCharacter();
                            context.read<AppModel>().updateTheme();
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text('$characterName deleted'),
                                ),
                              );
                          }
                        },
                      );
                    }
                  : () async {
                      await showDialog<bool>(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          return CreateCharacterDialog(
                            charactersModel: charactersModel,
                          );
                        },
                      ).then((value) {
                        if (value) {
                          appModel.updateTheme();
                        }
                      });
                    },
            ),
          ),
        Tooltip(
          message: 'Settings',
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () async {
              if (charactersModel.isEditMode) {
                charactersModel.toggleEditMode();
              }
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    // must watch
                    appModel: context.watch<AppModel>(),
                    charactersModel: context.watch<CharactersModel>(),
                    enhancementCalculatorModel: enhancementCalculatorModel,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
