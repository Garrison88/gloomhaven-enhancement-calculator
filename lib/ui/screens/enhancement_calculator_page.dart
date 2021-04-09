import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../data/constants.dart';
import '../../data/enhancement_list_data.dart';
import '../../data/strings.dart';
import '../../enums/enhancement_category.dart';
import '../../main.dart';
import '../../models/enhancement.dart';
import '../dialogs/show_info.dart';

class EnhancementCalculatorPage extends StatefulWidget {
  EnhancementCalculatorPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnhancementCalculatorPageState();
}

class _EnhancementCalculatorPageState extends State<EnhancementCalculatorPage> {
  int _targetCardLvl = 0, _previousEnhancements = 0, _enhancementCost = 0;

  bool _multipleTargetsSwitch = false, _disableMultiTargetSwitch = false;

  Enhancement _selectedEnhancement;

  @override
  void initState() {
    super.initState();
    // _writeToSharedPrefs();
    _readFromSharedPrefs();
    _updateEnhancementCost();
  }

  void _writeToSharedPrefs() async {
    prefs.setInt('targetCardLvlKey', _targetCardLvl);
    prefs.setInt('enhancementsOnTargetActionKey', _previousEnhancements);
    prefs.setInt('enhancementTypeKey',
        enhancementList.indexOf(_selectedEnhancement ?? null) ?? 0);
    prefs.setBool('disableMultiTargetsSwitchKey', _disableMultiTargetSwitch);
    prefs.setBool('multipleTargetsSelectedKey', _multipleTargetsSwitch);
//    prefs.setInt('enhancementCostKey', _enhancementCost);
    print('shared prefs to ' '$_enhancementCost');
    setState(() {});
  }

  Future _readFromSharedPrefs() async {
    _targetCardLvl = prefs.getInt('targetCardLvlKey') ?? 0;
    _previousEnhancements = prefs.getInt('enhancementsOnTargetActionKey') ?? 0;
    _selectedEnhancement = prefs.getInt('enhancementTypeKey') != null
        ? enhancementList[prefs.getInt('enhancementTypeKey') ?? 0]
        : null;
    _disableMultiTargetSwitch =
        prefs.getBool('disableMultiTargetsSwitchKey') ?? false;
    _multipleTargetsSwitch =
        prefs.getBool('multipleTargetsSelectedKey') ?? false;
    print('shared prefs from ' + '$_enhancementCost');
    _updateEnhancementCost();
    setState(() {});
  }

  Future _resetAllFields() async {
    prefs.remove('targetCardLvlKey');
    prefs.remove('enhancementsOnTargetActionKey');
    prefs.remove('enhancementTypeKey');
    prefs.remove('disableMultiTargetsSwitchKey');
    prefs.remove('multipleTargetsSelectedKey');
//    prefs.remove('enhancementCostKey');
    _readFromSharedPrefs();
  }

  void _handleLevelOfTargetCardSelection(int _value) {
    _targetCardLvl = _value;
    _updateEnhancementCost();
  }

  void _handlePreviousEnhancementsSelection(int _value) {
    _previousEnhancements = _value;
    _updateEnhancementCost();
  }

  void _handleMultipleTargetsSelection(bool _value) {
    _multipleTargetsSwitch = _value;
    _updateEnhancementCost();
  }

  void _handleTypeSelection(Enhancement _value) {
    switch (_value.category) {
      case EnhancementCategory.target:
        _multipleTargetsSwitch = true;
        _disableMultiTargetSwitch = true;
        break;
      case EnhancementCategory.hex:
        _multipleTargetsSwitch = false;
        _disableMultiTargetSwitch = true;
        break;
      default:
        _disableMultiTargetSwitch = false;
        break;
    }
    _selectedEnhancement = _value;
    _updateEnhancementCost();
  }

  void _updateEnhancementCost() {
    int _baseCost =
        _selectedEnhancement != null ? _selectedEnhancement.baseCost : 0;
    _enhancementCost =
        // add 25g for each card level beyond 1
        (_targetCardLvl != null && _targetCardLvl > 0
                ? _targetCardLvl * 25
                : 0) +
            // add 75g for each previous enhancement on target action
            (_previousEnhancements != null ? _previousEnhancements * 75 : 0) +
            // multiply base cost x2 if multiple targets switch is true
            (_multipleTargetsSwitch ? _baseCost * 2 : _baseCost);
    _writeToSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
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
                                fontFamily: highTower,
                                color: ThemeData.estimateBrightnessForColor(
                                            Theme.of(context).accentColor) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          onPressed: () => showInfoDialog(
                              context,
                              Strings.generalInfoTitle,
                              Strings.generalInfoBody,
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
                                    Strings.cardLevelInfoBody,
                                    null);
                              }),
                          Text('Card Level:'),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              hint: Text(
                                '1 / x',
                                style: TextStyle(fontFamily: highTower),
                              ),
                              value: _targetCardLvl,
                              items: cardLevelList,
                              onChanged: _handleLevelOfTargetCardSelection,
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
                                    Strings.previousEnhancementsInfoBody,
                                    null);
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
                                style: TextStyle(fontFamily: highTower),
                              ),
                              value: _previousEnhancements,
                              items: previousEnhancementsList,
                              onChanged: _handlePreviousEnhancementsSelection,
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
                                            showInfoDialog(context, null, null,
                                                _selectedEnhancement.category);
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
                                  style: TextStyle(fontFamily: highTower),
                                ),
                                value: _selectedEnhancement,
                                items: enhancementTypeList,
                                onChanged: _handleTypeSelection),
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
                                    Strings.multipleTargetsInfoBody,
                                    null);
                              }),
                          AutoSizeText('Multiple Targets?'),
                          AbsorbPointer(
                            absorbing: _disableMultiTargetSwitch,
                            child: Opacity(
                              opacity: _disableMultiTargetSwitch ? 0.5 : 1.0,
                              child: Switch(
                                  value: _multipleTargetsSwitch,
                                  onChanged: _handleMultipleTargetsSelection),
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
                      AutoSizeText('Enhancement Cost:',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 75.0)),
                      Text('${_enhancementCost ?? 0}' + 'g',
                          style: TextStyle(fontSize: 75.0))
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
