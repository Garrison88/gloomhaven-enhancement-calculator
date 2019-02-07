import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/enums/enhancement_category.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement_model.dart';
import 'package:gloomhaven_enhancement_calc/ui/alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnhancementCalculatorPage extends StatefulWidget {
  EnhancementCalculatorPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EnhancementCalculatorPageState();
  }
}

class _EnhancementCalculatorPageState extends State<EnhancementCalculatorPage> {
  int _targetCardLvl, _previousEnhancements, _enhancementCost = 0;

  bool _multipleTargetsSwitch = false, _disableMultiTargetSwitch = false;

  Enhancement _selectedEnhancement;

  @override
  void initState() {
    super.initState();
    _readFromSharedPrefs();
  }

  Future _readFromSharedPrefs() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _targetCardLvl = _prefs.getInt('targetCardLvlKey') != null
          ? _prefs.getInt('targetCardLvlKey')
          : null;
      _previousEnhancements =
          _prefs.getInt('enhancementsOnTargetActionKey') != null
              ? _prefs.getInt('enhancementsOnTargetActionKey')
              : null;
      _selectedEnhancement =
          _prefs.getInt('enhancementTypeKey') != null && enhancementList != null
              ? enhancementList[_prefs.getInt('enhancementTypeKey')]
              : null;
      _disableMultiTargetSwitch =
          _prefs.getBool('eligibleForMultipleTargetsKey') != null
              ? _prefs.getBool('eligibleForMultipleTargetsKey')
              : false;
      _multipleTargetsSwitch =
          _prefs.getBool('multipleTargetsSelectedKey') != null
              ? _prefs.getBool('multipleTargetsSelectedKey')
              : false;
      _enhancementCost = _prefs.getInt('enhancementCostKey') != null
          ? _prefs.getInt('enhancementCostKey')
          : 0;
    });
  }

  Future _writeToSharedPrefs() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs.setInt('targetCardLvlKey', _targetCardLvl);
      _prefs.setInt('enhancementsOnTargetActionKey', _previousEnhancements);
      _prefs.setInt(
          'enhancementTypeKey', enhancementList.indexOf(_selectedEnhancement));
      _prefs.setBool(
          'eligibleForMultipleTargetsKey', _disableMultiTargetSwitch);
      _prefs.setBool('multipleTargetsSelectedKey', _multipleTargetsSwitch);
      _prefs.setInt('enhancementCostKey', _enhancementCost);
    });
  }

  void _handleLevelOfTargetCardSelection(int _value) {
    setState(() {
      _targetCardLvl = _value;
      _updateEnhancementCost();
    });
  }

  void _handlePreviousEnhancementsSelection(int _value) {
    setState(() {
      _previousEnhancements = _value;
      _updateEnhancementCost();
    });
  }

  void _handleMultipleTargetsSelection(bool _value) {
    setState(() {
      _multipleTargetsSwitch = _value;
      _value = _value;
      _updateEnhancementCost();
    });
  }

  void _handleTypeSelection(Enhancement _value) {
    setState(() {
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
    });
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

  void _resetAllFields() {
    setState(() {
      _targetCardLvl = null;
      _previousEnhancements = null;
      _selectedEnhancement = null;
      _enhancementCost = 0;
      _multipleTargetsSwitch = false;
      _disableMultiTargetSwitch = false;
      _writeToSharedPrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background_page.jpg'),
                fit: BoxFit.fill),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(23.0, 25.0, 20.0, 15.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                            ),
                            RaisedButton.icon(
                              color: Theme.of(context).accentColor,
                              icon: Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30.0)),
                              label: Text(
                                'General Guidelines',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontFamily: secondaryFontFamily),
                              ),
                              onPressed: () {
                                showInfoAlert(context, Strings.generalInfoTitle,
                                    Strings.generalInfoBody, null);
                              },
                            ),
                          ],
                        ),
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.info_outline,
                                      color: Theme.of(context).accentColor),
                                  onPressed: () {
                                    showInfoAlert(
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
                                    style: TextStyle(
                                        fontFamily: secondaryFontFamily),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onPressed: () {
                                    showInfoAlert(
                                        context,
                                        Strings.previousEnhancementsInfoTitle,
                                        Strings.previousEnhancementsInfoBody,
                                        null);
                                  }),
                              Expanded(
                                child: Text(
                                  'Previous Enhancements:',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(right: smallPadding)),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  hint: Text(
                                    'None',
                                    style: TextStyle(
                                        fontFamily: secondaryFontFamily),
                                  ),
                                  value: _previousEnhancements,
                                  items: previousEnhancementsList,
                                  onChanged:
                                      _handlePreviousEnhancementsSelection,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Opacity(
                                    opacity: _selectedEnhancement != null
                                        ? 1.0
                                        : 0.5,
                                    child: IconButton(
                                        icon: Icon(Icons.info_outline,
                                            color:
                                                Theme.of(context).accentColor),
                                        onPressed: _selectedEnhancement != null
                                            ? () {
                                                showInfoAlert(
                                                    context,
                                                    null,
                                                    null,
                                                    _selectedEnhancement
                                                        .category);
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
                                      style: TextStyle(
                                          fontFamily: secondaryFontFamily),
                                    ),
                                    value: _selectedEnhancement,
                                    items: enhancementTypeList,
                                    onChanged: _handleTypeSelection),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.info_outline,
                                      color: Theme.of(context).accentColor),
                                  onPressed: () {
                                    showInfoAlert(
                                        context,
                                        Strings.multipleTargetsInfoTitle,
                                        Strings.multipleTargetsInfoBody,
                                        null);
                                  }),
                              Text('Multiple Targets?'),
                              AbsorbPointer(
                                absorbing: _disableMultiTargetSwitch,
                                child: Opacity(
                                  opacity:
                                      _disableMultiTargetSwitch ? 0.5 : 1.0,
                                  child: Switch(
                                      value: _multipleTargetsSwitch,
                                      onChanged:
                                          _handleMultipleTargetsSelection),
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
                          Text('Enhancement Cost:',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 35.0)),
                          Text('$_enhancementCost' + 'g',
                              style: TextStyle(fontSize: 75.0))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _resetAllFields,
            child: Image.asset('images/shuffle_white.png')));
  }
}
