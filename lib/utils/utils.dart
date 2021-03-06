import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perk_row.dart';

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
      }
      // TODO: create half-and-half element icon
      // else if (element.contains('/')) {}
      else {
        switch (
            element.replaceAll(RegExp(r'"'), '').replaceAll(RegExp(r','), '')) {
          case ('-2'):
            assetPath = 'attack_modifiers/minus_2.png';
            break;
          case ('-1'):
            assetPath = 'attack_modifiers/minus_1.png';
            break;
          case ('+0'):
            assetPath = 'attack_modifiers/plus_0.png';
            break;
          case ('+X'):
            assetPath = 'attack_modifiers/plus_x.png';
            break;
          case ('+1'):
            assetPath = 'attack_modifiers/plus_1.png';
            break;
          case ('+2'):
            assetPath = 'attack_modifiers/plus_2.png';
            break;
          case ('+3'):
            assetPath = 'attack_modifiers/plus_3.png';
            break;
          case ('+4'):
            assetPath = 'attack_modifiers/plus_4.png';
            break;
          case ('Rolling'):
            assetPath = 'rolling.svg';
            break;
          case ('HEAL'):
            assetPath = 'heal.svg';
            invertColor = true;
            break;
          case ('SHIELD'):
            assetPath = 'shield.svg';
            invertColor = true;
            break;
          case ('STUN'):
            assetPath = 'stun.svg';
            break;
          case ('WOUND'):
            assetPath = 'wound.svg';
            break;
          case ('CURSE'):
            assetPath = 'curse.svg';
            break;
          case ('PIERCE'):
            assetPath = 'pierce.svg';
            break;
          case ('REGENERATE'):
            assetPath = 'regenerate.svg';
            break;
          case ('DISARM'):
            assetPath = 'disarm.svg';
            break;
          case ('BLESS'):
            assetPath = 'bless.svg';
            break;
          case ('TARGET'):
            assetPath = 'target.svg';
            break;
          case ('Range'):
            assetPath = 'range.svg';
            invertColor = true;
            break;
          case ('RETALIATE'):
            assetPath = 'retaliate.svg';
            invertColor = true;
            break;
          case ('PUSH'):
            assetPath = 'push.svg';
            break;
          case ('PULL'):
            assetPath = 'pull.svg';
            break;
          case ('IMMOBILIZE'):
            assetPath = 'immobilize.svg';
            break;
          case ('POISON'):
            assetPath = 'poison.svg';
            break;
          case ('MUDDLE'):
            assetPath = 'muddle.svg';
            break;
          case ('INVISIBLE'):
            assetPath = 'invisible.svg';
            break;
          case ('STRENGTHEN'):
            assetPath = 'strengthen.svg';
            break;
          case ('CHILL'):
            assetPath = 'chill.svg';
            break;
          case ('PROVOKE'):
            assetPath = 'provoke.svg';
            break;
          case ('BRITTLE'):
            assetPath = 'brittle.svg';
            break;
          case ('WARD'):
            assetPath = 'ward.svg';
            break;
          case ('Shrug_Off'):
            assetPath = 'shrug_off.svg';
            invertColor = true;
            break;
          case ('Projectile'):
            assetPath = 'projectile.svg';
            invertColor = true;
            break;
          case ('VOID'):
            assetPath = 'void.svg';
            break;
          case ('VOIDSIGHT'):
            assetPath = 'voidsight.svg';
            invertColor = true;
            break;
          // ELEMENTS
          case ('EARTH'):
            assetPath = 'elem_earth.svg';
            break;
          case ('AIR'):
            assetPath = 'elem_air.svg';
            break;
          case ('DARK'):
            assetPath = 'elem_dark.svg';
            break;
          case ('LIGHT'):
            assetPath = 'elem_light.svg';
            break;
          case ('ICE'):
            assetPath = 'elem_ice.svg';
            break;
          case ('FIRE'):
            assetPath = 'elem_fire.svg';
            break;
          // TODO: remove this once first TODO is done
          case ('EARTH/FIRE'):
            assetPath = 'elem_earth_or_fire.svg';
            break;
          case ('ANY_ELEMENT'):
            assetPath = 'elem_any.svg';
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
              message: element.toLowerCase(),
              child: SizedBox(
                height: iconSize - 5,
                width: iconSize - 5,
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
        perkRows.add(PerkRow(
          perks: perkRowPerks,
        ));
        perkRowPerks = [perk];
        details = perk.perkDetails;
      }
    }
    perkRows.add(PerkRow(
      perks: perkRowPerks,
    ));
    return perkRows;
  }
}
