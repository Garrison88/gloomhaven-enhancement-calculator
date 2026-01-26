import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/l10n/app_localizations.dart';
import 'package:gloomhaven_enhancement_calc/models/game_edition.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/info_dialog.dart';
import 'package:gloomhaven_enhancement_calc/utils/themed_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

/// The body content for the combined modifier toggles card.
///
/// Contains toggles for:
/// - Multiple Targets
/// - Loss Non-Persistent (GH2E/FH only)
/// - Persistent (FH only)
class ModifierTogglesBody extends StatelessWidget {
  final EnhancementCalculatorModel model;
  final GameEdition edition;
  final bool darkTheme;

  const ModifierTogglesBody({
    super.key,
    required this.model,
    required this.edition,
    required this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // MULTIPLE TARGETS
        _buildMultipleTargetsToggle(context),
        // LOSS NON-PERSISTENT (GH2E and FH only)
        if (edition.hasLostModifier) _buildLostNonPersistentToggle(context),
        // PERSISTENT (FH only)
        if (edition.hasPersistentModifier) _buildPersistentToggle(context),
      ],
    );
  }

  Widget _buildMultipleTargetsToggle(BuildContext context) {
    return SwitchListTile(
      value: model.multipleTargets,
      onChanged: !model.disableMultiTargetsSwitch
          ? (bool value) {
              model.multipleTargets = value;
            }
          : null,
      secondary: IconButton(
        icon: Icon(
          Icons.info_outline_rounded,
          color: darkTheme ? Colors.white : Colors.black,
        ),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) {
            return InfoDialog(
              title: Strings.multipleTargetsInfoTitle,
              message: Strings.multipleTargetsInfoBody(
                context,
                edition: edition,
                enhancerLvl2:
                    edition.hasEnhancerLevels && SharedPrefs().enhancerLvl2,
                darkMode: darkTheme,
              ),
            );
          },
        ),
      ),
      title: AutoSizeText(AppLocalizations.of(context).multipleTargets),
    );
  }

  Widget _buildLostNonPersistentToggle(BuildContext context) {
    // Disable when: persistent is on (FH), OR
    // in GH2E mode with summon stat selected (summons excluded)
    final isDisabled = model.persistent ||
        (!edition.hasPersistentModifier &&
            model.enhancement?.category == EnhancementCategory.summonPlusOne);

    return SwitchListTile(
      value: model.lostNonPersistent,
      onChanged: isDisabled
          ? null
          : (bool value) {
              model.lostNonPersistent = value;
            },
      secondary: IconButton(
        icon: Icon(
          Icons.info_outline_rounded,
          color: darkTheme ? Colors.white : Colors.black,
        ),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) {
            return InfoDialog(
              title: Strings.lostNonPersistentInfoTitle(edition: edition),
              message: Strings.lostNonPersistentInfoBody(
                context,
                edition,
                darkTheme,
              ),
            );
          },
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ThemedSvg(assetKey: 'LOSS', width: iconSize),
          // Only show "not persistent" icon in FH mode
          // (GH2E doesn't have persistent modifier)
          if (edition.hasPersistentModifier)
            SizedBox(
              width: iconSize + 16,
              height: iconSize + 11,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: ThemedSvg(
                      assetKey: 'PERSISTENT',
                      width: iconSize,
                    ),
                  ),
                  Positioned(
                    right: 5,
                    child: SvgPicture.asset(
                      'images/ui/not.svg',
                      width: iconSize + 11,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersistentToggle(BuildContext context) {
    final isDisabled =
        model.enhancement?.category == EnhancementCategory.summonPlusOne ||
            model.lostNonPersistent;

    return SwitchListTile(
      value: model.persistent,
      onChanged: isDisabled
          ? null
          : (bool value) {
              model.persistent = value;
            },
      secondary: IconButton(
        icon: Icon(
          Icons.info_outline_rounded,
          color: darkTheme ? Colors.white : Colors.black,
        ),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) {
            return InfoDialog(
              title: Strings.persistentInfoTitle,
              message: Strings.persistentInfoBody(context, darkTheme),
            );
          },
        ),
      ),
      title: ThemedSvg(
        assetKey: 'PERSISTENT',
        width: iconSize,
      ),
    );
  }
}

