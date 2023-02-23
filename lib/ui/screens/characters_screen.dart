import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import '../../data/constants.dart';
import '../../shared_prefs.dart';
import 'character_screen.dart';
import '../../viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({
    Key key,
  }) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey _pageStorageKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    CharactersModel charactersModel = context.read<CharactersModel>();
    // must watch
    if (context.watch<CharactersModel>().characters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
              left: smallPadding * 2,
              right: smallPadding * 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create ${charactersModel.retiredCharactersAreHidden ? 'a' : 'your first'} character using the button below, or restore a backup from the Settings menu',
                  textAlign: TextAlign.center,
                ),
                if (charactersModel.retiredCharactersAreHidden) ...[
                  const SizedBox(
                    height: smallPadding,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: smallPadding),
                    child: Divider(),
                  ),
                  TextButton(
                    onPressed: () {
                      charactersModel.toggleShowRetired();
                      context.read<AppModel>().updateTheme();
                    },
                    child: Text(
                      'Show Retired Characters',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    } else {
      try {
        charactersModel.currentCharacter =
            charactersModel.characters[SharedPrefs().initialPage];
      } catch (e) {
        charactersModel.currentCharacter = charactersModel.characters[0];
      }
      return PageView.builder(
        key: _pageStorageKey,
        controller: charactersModel.pageController,
        onPageChanged: (index) {
          charactersModel.onPageChanged(
            index,
          );
          Theme.of(context).colorScheme.copyWith(
                primary: Color(
                  int.parse(
                    SharedPrefs().themeColor,
                  ),
                ),
              );

          context.read<AppModel>().updateTheme();
        },
        itemCount: charactersModel.characters.length,
        itemBuilder: (context, int index) {
          return Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SvgPicture.asset(
                      'images/class_icons/${charactersModel.characters[index].playerClass.classIconUrl}',
                      color: charactersModel.characters[index].isRetired
                          ? Colors.black.withOpacity(0.1)
                          : Color(
                              int.parse(
                                charactersModel
                                    .characters[index].playerClass.classColor,
                              ),
                            ).withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              CharacterScreen(
                character: charactersModel.characters[index],
              ),
            ],
          );
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
