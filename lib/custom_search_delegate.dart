import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data/constants.dart';
import 'models/player_class.dart';
import 'shared_prefs.dart';
import 'data/character_data.dart';

class CustomSearchDelegate extends SearchDelegate<PlayerClass> {
  CustomSearchDelegate(
    List<PlayerClass> playerClass,
  ) : _playerClass = playerClass;
  final List<PlayerClass> _playerClass;

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
    final Iterable<PlayerClass> playerClass = _playerClass.where(
        (playerClass) =>
            playerClass.className.toLowerCase().contains(query.toLowerCase()));

    return _WordSuggestionList(
      query: query,
      suggestions: playerClass.toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
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
