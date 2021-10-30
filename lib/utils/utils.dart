import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/constants.dart';
import '../models/perk.dart';
import '../ui/widgets/perk_row.dart';

class Utils {
  static List<InlineSpan> generatePerkDetailsWithInlineIcons(
    List<String> list,
    bool darkTheme,
  ) {
    List<InlineSpan> inlineList = [];
    for (String element in list) {
      String assetPath;
      bool invertColor = false;
      if (element.contains('&')) {
        List<String> elements = element.split('&');
        element = '';
        inlineList.add(
          WidgetSpan(
            child: SizedBox(
              height: iconSize,
              width: iconSize,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'images/elem_${elements[0].toLowerCase()}.svg',
                      width: iconSize * 0.7,
                      height: iconSize * 0.7,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'images/elem_${elements[1].toLowerCase()}.svg',
                      width: iconSize * 0.7,
                      height: iconSize * 0.7,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      } else {
        switch (
            element.replaceAll(RegExp(r'"'), '').replaceAll(RegExp(r','), '')) {
          case '-2':
            assetPath = 'attack_modifiers/minus_2.png';
            break;
          case '-1':
            assetPath = 'attack_modifiers/minus_1.png';
            break;
          case '+0':
            assetPath = 'attack_modifiers/plus_0.png';
            break;
          case '+X':
            assetPath = 'attack_modifiers/plus_x.png';
            break;
          case '+1':
            assetPath = 'attack_modifiers/plus_1.png';
            break;
          case '+2':
            assetPath = 'attack_modifiers/plus_2.png';
            break;
          case '+3':
            assetPath = 'attack_modifiers/plus_3.png';
            break;
          case '+4':
            assetPath = 'attack_modifiers/plus_4.png';
            break;
          case 'One_Hand':
            assetPath = 'equipment_slots/one_handed.svg';
            invertColor = true;
            break;
          case 'Move':
            assetPath = 'move.svg';
            invertColor = true;
            break;
          case 'Rolling':
            assetPath = 'rolling.svg';
            break;
          case 'HEAL':
            assetPath = darkTheme ? 'heal.svg' : 'heal_light.svg';
            break;
          case 'SHIELD':
            assetPath = 'shield.svg';
            invertColor = true;
            break;
          case 'STUN':
            assetPath = 'stun.svg';
            break;
          case 'WOUND':
            assetPath = 'wound.svg';
            break;
          case 'CURSE':
            assetPath = 'curse.svg';
            break;
          case 'PIERCE':
            assetPath = 'pierce.svg';
            break;
          case 'REGENERATE':
            assetPath = 'regenerate.svg';
            break;
          case 'DISARM':
            assetPath = 'disarm.svg';
            break;
          case 'BLESS':
            assetPath = 'bless.svg';
            break;
          case 'TARGET':
            assetPath = 'target.svg';
            break;
          case 'Target':
            assetPath = darkTheme ? 'target_alt.svg' : 'target_alt_light.svg';
            break;
          case 'Range':
            assetPath = 'range.svg';
            invertColor = true;
            break;
          case 'Loot':
            assetPath = 'loot.svg';
            invertColor = true;
            break;
          case 'RETALIATE':
            assetPath = 'retaliate.svg';
            invertColor = true;
            break;
          case 'Attack':
            assetPath = 'attack.svg';
            invertColor = true;
            break;
          case 'Recover':
            assetPath =
                darkTheme ? 'recover_card.svg' : 'recover_card_light.svg';
            break;
          case 'Refresh':
            assetPath =
                darkTheme ? 'refresh_item.svg' : 'refresh_item_light.svg';
            break;
          case 'PUSH':
            assetPath = 'push.svg';
            break;
          case 'PULL':
            assetPath = 'pull.svg';
            break;
          case 'IMMOBILIZE':
            assetPath = 'immobilize.svg';
            break;
          case 'POISON':
            assetPath = 'poison.svg';
            break;
          case 'MUDDLE':
            assetPath = 'muddle.svg';
            break;
          case 'INVISIBLE':
            assetPath = 'invisible.svg';
            break;
          case 'STRENGTHEN':
            assetPath = 'strengthen.svg';
            break;
          case 'CHILL':
            assetPath = 'chill.svg';
            break;
          case 'PROVOKE':
            assetPath = 'provoke.svg';
            break;
          case 'BRITTLE':
            assetPath = 'brittle.svg';
            break;
          case 'WARD':
            assetPath = 'ward.svg';
            break;
          case 'RUPTURE':
            assetPath = 'rupture.svg';
            break;
          case 'EMPOWER':
            assetPath = 'empower.svg';
            break;
          case 'HEX':
            assetPath = 'luminary_hexes.svg';
            break;
          case 'DAMAGE':
            assetPath = darkTheme ? 'damage.svg' : 'damage_light.svg';
            break;
          case 'Shackle':
          case 'Shackled':
            assetPath = 'class_icons/chainguard.svg';
            invertColor = true;
            break;
          case 'Chieftain':
            assetPath = 'class_icons/chieftain.svg';
            invertColor = true;
            break;
          case 'Boneshaper':
            assetPath = 'class_icons/boneshaper.svg';
            invertColor = true;
            break;
          case 'Glow':
            assetPath = 'class_icons/luminary.svg';
            invertColor = true;
            break;
          case 'Spirit':
            assetPath = 'class_icons/spirit_caller.svg';
            invertColor = true;
            break;
          case 'SWING':
            assetPath = 'swing.svg';
            break;
          case 'SATED':
            assetPath = 'sated.svg';
            invertColor = true;
            break;
          case 'Ladder':
            assetPath = 'ladder.svg';
            invertColor = true;
            break;
          case 'Shrug_Off':
            assetPath = 'shrug_off.svg';
            invertColor = true;
            break;
          case 'Projectile':
            assetPath = 'class_icons/bombard.svg';
            invertColor = true;
            break;
          case 'VOID':
            assetPath = 'void.svg';
            break;
          case 'VOIDSIGHT':
            assetPath = 'voidsight.svg';
            invertColor = true;
            break;
          // ELEMENTS
          case 'EARTH':
            assetPath = 'elem_earth.svg';
            break;
          case 'AIR':
            assetPath = 'elem_air.svg';
            break;
          case 'DARK':
            assetPath = 'elem_dark.svg';
            break;
          case 'LIGHT':
            assetPath = 'elem_light.svg';
            break;
          case 'ICE':
            assetPath = 'elem_ice.svg';
            break;
          case 'FIRE':
            assetPath = 'elem_fire.svg';
            break;
          case 'EARTH/FIRE':
            assetPath = 'elem_earth_or_fire.svg';
            break;
          case 'EARTH/DARK':
            assetPath = 'elem_earth_or_dark.svg';
            break;
          case 'Any_Element':
            assetPath = 'elem_any.svg';
            break;
          case 'Consume_Any_Element':
            assetPath = 'elem_any_consume.svg';
            break;
        }
      }
      if (assetPath != null) {
        if (element.startsWith('"')) {
          inlineList.add(
            const TextSpan(text: '"'),
          );
        }
        inlineList.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Tooltip(
              message:
                  element.toLowerCase().replaceAll(RegExp('[\\"|\\,]'), ''),
              child: SizedBox(
                height: iconSize - 2.5,
                width: iconSize - 2.5,
                child: invertColor && darkTheme
                    ? assetPath.contains('.svg')
                        ? SvgPicture.asset(
                            'images/$assetPath',
                            color: Colors.white,
                          )
                        : Image.asset(
                            'images/$assetPath',
                            color: Colors.white,
                          )
                    : assetPath.contains('.svg')
                        ? SvgPicture.asset(
                            'images/$assetPath',
                          )
                        : Image.asset(
                            'images/$assetPath',
                          ),
              ),
            ),
          ),
        );
        if (element.endsWith('"')) {
          inlineList.add(
            const TextSpan(text: '"'),
          );
        }
        if (element.endsWith(',')) {
          inlineList.add(
            const TextSpan(text: ','),
          );
        }
      } else {
        inlineList.add(
          TextSpan(text: element),
        );
      }
      inlineList.add(
        const TextSpan(text: ' '),
      );
    }
    return inlineList;
  }

  static List<PerkRow> generatePerkRows(List<dynamic> perkMaps) {
    List<PerkRow> perkRows = [];
    List<Perk> perkRowPerks = [];
    List<Perk> perks = [];
    for (var perkMap in perkMaps) {
      perks.add(Perk.fromMap(perkMap));
    }
    String details = '';
    for (Perk perk in perks) {
      if (details.isEmpty) {
        details = perk.perkDetails;
        perkRowPerks.add(perk);
        continue;
      }
      if (details == perk.perkDetails) {
        perkRowPerks.add(perk);
        continue;
      }
      if (details != perk.perkDetails) {
        perkRows.add(
          PerkRow(
            perks: perkRowPerks,
          ),
        );
        perkRowPerks = [perk];
        details = perk.perkDetails;
      }
    }
    perkRows.add(
      PerkRow(
        perks: perkRowPerks,
      ),
    );
    return perkRows;
  }

  /// Darken a color by [percent] amount (100 = black)
// ........................................................
  static Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
    // '0x${Utils.darken(Color(int.parse(currentCharacter.playerClass.classColor))).value.toRadixString(16)}'
  }

  /// Lighten a color by [percent] amount (100 = white)
// ........................................................
  static Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
    // '0x${Utils.darken(Color(int.parse(currentCharacter.playerClass.classColor))).value.toRadixString(16)}'
  }
}
