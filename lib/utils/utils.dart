import 'package:flutter/material.dart';

class Utils {
  static List<InlineSpan> generatePerkDetailsWithInlineIcons(
    List<String> list,
    bool darkTheme,
  ) {
    List<InlineSpan> inlineList = [];
    list.forEach((element) {
      String assetPath;
      bool invertColor = false;
      switch (element) {
        case ('+0'):
          assetPath = 'attack_modifiers/plus_0.png';
          break;
        case ('+1'):
          assetPath = 'attack_modifiers/plus_1.png';
          break;
        case ('-1'):
          assetPath = 'attack_modifiers/minus_1.png';
          break;
        case ('+2'):
          assetPath = 'attack_modifiers/plus_2.png';
          break;
        case ('-2'):
          assetPath = 'attack_modifiers/minus_2.png';
          break;
        case ('Rolling'):
          assetPath = 'rolling.png';
          break;
        case ('HEAL'):
          assetPath = 'heal.png';
          invertColor = true;
          break;
        case ('SHIELD'):
          assetPath = 'shield.png';
          invertColor = true;
          break;
        case ('STUN'):
          assetPath = 'stun.png';
          break;
        case ('WOUND'):
          assetPath = 'wound.png';
          break;
        case ('CURSE'):
          assetPath = 'curse.png';
          break;
        case ('PIERCE'):
          assetPath = 'pierce.png';
          break;
        case ('REGENERATE,'):
          assetPath = 'regenerate.png';
          break;
        case ('DISARM'):
          assetPath = 'disarm.png';
          break;
        case ('BLESS'):
          assetPath = 'bless.png';
          break;
        case ('TARGET'):
          assetPath = 'target.png';
          break;
        case ('PUSH'):
          assetPath = 'push.png';
          break;
        case ('PULL'):
          assetPath = 'pull.png';
          break;
        case ('IMMOBILIZE'):
          assetPath = 'immobilize.png';
          break;
        case ('POISON'):
          assetPath = 'poison.png';
          break;
        case ('MUDDLE'):
          assetPath = 'muddle.png';
          break;
        case ('INVISIBLE'):
          assetPath = 'invisible.png';
          break;
        // ELEMENTS
        case ('EARTH'):
          assetPath = 'elem_earth.png';
          break;
        case ('AIR'):
          assetPath = 'elem_air.png';
          break;
        case ('DARK'):
          assetPath = 'elem_dark.png';
          break;
        case ('LIGHT'):
          assetPath = 'elem_light.png';
          break;
        case ('ICE'):
          assetPath = 'elem_ice.png';
          break;
        case ('FIRE'):
          assetPath = 'elem_fire.png';
          break;
        case ('FIRE/LIGHT'):
          assetPath = 'elem_fire_light.png';
          break;
        default:
      }
      if (assetPath != null) {
        inlineList.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Tooltip(
              message: '${element.toLowerCase()}',
              child: Container(
                height: 35,
                width: 35,
                child: invertColor && darkTheme
                    ? Image.asset(
                        'images/$assetPath',
                        color: Colors.white70,
                      )
                    : Image.asset(
                        'images/$assetPath',
                      ),
              ),
            ),
          ),
        );
      } else {
        inlineList.add(
          TextSpan(text: element),
        );
      }
      inlineList.add(
        TextSpan(text: ' '),
      );
    });
    return inlineList;
  }
}
