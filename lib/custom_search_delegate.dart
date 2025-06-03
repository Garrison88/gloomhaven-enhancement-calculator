import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gloomhaven_enhancement_calc/data/player_classes/character_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/constants.dart';
import 'models/player_class.dart';
import 'shared_prefs.dart';

class CustomSearchDelegate extends SearchDelegate<SelectedPlayerClass> {
  CustomSearchDelegate(
    List<PlayerClass> playerClass,
  ) : _playerClasses = playerClass;
  final List<PlayerClass> _playerClasses;

  bool gh = false;
  bool jotl = false;
  bool fh = false;
  bool cs = false;
  bool cc = false;
  bool hideLockedClasses = false;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear_rounded,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_rounded,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(
      builder: (
        BuildContext context,
        StateSetter stateSetter,
      ) {
        // List<PlayerClass> filteredPlayerClasses = ;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: smallPadding,
                top: smallPadding,
              ),
              child: Wrap(
                runSpacing: smallPadding,
                spacing: smallPadding,
                children: [
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    elevation: gh ? 4 : 0,
                    labelStyle:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: gh
                                  ? ThemeData.estimateBrightnessForColor(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary) ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black
                                  : null,
                            ),
                    selected: gh,
                    onSelected: (value) => stateSetter(() {
                      gh = value;
                    }),
                    label: const Text(
                      'Gloomhaven',
                    ),
                  ),
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    elevation: jotl ? 4 : 0,
                    labelStyle:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: jotl
                                  ? ThemeData.estimateBrightnessForColor(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary) ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black
                                  : null,
                            ),
                    selected: jotl,
                    onSelected: (value) => stateSetter(() {
                      jotl = value;
                    }),
                    label: const Text(
                      'Jaws of the Lion',
                    ),
                  ),
                  FilterChip(
                    visualDensity: VisualDensity.compact,
                    elevation: fh ? 4 : 0,
                    labelStyle:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: fh
                                  ? ThemeData.estimateBrightnessForColor(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary) ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black
                                  : null,
                            ),
                    selected: fh,
                    onSelected: (value) => stateSetter(() {
                      fh = value;
                    }),
                    label: const Text(
                      'Frosthaven',
                    ),
                  ),
                  if (SharedPrefs().customClasses)
                    FilterChip(
                      visualDensity: VisualDensity.compact,
                      elevation: cs ? 4 : 0,
                      labelStyle:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: cs
                                    ? ThemeData.estimateBrightnessForColor(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary) ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black
                                    : null,
                              ),
                      selected: cs,
                      onSelected: (value) => stateSetter(() {
                        cs = value;
                      }),
                      label: const Text(
                        'Crimson Scales',
                      ),
                    ),
                  if (SharedPrefs().customClasses)
                    FilterChip(
                      visualDensity: VisualDensity.compact,
                      elevation: cc ? 4 : 0,
                      labelStyle:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: cc
                                    ? ThemeData.estimateBrightnessForColor(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary) ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black
                                    : null,
                              ),
                      selected: cc,
                      onSelected: (value) => stateSetter(() {
                        cc = value;
                      }),
                      label: const Text(
                        'Custom Classes',
                      ),
                    ),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text(
                'Hide locked classes',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.right,
              ),
              onChanged: (bool? value) => {
                stateSetter(() {
                  hideLockedClasses = value ?? false;
                }),
              },
              value: hideLockedClasses,
            ),
            Expanded(
              child: _WordSuggestionList(
                query: query,
                suggestions: _filteredList(_playerClasses),
                onSelected: (String suggestion) {
                  query = suggestion;
                  showResults(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<PlayerClass> _filteredList(List<PlayerClass> playerClasses) {
    return playerClasses.where((playerClass) {
      if (_doNotRenderPlayerClass(
        playerClass,
        hideLockedClass: hideLockedClasses,
      )) {
        return false;
      }
      if (!gh && !jotl && !fh && !cs && !cc) {
        return playerClass.name.toLowerCase().contains(query.toLowerCase());
      }

      return (playerClass.name.toLowerCase().contains(query.toLowerCase()) &&
              playerClass.category == ClassCategory.gloomhaven &&
              gh) ||
          (playerClass.name.toLowerCase().contains(query.toLowerCase()) &&
              playerClass.category == ClassCategory.jawsOfTheLion &&
              jotl) ||
          (playerClass.name.toLowerCase().contains(query.toLowerCase()) &&
              playerClass.category == ClassCategory.frosthaven &&
              fh) ||
          (playerClass.name.toLowerCase().contains(query.toLowerCase()) &&
              playerClass.category == ClassCategory.crimsonScales &&
              cs) ||
          (playerClass.name.toLowerCase().contains(query.toLowerCase()) &&
              playerClass.category == ClassCategory.custom &&
              cc);
    }).toList()
      // TODO: remove this when reintroducing the Rootwhisperer - see Character Data
      ..removeWhere((element) => element.classCode == 'rw');
  }

  bool _doNotRenderPlayerClass(
    PlayerClass playerClass, {
    required bool hideLockedClass,
  }) =>
      (!SharedPrefs().envelopeX && playerClass.classCode == 'bs') ||
      (!SharedPrefs().envelopeV && playerClass.classCode == 'vanquisher') ||
      (!SharedPrefs().customClasses &&
          (playerClass.category == ClassCategory.custom ||
              playerClass.category == ClassCategory.crimsonScales)) ||
      (hideLockedClass &&
          playerClass.locked &&
          !SharedPrefs().getPlayerClassIsUnlocked(
            playerClass.classCode,
          ));

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }
}

class _WordSuggestionList extends StatefulWidget {
  const _WordSuggestionList({
    required this.suggestions,
    required this.query,
    required this.onSelected,
  });

  final List<PlayerClass> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  __WordSuggestionListState createState() => __WordSuggestionListState();
}

class __WordSuggestionListState extends State<_WordSuggestionList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.suggestions.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        final PlayerClass selectedPlayerClass = widget.suggestions[index];
        bool showHidden = SharedPrefs().getPlayerClassIsUnlocked(
          selectedPlayerClass.classCode,
        );
        return StatefulBuilder(
          builder: (
            thisLowerContext,
            innerSetState,
          ) {
            return ListTile(
              leading: SvgPicture.asset(
                'images/class_icons/${selectedPlayerClass.icon}',
                width: iconSize + 5,
                height: iconSize + 5,
                colorFilter: ColorFilter.mode(
                  Color(
                    selectedPlayerClass.primaryColor,
                  ),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                showHidden || !selectedPlayerClass.locked
                    ? selectedPlayerClass.name
                    : '???',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: showHidden || !selectedPlayerClass.locked
                          ? null
                          : Theme.of(context).disabledColor,
                    ),
              ),
              trailing: selectedPlayerClass.locked
                  ? IconButton(
                      onPressed: () {
                        SharedPrefs().setPlayerClassIsUnlocked(
                          selectedPlayerClass.classCode,
                          !showHidden,
                        );
                        innerSetState(() {
                          showHidden = !showHidden;
                        });
                      },
                      icon: Icon(
                        showHidden
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    )
                  : null,
              onTap: () async {
                SelectedPlayerClass? choice = await _onClassSelected(
                  context,
                  selectedPlayerClass,
                );
                if (choice != null) {
                  Navigator.pop<SelectedPlayerClass>(
                    context,
                    choice,
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  /// This method shows a dialog which gives the user the option to select
  /// a specific version of the class, if available.
  Future<SelectedPlayerClass?> _onClassSelected(
    BuildContext context,
    PlayerClass selectedPlayerClass,
  ) async {
    bool hideMessage = SharedPrefs().hideCustomClassesWarningMessage;
    bool? proceed = true;
    SelectedPlayerClass userChoice = SelectedPlayerClass(
      playerClass: selectedPlayerClass,
    );
    if ((selectedPlayerClass.category == ClassCategory.custom) &&
        !hideMessage) {
      proceed = await _showCustomClassWarningDialog(hideMessage);
    }
    // TODO: This can be removed once all classes (Crimson Scales and custom) are converted over to use the Map
    if (PlayerClass.perkListByClassCode(selectedPlayerClass.classCode)!.length >
        1) {
      Variant? variant = await _showVariantDialog(selectedPlayerClass);
      proceed = variant != null;
      userChoice = SelectedPlayerClass(
        playerClass: selectedPlayerClass,
        variant: variant,
      );
      // return userChoice;
    }
    return proceed == true ? userChoice : null;
  }

  Future<bool?> _showCustomClassWarningDialog(bool hideMessage) async {
    return await showDialog<bool?>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Custom Classes',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          content: StatefulBuilder(
            builder: (
              thisLowerContext,
              innerSetState,
            ) {
              return Container(
                constraints: const BoxConstraints(
                  maxWidth: maxDialogWidth,
                  minWidth: maxDialogWidth,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  "Please note that these classes are created by members of the 'Gloomhaven Custom Content Unity Guild' and are subject to change. Use at your own risk and report any incongruencies to the developer. More information can be found on the ",
                            ),
                            TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                              text: 'Discord server',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Uri uri = Uri(
                                    scheme: 'https',
                                    host: 'discord.gg',
                                    path:
                                        'gloomhaven-custom-content-unity-guild-728375347732807825',
                                  );
                                  var urllaunchable = await canLaunchUrl(
                                    uri,
                                  );
                                  if (urllaunchable) {
                                    await launchUrl(
                                      uri,
                                    );
                                  } else {
                                    // print(
                                    //     "URL can't be launched.");
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Don't show again",
                            overflow: TextOverflow.visible,
                          ),
                          Checkbox(
                            value: hideMessage,
                            onChanged: (bool? value) {
                              if (value != null) {
                                innerSetState(
                                  () {
                                    SharedPrefs()
                                            .hideCustomClassesWarningMessage =
                                        value;
                                    hideMessage = !hideMessage;
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
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
              ),
              onPressed: () => Navigator.pop(
                context,
                false,
              ),
            ),
            TextButton(
              child: const Text(
                'Continue',
              ),
              onPressed: () => Navigator.pop(
                context,
                true,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Variant?> _showVariantDialog(PlayerClass selectedPlayerClass) async {
    return await showDialog<Variant?>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/class_icons/${selectedPlayerClass.icon}',
                width: iconSize + 5,
                height: iconSize + 5,
                colorFilter: ColorFilter.mode(
                  Color(
                    selectedPlayerClass.primaryColor,
                  ),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: smallPadding * 2),
              Text(
                selectedPlayerClass.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          content: const Text(
            'Version',
            textAlign: TextAlign.center,
          ),
          actions:
              PlayerClass.perkListByClassCode(selectedPlayerClass.classCode)!
                  .map((perkList) {
            return TextButton(
              onPressed: () {
                Navigator.of(context).pop(perkList.variant);
              },
              child: Text(
                ClassVariants.classVariants[perkList.variant]!,
                textAlign: TextAlign.end,
              ),
            );
          }).toList()
                ..add(TextButton(
                    onPressed: (() => Navigator.of(context).pop()),
                    child: const Text('Cancel'))),
        );
      },
    );
  }
}

class SelectedPlayerClass {
  SelectedPlayerClass({
    required this.playerClass,
    this.variant = Variant.base,
  });
  final PlayerClass playerClass;
  final Variant? variant;
}
