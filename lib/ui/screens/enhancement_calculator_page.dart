import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

import '../../data/constants.dart';
import '../../data/enhancement_list_data.dart';
import '../../data/strings.dart';
import '../../enums/enhancement_category.dart';
import '../../models/enhancement.dart';
import '../dialogs/show_info.dart';

class EnhancementCalculatorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EnhancementCalculatorPageState();
}

class _EnhancementCalculatorPageState extends State<EnhancementCalculatorPage> {
  bool _disableMultiTargetSwitch = false;

  Enhancement _selectedEnhancement;

  @override
  void initState() {
    super.initState();
    _selectedEnhancement = SharedPrefs().enhancementType != 0
        ? enhancementsList[SharedPrefs().enhancementType]
        : null;
    _updateEnhancementCost();
  }

  void _resetAllFields() {
    _selectedEnhancement = null;
    SharedPrefs().remove('targetCardLvlKey');
    SharedPrefs().remove('enhancementsOnTargetActionKey');
    SharedPrefs().remove('enhancementTypeKey');
    SharedPrefs().remove('disableMultiTargetsSwitchKey');
    SharedPrefs().remove('multipleTargetsSelectedKey');
    SharedPrefs().remove('enhancementCost');
    setState(() {});
  }

  void _handleTypeSelection(Enhancement value) {
    switch (value.category) {
      case EnhancementCategory.title:
        return;
      case EnhancementCategory.target:
        SharedPrefs().multipleTargetsSwitch = true;
        _disableMultiTargetSwitch = true;
        _selectedEnhancement = value;
        break;
      case EnhancementCategory.hex:
        SharedPrefs().multipleTargetsSwitch = false;
        _disableMultiTargetSwitch = true;
        _selectedEnhancement = value;
        break;
      default:
        _disableMultiTargetSwitch = false;
        _selectedEnhancement = value;
        break;
    }
    SharedPrefs().enhancementType = enhancementsList.indexOf(value);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //TODO: this ensures that enabling Party Boon recalculates the current cost
    _updateEnhancementCost();
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(smallPadding),
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
                        Padding(
                          padding: EdgeInsets.only(left: smallPadding / 2),
                        ),
                        RaisedButton.icon(
                          elevation: 5.0,
                          color: Theme.of(context).accentColor,
                          icon: Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          label: Text(
                            'General Guidelines',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: ThemeData.estimateBrightnessForColor(
                                            Theme.of(context).accentColor) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          onPressed: () => showInfoDialog(
                              context,
                              Strings.generalInfoTitle,
                              Strings.generalInfoBody(context),
                              null),
                        ),
                      ],
                    ),
                    Card(
                      elevation: 5.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.info_outline,
                                  color: Theme.of(context).accentColor),
                              onPressed: () {
                                showInfoDialog(
                                    context,
                                    Strings.cardLevelInfoTitle,
                                    Strings.cardLevelInfoBody(context),
                                    null);
                              }),
                          Text('Card Level:'),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: SharedPrefs().targetCardLvl,
                              items: cardLevelList(SharedPrefs().partyBoon),
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
                      elevation: 5.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () {
                                showInfoDialog(
                                  context,
                                  Strings.previousEnhancementsInfoTitle,
                                  Strings.previousEnhancementsInfoBody(context),
                                  null,
                                );
                              }),
                          Expanded(
                            child: AutoSizeText(
                              'Previous Enhancements:',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: smallPadding)),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              hint: Text(
                                'None',
                              ),
                              value: SharedPrefs().previousEnhancements,
                              items: previousEnhancementsList(),
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
                      elevation: 5.0,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Opacity(
                                opacity:
                                    _selectedEnhancement != null ? 1.0 : 0.5,
                                child: IconButton(
                                    icon: Icon(Icons.info_outline,
                                        color: Theme.of(context).accentColor),
                                    onPressed: _selectedEnhancement != null
                                        ? () {
                                            showInfoDialog(
                                              context,
                                              null,
                                              null,
                                              _selectedEnhancement.category,
                                            );
                                          }
                                        : null),
                              ),
                              Text(
                                'Enhancement Type:',
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.transparent,
                                  ),
                                  onPressed: null),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<Enhancement>(
                              hint: Text(
                                'Type',
                              ),
                              value: _selectedEnhancement,
                              items: enhancementTypeList(),
                              onChanged: (Enhancement enhancement) {
                                _handleTypeSelection(enhancement);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.info_outline,
                                  color: Theme.of(context).accentColor),
                              onPressed: () {
                                showInfoDialog(
                                    context,
                                    Strings.multipleTargetsInfoTitle,
                                    Strings.multipleTargetsInfoBody(context),
                                    null);
                              }),
                          AutoSizeText('Multiple Targets?'),
                          AbsorbPointer(
                            absorbing: _disableMultiTargetSwitch,
                            child: Opacity(
                              opacity: _disableMultiTargetSwitch ? 0.5 : 1.0,
                              child: Switch(
                                  value: SharedPrefs().multipleTargetsSwitch,
                                  onChanged: (bool value) {
                                    SharedPrefs().multipleTargetsSwitch = value;
                                    _updateEnhancementCost();
                                  }),
                            ),
                          ),
                          IconButton(
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
                Container(
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
                        '${SharedPrefs().enhancementCost}' + 'g',
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
      floatingActionButton: FloatingActionButton(
        onPressed: _resetAllFields,
        child: Image.asset('images/shuffle_white.png'),
      ),
    );
  }
}
