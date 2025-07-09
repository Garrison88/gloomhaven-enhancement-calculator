import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
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
    super.key,
  });

  @override
  State<GHCAppBar> createState() => _GHCAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _GHCAppBarState extends State<GHCAppBar> {
  late VoidCallback _charScrollListener;
  late VoidCallback _enhancementScrollListener;

  @override
  void initState() {
    super.initState();
    final charactersModel = context.read<CharactersModel>();

    _charScrollListener =
        () => _scrollListener(charactersModel.charScreenScrollController);
    _enhancementScrollListener =
        () => _scrollListener(charactersModel.enhancementCalcScrollController);

    charactersModel.charScreenScrollController.addListener(_charScrollListener);
    charactersModel.enhancementCalcScrollController
        .addListener(_enhancementScrollListener);
  }

  @override
  void dispose() {
    final charactersModel = context.read<CharactersModel>();
    charactersModel.charScreenScrollController
        .removeListener(_charScrollListener);
    charactersModel.enhancementCalcScrollController
        .removeListener(_enhancementScrollListener);
    super.dispose();
  }

  void _scrollListener(
    ScrollController scrollController,
  ) {
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
      automaticallyImplyLeading: false,
      // leading: Icon(Icons.settings),
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
          : context.watch<AppModel>().page == 1
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // hack to center Switch
                    const Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      visible: false,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.settings,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'images/titles/gloomhaven.png',
                          scale: 6.25,
                        ),
                      ),
                    ),
                    Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                outline: Colors.transparent,
                              ),
                        ),
                        child: Switch(
                          inactiveThumbImage: const AssetImage(
                            'images/switch_gh.png',
                          ),
                          activeColor: const Color(0xff005cb2),
                          trackColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? const Color(0xff6ab7ff)
                                : const Color(0xffa98274),
                          ),
                          value: !SharedPrefs().gloomhavenMode,
                          onChanged: (value) {
                            SharedPrefs().gloomhavenMode = !value;
                            Provider.of<EnhancementCalculatorModel>(
                              context,
                              listen: false,
                            ).gameVersionToggled();
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'images/titles/frosthaven.png',
                          scale: 7,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
      actions: <Widget>[
        if (charactersModel.isEditMode)
          Tooltip(
            message: charactersModel.currentCharacter!.isRetired
                ? 'Unretire'
                : 'Retire',
            child: IconButton(
              icon: Icon(
                charactersModel.currentCharacter!.isRetired
                    ? Icons.directions_walk
                    : Icons.assist_walker,
              ),
              onPressed: () async {
                final String message =
                    '${charactersModel.currentCharacter!.name} ${charactersModel.currentCharacter!.isRetired ? 'unretired' : 'retired'}';
                Character? character = charactersModel.currentCharacter;
                await charactersModel.retireCurrentCharacter();
                appModel.updateTheme();
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(message),
                      action: charactersModel.showRetired
                          ? null
                          : SnackBarAction(
                              label: 'Show',
                              textColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              onPressed: () {
                                charactersModel.toggleShowRetired(
                                  character: character,
                                );
                              },
                            ),
                    ),
                  );
              },
            ),
          ),
        // if (appModel.page == 0 && !charactersModel.isEditMode)
        //   IconButton(
        //     icon: const Icon(
        //       Icons.info_outline_rounded,
        //     ),
        //     onPressed: () => showDialog<void>(
        //       context: context,
        //       builder: (_) {
        //         return InfoDialog(
        //           title: Strings.previousRetirementsInfoTitle,
        //           message: Strings.previousRetirementsInfoBody(context),
        //         );
        //       },
        //     ),
        //   ),
        if (appModel.page == 0)
          Tooltip(
            message: charactersModel.isEditMode ? 'Delete' : 'New Character',
            child: IconButton(
              icon: Icon(
                charactersModel.isEditMode
                    ? Icons.delete_rounded
                    : Icons.person_add_rounded,
                color: charactersModel.isEditMode
                    ? Colors.red[400]
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
              onPressed: charactersModel.isEditMode
                  ? () {
                      showDialog<bool?>(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Container(
                              constraints: const BoxConstraints(
                                maxWidth: maxDialogWidth,
                                minWidth: maxDialogWidth,
                              ),
                              child: const Text(
                                'Are you sure? This cannot be undone',
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Cancel',
                                ),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              ElevatedButton.icon(
                                style: Theme.of(context)
                                    .textButtonTheme
                                    .style
                                    ?.copyWith(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<WidgetState> states) =>
                                            Colors.red.withValues(alpha: 0.75),
                                      ),
                                    ),
                                onPressed: () => Navigator.pop(
                                  context,
                                  true,
                                ),
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Delete',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              )
                            ],
                          );
                        },
                      ).then(
                        (bool? result) async {
                          if (result != null && result) {
                            final String characterName =
                                charactersModel.currentCharacter!.name;
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
                        if (value != null && value) {
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
              Icons.settings_rounded,
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
