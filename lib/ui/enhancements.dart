import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/list_data.dart';
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
//        case 10:
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
        body:
//        LayoutBuilder(builder:
//            (BuildContext context, BoxConstraints viewportConstraints) {
//          return SingleChildScrollView(
//            child: ConstrainedBox(
//              constraints:
//                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
//              child: IntrinsicHeight(
//                child:
            Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background_page.jpg'),
                  fit: BoxFit.fill)),
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(23.0, 35.0, 20.0, 15.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Card(
                            color: Colors.white,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: smallPadding),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Prosperity Level:',
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.only(left: smallPadding),
//                                            child: Theme(
//                                                data: Theme.of(context)
//                                                    .copyWith(
//                                                        canvasColor:
//                                                            Theme.of(context)
//                                                                .accentColor),
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                        hint: Text('1',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    secondaryFontFamily)),
                                        value: cityProsperityLvl,
                                        items: levelList,
                                        onChanged:
                                            handleCityProsperitySelection,
                                      )))
                                ])),
                        Padding(padding: EdgeInsets.all(smallPadding)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'You may enhance ' +
                                    (cityProsperityLvl != null &&
                                            cityProsperityLvl > 1
                                        ? '$cityProsperityLvl cards'
                                        : '1 card'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: secondaryFontSize,
                                    fontFamily: secondaryFontFamily),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(smallPadding)),
                        Card(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: smallPadding),
                              ),
                              Expanded(
                                child: Text('Level of target card:'),
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: smallPadding),
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                    hint: Text('1 / x',
                                        style: TextStyle(
                                            fontFamily: secondaryFontFamily)),
                                    value: targetCardLvl,
                                    items: levelOfTargetCardList,
                                    onChanged: handleLevelOfTargetCardSelection,
                                  )))
                            ])),
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: smallPadding),
                              ),
                              Expanded(
                                  child: Text(
                                      'Existing enhancements on target action:')),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  hint: Text('None',
                                      style: TextStyle(
                                          fontFamily: secondaryFontFamily)),
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Type of enhancement:',
                                textAlign: TextAlign.center,
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
//                            ],
//                          ),
                        ),
                        Card(
                          child: Visibility(
                            visible: eligibleForMultipleTargets,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: smallPadding)),
                                Expanded(
                                  child: Text('Multiple targets?'),
                                ),
                                Switch(
                                    value: multipleTargetsSwitch,
                                    onChanged: handleMultipleTargetsSelection)
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
