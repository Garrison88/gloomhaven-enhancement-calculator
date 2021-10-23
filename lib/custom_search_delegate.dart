import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool jl = false;
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
          if (!gh && !jl && !cs && !rc) {
            return playerClass.className
                .toLowerCase()
                .contains(query.toLowerCase());
          }
          return (playerClass.className
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  playerClass.classCategory == ClassCategory.gloomhaven &&
                  gh) ||
              // (playerClass.className
              //         .toLowerCase()
              //         .contains(query.toLowerCase()) &&
              //     playerClass.classCategory == ClassCategory.forgottenCircles &&
              //     fc) ||
              (playerClass.className
                      .toLowerCase()
                      .contains(query.toLowerCase()) &&
                  playerClass.classCategory == ClassCategory.jawsOfTheLion &&
                  jl) ||
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
                  // FilterChip(
                  //   selected: fc,
                  //   onSelected: (value) => stateSetter(() {
                  //     fc = value;
                  //   }),
                  //   label: const Text('Forgotten Circles'),
                  // ),
                  FilterChip(
                    selected: jl,
                    onSelected: (value) => stateSetter(() {
                      jl = value;
                    }),
                    label: const Text('Jaws of the Lion'),
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
                      label: const Text('Released Classes'),
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
      separatorBuilder: (BuildContext context, int index) {
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
        final String suggestion = widget.suggestions[index].locked
            ? '???'
            : widget.suggestions[index].className;
        if ((!SharedPrefs().envelopeX &&
                widget.suggestions[index].classCode == 'bs') ||
            !SharedPrefs().customClasses &&
                (widget.suggestions[index].classCategory ==
                        ClassCategory.custom ||
                    widget.suggestions[index].classCategory ==
                        ClassCategory.crimsonScales)) {
          return Container();
        } else {
          bool showHidden = false;
          return StatefulBuilder(builder: (thisLowerContext, innerSetState) {
            return ListTile(
              trailing: widget.suggestions[index].locked
                  ? IconButton(
                      onPressed: () {
                        innerSetState(() {
                          showHidden = !showHidden;
                        });
                      },
                      icon: Icon(
                        showHidden ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    )
                  : null,
              leading: SvgPicture.asset(
                'images/class_icons/${widget.suggestions[index].classIconUrl}',
                width: iconSize + 5,
                height: iconSize + 5,
                color: Color(int.parse(widget.suggestions[index].classColor)),
              ),
              title: Text(showHidden
                  ? widget.suggestions[index].className
                  : suggestion),
              onTap: () {
                Navigator.pop<PlayerClass>(context, widget.suggestions[index]);
              },
            );
          });
        }
      },
    );
  }
}
