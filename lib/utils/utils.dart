import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/constants.dart';

class Utils {
  static List<InlineSpan> generateCheckRowDetails(
    String details,
    bool darkTheme,
  ) {
    List<InlineSpan> inlineList = [];
    List<String> list = details.split(' ');
    for (String element in list) {
      String assetPath;
      bool invertColor = false;
      if (element.contains('&')) {
        // Stack both Elements
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
        switch (element.replaceAll(RegExp(r'[",:()]'), '')) {
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
          case '2x':
            assetPath = 'attack_modifiers/2_x.png';
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
          case 'Two_Hand':
            assetPath = 'equipment_slots/two_handed.svg';
            invertColor = true;
            break;
          case 'MOVE':
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
          case 'RANGE':
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
          case 'ATTACK':
            assetPath = 'attack.svg';
            invertColor = true;
            break;
          case 'Recover':
          case 'REFRESH':
            assetPath =
                darkTheme ? 'recover_card.svg' : 'recover_card_light.svg';
            break;
          // case 'REFRESH':
          //   assetPath =
          //       darkTheme ? 'refresh_item.svg' : 'refresh_item_light.svg';
          //   break;
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
          case 'ENFEEBLE':
            assetPath = 'enfeeble.svg';
            break;
          case 'INFECT':
            assetPath = 'infect.svg';
            break;
          case 'DODGE':
            assetPath = 'dodge.svg';
            break;
          case 'IMMUNE':
            assetPath = 'immune.svg';
            break;
          case 'IMPAIR':
            assetPath = 'impair.svg';
            break;
          case 'HEX':
            assetPath = 'luminary_hexes.svg';
            break;
          case 'SHADOW':
            assetPath = 'shadow.svg';
            invertColor = true;
            break;
          case 'TIME_TOKEN':
            assetPath = 'time_token.svg';
            invertColor = true;
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
          case 'CONQUEROR':
            assetPath = 'conqueror.svg';
            break;
          case 'REAVER':
            assetPath = 'reaver.svg';
            break;
          case 'RITUALIST':
            assetPath = 'ritualist.svg';
            break;
          // ELEMENTS
          case 'EARTH':
          case 'consume_EARTH':
            assetPath = 'elem_earth.svg';
            break;
          case 'AIR':
          case 'consume_AIR':
            assetPath = 'elem_air.svg';
            break;
          case 'AIR/DARK':
          case 'consume_AIR/DARK':
            assetPath = 'elem_air_or_dark.svg';
            break;
          case 'DARK':
          case 'consume_DARK':
            assetPath = 'elem_dark.svg';
            break;
          case 'LIGHT':
          case 'consume_LIGHT':
            assetPath = 'elem_light.svg';
            break;
          case 'ICE':
          case 'consume_ICE':
            assetPath = 'elem_ice.svg';
            break;
          case 'FIRE':
          case 'consume_FIRE':
            assetPath = 'elem_fire.svg';
            break;
          case 'EARTH/FIRE':
          case 'consume_EARTH/FIRE':
            assetPath = 'elem_earth_or_fire.svg';
            break;
          case 'EARTH/AIR':
          case 'consume_EARTH/AIR':
            assetPath = 'elem_earth_or_air.svg';
            break;
          case 'EARTH/DARK':
          case 'consume_EARTH/DARK':
            assetPath = 'elem_earth_or_dark.svg';
            break;
          case 'FIRE/ICE':
          case 'consume_FIRE/ICE':
            assetPath = 'elem_fire_or_ice.svg';
            break;
          // TODO: get this icon
          // case 'FIRE/AIR':
          // case 'consume_FIRE/AIR':
          //   assetPath = 'elem_fire_or_air.svg';
          //   break;
          case 'Any_Element':
          case 'Consume_Any_Element':
            assetPath = 'elem_any.svg';
            break;
          case 'plusone':
            assetPath = null;
            break;
          //TODO: get the RESONANCE icon
          // case 'RESONANCE':
          //   assetPath = 'resonance.svg';
          //   break;
          //TODO: get the INFUSION icon
          // case 'INFUSION':
          //   assetPath = 'infusion.svg';
          //   break;
          //TODO: get the Item Minus One icon
          // case 'item_minus_one':
          //   assetPath = 'item_minus_one.svg';
          //   break;
        }
      }
      if (assetPath != null) {
        if (element.startsWith('"')) {
          inlineList.add(
            const TextSpan(text: '"'),
          );
        }
        if (element.startsWith('(')) {
          inlineList.add(
            const TextSpan(text: '('),
          );
        }
        inlineList.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Tooltip(
              message: element
                  .toLowerCase()
                  .replaceAll(RegExp('[\\"|\\,]'), '')
                  .replaceAll(RegExp('[\\_]'), ' ')
                  .toTitleCase,
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
                        ? element.toLowerCase().contains('consume')
                            // Stack a Consume icon ontop of the Element icon
                            ? Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  SvgPicture.asset(
                                    'images/$assetPath',
                                  ),
                                  SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: SvgPicture.asset(
                                      'images/consume.svg',
                                    ),
                                  ),
                                ],
                              )
                            : SvgPicture.asset(
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
        if (element.endsWith(')')) {
          inlineList.add(
            const TextSpan(text: ')'),
          );
        }
        // this is specific to the Infuser character sheet
      } else if (element == '"plusone') {
        inlineList.add(
          const TextSpan(text: '"+1'),
        );
      } else if (element == 'plusone') {
        inlineList.add(
          const TextSpan(text: '+1'),
        );
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
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({
    Key key,
    this.onChildSize,
    this.child,
  }) : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    super.initState();
    if (context != null && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onChildSize(context.size);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
