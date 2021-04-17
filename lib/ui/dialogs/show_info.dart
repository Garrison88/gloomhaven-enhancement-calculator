import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

_createIconsListForDialog(List<Enhancement> list) {
  List<Widget> icons = [];
  if (list == null) {
    icons.add(
      Padding(
        child: Image.asset(
          'images/plus_one.png',
          height: iconSize,
          width: iconSize,
        ),
        padding: EdgeInsets.only(
          right: (smallPadding / 2),
        ),
      ),
    );
  } else {
    list.forEach(
      (icon) => icons.add(
        Padding(
          child: SharedPrefs().darkTheme && icon.invertColor
              ? Image.asset(
                  'images/${icon.icon}',
                  height: iconSize,
                  width: iconSize,
                  color: Colors.white,
                )
              : Image.asset(
                  'images/${icon.icon}',
                  height: iconSize,
                  width: iconSize,
                ),
          padding: EdgeInsets.only(
            right: (smallPadding / 2),
          ),
        ),
      ),
    );
  }
  return icons;
}

void showInfoDialog(
  BuildContext context,
  String dialogTitle,
  RichText dialogMessage,
  EnhancementCategory category,
) {
  RichText bodyText;
  List<Enhancement> titleIcons;
  List<Enhancement> eligibleForIcons;
  // info about enhancement category requested
  if (category != null) {
    switch (category) {
      // plus one for character enhancement selected
      case EnhancementCategory.charPlusOne:
      case EnhancementCategory.target:
        bodyText = Strings.plusOneCharacterInfoBody(context);
        eligibleForIcons = EnhancementData.enhancements
            .where(
              (element) =>
                  element.category == EnhancementCategory.charPlusOne ||
                  element.category == EnhancementCategory.target,
            )
            .toList();
        break;
      // plus one for summon enhancement selected
      case EnhancementCategory.summonPlusOne:
        bodyText = Strings.plusOneSummonInfoBody(context);
        eligibleForIcons = EnhancementData.enhancements
            .where(
              (element) =>
                  element.category == EnhancementCategory.summonPlusOne,
            )
            .toList();
        break;
      // negative enhancement selected
      case EnhancementCategory.negEffect:
        bodyText = Strings.negEffectInfoBody(context);
        titleIcons = EnhancementData.enhancements
            .where(
              (element) => element.category == EnhancementCategory.negEffect,
            )
            .toList();
        eligibleForIcons = EnhancementData.enhancements
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
        bodyText = Strings.posEffectInfoBody(context);
        titleIcons = EnhancementData.enhancements
            .where(
              (element) => element.category == EnhancementCategory.posEffect,
            )
            .toList();
        eligibleForIcons = EnhancementData.enhancements
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
        eligibleForIcons.add(
          Enhancement(EnhancementCategory.posEffect, 0, 'invisible.png', false,
              'Invisible'),
        );
        break;
      // jump selected
      case EnhancementCategory.jump:
        bodyText = Strings.jumpInfoBody(context);
        titleIcons = EnhancementData.enhancements
            .where(
              (element) => element.category == EnhancementCategory.jump,
            )
            .toList();
        eligibleForIcons = EnhancementData.enhancements
            .where(
              (element) =>
                  element.name == 'Move' &&
                  element.category != EnhancementCategory.summonPlusOne,
            )
            .toList();
        break;
      // specific element selected
      case EnhancementCategory.specElem:
        bodyText = Strings.specificElementInfoBody(context);
        titleIcons = [
          Enhancement(EnhancementCategory.specElem, 100, 'elem_air.png', false,
              'Specific Element'),
          Enhancement(EnhancementCategory.specElem, 100, 'elem_earth.png',
              false, 'Specific Element'),
          Enhancement(EnhancementCategory.specElem, 100, 'elem_fire.png', false,
              'Specific Element'),
          Enhancement(EnhancementCategory.specElem, 100, 'elem_ice.png', false,
              'Specific Element'),
          Enhancement(EnhancementCategory.specElem, 100, 'elem_dark.png', false,
              'Specific Element'),
          Enhancement(EnhancementCategory.specElem, 100, 'elem_light.png',
              false, 'Specific Element')
        ];
        eligibleForIcons = EnhancementData.enhancements
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
        eligibleForIcons.add(
          Enhancement(EnhancementCategory.posEffect, 0, 'invisible.png', false,
              'Invisible'),
        );
        break;
      // any element selected
      case EnhancementCategory.anyElem:
        bodyText = Strings.anyElementInfoBody(context);
        titleIcons = EnhancementData.enhancements
            .where(
              (element) => element.category == EnhancementCategory.anyElem,
            )
            .toList();
        eligibleForIcons = eligibleForIcons = EnhancementData.enhancements
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
        eligibleForIcons.add(
          Enhancement(EnhancementCategory.posEffect, 0, 'invisible.png', false,
              'Invisible'),
        );
        break;
      // hex selected
      case EnhancementCategory.hex:
        bodyText = Strings.hexInfoBody(context);
        titleIcons = [
          EnhancementData.enhancements.firstWhere(
              (element) => element.category == EnhancementCategory.hex)
        ];
        eligibleForIcons = [
          EnhancementData.enhancements.firstWhere(
              (element) => element.category == EnhancementCategory.hex)
        ];
        break;
      // title selected (do nothing)
      default:
        break;
    }
  }
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            // no title provided - this will be an enhancement dialog with icons
            title: dialogTitle == null
                ? Center(
                    child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _createIconsListForDialog(titleIcons),
                    ),
                  ))
                // title provided - this will be an info dialog with a text title
                : Center(
                    child: Text(
                      dialogTitle,
                      style: TextStyle(fontSize: 28.0, fontFamily: pirataOne),
                    ),
                  ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // if title isn't provided, display eligible enhancements
                  dialogTitle == null
                      ? Column(children: <Widget>[
                          Text(
                            'Eligible For:',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: smallPadding, bottom: smallPadding)),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: _createIconsListForDialog(
                                    eligibleForIcons)),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: smallPadding, bottom: smallPadding)),
                        ])
                      // if title isn't provided, display an empty container
                      : Container(),
                  dialogMessage == null ? bodyText : dialogMessage,
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Got it!',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: secondaryFontSize,
                  ),
                ),
              ),
            ],
          ));
}
