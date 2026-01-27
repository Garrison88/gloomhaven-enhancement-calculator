import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/l10n/app_localizations.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/models/game_edition.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/enhancement_type_selector.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/strikethrough_text.dart';
import 'package:gloomhaven_enhancement_calc/utils/themed_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

/// The body content for the Enhancement Type selector card.
///
/// Contains a tappable button that opens a bottom sheet for selecting
/// enhancement types, and displays the current selection with its cost.
class EnhancementTypeBody extends StatelessWidget {
  final EnhancementCalculatorModel model;
  final GameEdition edition;

  const EnhancementTypeBody({
    super.key,
    required this.model,
    required this.edition,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final enhancement = model.enhancement;

    return InkWell(
      onTap: () {
        EnhancementTypeSelector.show(
          context,
          currentSelection: enhancement,
          edition: edition,
          onSelected: (selected) {
            model.enhancementSelected(selected);
          },
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: enhancement != null
                  ? _buildSelectedEnhancement(context, enhancement)
                  : Text(
                      AppLocalizations.of(context).type,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedEnhancement(
    BuildContext context,
    Enhancement enhancement,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPlusOne =
        enhancement.category == EnhancementCategory.charPlusOne ||
        enhancement.category == EnhancementCategory.target ||
        enhancement.category == EnhancementCategory.summonPlusOne;

    final baseCost = enhancement.cost(edition: edition);
    final discountedCost = model.enhancementCost(enhancement);
    final hasDiscount = discountedCost != baseCost;

    return Row(
      children: [
        if (enhancement.assetKey != null) ...[
          _buildEnhancementIcon(enhancement, isPlusOne),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(enhancement.name, style: theme.textTheme.bodyMedium),
        ),
        // Cost display
        hasDiscount
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StrikethroughText(
                    '${baseCost}g',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${discountedCost}g',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text(
                '${baseCost}g',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
      ],
    );
  }

  Widget _buildEnhancementIcon(Enhancement enhancement, bool isPlusOne) {
    if (enhancement.name == 'Element') {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              top: 5,
              left: 5,
              child: SvgPicture.asset(
                'images/elements/elem_dark.svg',
                width: 10,
              ),
            ),
            Positioned(
              top: 4,
              left: 7,
              child: SvgPicture.asset(
                'images/elements/elem_air.svg',
                width: 11,
              ),
            ),
            Positioned(
              top: 3,
              right: 6,
              child: SvgPicture.asset(
                'images/elements/elem_ice.svg',
                width: 12,
              ),
            ),
            Positioned(
              top: 0,
              right: 2,
              bottom: 2,
              child: SvgPicture.asset(
                'images/elements/elem_fire.svg',
                width: 13,
              ),
            ),
            Positioned(
              bottom: 1,
              right: 4,
              child: SvgPicture.asset(
                'images/elements/elem_earth.svg',
                width: 14,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 3,
              child: SvgPicture.asset(
                'images/elements/elem_light.svg',
                width: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ThemedSvg(
      assetKey: enhancement.assetKey!,
      width: iconSize,
      showPlusOneOverlay: isPlusOne,
    );
  }
}
