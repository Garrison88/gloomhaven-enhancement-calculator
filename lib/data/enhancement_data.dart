import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/game_edition.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';
import 'package:provider/provider.dart';

import '../models/enhancement.dart';

enum EnhancementCategory {
  charPlusOne,
  target,
  summonPlusOne,
  posEffect,
  negEffect,
  jump,
  specElem,
  anyElem,
  hex;

  /// Returns the section title for this category
  String get sectionTitle {
    switch (this) {
      case EnhancementCategory.charPlusOne:
      case EnhancementCategory.target:
        return 'Character';
      case EnhancementCategory.summonPlusOne:
        return 'Summon';
      case EnhancementCategory.posEffect:
      case EnhancementCategory.negEffect:
      case EnhancementCategory.jump:
      case EnhancementCategory.specElem:
      case EnhancementCategory.anyElem:
        return 'Effect';
      case EnhancementCategory.hex:
        return 'Current Hexes';
    }
  }

  /// Returns the asset key for the section icon, if any
  String? get sectionAssetKey {
    switch (this) {
      case EnhancementCategory.charPlusOne:
      case EnhancementCategory.target:
      case EnhancementCategory.summonPlusOne:
        return 'plus_one';
      case EnhancementCategory.hex:
        return 'hex';
      default:
        return null;
    }
  }
}

