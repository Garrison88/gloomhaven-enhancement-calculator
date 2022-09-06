import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class GHCBottomAppBar extends StatefulWidget {
  const GHCBottomAppBar({Key key}) : super(key: key);

  @override
  State<GHCBottomAppBar> createState() => _GHCBottomAppBarState();
}

class _GHCBottomAppBarState extends State<GHCBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    // final enhancementCalculatorModel =
    // context.read<EnhancementCalculatorModel>();
    final appModel = context.watch<AppModel>();
    // final charactersModel = context.read<CharactersModel>();
    return BottomAppBar(
      // color: Theme.of(context).colorScheme.onInverseSurface,
      shape: const CircularNotchedRectangle(),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // SizedBox(
          //   width: MediaQuery.of(context).size.width / 6,
          // ),
          Expanded(
            child: NavigationBar(
              // backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
              // surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              // backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
              selectedIndex: appModel.page,
              onDestinationSelected: (int page) {
                appModel.page = page;
                // setState(() {});
                appModel.pageController.animateToPage(
                  page,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
                context.read<CharactersModel>().isScrolledToTop = true;
              },
              destinations: [
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.history_edu_outlined,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  icon: const Icon(
                    Icons.history_edu_outlined,
                  ),
                  label: 'CHARACTERS',
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.auto_awesome_outlined,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  icon: const Icon(
                    Icons.auto_awesome_outlined,
                  ),
                  label: 'ENHANCEMENTS',
                ),
              ],
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width / 6,
          // ),
        ],
      ),
    );
  }
}
