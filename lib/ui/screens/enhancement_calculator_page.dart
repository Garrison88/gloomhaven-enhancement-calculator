import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/constants.dart';
import '../../data/enhancement_data.dart';
import '../../data/strings.dart';
import '../../models/enhancement.dart';
import '../../shared_prefs.dart';
import '../dialogs/info_dialog.dart';

class EnhancementCalculatorPage extends StatefulWidget {
  const EnhancementCalculatorPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnhancementCalculatorPageState();
}

class _EnhancementCalculatorPageState extends State<EnhancementCalculatorPage> {
  bool _disableMultiTargetSwitch = false;
  bool _fabIsVisible = true;
  bool _costIsVisible = true;
  Enhancement _selectedEnhancement;

  @override
  void initState() {
    super.initState();
    _selectedEnhancement = SharedPrefs().enhancementTypeIndex != 0
        ? EnhancementData.enhancements[SharedPrefs().enhancementTypeIndex]
        : null;
  }

  void _resetAllFields() {
    _selectedEnhancement = null;
    _disableMultiTargetSwitch = false;
    SharedPrefs().remove('targetCardLvl');
    SharedPrefs().remove('enhancementsOnTargetAction');
    SharedPrefs().remove('enhancementType');
    SharedPrefs().remove('disableMultiTargetsSwitch');
    SharedPrefs().remove('multipleTargetsSelected');
    SharedPrefs().remove('enhancementCost');
    SharedPrefs().remove('disableMultiTargetsSwitch');
    setState(() {});
  }

  void _handleTypeSelection(Enhancement value) {
    switch (value.category) {
      case EnhancementCategory.title:
        return;
      case EnhancementCategory.target:
        SharedPrefs().multipleTargetsSwitch = true;
        SharedPrefs().disableMultiTargetSwitch = true;
        _selectedEnhancement = value;
        break;
      case EnhancementCategory.hex:
        SharedPrefs().multipleTargetsSwitch = false;
        SharedPrefs().disableMultiTargetSwitch = true;
        _selectedEnhancement = value;
        break;
      default:
        SharedPrefs().disableMultiTargetSwitch = false;
        _selectedEnhancement = value;
        break;
    }
    SharedPrefs().enhancementTypeIndex =
        EnhancementData.enhancements.indexOf(value);
    _updateEnhancementCost();
  }

  void _updateEnhancementCost() {
    int _baseCost =
        _selectedEnhancement != null && _selectedEnhancement.baseCost != null
            ? _selectedEnhancement.baseCost
            : 0;
    SharedPrefs().enhancementCost =
        // add 25g for each card level beyond 1 (20 is 'Party Boon' is enabled)
        (SharedPrefs().targetCardLvl != null && SharedPrefs().targetCardLvl > 0
                ? SharedPrefs().targetCardLvl *
                    (SharedPrefs().partyBoon ? 20 : 25)
                : 0) +
            // add 75g for each previous enhancement on target action
            (SharedPrefs().previousEnhancements != null
                ? SharedPrefs().previousEnhancements * 75
                : 0) +
            // multiply base cost x2 if multiple targets switch is true
            (SharedPrefs().multipleTargetsSwitch ? _baseCost * 2 : _baseCost);
    _disableMultiTargetSwitch = SharedPrefs().disableMultiTargetSwitch;
    if (SharedPrefs().targetCardLvl > 0 ||
        SharedPrefs().previousEnhancements != 0 ||
        _selectedEnhancement != null ||
        SharedPrefs().multipleTargetsSwitch == true) {
      _fabIsVisible = true;
    } else {
      _fabIsVisible = false;
    }
    if (SharedPrefs().targetCardLvl > 0 ||
        SharedPrefs().previousEnhancements != 0 ||
        _selectedEnhancement != null) {
      _costIsVisible = true;
    } else {
      _costIsVisible = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This ensures that enabling Party Boon recalculates the current cost
    _updateEnhancementCost();
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: smallPadding / 2),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) {
                              return InfoDialog(
                                title: Strings.generalInfoTitle,
                                message: Strings.generalInfoBody(context),
                              );
                            },
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).colorScheme.secondary),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.info_outlined,
                            color: ThemeData.estimateBrightnessForColor(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary) ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          label: Text(
                            'General Guidelines',
                            style: TextStyle(
                              color: ThemeData.estimateBrightnessForColor(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                            ),
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) {
                                return InfoDialog(
                                  title: Strings.cardLevelInfoTitle,
                                  message: Strings.cardLevelInfoBody(context),
                                );
                              },
                            ),
                          ),
                          const Text('Card Level:'),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: SharedPrefs().targetCardLvl,
                              items: EnhancementData.cardLevels(
                                  SharedPrefs().partyBoon),
                              onChanged: (int value) {
                                SharedPrefs().targetCardLvl = value;
                                _updateEnhancementCost();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                            ),
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) {
                                return InfoDialog(
                                  title: Strings.previousEnhancementsInfoTitle,
                                  message: Strings.previousEnhancementsInfoBody(
                                      context),
                                );
                              },
                            ),
                          ),
                          const Expanded(
                            child: AutoSizeText(
                              'Previous Enhancements:',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              right: smallPadding,
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              hint: const Text(
                                'None',
                              ),
                              value: SharedPrefs().previousEnhancements,
                              items: EnhancementData.previousEnhancements(),
                              onChanged: (int value) {
                                SharedPrefs().previousEnhancements = value;
                                _updateEnhancementCost();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  disabledColor: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.5),
                                  icon: const Icon(
                                    Icons.info_outline,
                                  ),
                                  onPressed: _selectedEnhancement != null
                                      ? () => showDialog<void>(
                                            context: context,
                                            builder: (_) {
                                              return InfoDialog(
                                                category: _selectedEnhancement
                                                    .category,
                                              );
                                            },
                                          )
                                      : null),
                              const Text(
                                'Enhancement Type:',
                              ),
                              const IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.transparent,
                                  ),
                                  onPressed: null),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<Enhancement>(
                              hint: const Text(
                                'Type',
                              ),
                              value: _selectedEnhancement,
                              items: EnhancementData.enhancementTypes(),
                              onChanged: (Enhancement enhancement) {
                                _handleTypeSelection(enhancement);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                            ),
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) {
                                return InfoDialog(
                                  title: Strings.multipleTargetsInfoTitle,
                                  message:
                                      Strings.multipleTargetsInfoBody(context),
                                );
                              },
                            ),
                          ),
                          const AutoSizeText('Multiple Targets?'),
                          Switch(
                            value: SharedPrefs().multipleTargetsSwitch,
                            onChanged: !_disableMultiTargetSwitch
                                ? (bool value) {
                                    SharedPrefs().multipleTargetsSwitch = value;
                                    _updateEnhancementCost();
                                  }
                                : null,
                          ),
                          const IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.transparent,
                              ),
                              onPressed: null),
                        ],
                      ),
                    ),
                  ],
                ),
                Opacity(
                  opacity: _costIsVisible ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        'Enhancement Cost:',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        '${SharedPrefs().enhancementCost} g',
                        style: Theme.of(context).textTheme.headline1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _fabIsVisible,
        child: FloatingActionButton(
          onPressed: _resetAllFields,
          child: SvgPicture.asset(
            'images/shuffle.svg',
            width: 40,
            color: ThemeData.estimateBrightnessForColor(
                        Theme.of(context).colorScheme.secondary) ==
                    Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
