import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/constants.dart';
import '../../data/enhancement_data.dart';
import '../../data/strings.dart';
import '../../models/enhancement.dart';
import '../../shared_prefs.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final RichText message;
  final EnhancementCategory category;
  RichText _bodyText;
  List<Enhancement> _titleIcons;
  List<Enhancement> _eligibleForIcons;

  InfoDialog({
    this.title,
    this.message,
    this.category,
  });

  List<Widget> _createIconsListForDialog(List<Enhancement> list) {
    List<Widget> icons = [];
    if (list == null) {
      icons.add(
        Padding(
          child: SvgPicture.asset(
            'images/plus_one.svg',
            height: iconSize,
            width: iconSize,
          ),
          padding: const EdgeInsets.only(
            right: (smallPadding / 2),
          ),
        ),
      );
    } else {
      for (final Enhancement enhancement in list) {
        icons.add(
          Padding(
            child: SharedPrefs().darkTheme && enhancement.invertColor
                ? SvgPicture.asset(
                    'images/${enhancement.icon}',
                    height: iconSize,
                    width: iconSize,
                    color: Colors.white,
                  )
                : SvgPicture.asset(
                    'images/${enhancement.icon}',
                    height: iconSize,
                    width: iconSize,
                  ),
            padding: const EdgeInsets.only(
              right: (smallPadding / 2),
            ),
          ),
        );
      }
    }
    return icons;
  }

  // void showInfoDialog() {
  // info about enhancement category requested

  // showDialog<void>(
  //     context: context,
  //     builder: (_) => );
  // }

  @override
  Widget build(BuildContext context) {
    if (category != null) {
      switch (category) {
        // plus one for character enhancement selected
        case EnhancementCategory.charPlusOne:
        case EnhancementCategory.target:
          _bodyText = Strings.plusOneCharacterInfoBody(context);
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.charPlusOne ||
                    element.category == EnhancementCategory.target,
              )
              .toList();
          break;
        // plus one for summon enhancement selected
        case EnhancementCategory.summonPlusOne:
          _bodyText = Strings.plusOneSummonInfoBody(context);
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.summonPlusOne,
              )
              .toList();
          break;
        // negative enhancement selected
        case EnhancementCategory.negEffect:
          _bodyText = Strings.negEffectInfoBody(context);
          _titleIcons = EnhancementData.enhancements
              .where(
                (element) => element.category == EnhancementCategory.negEffect,
              )
              .toList();
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.negEffect ||
                    ['Attack', 'Push', 'Pull'].contains(element.name) &&
                        element.category != EnhancementCategory.summonPlusOne,
              )
              .toList();
          break;
        // positive enhancement selected
        case EnhancementCategory.posEffect:
          _bodyText = Strings.posEffectInfoBody(context);
          _titleIcons = EnhancementData.enhancements
              .where(
                (element) => element.category == EnhancementCategory.posEffect,
              )
              .toList();
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.posEffect ||
                    [
                      'Heal',
                      'Retaliate',
                      'Shield',
                    ].contains(element.name),
              )
              .toList();
          _eligibleForIcons.add(
            Enhancement(EnhancementCategory.posEffect, 0, 'invisible.svg',
                false, 'Invisible'),
          );
          break;
        // jump selected
        case EnhancementCategory.jump:
          _bodyText = Strings.jumpInfoBody(context);
          _titleIcons = EnhancementData.enhancements
              .where(
                (element) => element.category == EnhancementCategory.jump,
              )
              .toList();
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.name == 'Move' &&
                    element.category != EnhancementCategory.summonPlusOne,
              )
              .toList();
          break;
        // specific element selected
        case EnhancementCategory.specElem:
          _bodyText = Strings.specificElementInfoBody(context);
          _titleIcons = [
            Enhancement(EnhancementCategory.specElem, 100, 'elem_air.svg',
                false, 'Specific Element'),
            Enhancement(EnhancementCategory.specElem, 100, 'elem_earth.svg',
                false, 'Specific Element'),
            Enhancement(EnhancementCategory.specElem, 100, 'elem_fire.svg',
                false, 'Specific Element'),
            Enhancement(EnhancementCategory.specElem, 100, 'elem_ice.svg',
                false, 'Specific Element'),
            Enhancement(EnhancementCategory.specElem, 100, 'elem_dark.svg',
                false, 'Specific Element'),
            Enhancement(EnhancementCategory.specElem, 100, 'elem_light.svg',
                false, 'Specific Element')
          ];
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.negEffect ||
                    element.category == EnhancementCategory.posEffect ||
                    [
                          'Move',
                          'Attack',
                          'Shield',
                          'Heal',
                          'Retaliate',
                          'Push',
                          'Pull',
                        ].contains(element.name) &&
                        element.category != EnhancementCategory.summonPlusOne,
              )
              .toList();
          _eligibleForIcons.add(
            Enhancement(EnhancementCategory.posEffect, 0, 'invisible.svg',
                false, 'Invisible'),
          );
          break;
        // any element selected
        case EnhancementCategory.anyElem:
          _bodyText = Strings.anyElementInfoBody(context);
          _titleIcons = EnhancementData.enhancements
              .where(
                (element) => element.category == EnhancementCategory.anyElem,
              )
              .toList();
          _eligibleForIcons = _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.negEffect ||
                    element.category == EnhancementCategory.posEffect ||
                    [
                          'Move',
                          'Attack',
                          'Shield',
                          'Heal',
                          'Retaliate',
                          'Push',
                          'Pull',
                        ].contains(element.name) &&
                        element.category != EnhancementCategory.summonPlusOne,
              )
              .toList();
          _eligibleForIcons.add(
            Enhancement(EnhancementCategory.posEffect, 0, 'invisible.svg',
                false, 'Invisible'),
          );
          break;
        // hex selected
        case EnhancementCategory.hex:
          _bodyText = Strings.hexInfoBody(context);
          _titleIcons = [
            EnhancementData.enhancements.firstWhere(
                (element) => element.category == EnhancementCategory.hex)
          ];
          _eligibleForIcons = [
            EnhancementData.enhancements.firstWhere(
                (element) => element.category == EnhancementCategory.hex)
          ];
          break;
        // title selected (do nothing)
        default:
          break;
      }
    }
    return AlertDialog(
      // no title provided - this will be an enhancement dialog with icons
      title: title == null
          ? Center(
              child: Wrap(
                runSpacing: smallPadding,
                spacing: smallPadding,
                alignment: WrapAlignment.center,
                children: _createIconsListForDialog(_titleIcons),
              ),
            )
          // title provided - this will be an info dialog with a text title
          : Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 28.0, fontFamily: pirataOne),
              ),
            ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // if title isn't provided, display eligible enhancements
            title == null
                ? Column(children: <Widget>[
                    const Text(
                      'Eligible For:',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: smallPadding,
                        bottom: smallPadding,
                      ),
                    ),
                    Wrap(
                      runSpacing: smallPadding,
                      spacing: smallPadding,
                      alignment: WrapAlignment.center,
                      children: _createIconsListForDialog(_eligibleForIcons),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: smallPadding,
                        bottom: smallPadding,
                      ),
                    ),
                  ])
                // if title isn't provided, display an empty container
                : Container(),
            message ?? _bodyText,
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Got it!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: secondaryFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
