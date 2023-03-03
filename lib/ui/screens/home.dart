import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/ghc_app_bar.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/ghc_bottom_navigation_bar.dart';
import '../../data/constants.dart';
import '../../models/character.dart';
import '../../viewmodels/app_model.dart';
import '../../viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/characters_model.dart';
import '../dialogs/create_character_dialog.dart';
import 'characters_screen.dart';
import 'enhancement_calculator_page.dart';

class Home extends StatefulWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Future<List<Character>> future;
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    context.read<CharactersModel>().hideRetireCharacterAnimationController =
        AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      reverseDuration: kThemeAnimationDuration,
    )..forward();
    future = context.read<CharactersModel>().loadCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final enhancementCalculatorModel =
        context.read<EnhancementCalculatorModel>();
    final appModel = context.read<AppModel>();
    final charactersModel = context.read<CharactersModel>();
    return Scaffold(
      extendBody: true,
      key: scaffoldMessengerKey,
      appBar: const GHCAppBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
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
        controller: appModel.pageController,
        onPageChanged: (index) {
          charactersModel.isEditMode = false;
          appModel.page = index;
          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButtonLocation:
      //     MediaQuery.of(context).viewInsets.bottom != 0.0
      //         ? FloatingActionButtonLocation.endFloat
      //         : FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionButton(
        // shape: const CircleBorder(),
        // backgroundColor: Color(
        //   int.parse(
        //     SharedPrefs().themeColor,
        //   ),
        // ),
        mini: MediaQuery.of(context).viewInsets.bottom != 0.0,
        heroTag: null,
        child: Icon(
          appModel.page == 1
              ? Icons.clear
              : charactersModel.characters.isEmpty
                  ? Icons.add
                  : charactersModel.isEditMode
                      ? Icons.edit_off_outlined
                      : Icons.edit_outlined,
          color: ThemeData.estimateBrightnessForColor(
                      Theme.of(context).colorScheme.primary) ==
                  Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        onPressed: appModel.page == 1
            ? () => enhancementCalculatorModel.resetCost()
            // must watch
            : context.watch<CharactersModel>().characters.isEmpty
                ? () async {
                    return await showDialog<bool>(
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
                  }
                : () => charactersModel.toggleEditMode(),
      ),
      bottomNavigationBar: const GHCBottomNavigationBar(),
    );
  }
}
