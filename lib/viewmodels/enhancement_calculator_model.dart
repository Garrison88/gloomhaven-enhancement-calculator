import 'package:flutter/material.dart';

import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
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

  bool showCost = false;

  int totalCost = 0;

  int get cardLevel => _cardLevel;

  set cardLevel(int cardLevel) {
    SharedPrefs().targetCardLvl = cardLevel;
    _cardLevel = cardLevel;
    calculateCost();
  }

  int cardLevelPenalty(
    int level,
  ) {
    if (level == 0) {
      return 0;
    }
    int penalty = 25 * level;
    if (SharedPrefs().gloomhavenMode) {
      if (SharedPrefs().partyBoon) {
        penalty -= 5 * level;
      }
    } else if (SharedPrefs().enhancerLvl3) {
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

  int previousEnhancementsPenalty(
    int previousEnhancements,
  ) {
    if (previousEnhancements == 0) {
      return 0;
    }
    int penalty = 75 * previousEnhancements;
    if (!SharedPrefs().gloomhavenMode && SharedPrefs().enhancerLvl4) {
      penalty -= 25 * previousEnhancements;
    }
    if (temporaryEnhancementMode) {
      penalty -= 20;
    }
    return penalty;
  }

  int _temporaryEnhancementMutator(
    int cost,
  ) {
    return (cost * 0.8).ceil();
  }

  Enhancement? get enhancement => _enhancement;

  set enhancement(Enhancement? enhancement) {
    if (enhancement != null) {
      SharedPrefs().enhancementTypeIndex =
          EnhancementData.enhancements.indexOf(enhancement);
    }
    _enhancement = enhancement;
  }

  /// Multiply the cost by 2 if [_multipleTargets]
  /// Halve the cost if [_lostNonPersistent]
  /// Triple the cost if [_persistent]
  /// Subtract 10 gold if [_enhancerLvl2]
  int enhancementCost(
    Enhancement? enhancement,
  ) {
    if (enhancement == null) {
      return 0;
    }
    int enhancementCost = enhancement.cost(
      gloomhavenMode: SharedPrefs().gloomhavenMode,
    );
    if (multipleTargets &&
        eligibleForMultipleTargets(
          enhancement,
          gloomhavenMode: SharedPrefs().gloomhavenMode,
        )) {
      enhancementCost *= 2;
    }
    if (!SharedPrefs().gloomhavenMode) {
      enhancementCost =
          lostNonPersistent ? (enhancementCost / 2).round() : enhancementCost;
      enhancementCost = persistent ? enhancementCost * 3 : enhancementCost;
    }
    if (!SharedPrefs().gloomhavenMode && SharedPrefs().enhancerLvl2) {
      enhancementCost -= 10;
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

  void calculateCost({
    bool notify = true,
  }) {
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
      totalCost = _temporaryEnhancementMutator(
        totalCost,
      );
    }

    /// only show cost if there's a price to display
    showCost =
        cardLevel != 0 || previousEnhancements != 0 || enhancement != null;
    if (notify) {
      notifyListeners();
    }
  }

  void gameVersionToggled() {
    if (enhancement != null) {
      enhancementSelected(enhancement!);
    }
    notifyListeners();
  }

  void enhancementSelected(Enhancement selectedEnhancement) {
    // This is to handle the case where the user has disarm or ward selected,
    // and flips the game version switch
    if ((!SharedPrefs().gloomhavenMode &&
            selectedEnhancement.name == 'Disarm') ||
        (SharedPrefs().gloomhavenMode && selectedEnhancement.name == 'Ward')) {
      _enhancement = null;
      SharedPrefs().remove('enhancementType');
      notifyListeners();
      return;
    }
    switch (selectedEnhancement.category) {
      case EnhancementCategory.title:
        return;
      case EnhancementCategory.target:
        multipleTargets = SharedPrefs().gloomhavenMode;
        disableMultiTargetsSwitch = true;
        break;
      case EnhancementCategory.hex:
        multipleTargets = false;
        disableMultiTargetsSwitch = true;
        break;
      case EnhancementCategory.anyElem:
      case EnhancementCategory.specElem:
        if (!SharedPrefs().gloomhavenMode) {
          multipleTargets = false;
          disableMultiTargetsSwitch = true;
        } else {
          disableMultiTargetsSwitch = false;
        }
        break;
      case EnhancementCategory.summonPlusOne:
        persistent = false;
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
    required bool gloomhavenMode,
  }) {
    return gloomhavenMode && !enhancement.name.toLowerCase().contains('hex') ||
        (!gloomhavenMode &&
            (!enhancement.name.toLowerCase().contains('hex') &&
                (!enhancement.name.toLowerCase().contains('target') &&
                    (!enhancement.name.toLowerCase().contains('element')))));
  }
}
