import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/list_data.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnhancementsPage extends StatefulWidget {
  EnhancementsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EnhancementsPageState();
  }
}

class EnhancementsPageState extends State<EnhancementsPage> {
//  List<Enhancement> enhancementList = []
//    ..add(Enhancement('attack', 50, 'dggrwgw', false, false))
//    ..add(Enhancement('attack', 50, 'dggrwgw', false, false));

  int cityProsperityLvl,
      targetCardLvl = 0,
      enhancementsOnTargetAction,
      enhancementType,
      enhancementCost = 0;

  bool multipleTargetsSwitch = false, eligibleForMultipleTargets = false;

  createIconsListForDialog(List<String> list) {
    List<Widget> icons = [];
//    if (list != null) {
    list.forEach((icon) => icons.add(Image.asset(
          'images/$icon',
          height: iconWidth,
          width: iconWidth,
        )));
    return icons;
//    }
  }

  void _showInfoAlert(String title, String message) {
    String body;
    List<String> icons;
    if (enhancementType != null) {
      // plus one enhancement selected
      if (enhancementType > 0 && enhancementType < 16) {
        body = Strings.plusOneInfoBody;
        icons = Strings.plusOneIcons;
        // negative enhancement selected
      } else if (enhancementType > 16 && enhancementType < 23) {
        body = Strings.negEffectInfoBody;
        icons = Strings.negEffectIcons;
        // positive enhancement selected
      } else if (enhancementType == 23 || enhancementType == 24) {
        body = Strings.posEffectInfoBody;
        icons = Strings.posEffectIcons;
        // move enhancement selected
      } else if (enhancementType == 25) {
        body = Strings.moveInfoBody;
        icons = Strings.moveIcons;
        // elemental enhancement selected
      } else if (enhancementType == 26 || enhancementType == 27) {
        body = Strings.elementsInfoBody;
        icons = Strings.elementsIcons;
        // hex target enhancement selected
      } else if (enhancementType > 29 && enhancementType <= 40) {
        body = Strings.hexInfoBody;
        icons = Strings.hexIcons;
      }
    }
//if (enhancementType != null) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: title == null
                  ? Center(
                      child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: createIconsListForDialog(icons),
                      ),
                    ))
                  : Center(
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 23.0),
                      ),
                    ),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      message == null ? body : message,
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
                    )),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    readFromSharedPrefs();
  }

  Future readFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cityProsperityLvl = prefs.getInt('prosperityLvlKey') != null
          ? prefs.getInt('prosperityLvlKey')
          : 1;
      targetCardLvl = prefs.getInt('targetCardLvlKey') != null
          ? prefs.getInt('targetCardLvlKey')
          : null;
      enhancementsOnTargetAction =
          prefs.getInt('enhancementsOnTargetActionKey') != null
              ? prefs.getInt('enhancementsOnTargetActionKey')
              : null;
      enhancementType = prefs.getInt('enhancementTypeKey') != null
          ? prefs.getInt('enhancementTypeKey')
          : null;
      eligibleForMultipleTargets =
          prefs.getBool('eligibleForMultipleTargetsKey') != null
              ? prefs.getBool('eligibleForMultipleTargetsKey')
              : false;
      multipleTargetsSwitch =
          prefs.getBool('multipleTargetsSelectedKey') != null
              ? prefs.getBool('multipleTargetsSelectedKey')
              : false;
      enhancementCost = prefs.getInt('enhancementCostKey') != null
          ? prefs.getInt('enhancementCostKey')
          : 0;
    });
  }

  Future writeToSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('prosperityLvlKey', cityProsperityLvl);
      prefs.setInt('targetCardLvlKey', targetCardLvl);
      prefs.setInt('enhancementsOnTargetActionKey', enhancementsOnTargetAction);
      prefs.setInt('enhancementTypeKey', enhancementType);
      prefs.setBool(
          'eligibleForMultipleTargetsKey', eligibleForMultipleTargets);
      prefs.setBool('multipleTargetsSelectedKey', multipleTargetsSwitch);
      prefs.setInt('enhancementCostKey', enhancementCost);
    });
  }

  void updateEnhancementCost() {
    int baseCost = 0;
    if (tierOneEnhancements.contains(enhancementType)) {
      baseCost = 30;
    } else if (tierTwoEnhancements.contains(enhancementType)) {
      baseCost = 50;
    } else if (tierThreeEnhancements.contains(enhancementType)) {
      baseCost = 75;
    } else if (tierFourEnhancements.contains(enhancementType)) {
      baseCost = 100;
    } else if (tierFiveEnhancements.contains(enhancementType)) {
      baseCost = 150;
      // otherwise hex is chosen
    } else {
      switch (enhancementType) {
        // 2 current hexes targeted
        case 29:
          baseCost = 100;
          break;
        // 3 current hexes targeted
        case 30:
          baseCost = 66;
          break;
        // 4 current hexes targeted
        case 31:
          baseCost = 50;
          break;
        // 5 current hexes targeted
        case 32:
          baseCost = 40;
          break;
        // 6 current hexes targeted
        case 33:
          baseCost = 33;
          break;
        // 7 current hexes targeted
        case 34:
          baseCost = 28;
          break;
        // 8 current hexes targeted
        case 35:
          baseCost = 25;
          break;
        // 9 current hexes targeted
        case 36:
          baseCost = 22;
          break;
        // 10 current hexes targeted
        case 37:
          baseCost = 20;
          break;
        // 11 current hexes targeted
        case 38:
          baseCost = 18;
          break;
        // 12 current hexes targeted
        case 39:
          baseCost = 16;
          break;
        // 13 current hexes targeted
        case 40:
          baseCost = 15;
          break;
      }
    }

    enhancementCost =
        // add 25g for each card level beyond 1
        (targetCardLvl != null && targetCardLvl > 0 ? targetCardLvl * 25 : 0) +
            // add 75g for each existing enhancement on target action
            (enhancementsOnTargetAction != null
                ? enhancementsOnTargetAction * 75
                : 0) +
            (multipleTargetsSwitch ? baseCost * 2 : baseCost);

    writeToSharedPrefs();
  }

  void resetAllFields() {
    setState(() {
      targetCardLvl = null;
      enhancementsOnTargetAction = null;
      enhancementType = null;
      enhancementCost = 0;
      multipleTargetsSwitch = false;
      eligibleForMultipleTargets = false;
      writeToSharedPrefs();
    });
  }

  void handleCityProsperitySelection(int value) {
    setState(() {
      cityProsperityLvl = value;
      updateEnhancementCost();
    });
  }

  void handleLevelOfTargetCardSelection(int value) {
    setState(() {
      targetCardLvl = value;
      updateEnhancementCost();
    });
  }

  void handleEnhancementsOnTargetActionSelection(int value) {
    setState(() {
      enhancementsOnTargetAction = value;
      updateEnhancementCost();
    });
  }

  void handleMultipleTargetsSelection(bool value) {
    setState(() {
      multipleTargetsSwitch = value;
      value = value;
      updateEnhancementCost();
    });
  }

  void handleTypeSelection(int value) {
    setState(() {
      switch (value) {
        // drop down list titles (do nothing)
        case 0:
        case 11:
        case 16:
        case 28:
          break;
        // not eligible for 2x multiplier (hide multiplier switch)
//        case 4:
//        case 8:
        case 10:
          multipleTargetsSwitch = true;
          enhancementType = value;
          break;
//        case 15:
//        case 25:
//          eligibleForMultipleTargets = false;
//          multipleTargetsSwitch = false;
//          enhancementType = value;
//          updateEnhancementCost();
//          break;
        // hex selected
        case 29:
        case 30:
        case 31:
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
        case 37:
        case 38:
        case 39:
        case 40:
          eligibleForMultipleTargets = false;
          multipleTargetsSwitch = false;
          enhancementType = value;
          updateEnhancementCost();
          break;
        // normal enhancement selected, eligible for multiple target multiplier
        default:
          eligibleForMultipleTargets = true;
          multipleTargetsSwitch = false;
          enhancementType = value;
          updateEnhancementCost();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text('Gloomhaven Companion', style: TextStyle(fontSize: 25.0))),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton.icon(
                              color: Theme.of(context).accentColor,
                              icon: Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              label: Text(
                                'General Info',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
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
                              Text('Card level:'),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  hint: Text(
                                    '1/x',
                                    style: TextStyle(
                                        fontFamily: secondaryFontFamily),
                                  ),
                                  value: targetCardLvl,
                                  items: levelOfTargetCardList,
                                  onChanged: handleLevelOfTargetCardSelection,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
//                              Padding(
//                                padding: EdgeInsets.only(left: smallPadding),
//                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onPressed: () {
                                    _showInfoAlert(
                                        Strings.existingEnhancementsInfoTitle,
                                        Strings.existingEnhancementsInfoBody);
                                  }),
                              Expanded(
                                child: Text('Existing enhancements:'),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  hint: Text(
                                    'None',
                                    style: TextStyle(
                                        fontFamily: secondaryFontFamily),
                                  ),
                                  value: enhancementsOnTargetAction,
                                  items: enhancementsOnTargetActionList,
                                  onChanged:
                                      handleEnhancementsOnTargetActionSelection,
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
                                  IconButton(
                                      icon: Icon(Icons.info_outline,
                                          color: enhancementType != null
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context)
                                                  .accentColor
                                                  .withOpacity(0.5)),
                                      onPressed: enhancementType != null
                                          ? () {
                                              _showInfoAlert(null, null);
                                            }
                                          : null),
                                  Text(
                                    'Enhancement type:',
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
                                child: DropdownButton<int>(
                                    hint: Text(
                                      'Type',
                                      style: TextStyle(
                                          fontFamily: secondaryFontFamily),
                                    ),
                                    value: enhancementType,
                                    items: enhancementTypeList,
                                    onChanged: handleTypeSelection),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Visibility(
                            visible: eligibleForMultipleTargets,
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
                                Text('Multiple targets?'),
                                Switch(
                                    value: multipleTargetsSwitch,
                                    onChanged: handleMultipleTargetsSelection),
                                IconButton(
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: Colors.transparent,
                                    ),
                                    onPressed: null),
                              ],
                            ),
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
                          Text('$enhancementCost' + 'g',
                              style: TextStyle(fontSize: 75.0))
                        ],
                      ),
                    ),
//                ),
                  ],
                ),
              ),
            ],
          ),
        ),

//              ),
//            ),
//          );
//        }),
        floatingActionButton: FloatingActionButton(
            onPressed: resetAllFields,
            child: Image.asset('images/shuffle_white.png')));
  }
}
