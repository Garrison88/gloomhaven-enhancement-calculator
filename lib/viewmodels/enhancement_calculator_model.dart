import 'package:flutter/material.dart';
import '../data/enhancement_data.dart';
import '../models/enhancement.dart';
import '../shared_prefs.dart';

class EnhancementCalculatorModel with ChangeNotifier {
  int _cardLevel = SharedPrefs().targetCardLvl;

  int _previousEnhancements = SharedPrefs().previousEnhancements;

  Enhancement _enhancement = SharedPrefs().enhancementTypeIndex != 0
      ? EnhancementData.enhancements[SharedPrefs().enhancementTypeIndex]
      : null;
  bool _multipleTargets = SharedPrefs().multipleTargetsSwitch;
  bool _lossNonPersistent = SharedPrefs().lossNonPersistent;
  bool _persistent = SharedPrefs().persistent;

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

  bool get lossNonPersistent => _lossNonPersistent;

  set lossNonPersistent(bool lossNonPersistent) {
    SharedPrefs().lossNonPersistent = lossNonPersistent;
    _lossNonPersistent = lossNonPersistent;
  }

  bool get persistent => _persistent;

  set persistent(bool persistent) {
    // does NOT apply to summon stat enhancements
    if (persistent) {
      lossNonPersistent = false;
    }
    SharedPrefs().persistent = persistent;
    _persistent = persistent;
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

  void calculateCost({
    bool notify = true,
  }) {
    int baseCost = enhancement != null && enhancement.ghCost != null
        ? SharedPrefs().gloomhavenEnhancementCosts
            ? enhancement.ghCost
            : enhancement.fhCost ?? enhancement.ghCost
        : 0;
    if (!SharedPrefs().gloomhavenEnhancementCosts) {
      if (persistent) {
        baseCost = baseCost * 3;
      } else if (lossNonPersistent) {
        baseCost = (baseCost / 2).round();
      }
    }
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

  void gameVersionToggled(bool value) {
    enhancementSelected(enhancement);
    calculateCost();
  }

  void enhancementSelected(Enhancement selectedEnhancement) {
    switch (selectedEnhancement.category) {
      case EnhancementCategory.title:
        return;
      case EnhancementCategory.target:
        multipleTargets = SharedPrefs().gloomhavenEnhancementCosts;
        SharedPrefs().multipleTargetsSwitch =
            SharedPrefs().gloomhavenEnhancementCosts;
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
      case EnhancementCategory.anyElem:
      case EnhancementCategory.specElem:
        if (!SharedPrefs().gloomhavenEnhancementCosts) {
          multipleTargets = false;
          SharedPrefs().multipleTargetsSwitch = false;
          disableMultiTargetsSwitch = true;
          SharedPrefs().disableMultiTargetSwitch = true;
          enhancement = selectedEnhancement;
        } else {
          disableMultiTargetsSwitch = false;
          SharedPrefs().disableMultiTargetSwitch = false;
        }
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
