import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'data/constants.dart';
import 'models/player_class.dart';
import 'shared_prefs.dart';
import 'data/character_data.dart';
import 'main.dart';

class CustomSearchDelegate extends SearchDelegate<PlayerClass> {
  CustomSearchDelegate(
    List<PlayerClass> playerClass,
  ) : _playerClasses = playerClass;
  final List<PlayerClass> _playerClasses;

  bool gh = false;
  bool jotl = false;
  bool fh = false;
  bool cs = false;
  bool rc = false;

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
        final Iterable<PlayerClass> playerClass =
            _playerClasses.where((playerClass) {
          if (!gh && !jotl && !fh && !cs && !rc) {
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
                  playerClass.classCategory == ClassCategory.frostHaven &&
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
                  rc);
        }).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: smallPadding),
              child: Wrap(
                spacing: smallPadding,
                children: [
                  FilterChip(
                    selected: gh,
                    onSelected: (value) => stateSetter(() {
                      gh = value;
                    }),
                    label: const Text('Gloomhaven'),
                  ),
                  FilterChip(
                    selected: jotl,
                    onSelected: (value) => stateSetter(() {
                      jotl = value;
                    }),
                    label: const Text('Jaws of the Lion'),
                  ),
                  if (includeFrosthaven)
                    FilterChip(
                      selected: fh,
                      onSelected: (value) => stateSetter(() {
                        fh = value;
                      }),
                      label: const Text('Frosthaven'),
                    ),
                  if (SharedPrefs().customClasses)
                    FilterChip(
                      selected: cs,
                      onSelected: (value) => stateSetter(() {
                        cs = value;
                      }),
                      label: const Text('Crimson Scales'),
                    ),
                  if (SharedPrefs().customClasses)
                    FilterChip(
                      selected: rc,
                      onSelected: (value) => stateSetter(() {
                        rc = value;
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
      itemBuilder: (BuildContext context, int index) {
        final PlayerClass selectedPlayerClass = widget.suggestions[index];
        // final String suggestion = selectedPlayerClass.locked
        //     ? '???'
        //     : selectedPlayerClass.className;
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
              return ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    selectedPlayerClass.classCategory == ClassCategory.custom
                        ? IconButton(
                            onPressed: () {
                              showDialog<bool>(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: const Text(
                                      'Please note that these classes are ',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'Got it!',
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.grey,
                            ),
                          )
                        : Container(),
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
                  color: Color(
                    int.parse(
                      selectedPlayerClass.classColor,
                    ),
                  ),
                ),
                title: Text(
                  showHidden ? selectedPlayerClass.className : '???',
                ),
                onTap: () {
                  Navigator.pop<PlayerClass>(
                    context,
                    selectedPlayerClass,
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
