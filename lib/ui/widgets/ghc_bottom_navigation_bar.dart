import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class GHCBottomNavigationBar extends StatelessWidget {
  const GHCBottomNavigationBar({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final appModel = context.watch<AppModel>();
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 35,
            child: Icon(
              Icons.history_edu_outlined,
              size: iconSize,
            ),
          ),
          label: 'CHARACTERS',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 35,
            child: Icon(
              Icons.auto_awesome_outlined,
              size: iconSize,
            ),
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
    );
  }
}
