import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/constants.dart';
import 'models/player_class.dart';
import 'shared_prefs.dart';

class CustomSearchDelegate extends SearchDelegate<PlayerClass> {
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
          Icons.clear,
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
        Icons.arrow_back,
      ),
      onPressed: () => close(
        context,
        null,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) => null;

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
                    labelStyle: Theme.of(context).textTheme.bodyLarge.copyWith(
                          color: gh
                              ? ThemeData.estimateBrightnessForColor(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black
                              : Theme.of(context).textTheme.bodyLarge.color,
                        ),
                    selected: gh,
                    onSelected: (value) => stateSetter(() {
                      gh = value;
                    }),
                    label: const Text('Gloomhaven'),
                  ),
                  FilterChip(
                    labelStyle: Theme.of(context).textTheme.bodyLarge.copyWith(
                          color: jotl
                              ? ThemeData.estimateBrightnessForColor(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black
                              : Theme.of(context).textTheme.bodyLarge.color,
                        ),
                    selected: jotl,
                    onSelected: (value) => stateSetter(() {
                      jotl = value;
                    }),
                    label: const Text('Jaws of the Lion'),
                  ),
                  FilterChip(
                    labelStyle: Theme.of(context).textTheme.bodyLarge.copyWith(
                          color: fh
                              ? ThemeData.estimateBrightnessForColor(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black
                              : Theme.of(context).textTheme.bodyLarge.color,
                        ),
                    selected: fh,
                    onSelected: (value) => stateSetter(() {
                      fh = value;
                    }),
                    label: const Text('Frosthaven'),
                  ),
                  if (SharedPrefs().customClasses)
                    FilterChip(
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          .copyWith(
                            color: cs
                                ? ThemeData.estimateBrightnessForColor(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black
                                : Theme.of(context).textTheme.bodyLarge.color,
                          ),
                      selected: cs,
                      onSelected: (value) => stateSetter(() {
                        cs = value;
                      }),
                      label: const Text('Crimson Scales'),
                    ),
                  if (SharedPrefs().customClasses)
                    FilterChip(
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          .copyWith(
                            color: cc
                                ? ThemeData.estimateBrightnessForColor(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black
                                : Theme.of(context).textTheme.bodyLarge.color,
                          ),
                      selected: cc,
                      onSelected: (value) => stateSetter(() {
                        cc = value;
                      }),
                      label: const Text('Custom Classes'),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Hide Locked Classes',
                  // style: Theme.of(context).textTheme.titleMedium,
                ),
                Checkbox(
                  onChanged: (value) => {
                    stateSetter(() {
                      hideLockedClasses = value;
                    }),
                  },
                  value: hideLockedClasses,
                ),
              ],
            ),
            Expanded(
              child: _WordSuggestionList(
                query: query,
                suggestions: filteredList(_playerClasses),
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

  List<PlayerClass> filteredList(List<PlayerClass> playerClasses) {
    return playerClasses.where((playerClass) {
      if (doNotRenderPlayerClass(playerClass, hideLockedClass: hideLockedClasses
          //  &&
          //     !SharedPrefs().getPlayerClassIsUnlocked(
          //       playerClass.classCode,
          //     ),
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

  bool doNotRenderPlayerClass(
    PlayerClass playerClass, {
    bool hideLockedClass,
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
}

class _WordSuggestionList extends StatefulWidget {
  const _WordSuggestionList({
    this.suggestions,
    this.query,
    this.onSelected,
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
    return ListView.separated(
      separatorBuilder: (
        BuildContext _,
        int index,
      ) =>
          const Divider(
        indent: 8,
        endIndent: 8,
        height: 3,
      ),
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
            bool hideMessage = SharedPrefs().hideCustomClassesWarningMessage;
            return ListTile(
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  selectedPlayerClass.locked
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
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        )
                      : Container(),
                ],
              ),
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
                style: Theme.of(context).textTheme.bodyMedium.copyWith(
                      color: showHidden || !selectedPlayerClass.locked
                          ? null
                          : Theme.of(context).disabledColor,
                    ),
              ),
              onTap: () {
                if ((selectedPlayerClass.category == ClassCategory.custom) &&
                    !hideMessage) {
                  showDialog<bool>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Center(
                          child: Text('Custom Content'),
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
                                                .copyWith(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                            text: 'Discord server',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                Uri uri = Uri(
                                                  scheme: 'https',
                                                  host: 'discord.gg',
                                                  path: 'gSRz6sB',
                                                );
                                                var urllaunchable =
                                                    await canLaunchUrl(
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
                                          onChanged: (value) =>
                                              innerSetState(() {
                                            SharedPrefs()
                                                    .hideCustomClassesWarningMessage =
                                                value;
                                            hideMessage = !hideMessage;
                                          }),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: Text(
                              'Got it!',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      );
                    },
                  ).then((value) {
                    if (value) {
                      Navigator.pop<PlayerClass>(
                        context,
                        selectedPlayerClass,
                      );
                    }
                  });
                } else {
                  Navigator.pop<PlayerClass>(
                    context,
                    selectedPlayerClass,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
