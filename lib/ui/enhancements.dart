import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/enums/enhancement_category.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EnhancementsPage extends StatefulWidget {
  EnhancementsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EnhancementsPageState();
  }
}

class _EnhancementsPageState extends State<EnhancementsPage> {
  int _targetCardLvl = 0, _previousEnhancements, _enhancementCost = 0;

  bool _multipleTargetsSwitch = false, _disableMultiTargetSwitch = true;

  Enhancement _selectedEnhancement;

  @override
  void initState() {
    super.initState();
    _readFromSharedPrefs();
  }

  void _menuItemSelected(String _choice) {
    if (_choice == 'Developer Website') {
      _launchUrl();
    }
  }

  void _launchUrl() async {
    if (await canLaunch(Strings.devWebsiteUrl)) {
      await launch(Strings.devWebsiteUrl);
    } else {
      throw 'Could not launch ${Strings.devWebsiteUrl}';
    }
  }

  _createIconsListForDialog(List<String> _list) {
    List<Widget> _icons = [];
    _list.forEach(
      (icon) => _icons.add(
            Padding(
              child: Image.asset(
                'images/$icon',
                height: icon == 'plus_one.png' ? plusOneWidth : iconWidth,
                width: icon == 'plus_one.png' ? plusOneHeight : iconHeight,
              ),
              padding: EdgeInsets.only(
                right: (smallPadding / 2),
              ),
            ),
          ),
    );
    return _icons;
  }

  void _showInfoAlert(String _dialogTitle, String _dialogMessage) {
    String _bodyText;
    List<String> _titleIcons;
    List<String> _eligibleForIcons;
    if (_selectedEnhancement != null) {
      switch (_selectedEnhancement.category) {
        // plus one for character enhancement selected
        case EnhancementCategory.charPlusOne:
        case EnhancementCategory.target:
          _bodyText = Strings.plusOneCharacterInfoBody;
          _titleIcons = Strings.plusOneIcon;
          _eligibleForIcons = Strings.plusOneCharacterEligibleIcons;
          break;
        // plus one for summon enhancement selected
        case EnhancementCategory.summonPlusOne:
          _bodyText = Strings.plusOneSummonInfoBody;
          _titleIcons = Strings.plusOneIcon;
          _eligibleForIcons = Strings.plusOneSummonEligibleIcons;
          break;
        // negative enhancement selected
        case EnhancementCategory.negEffect:
          _bodyText = Strings.negEffectInfoBody;
          _titleIcons = Strings.negEffectIcons;
          _eligibleForIcons = Strings.negEffectEligibleIcons;
          break;
        // positive enhancement selected
        case EnhancementCategory.posEffect:
          _bodyText = Strings.posEffectInfoBody;
          _titleIcons = Strings.posEffectIcons;
          _eligibleForIcons = Strings.posEffectEligibleIcons;
          break;
        // jump selected
        case EnhancementCategory.jump:
          _bodyText = Strings.jumpInfoBody;
          _titleIcons = Strings.jumpIcon;
          _eligibleForIcons = Strings.jumpEligibleIcons;
          break;
        // specific element selected
        case EnhancementCategory.specElem:
          _bodyText = Strings.specificElementInfoBody;
          _titleIcons = Strings.specificElementIcons;
          _eligibleForIcons = Strings.elementEligibleIcons;
          break;
        // any element selected
        case EnhancementCategory.anyElem:
          _bodyText = Strings.anyElementInfoBody;
          _titleIcons = Strings.anyElementIcon;
          _eligibleForIcons = Strings.elementEligibleIcons;
          break;
        // hex selected
        case EnhancementCategory.hex:
          _bodyText = Strings.hexInfoBody;
          _titleIcons = Strings.hexIcon;
          _eligibleForIcons = Strings.hexEligibleIcons;
          break;
        // title selected (do nothing)
        case EnhancementCategory.title:
          break;
      }
    }
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              // no title provided - this will be an enhancement dialog with icons
              title: _dialogTitle == null
                  ? Center(
                      child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _createIconsListForDialog(_titleIcons),
                      ),
                    ))
                  // title provided - this will be an info dialog with a text title
                  : Center(
                      child: Text(
                        _dialogTitle,
                        style: TextStyle(
                            fontSize: 28.0,
                            decoration: TextDecoration.underline),
                      ),
                    ),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // if title isn't provided, display eligible enhancements
                    _dialogTitle == null
                        ? Column(children: <Widget>[
                            Text(
                              'Eligible For:',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: smallPadding, bottom: smallPadding)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: _createIconsListForDialog(
                                      _eligibleForIcons)),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: smallPadding, bottom: smallPadding)),
                          ])
                        // if title isn't provided, display an empty container
                        : Container(),
                    Text(
                      _dialogMessage == null ? _bodyText : _dialogMessage,
                      style: TextStyle(fontFamily: secondaryFontFamily),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Got it!',
                    style: TextStyle(
                        fontSize: secondaryFontSize,
                        fontFamily: secondaryFontFamily),
                  ),
                ),
              ],
            ));
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
      _selectedEnhancement = _prefs.getInt('enhancementTypeKey') != null
          ? enhancementList[_prefs.getInt('enhancementTypeKey')]
          : null;
      _disableMultiTargetSwitch =
          _prefs.getBool('eligibleForMultipleTargetsKey') != null
              ? _prefs.getBool('eligibleForMultipleTargetsKey')
              : true;
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
      if (_value.category == EnhancementCategory.target) {
        _multipleTargetsSwitch = true;
        _disableMultiTargetSwitch = true;
      } else if (_value.category == EnhancementCategory.hex) {
        _multipleTargetsSwitch = false;
        _disableMultiTargetSwitch = true;
      } else {
        _disableMultiTargetSwitch = false;
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
        appBar: AppBar(
          title: Text(
            'Gloomhaven Companion',
            style: TextStyle(fontSize: 25.0),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _menuItemSelected,
              itemBuilder: (BuildContext context) {
                return Strings.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: TextStyle(
                          fontFamily: secondaryFontFamily, fontSize: 20.0),
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
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
                              label: Text(
                                'General Guidelines',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontFamily: secondaryFontFamily),
                              ),
                              onPressed: () {
                                _showInfoAlert(Strings.generalInfoTitle,
                                    Strings.generalInfoBody);
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
                                    _showInfoAlert(Strings.cardLevelInfoTitle,
                                        Strings.cardLevelInfoBody);
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
                                    _showInfoAlert(
                                        Strings.previousEnhancementsInfoTitle,
                                        Strings.previousEnhancementsInfoBody);
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
                                                _showInfoAlert(null, null);
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
                                    _showInfoAlert(
                                        Strings.multipleTargetsInfoTitle,
                                        Strings.multipleTargetsInfoBody);
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
