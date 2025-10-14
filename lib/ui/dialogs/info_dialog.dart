import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/constants.dart';
import '../../data/enhancement_data.dart';
import '../../data/strings.dart';
import '../../models/enhancement.dart';
import '../../shared_prefs.dart';

class InfoDialog extends StatefulWidget {
  final String? title;
  final RichText? message;
  final EnhancementCategory? category;

  const InfoDialog({
    super.key,
    this.title,
    this.message,
    this.category,
  });

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  late RichText _bodyText;
  List<Enhancement> _titleIcons = [];
  late List<Enhancement> _eligibleForIcons;

  /// Creates a list of icon widgets for display in the dialog
  List<Widget> _createIconsListForDialog(List<Enhancement>? list) {
    List<Widget> icons = [];

    if (list == null) {
      icons.add(
        Padding(
          padding: const EdgeInsets.only(right: smallPadding / 2),
          child: SvgPicture.asset(
            'images/plus_one.svg',
            height: iconSize,
            width: iconSize,
          ),
        ),
      );
    } else {
      for (final Enhancement enhancement in list) {
        icons.add(
          Padding(
            padding: const EdgeInsets.only(right: smallPadding / 2),
            child: SvgPicture.asset(
              'images/${enhancement.iconPath}',
              height: iconSize,
              width: iconSize,
              colorFilter:
                  SharedPrefs().darkTheme && enhancement.invertIconColor
                      ? const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        )
                      : null,
            ),
          ),
        );
      }
    }

    return icons;
  }

  @override
  Widget build(BuildContext context) {
    // Cache theme settings used throughout the dialog
    final darkTheme = SharedPrefs().darkTheme;
    final gloomhavenMode = SharedPrefs().gloomhavenMode;

    // Configure dialog content based on category
    if (widget.category != null) {
      switch (widget.category) {
        case EnhancementCategory.charPlusOne:
        case EnhancementCategory.target:
          _bodyText = Strings.plusOneCharacterInfoBody(
            context,
            gloomhavenMode,
            darkTheme,
          );
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.charPlusOne ||
                    element.category == EnhancementCategory.target,
              )
              .toList();
          break;

        case EnhancementCategory.summonPlusOne:
          _bodyText = Strings.plusOneSummonInfoBody(
            context,
            gloomhavenMode,
            darkTheme,
          );
          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (element) =>
                    element.category == EnhancementCategory.summonPlusOne,
              )
              .toList();
          break;

        case EnhancementCategory.negEffect:
          _bodyText = Strings.negEffectInfoBody(context, darkTheme);
          _titleIcons = EnhancementData.enhancements
              .where(
                (element) => element.category == EnhancementCategory.negEffect,
              )
              .toList();

          // Remove Disarm if we're using Frosthaven rules or Ward if we're using Gloomhaven rules
          _titleIcons.removeWhere(
            (element) => gloomhavenMode
                ? element.name == 'Ward'
                : element.name == 'Disarm',
          );

          _eligibleForIcons = EnhancementData.enhancements
              .where(
                (enhancement) =>
                    enhancement.category == EnhancementCategory.negEffect ||
                    ['Attack', 'Push', 'Pull'].contains(enhancement.name) &&
                        enhancement.category !=
                            EnhancementCategory.summonPlusOne,
              )
              .toList()
            ..add(
              Enhancement(
                EnhancementCategory.negEffect,
                'Stun',
                ghCost: 0,
                iconPath: 'stun.svg',
              ),
            );
          break;

        case EnhancementCategory.posEffect:
          _bodyText = Strings.posEffectInfoBody(context, darkTheme);
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
                      'Ward',
                    ].contains(element.name),
              )
              .toList()
            ..removeWhere(
              (element) => element.name == 'Ward' && gloomhavenMode,
            )
            ..add(
              Enhancement(
                EnhancementCategory.posEffect,
                'Invisible',
                ghCost: 0,
                iconPath: 'invisible.svg',
              ),
            );
          break;

        case EnhancementCategory.jump:
          _bodyText = Strings.jumpInfoBody(context, darkTheme);
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

        case EnhancementCategory.specElem:
          _bodyText = Strings.specificElementInfoBody(
            context,
            gloomhavenMode,
            darkTheme,
          );
          _titleIcons = [
            Enhancement(
              EnhancementCategory.specElem,
              'Specific Element',
              ghCost: 100,
              iconPath: 'elem_air.svg',
            ),
            Enhancement(
              EnhancementCategory.specElem,
              'Specific Element',
              ghCost: 100,
              iconPath: 'elem_earth.svg',
            ),
            Enhancement(
              EnhancementCategory.specElem,
              'Specific Element',
              ghCost: 100,
              iconPath: 'elem_fire.svg',
            ),
            Enhancement(
              EnhancementCategory.specElem,
              'Specific Element',
              ghCost: 100,
              iconPath: 'elem_ice.svg',
            ),
            Enhancement(
              EnhancementCategory.specElem,
              'Specific Element',
              ghCost: 100,
              iconPath: 'elem_dark.svg',
            ),
            Enhancement(
              EnhancementCategory.specElem,
              'Specific Element',
              ghCost: 100,
              iconPath: 'elem_light.svg',
            )
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
              .toList()
            ..add(
              Enhancement(
                EnhancementCategory.posEffect,
                'Invisible',
                ghCost: 0,
                iconPath: 'invisible.svg',
              ),
            );
          break;

        case EnhancementCategory.anyElem:
          _bodyText = Strings.anyElementInfoBody(
            context,
            gloomhavenMode,
            darkTheme,
          );
          _titleIcons = EnhancementData.enhancements
              .where(
                (element) => element.category == EnhancementCategory.anyElem,
              )
              .toList();
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
              .toList()
            ..add(
              Enhancement(
                EnhancementCategory.posEffect,
                'Invisible',
                ghCost: 0,
                iconPath: 'invisible.svg',
              ),
            );
          break;

        case EnhancementCategory.hex:
          _bodyText = Strings.hexInfoBody(context, darkTheme);
          _titleIcons = [
            EnhancementData.enhancements.firstWhere(
                (element) => element.category == EnhancementCategory.hex)
          ];
          _eligibleForIcons = [
            EnhancementData.enhancements.firstWhere(
                (element) => element.category == EnhancementCategory.hex)
          ];
          break;

        default:
          break;
      }
    }

    return AlertDialog(
      title: widget.title == null
          ? Center(
              child: Wrap(
                runSpacing: smallPadding,
                spacing: smallPadding,
                alignment: WrapAlignment.center,
                children: _createIconsListForDialog(_titleIcons),
              ),
            )
          : Center(
              child: Text(
                widget.title!,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: maxDialogWidth,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // If title isn't provided, display eligible enhancements
              if (widget.title == null)
                Column(
                  children: <Widget>[
                    const Text(
                      'Eligible For',
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
                  ],
                ),
              widget.message ?? _bodyText,
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Got it!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
