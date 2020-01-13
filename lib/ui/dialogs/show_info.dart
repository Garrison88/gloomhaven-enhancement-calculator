import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/strings.dart';
import 'package:gloomhaven_enhancement_calc/enums/enhancement_category.dart';

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

void showInfoAlert(BuildContext _context, String _dialogTitle,
    RichText _dialogMessage, EnhancementCategory _category) {
  RichText _bodyText;
  List<String> _titleIcons;
  List<String> _eligibleForIcons;
  // info about enhancement category requested
  if (_category != null) {
    switch (_category) {
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
      default:
        break;
    }
  }
  showDialog(
      context: _context,
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
                      style: TextStyle(fontSize: 28.0),
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
                            style:
                                TextStyle(decoration: TextDecoration.underline),
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
                  _dialogMessage == null ? _bodyText : _dialogMessage,
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(_context).pop(),
                child: Text(
                  'Got it!',
                  style: TextStyle(
                      color: Theme.of(_context).accentColor,
                      fontSize: secondaryFontSize,
                      fontFamily: highTower),
                ),
              ),
            ],
          ));
}
