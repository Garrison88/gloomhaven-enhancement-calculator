import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    if (SharedPrefs().showUpdate4Dialog) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text(
                'New in version 4',
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
                child: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("1. Added all 'Frosthaven' classes"),
                      Text(
                          "2. Added all remaining 'Crimson Scales', add-on, and 'Trail of Ashes' classes (show Custom Classes in the Settings menu)"),
                      Text('3. Added Resources section'),
                      Text(
                          "4. Added a toggle for the Enhancement Calculator to use 'Gloomhaven' or 'Frosthaven' rules"),
                      Text(
                          '5. Optional random name generator in Create Character dialog'),
                      Text(
                          "6. Added support for 'Temporary Enhancement' Variant mode in Enhancement Calculator"),
                      Text(
                          '7. Replaced many icons, UI/UX improvements, and many behind-the-scenes performance improvements'),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Upcoming:'),
                      Text(
                          "Frosthaven crossover variants of 'Gloomhaven' and 'Crimson Scales' classes"),
                      SizedBox(height: 16),
                      Text(
                          'Please reach out to the developer through the Support section in the Settings menu with any questions, comments, or critiques'),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Got it!',
                  ),
                )
              ],
            );
          },
        );
        SharedPrefs().showUpdate4Dialog = false;
      });
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
          const EnhancementCalculatorPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButtonLocation:
      //     MediaQuery.of(context).viewInsets.bottom != 0.0
      //         ? FloatingActionButtonLocation.endFloat
      //         : FloatingActionButtonLocation.centerDocked,

      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          // shape: const CircleBorder(),
          // backgroundColor: Color(
          //   int.parse(
          //     SharedPrefs().themeColor,
          //   ),
          // ),
          heroTag: null,
          onPressed: context.read<AppModel>().page == 1
              ? () => context.read<EnhancementCalculatorModel>().resetCost()
              // must watch
              : context.watch<CharactersModel>().characters.isEmpty
                  ? () => showDialog<bool>(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => CreateCharacterDialog(
                          charactersModel: charactersModel,
                        ),
                      ).then((value) {
                        if (value != null && value) {
                          context.read<AppModel>().updateTheme();
                        }
                      })
                  : () => charactersModel.toggleEditMode(),
          child: Icon(
            appModel.page == 1
                ? Icons.clear_rounded
                : charactersModel.characters.isEmpty
                    ? Icons.add
                    : charactersModel.isEditMode
                        ? Icons.edit_off_rounded
                        : Icons.edit_rounded,
          ),
        );
      }),
      bottomNavigationBar: const GHCBottomNavigationBar(),
    );
  }
}
