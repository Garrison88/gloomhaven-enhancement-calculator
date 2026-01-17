import 'package:flutter/material.dart';

import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/models/game_edition.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class EnhancementCalculatorModel with ChangeNotifier {
  int _cardLevel = SharedPrefs().targetCardLvl;

  int _previousEnhancements = SharedPrefs().previousEnhancements;

  Enhancement? _enhancement = SharedPrefs().enhancementTypeIndex != 0
      ? EnhancementData.enhancements[SharedPrefs().enhancementTypeIndex]
      : null;

  bool _multipleTargets = SharedPrefs().multipleTargetsSwitch;

  bool _lostNonPersistent = SharedPrefs().lostNonPersistent;

  bool _persistent = SharedPrefs().persistent;

  bool _disableMultiTargetsSwitch = SharedPrefs().disableMultiTargetSwitch;

  bool _temporaryEnhancementMode = SharedPrefs().temporaryEnhancementMode;

  bool _hailsDiscount = SharedPrefs().hailsDiscount;

  bool showCost = false;

  int totalCost = 0;

  int get cardLevel => _cardLevel;

  set cardLevel(int cardLevel) {
    SharedPrefs().targetCardLvl = cardLevel;
    _cardLevel = cardLevel;
    calculateCost();
  }

  int cardLevelPenalty(int level) {
    if (level == 0) {
      return 0;
    }
    int penalty = 25 * level;
    final edition = SharedPrefs().gameEdition;
    if (edition.supportsPartyBoon) {
      // Party boon: GH and GH2E
      if (SharedPrefs().partyBoon) {
        penalty -= 5 * level;
      }
    } else if (edition.hasEnhancerLevels && SharedPrefs().enhancerLvl3) {
      // Enhancer level 3: FH only
      penalty -= 10 * level;
    }
    return penalty;
  }

  int get previousEnhancements => _previousEnhancements;

  set previousEnhancements(int previousEnhancements) {
    SharedPrefs().previousEnhancements = previousEnhancements;
    _previousEnhancements = previousEnhancements;
    calculateCost();
  }

  int previousEnhancementsPenalty(int previousEnhancements) {
    if (previousEnhancements == 0) {
      return 0;
    }
    int penalty = 75 * previousEnhancements;
    final edition = SharedPrefs().gameEdition;
    if (edition.hasEnhancerLevels && SharedPrefs().enhancerLvl4) {
      // Enhancer level 4: FH only
      penalty -= 25 * previousEnhancements;
    }
    if (temporaryEnhancementMode) {
      penalty -= 20;
    }
    return penalty;
  }

  int _temporaryEnhancementMutator(int cost) {
    return (cost * 0.8).ceil();
  }

  Enhancement? get enhancement => _enhancement;

  set enhancement(Enhancement? enhancement) {
    if (enhancement != null) {
      SharedPrefs().enhancementTypeIndex = EnhancementData.enhancements.indexOf(
        enhancement,
      );
    }
    _enhancement = enhancement;
  }

  /// Multiply the cost by 2 if [_multipleTargets]
  /// Halve the cost if [_lostNonPersistent] (GH2E/FH only)
  /// Triple the cost if [_persistent] (FH only)
  /// Subtract 10 gold if [_enhancerLvl2] (FH only)
  /// Subtract 5 gold if [_hailsDiscount]
  int enhancementCost(Enhancement? enhancement) {
    if (enhancement == null) {
      return 0;
    }
    final edition = SharedPrefs().gameEdition;
    int enhancementCost = enhancement.cost(edition: edition);
    if (multipleTargets &&
        eligibleForMultipleTargets(enhancement, edition: edition)) {
      enhancementCost *= 2;
    }
    // Lost action modifier: GH2E and FH
    if (edition.hasLostModifier && lostNonPersistent) {
      enhancementCost = (enhancementCost / 2).round();
    }
    // Persistent action modifier: FH only
    if (edition.hasPersistentModifier && persistent) {
      enhancementCost *= 3;
    }
    // Enhancer level 2: FH only
    if (edition.hasEnhancerLevels && SharedPrefs().enhancerLvl2) {
      enhancementCost -= 10;
    }
    // Hail's Discount
    if (hailsDiscount) {
      enhancementCost -= 5;
    }
    return enhancementCost.isNegative ? 0 : enhancementCost;
  }

  bool get multipleTargets => _multipleTargets;

  set multipleTargets(bool value) {
    SharedPrefs().multipleTargetsSwitch = value;
    _multipleTargets = value;
    calculateCost();
  }

  bool get disableMultiTargetsSwitch => _disableMultiTargetsSwitch;

  set disableMultiTargetsSwitch(bool value) {
    SharedPrefs().disableMultiTargetSwitch = value;
    _disableMultiTargetsSwitch = value;
  }

  bool get temporaryEnhancementMode => _temporaryEnhancementMode;

  set temporaryEnhancementMode(bool value) {
    SharedPrefs().temporaryEnhancementMode = value;
    _temporaryEnhancementMode = value;
    calculateCost();
  }

  bool get hailsDiscount => _hailsDiscount;

  set hailsDiscount(bool value) {
    SharedPrefs().hailsDiscount = value;
    _hailsDiscount = value;
    calculateCost();
  }

  bool get lostNonPersistent => _lostNonPersistent;

  set lostNonPersistent(bool value) {
    if (value) {
      persistent = false;
    }
    SharedPrefs().lostNonPersistent = value;
    _lostNonPersistent = value;
    calculateCost();
  }

  bool get persistent => _persistent;

  set persistent(bool value) {
    if (value) {
      lostNonPersistent = false;
    }
    SharedPrefs().persistent = value;
    _persistent = value;
    calculateCost();
  }

  void resetCost() {
    cardLevel = 0;
    previousEnhancements = 0;
    _enhancement = null;
    multipleTargets = false;
    disableMultiTargetsSwitch = false;
    totalCost = 0;
    showCost = false;
    lostNonPersistent = false;
    persistent = false;
    SharedPrefs().remove('targetCardLvl');
    SharedPrefs().remove('enhancementsOnTargetAction');
    SharedPrefs().remove('enhancementType');
    SharedPrefs().remove('disableMultiTargetsSwitch');
    SharedPrefs().remove('multipleTargetsSelected');
    SharedPrefs().remove('enhancementCost');
    SharedPrefs().remove('disableMultiTargetsSwitch');
    SharedPrefs().remove('lostNonPersistent');
    SharedPrefs().remove('persistent');
    notifyListeners();
  }

  void calculateCost({bool notify = true}) {
    /// get the base cost of the selected enhancement
    totalCost = enhancementCost(enhancement);

    /// add 25g for each [cardLevel] beyond 1
    totalCost += cardLevelPenalty(cardLevel);

    /// add 75g for each [previousEnhancement]
    totalCost += previousEnhancementsPenalty(previousEnhancements);

    /// Temporary Enhancement: if there is at least one previous enhancement,
    /// reduce the cost by 20 gold. Then reduce the entire cost by 20%, rouded
    /// up
    if (temporaryEnhancementMode) {
      totalCost = _temporaryEnhancementMutator(totalCost);
    }

    /// only show cost if there's a price to display
    showCost =
        cardLevel != 0 || previousEnhancements != 0 || enhancement != null;
    if (notify) {
      notifyListeners();
    }
  }

  void gameVersionToggled() {
    final edition = SharedPrefs().gameEdition;

    // Clear persistent if switching to an edition that doesn't support it
    if (!edition.hasPersistentModifier && persistent) {
      persistent = false;
    }

    // Clear lostNonPersistent if switching to an edition that doesn't support it
    if (!edition.hasLostModifier && lostNonPersistent) {
      lostNonPersistent = false;
    }

    if (enhancement != null) {
      enhancementSelected(enhancement!);
    }
    notifyListeners();
  }

  void enhancementSelected(Enhancement selectedEnhancement) {
    final edition = SharedPrefs().gameEdition;

    // Handle the case where the user has an enhancement selected that's not
    // available in the current edition (e.g., Disarm in GH2E/FH, Ward in GH,
    // Regenerate in GH2E)
    if (!EnhancementData.isAvailableInEdition(selectedEnhancement, edition)) {
      _enhancement = null;
      SharedPrefs().remove('enhancementType');
      notifyListeners();
      return;
    }

    switch (selectedEnhancement.category) {
      case EnhancementCategory.title:
        return;
      case EnhancementCategory.target:
        // Target: multi-target applies in GH only
        multipleTargets = edition.multiTargetAppliesToAll;
        disableMultiTargetsSwitch = true;
        break;
      case EnhancementCategory.hex:
        multipleTargets = false;
        disableMultiTargetsSwitch = true;
        break;
      case EnhancementCategory.anyElem:
      case EnhancementCategory.specElem:
        // Elements: multi-target applies in GH only
        if (!edition.multiTargetAppliesToAll) {
          multipleTargets = false;
          disableMultiTargetsSwitch = true;
        } else {
          disableMultiTargetsSwitch = false;
        }
        break;
      case EnhancementCategory.summonPlusOne:
        persistent = false;
        // GH2E: "not a summon action" - summon stats never get lost discount
        // FH: Lost discount can apply if action is lost but not persistent
        if (!edition.hasPersistentModifier) {
          lostNonPersistent = false;
        }
        disableMultiTargetsSwitch = false;
        break;
      default:
        disableMultiTargetsSwitch = false;
        break;
    }
    enhancement = selectedEnhancement;
    calculateCost();
  }

  static bool eligibleForMultipleTargets(
    Enhancement enhancement, {
    required GameEdition edition,
  }) {
    final name = enhancement.name.toLowerCase();
    // Hex is never eligible for multi-target in any edition
    if (name.contains('hex')) {
      return false;
    }
    // In GH, all types except hex are eligible
    if (edition.multiTargetAppliesToAll) {
      return true;
    }
    // In GH2E and FH, target and elements are not eligible
    return !name.contains('target') && !name.contains('element');
  }
}
