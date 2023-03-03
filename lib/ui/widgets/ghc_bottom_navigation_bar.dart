import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class GHCBottomNavigationBar extends StatefulWidget {
  const GHCBottomNavigationBar({
    Key key,
  }) : super(
          key: key,
        );

  @override
  State<GHCBottomNavigationBar> createState() => _GHCBottomNavigationBarState();
}

class _GHCBottomNavigationBarState extends State<GHCBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final appModel = context.watch<AppModel>();
    return SizedBox(
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history_edu_outlined,
            ),
            label: 'CHARACTERS',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.auto_awesome_outlined,
            ),
            label: 'ENHANCEMENTS',
          ),
        ],
        currentIndex: appModel.page,
        onTap: (value) {
          appModel.page = value;
          appModel.pageController.jumpToPage(
            value,
          );
          context.read<CharactersModel>().isScrolledToTop = true;
        },
      ),
    );
  }
}
