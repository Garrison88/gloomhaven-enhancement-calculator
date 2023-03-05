import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data/constants.dart';
import 'models/player_class.dart';
import 'shared_prefs.dart';
import 'data/character_data.dart';

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
      onPressed: () {
        close(context, null);
      },
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
        final Iterable<PlayerClass> playerClass = _playerClasses
            .where((playerClass) {
          if (!gh && !jotl && !fh && !cs && !cc) {
            return playerClass.className
                .toLowerCase()
                .contains(query.toLowerCase());
          }
          return (playerClass.className
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  playerClass.classCategory == ClassCategory.gloomhaven &&
                  gh) ||
              (playerClass.className
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  playerClass.classCategory == ClassCategory.jawsOfTheLion &&
                  jotl) ||
              (playerClass.className
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  playerClass.classCategory == ClassCategory.frosthaven &&
                  fh) ||
              (playerClass.className
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  playerClass.classCategory == ClassCategory.crimsonScales &&
                  cs) ||
              (playerClass.className
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  playerClass.classCategory == ClassCategory.custom &&
                  cc);
        }).toList()
          // TODO: remove this when reintroducing the Rootwhisperer - see Character Data
          ..removeWhere((element) => element.classCode == 'rw');
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
                    checkmarkColor: ThemeData.estimateBrightnessForColor(
                                Theme.of(context).colorScheme.primary) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    visualDensity: VisualDensity.compact,
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
                    checkmarkColor: ThemeData.estimateBrightnessForColor(
                                Theme.of(context).colorScheme.primary) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    visualDensity: VisualDensity.compact,
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
                    checkmarkColor: ThemeData.estimateBrightnessForColor(
                                Theme.of(context).colorScheme.primary) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    visualDensity: VisualDensity.compact,
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
                      checkmarkColor: ThemeData.estimateBrightnessForColor(
                                  Theme.of(context).colorScheme.primary) ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      visualDensity: VisualDensity.compact,
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
                      checkmarkColor: ThemeData.estimateBrightnessForColor(
                                  Theme.of(context).colorScheme.primary) ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      visualDensity: VisualDensity.compact,
                      selected: cc,
                      onSelected: (value) => stateSetter(() {
                        cc = value;
                      }),
                      label: const Text('Custom Classes'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _WordSuggestionList(
                query: query,
                suggestions: playerClass,
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
      ) {
        if ((!SharedPrefs().envelopeX &&
                widget.suggestions[index].classCode == 'bs') ||
            !SharedPrefs().customClasses &&
                (widget.suggestions[index].classCategory ==
                        ClassCategory.custom ||
                    widget.suggestions[index].classCategory ==
                        ClassCategory.crimsonScales)) {
          return Container();
        } else {
          return const Divider(
            indent: 8,
            endIndent: 8,
            height: 3,
          );
        }
      },
      itemCount: widget.suggestions.length,
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        final PlayerClass selectedPlayerClass = widget.suggestions[index];
        if ((!SharedPrefs().envelopeX &&
                selectedPlayerClass.classCode == 'bs') ||
            !SharedPrefs().customClasses &&
                (selectedPlayerClass.classCategory == ClassCategory.custom ||
                    selectedPlayerClass.classCategory ==
                        ClassCategory.crimsonScales)) {
          return Container();
        } else {
          bool showHidden = false;
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
                              innerSetState(() {
                                showHidden = !showHidden;
                              });
                            },
                            icon: Icon(
                              showHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          )
                        : Container(),
                  ],
                ),
                leading: SvgPicture.asset(
                  'images/class_icons/${selectedPlayerClass.classIconUrl}',
                  width: iconSize + 5,
                  height: iconSize + 5,
                  colorFilter: ColorFilter.mode(
                    Color(
                      int.parse(
                        selectedPlayerClass.classColor,
                      ),
                    ),
                    BlendMode.srcIn,
                  ),
                ),
                title: Text(
                  showHidden || !selectedPlayerClass.locked
                      ? selectedPlayerClass.className
                      : '???',
                ),
                onTap: () {
                  if ((selectedPlayerClass.classCategory ==
                              ClassCategory.custom ||
                          selectedPlayerClass.classCategory ==
                              ClassCategory.crimsonScales) &&
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
                              return SingleChildScrollView(
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
                              );
                            },
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.black87,
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
        }
      },
    );
  }
}
