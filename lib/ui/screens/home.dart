import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gloomhaven_enhancement_calc/data/campaign_database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/create_campaign_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/campaign_tracker_screen.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/campaign_model.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/create_character_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/characters_screen.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/enhancement_calculator_page.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/ghc_app_bar.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/ghc_bottom_navigation_bar.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Character>> future;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    future = context.read<CharactersModel>().loadCharacters();
    if (SharedPrefs().showUpdate420Dialog) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          showDialog<void>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              bool iUnderstand = false;
              return StatefulBuilder(
                builder: (
                  _,
                  innerSetState,
                ) {
                  return AlertDialog(
                    title: const Text(
                      'New in version 4.2.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    content: Container(
                      constraints: const BoxConstraints(
                        maxWidth: maxDialogWidth,
                        minWidth: maxDialogWidth,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                                '1. Added all Frosthaven variants of Gloomhaven and JotL classes (Crimson Scales upcoming).'),
                            const SizedBox(height: 16),
                            const Text(
                                "2. Corrected an error present in the 'Astral' perk list."),
                            const SizedBox(height: 16),
                            Text(
                              'Breaking change:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                                "3. A necessary database migration means you cannot restore backups created before version 4.2.0. Please create a new backup now to replace the deprecated one."),
                            const SizedBox(height: 16),
                            const Text(
                                'Please reach out to the developer through the Support section in the Settings menu with any questions, comments, or critiques'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Expanded(
                                  child: Text(
                                    "I understand that I won't be able to restore backups created before version 4.2.0.",
                                  ),
                                ),
                                Checkbox(
                                  value: iUnderstand,
                                  onChanged: (value) {
                                    if (value != null) {
                                      innerSetState(
                                        () {
                                          iUnderstand = value;
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: iUnderstand
                            ? () {
                                SharedPrefs().showUpdate420Dialog = false;
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text(
                          iUnderstand
                              ? 'Got it!'
                              : 'Confirm before continuing...',
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appModel = context.watch<AppModel>();
    final charactersModel = context.read<CharactersModel>();
    return Scaffold(
      // this is necessary to make notched FAB background transparent, effectively
      // extendBody: true,
      key: scaffoldMessengerKey,
      appBar: const GHCAppBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: context.read<AppModel>().pageController,
        onPageChanged: (index) {
          charactersModel.isEditMode = false;
          context.read<AppModel>().page = index;
          setState(() {});
        },
        children: [
          FutureBuilder<List<Character>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return const CharactersScreen();
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Please wait...'),
                      SizedBox(height: smallPadding),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            },
          ),
          const CampaignTrackerScreen(),
          const EnhancementCalculatorPage(),
        ],
      ),
      // floatingActionButtonLocation:
      //     MediaQuery.of(context).viewInsets.bottom != 0.0
      //         ? FloatingActionButtonLocation.endFloat
      //         : FloatingActionButtonLocation.centerDocked,

      floatingActionButton: appModel.page != 1
          ? Builder(
              builder: (context) {
                return FloatingActionButton(
                  heroTag: null,
                  onPressed: onPressed,
                  child: Icon(appModel.page == 0
                      ? charactersModel.characters.isEmpty
                          ? Icons.add
                          : charactersModel.isEditMode
                              ? Icons.edit_off_rounded
                              : Icons.edit_rounded
                      : appModel.page == 1
                          ? Icons.edit_rounded
                          : Icons.clear_rounded),
                );
              },
            )
          : null,
      bottomNavigationBar: const GHCBottomNavigationBar(),
    );
  }

  void onPressed() {
    final appModel = context.read<AppModel>();
    final charactersModel = context.read<CharactersModel>();
    switch (appModel.page) {
      case 0:
        if (charactersModel.characters.isEmpty) {
          showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (_) => CreateCharacterDialog(
              charactersModel: charactersModel,
            ),
          ).then((value) {
            if (value != null && value) {
              context.read<AppModel>().updateTheme();
            }
          });
        } else {
          charactersModel.toggleEditMode();
        }
      case 2:
        context.read<EnhancementCalculatorModel>().resetCost();
      default:
    }
  }
}
