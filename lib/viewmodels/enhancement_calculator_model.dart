import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class EnhancementCalculatorModel with ChangeNotifier {
  int _cardLevel = SharedPrefs().targetCardLvl;

  int _previousEnhancements = SharedPrefs().previousEnhancements;

  Enhancement _enhancement = SharedPrefs().enhancementTypeIndex != 0
      ? EnhancementData.enhancements[SharedPrefs().enhancementTypeIndex]
      : null;
  bool _multipleTargets = SharedPrefs().multipleTargetsSwitch;

  bool disableMultiTargetsSwitch = SharedPrefs().disableMultiTargetSwitch;
  bool showCost = false;
  int enhancementCost = 0;

  int get cardLevel => _cardLevel;

  set cardLevel(int cardLevel) {
    SharedPrefs().targetCardLvl = cardLevel;
    _cardLevel = cardLevel;
  }

  int get previousEnhancements => _previousEnhancements;

  set previousEnhancements(int previousEnhancements) {
    SharedPrefs().previousEnhancements = previousEnhancements;
    _previousEnhancements = previousEnhancements;
  }

  Enhancement get enhancement => _enhancement;

  set enhancement(Enhancement enhancement) {
    SharedPrefs().enhancementTypeIndex =
        EnhancementData.enhancements.indexOf(enhancement);
    _enhancement = enhancement;
  }

  bool get multipleTargets => _multipleTargets;

  set multipleTargets(bool multipleTargets) {
    SharedPrefs().multipleTargetsSwitch = multipleTargets;
    _multipleTargets = multipleTargets;
  }

  void resetCost() {
    cardLevel = 0;
    previousEnhancements = 0;
    _enhancement = null;
    multipleTargets = false;
    disableMultiTargetsSwitch = false;
    enhancementCost = 0;
    showCost = false;
    SharedPrefs().remove('targetCardLvl');
    SharedPrefs().remove('enhancementsOnTargetAction');
    SharedPrefs().remove('enhancementType');
    SharedPrefs().remove('disableMultiTargetsSwitch');
    SharedPrefs().remove('multipleTargetsSelected');
    SharedPrefs().remove('enhancementCost');
    SharedPrefs().remove('disableMultiTargetsSwitch');
    notifyListeners();
  }

  void calculateCost({bool notify = true}) {
    int baseCost = enhancement != null && enhancement.baseCost != null
        ? enhancement.baseCost
        : 0;
    int enhancementCost =
        // add 25g for each card level beyond 1 (20 if 'Party Boon' is enabled)
        (cardLevel != null && cardLevel > 0
                ? cardLevel * (SharedPrefs().partyBoon ? 20 : 25)
                : 0) +
            // add 75g for each previous enhancement on target action
            (previousEnhancements != null ? previousEnhancements * 75 : 0) +
            // multiply base cost x2 if multiple targets switch is true
            (multipleTargets ? baseCost * 2 : baseCost);
    this.enhancementCost = enhancementCost;
    disableMultiTargetsSwitch = SharedPrefs().disableMultiTargetSwitch;
    showCost =
        cardLevel != 0 || previousEnhancements != 0 || enhancement != null;
    if (notify) {
      notifyListeners();
    }
  }

  void enhancementSelected(Enhancement selectedEnhancement) {
    switch (selectedEnhancement.category) {
      case EnhancementCategory.title:
        return;
      case EnhancementCategory.target:
        multipleTargets = true;
        SharedPrefs().multipleTargetsSwitch = true;
        disableMultiTargetsSwitch = true;
        SharedPrefs().disableMultiTargetSwitch = true;
        enhancement = selectedEnhancement;
        break;
      case EnhancementCategory.hex:
        multipleTargets = false;
        SharedPrefs().multipleTargetsSwitch = false;
        disableMultiTargetsSwitch = true;
        SharedPrefs().disableMultiTargetSwitch = true;
        enhancement = selectedEnhancement;
        break;
      default:
        disableMultiTargetsSwitch = false;
        SharedPrefs().disableMultiTargetSwitch = false;
        enhancement = selectedEnhancement;
        break;
    }
    SharedPrefs().enhancementTypeIndex =
        EnhancementData.enhancements.indexOf(selectedEnhancement);
    calculateCost();
  }
}
