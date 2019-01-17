import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/list_data.dart';
import 'package:gloomhaven_enhancement_calc/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnhancementsPage extends StatefulWidget {
  EnhancementsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EnhancementsPageState();
  }
}

class EnhancementsPageState extends State<EnhancementsPage> {
//  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

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
    getProsperityLvl();
    readFromBucket();
  }

  getProsperityLvl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cityProsperityLvl = prefs.getInt('prosperityLvl');
  }

  setProsperityLvl(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('prosperityLvl', value);
  }

  readFromBucket() {
    targetCardLvl = (bucket.readState(context,
                identifier: ValueKey('targetCardLevelKey')) !=
            null)
        ? bucket.readState(context, identifier: ValueKey('targetCardLevelKey'))
        : null;
    enhancementsOnTargetAction = (bucket.readState(context,
                identifier: ValueKey('enhancementsOnTargetActionKey')) !=
            null)
        ? bucket.readState(context,
            identifier: ValueKey('enhancementsOnTargetActionKey'))
        : null;
    enhancementType = (bucket.readState(context,
                identifier: ValueKey('enhancementTypeKey')) !=
            null)
        ? bucket.readState(context, identifier: ValueKey('enhancementTypeKey'))
        : null;
    eligibleForMultipleTargets = (bucket.readState(context,
                identifier: ValueKey('eligibleForMultipleTargetsKey')) !=
            null)
        ? bucket.readState(context,
            identifier: ValueKey('eligibleForMultipleTargetsKey'))
        : false;
    multipleTargetsSwitch = (bucket.readState(context,
                identifier: ValueKey('multipleTargetsSelectedKey')) !=
            null)
        ? bucket.readState(context,
            identifier: ValueKey('multipleTargetsSelectedKey'))
        : false;
    enhancementCost = (bucket.readState(context,
                identifier: ValueKey('enhancementCostKey')) !=
            null)
        ? bucket.readState(context, identifier: ValueKey('enhancementCostKey'))
        : 0;
  }

  void writeToBucket() {
    bucket.writeState(context, cityProsperityLvl,
        identifier: ValueKey('prosperityKey'));
    bucket.writeState(context, targetCardLvl,
        identifier: ValueKey('targetCardLevelKey'));
    bucket.writeState(context, enhancementsOnTargetAction,
        identifier: ValueKey('enhancementsOnTargetActionKey'));
    bucket.writeState(context, enhancementType,
        identifier: ValueKey('enhancementTypeKey'));
    bucket.writeState(context, eligibleForMultipleTargets,
        identifier: ValueKey('eligibleForMultipleTargetsKey'));
    bucket.writeState(context, multipleTargetsSwitch,
        identifier: ValueKey('multipleTargetsSelectedKey'));
    bucket.writeState(context, enhancementCost,
        identifier: ValueKey('enhancementCostKey'));
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

    writeToBucket();
  }

  void resetAllFields() {
    setState(() {
      targetCardLvl = null;
      enhancementsOnTargetAction = null;
      enhancementType = null;
      enhancementCost = 0;
      multipleTargetsSwitch = false;
      eligibleForMultipleTargets = false;

      writeToBucket();
    });
  }

  void handleCityProsperitySelection(int value) {
    setState(() {
      cityProsperityLvl = value;
      setProsperityLvl(value);
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
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: IntrinsicHeight(
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('images/background_page.jpg'),
                                  fit: BoxFit.fill)),
                          padding:
                              const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 30.0),
                          child: Column(children: <Widget>[
                            Column(children: <Widget>[
                              Card(
                                  color: Colors.white,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text('Gloomhaven Prosperity Level:'),
                                        Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10.0, 0.0, 10.0, 0.0),
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
                              Padding(padding: EdgeInsets.all(5.0)),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Center(
                                        child: Text(
                                            'You may enhance ' +
                                                (cityProsperityLvl != null &&
                                                        cityProsperityLvl > 1
                                                    ? '$cityProsperityLvl cards'
                                                    : '1 card'),
                                            style: TextStyle(
                                                fontSize: secondaryFontSize,
                                                fontFamily:
                                                    secondaryFontFamily)))
                                  ]),
                              Padding(padding: EdgeInsets.all(5.0)),
                              Card(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                    Text('Level of target card:'),
                                    Container(
                                        padding: EdgeInsets.fromLTRB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton<int>(
                                          hint: Text('1 / x',
                                              style: TextStyle(
                                                  fontFamily:
                                                      secondaryFontFamily)),
                                          value: targetCardLvl,
                                          items: levelOfTargetCardList,
                                          onChanged:
                                              handleLevelOfTargetCardSelection,
                                        )))
                                  ])),
                              Card(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
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
                                    ))
                                  ])),
                              Card(
                                  child: Container(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                    Center(child: Text('Type of enhancement')),
                                    DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                            hint: Text('Type',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                        secondaryFontFamily)),
                                            value: enhancementType,
                                            items: enhancementTypeList,
                                            onChanged: handleTypeSelection)),
                                  ]))),
                              Visibility(
                                  visible: eligibleForMultipleTargets,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                            child: Text(
                                                'Multiple targets? (x2 base cost)')),
                                        Switch(
                                            value: multipleTargetsSwitch,
                                            onChanged:
                                                handleMultipleTargetsSelection)
                                      ]))
//                      Expanded(
                            ]),
                            Expanded(
                                // A flexible child that will grow to fit the viewport but
                                // still be at least as big as necessary to fit its contents.
                                child: Container(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                  Text('Enhancement Cost:',
                                      style: TextStyle(fontSize: 50.0)),
                                  Text('$enhancementCost' + 'g',
                                      style: TextStyle(fontSize: 75.0))
                                ])))
                          ])))));
        }),
        floatingActionButton: FloatingActionButton(
            onPressed: resetAllFields,
            child: Image.asset('images/shuffle_white.png')));
  }
}
