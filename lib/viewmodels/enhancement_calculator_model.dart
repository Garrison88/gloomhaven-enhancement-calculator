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

  bool _lostNonPersistent = SharedPrefs().lostNonPersistent;

  bool _persistent = SharedPrefs().persistent;

  bool _disableMultiTargetsSwitch = SharedPrefs().disableMultiTargetSwitch;

  bool showCost = false;

  int enhancementCost = 0;

  int get cardLevel => _cardLevel;

  set cardLevel(int cardLevel) {
    SharedPrefs().targetCardLvl = cardLevel;
    _cardLevel = cardLevel;
    calculateCost();
  }

  int get previousEnhancements => _previousEnhancements;

  set previousEnhancements(int previousEnhancements) {
    SharedPrefs().previousEnhancements = previousEnhancements;
    _previousEnhancements = previousEnhancements;
    calculateCost();
  }

  Enhancement get enhancement => _enhancement;

  set enhancement(Enhancement enhancement) {
    SharedPrefs().enhancementTypeIndex =
        EnhancementData.enhancements.indexOf(enhancement);
    _enhancement = enhancement;
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
    enhancementCost = 0;
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
    enhancementCost = enhancement != null && enhancement.ghCost != null
        ? SharedPrefs().gloomhavenMode
            ? enhancement.ghCost
            : enhancement.fhCost ?? enhancement.ghCost
        : 0;

    /// multiply [baseCost] x2 if [multipleTargets]
    enhancementCost = multipleTargets ? enhancementCost * 2 : enhancementCost;

    /// if Frosthaven
    if (!SharedPrefs().gloomhavenMode) {
      /// halve the cost if [lostNonPersistent]
      enhancementCost =
          lostNonPersistent ? (enhancementCost / 2).round() : enhancementCost;

      /// triple the cost if [persistent]
      enhancementCost = persistent ? enhancementCost * 3 : enhancementCost;
    }

    /// add 25g for each [cardLevel] beyond 1 (20 if 'Party Boon' is enabled)
    enhancementCost += (cardLevel != null && cardLevel > 0
        ? cardLevel * (SharedPrefs().partyBoon ? 20 : 25)
        : 0);

    /// add 75g for each [previousEnhancement]
    enhancementCost +=
        (previousEnhancements != null ? previousEnhancements * 75 : 0);

    /// only show cost if there's a price to display
    showCost =
        cardLevel != 0 || previousEnhancements != 0 || enhancement != null;
    if (notify) {
      notifyListeners();
    }
  }

  void gameVersionToggled(bool value) {
    if (enhancement == null) {
      notifyListeners();
    } else {
      enhancementSelected(enhancement);
    }
  }

  void enhancementSelected(Enhancement selectedEnhancement) {
    if (!SharedPrefs().gloomhavenMode &&
        selectedEnhancement?.name == 'Disarm') {
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
}