class EnhancementData {
  static final List<Enhancement> enhancements = [
    // Character +1 stats
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Move',
      ghCost: 30,
      assetKey: 'MOVE',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Attack',
      ghCost: 50,
      assetKey: 'ATTACK',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Range',
      ghCost: 30,
      assetKey: 'RANGE',
    ),
    Enhancement(
      EnhancementCategory.target,
      'Target',
      ghCost: 50,
      assetKey: 'TARGET_CIRCLE',
      fhCost: 75,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Shield',
      ghCost: 100,
      assetKey: 'SHIELD',
      fhCost: 80,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Retaliate',
      ghCost: 100,
      assetKey: 'RETALIATE',
      fhCost: 60,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Pierce',
      ghCost: 30,
      assetKey: 'PIERCE',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Heal',
      ghCost: 30,
      assetKey: 'HEAL',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Push',
      ghCost: 30,
      assetKey: 'PUSH',
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Pull',
      ghCost: 30,
      assetKey: 'PULL',
      fhCost: 20,
    ),
    Enhancement(
      EnhancementCategory.charPlusOne,
      'Teleport',
      ghCost: 40,
      assetKey: 'TELEPORT',
      fhCost: 50,
    ),
    // Summon +1 stats
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'HP',
      ghCost: 50,
      assetKey: 'hp',
      fhCost: 40,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'Move',
      ghCost: 100,
      assetKey: 'MOVE',
      fhCost: 60,
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'Attack',
      ghCost: 100,
      assetKey: 'ATTACK',
    ),
    Enhancement(
      EnhancementCategory.summonPlusOne,
      'Range',
      ghCost: 50,
      assetKey: 'RANGE',
    ),
    // Effects (positive)
    Enhancement(
      EnhancementCategory.posEffect,
      'Regenerate',
      ghCost: 50,
      assetKey: 'REGENERATE',
      fhCost: 40,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      'Ward',
      ghCost: 75,
      assetKey: 'WARD',
      fhCost: 75,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      'Strengthen',
      ghCost: 50,
      assetKey: 'STRENGTHEN',
      fhCost: 100,
    ),
    Enhancement(
      EnhancementCategory.posEffect,
      'Bless',
      ghCost: 50,
      assetKey: 'BLESS',
      fhCost: 75,
    ),
    // negative effects
    Enhancement(
      EnhancementCategory.negEffect,
      'Wound',
      ghCost: 75,
      assetKey: 'WOUND',
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Poison',
      ghCost: 75,
      assetKey: 'POISON',
      fhCost: 50,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Immobilize',
      ghCost: 100,
      assetKey: 'IMMOBILIZE',
      fhCost: 150,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Muddle',
      ghCost: 50,
      assetKey: 'MUDDLE',
      fhCost: 40,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Curse',
      ghCost: 75,
      assetKey: 'CURSE',
      fhCost: 150,
    ),
    Enhancement(
      EnhancementCategory.negEffect,
      'Disarm',
      ghCost: 150,
      assetKey: 'DISARM',
    ),
    Enhancement(
      EnhancementCategory.jump,
      'Jump',
      ghCost: 50,
      assetKey: 'JUMP',
      fhCost: 60,
    ),
    Enhancement(
      EnhancementCategory.specElem,
      'Element',
      ghCost: 100,
      assetKey: 'FIRE',
    ),
    Enhancement(
      EnhancementCategory.anyElem,
      'Wild Element',
      ghCost: 150,
      assetKey: 'Wild_Element',
    ),
    // Current Hexes
    Enhancement(
      EnhancementCategory.hex,
      '2 hexes',
      ghCost: 100,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '3 hexes',
      ghCost: 66,
      fhCost: 67,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '4 hexes',
      ghCost: 50,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '5 hexes',
      ghCost: 40,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '6 hexes',
      ghCost: 33,
      fhCost: 34,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '7 hexes',
      ghCost: 28,
      fhCost: 29,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '8 hexes',
      ghCost: 25,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '9 hexes',
      ghCost: 22,
      fhCost: 23,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '10 hexes',
      ghCost: 20,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '11 hexes',
      ghCost: 18,
      fhCost: 19,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '12 hexes',
      ghCost: 16,
      fhCost: 17,
      assetKey: 'hex',
    ),
    Enhancement(
      EnhancementCategory.hex,
      '13 hexes',
      ghCost: 15,
      fhCost: 16,
      assetKey: 'hex',
    ),
  ];

  static List<DropdownMenuItem<int>> cardLevels(
    BuildContext context, {
    required bool partyBoon,
    required bool enhancerLvl3,
  }) {
    EnhancementCalculatorModel enhancementCalculatorModel = Provider.of(
      context,
      listen: false,
    );
    List<DropdownMenuItem<int>> list = [];
    for (int x = 0; x <= 8; x++) {
      list.add(
        DropdownMenuItem(
          value: x,
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                if (x == 0)
                  const TextSpan(text: '1 / x')
                else ...[
                  TextSpan(text: '${x + 1} ('),
                  if (enhancerLvl3 || (!enhancerLvl3 && partyBoon)) ...[
                    TextSpan(
                      text: '${25 * x}g',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text:
                          '${enhancementCalculatorModel.cardLevelPenalty(x)}g',
                      // style: Theme.of(context).textTheme.bodyMedium.copyWith(
                      //       color: Colors.green,
                      //     ),
                    ),
                    const TextSpan(text: ')'),
                  ] else ...[
                    TextSpan(text: '${25 * x}g)'),
                  ],
                ],
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  static List<DropdownMenuItem<int>> previousEnhancements(
    BuildContext context, {
    bool enhancerLvl4 = false,
    bool tempEnhancements = false,
  }) {
    EnhancementCalculatorModel enhancementCalculatorModel = Provider.of(
      context,
      listen: false,
    );
    List<DropdownMenuItem<int>> list = [];
    for (int x = 0; x <= 3; x++) {
      list.add(
        DropdownMenuItem(
          value: x,
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: <TextSpan>[
                if (x == 0)
                  const TextSpan(text: 'None')
                else ...[
                  TextSpan(text: '$x ('),
                  if (enhancerLvl4 || tempEnhancements) ...[
                    TextSpan(
                      text: '${75 * x}g',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text:
                          '${enhancementCalculatorModel.previousEnhancementsPenalty(x)}g${tempEnhancements ? ' †' : ''}',
                    ),
                    const TextSpan(text: ')'),
                  ] else ...[
                    TextSpan(text: '${75 * x}g)'),
                  ],
                ],
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

  /// Returns true if the enhancement is available in the given edition
  static bool isAvailableInEdition(
    Enhancement enhancement,
    GameEdition edition,
  ) {
    switch (enhancement.name) {
      case 'Disarm':
        // Disarm is only available in original Gloomhaven
        return edition == GameEdition.gloomhaven;
      case 'Ward':
        // Ward is available in GH2E and Frosthaven, not original GH
        return edition != GameEdition.gloomhaven;
      default:
        return true;
    }
  }

}
