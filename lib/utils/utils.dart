import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';

class Utils {
  static List<InlineSpan> generateCheckRowDetails(
    BuildContext context,
    String details,
    bool darkTheme,
  ) {
    List<InlineSpan> inlineList = [];
    // This makes Perk description text bold if it's [surrounded by square brackets]
    if (details.startsWith('[')) {
      String perkDescription =
          details.substring(details.indexOf('[') + 1, details.lastIndexOf(']'));
      details = details.substring(details.lastIndexOf(']') + 1);
      inlineList.add(
        TextSpan(
          text: perkDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 0.7,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    }
    List<String> list = details.split(' ');
    for (String element in list) {
      String? assetPath;
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
        switch (element.replaceAll(RegExp(r"[,.:()" "'" '"' "]"), '')) {
          case '-2':
            assetPath = 'attack_modifiers/minus_2.svg';
            break;
          case '-1':
            assetPath = 'attack_modifiers/minus_1.svg';
            break;
          case '+0':
            assetPath = 'attack_modifiers/plus_0.svg';
            break;
          case '+X':
            assetPath = 'attack_modifiers/plus_x.svg';
            break;
          case '2x':
            assetPath = 'attack_modifiers/2_x.svg';
            break;
          case '+1':
            assetPath = 'attack_modifiers/plus_1.svg';
            break;
          case '+2':
            assetPath = 'attack_modifiers/plus_2.svg';
            break;
          case '+3':
            assetPath = 'attack_modifiers/plus_3.svg';
            break;
          case '+4':
            assetPath = 'attack_modifiers/plus_4.svg';
            break;
          case 'pip_square':
            assetPath = 'pips/square.svg';
            break;
          case 'pip_circle':
            assetPath = 'pips/circle.svg';
            break;
          case 'pip_diamond_plus':
            assetPath = 'pips/diamond_plus.svg';
            break;
          case 'pip_diamond':
            assetPath = 'pips/diamond.svg';
            break;
          case 'pip_hex':
            assetPath = 'pips/hex.svg';
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
          case 'MOVE+1':
            assetPath = 'move.svg';
            invertColor = true;
            break;
          case 'JUMP':
            assetPath = 'jump.svg';
            invertColor = true;
            break;
          case 'Rolling':
            assetPath = 'rolling.svg';
            break;
          case 'HEAL':
          case 'HEAL+1':
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
          case 'Target+1':
            assetPath = darkTheme ? 'target_alt.svg' : 'target_alt_light.svg';
            break;
          case 'RANGE':
          case 'RANGE+1':
            assetPath = 'range.svg';
            invertColor = true;
            break;
          case 'LOOT':
            assetPath = 'loot.svg';
            invertColor = true;
            break;
          case 'RETALIATE':
            assetPath = 'retaliate.svg';
            invertColor = true;
            break;
          case 'ATTACK':
          case 'ATTACK+1':
            assetPath = 'attack.svg';
            invertColor = true;
            break;
          case 'RECOVER':
            assetPath =
                darkTheme ? 'recover_card.svg' : 'recover_card_light.svg';
            break;
          case 'SPENT':
            assetPath = darkTheme ? 'spent.svg' : 'spent_light.svg';
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
          case 'BANE':
            assetPath = 'bane.svg';
            break;
          case 'LUMINARY_HEXES':
            assetPath = 'luminary_hexes.svg';
            break;
          case 'SHADOW':
            assetPath = 'shadow.svg';
            break;
          case 'TIME_TOKEN':
            assetPath = 'time_token.svg';
            break;
          case 'DAMAGE':
            assetPath = darkTheme ? 'damage.svg' : 'damage_light.svg';
            break;
          case 'Shackle':
          case 'Shackled':
            assetPath = 'class_icons/chainguard.svg';
            invertColor = true;
            break;
          case 'Cultivate':
            assetPath = 'cultivate.svg';
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
            assetPath = 'glow.svg';
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
          case 'ALL_STANCES':
            assetPath = 'incarnate_all_stances.svg';
            break;
          case 'CRYSTALLIZE':
            assetPath = 'crystallize.svg';
            invertColor = true;
            break;
          case 'SPARK':
          case 'consume_SPARK':
            assetPath = 'spark.svg';
            invertColor = true;
            break;
          case 'RAGE':
            assetPath = 'class_icons/vanquisher.svg';
            invertColor = true;
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
          case 'Any_Element':
          case 'Consume_Any_Element':
            assetPath = 'elem_any.svg';
            break;
          case 'AIR/DARK':
          case 'consume_AIR/DARK':
            assetPath = 'elem_air_or_dark.svg';
            break;
          case 'AIR/EARTH':
          case 'consume_AIR/EARTH':
            assetPath = 'elem_air_or_earth.svg';
            break;
          case 'AIR/LIGHT':
          case 'consume_AIR/LIGHT':
            assetPath = 'elem_air_or_light.svg';
            break;
          case 'EARTH/DARK':
          case 'consume_EARTH/DARK':
            assetPath = 'elem_earth_or_dark.svg';
            break;
          case 'EARTH/LIGHT':
          case 'consume_EARTH/LIGHT':
            assetPath = 'elem_earth_or_light.svg';
            break;
          case 'FIRE/AIR':
          case 'consume_FIRE/AIR':
            assetPath = 'elem_fire_or_air.svg';
            break;
          case 'FIRE/DARK':
          case 'consume_FIRE/DARK':
            assetPath = 'elem_fire_or_dark.svg';
            break;
          case 'FIRE/EARTH':
          case 'consume_FIRE/EARTH':
            assetPath = 'elem_fire_or_earth.svg';
            break;
          case 'FIRE/ICE':
          case 'consume_FIRE/ICE':
            assetPath = 'elem_fire_or_ice.svg';
            break;
          case 'FIRE/LIGHT':
          case 'consume_FIRE/LIGHT':
            assetPath = 'elem_fire_or_light.svg';
            break;
          case 'ICE/AIR':
          case 'consume_ICE/AIR':
            assetPath = 'elem_ice_or_air.svg';
            break;
          case 'ICE/DARK':
          case 'consume_ICE/DARK':
            assetPath = 'elem_ice_or_dark.svg';
            break;
          case 'ICE/EARTH':
          case 'consume_ICE/EARTH':
            assetPath = 'elem_ice_or_earth.svg';
            break;
          case 'ICE/LIGHT':
          case 'consume_ICE/LIGHT':
            assetPath = 'elem_ice_or_light.svg';
            break;
          case 'LIGHT/DARK':
          case 'consume_LIGHT/DARK':
            assetPath = 'elem_light_or_dark.svg';
            break;
          case 'PERSIST':
            assetPath = 'persist.svg';
            invertColor = true;
            break;
          case 'plusone':
            assetPath = null;
            break;
          case 'pip_plus_one':
            assetPath = 'pips/pip_plus_one.svg';
            break;
          case 'plustwo':
            assetPath = null;
            break;
          case 'RESONANCE':
            assetPath = 'resonance.svg';
            break;
          case 'INFUSION':
            assetPath = 'infusion.svg';
            break;
          case 'TRANSFER':
            assetPath = 'transfer.svg';
            break;
          case 'TIDE':
            assetPath = 'tide.svg';
            break;
          case 'TROPHY':
            assetPath = 'trophy.svg';
            break;
          case 'PRESSURE_LOSE':
            assetPath = 'pressure_lose.svg';
            break;
          case 'PRESSURE_GAIN':
            assetPath = 'pressure_gain.svg';
            break;
          case 'PRESSURE_LOW':
            assetPath = 'pressure_low.svg';
            break;
          case 'PRESSURE_HIGH':
            assetPath = 'pressure_high.svg';
            break;
          case 'item_minus_one':
            assetPath =
                darkTheme ? 'item_minus_one_light.svg' : 'item_minus_one.svg';
            break;
        }
      }
      if (assetPath != null) {
        if ([
          '"',
          "'",
          '(',
        ].contains(element.characters.first)) {
          inlineList.add(
            TextSpan(
              text: element.characters.first,
            ),
          );
        }
        final double sizedBoxWidth =
            // Asset is 1.5x wide
            assetPath.contains('luminary_hexes') ||
                    assetPath.contains('item_minus_one')
                ? (iconSize - 2.5) * 1.5
                // Asset is double wide
                : assetPath.contains('_or_') || assetPath.contains('transfer')
                    ? (iconSize - 2.5) * 2
                    // Asset is triple wide
                    : assetPath.contains('incarnate_all_stances')
                        ? (iconSize - 2.5) * 3
                        : iconSize - 2.5;
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
                width: sizedBoxWidth,
                child: element.toLowerCase().contains('consume')
                    // Stack a Consume icon ontop of the Element icon
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          invertColor && darkTheme
                              ? SvgPicture.asset(
                                  'images/$assetPath',
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  'images/$assetPath',
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: SizedBox(
                              height: 12,
                              width: 12,
                              child: SvgPicture.asset(
                                'images/consume.svg',
                              ),
                            ),
                          ),
                        ],
                      )
                    : [
                        'ATTACK+1',
                        'MOVE+1',
                        'HEAL+1',
                        'Target+1,',
                      ].contains(element)
                        ? Stack(
                            alignment: const Alignment(
                              1.75,
                              -1.75,
                            ),
                            children: <Widget>[
                              invertColor && darkTheme
                                  ? SvgPicture.asset(
                                      'images/$assetPath',
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    )
                                  : SvgPicture.asset(
                                      'images/$assetPath',
                                    ),
                              SvgPicture.asset(
                                'images/plus_one.svg',
                                width: iconSize * .5,
                                height: iconSize * .5,
                              ),
                            ],
                          )
                        : invertColor && darkTheme
                            ? SvgPicture.asset(
                                'images/$assetPath',
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              )
                            : SvgPicture.asset(
                                'images/$assetPath',
                              ),
              ),
            ),
          ),
        );
        if ([
          '"',
          ',',
          ')',
          '.',
        ].contains(element.characters.last)) {
          inlineList.add(
            TextSpan(
              text: element.characters.last,
            ),
          );
        }
      } else if (element == '"plusone') {
        inlineList.add(
          const TextSpan(text: '"+1'),
        );
      } else if (element == 'plusone') {
        inlineList.add(
          const TextSpan(text: '+1'),
        );
      } else if (element == 'plustwo') {
        inlineList.add(
          const TextSpan(text: '+2'),
        );
      } else if (element.startsWith('~')) {
        inlineList.add(
          TextSpan(
            text: element.substring(1),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontStyle: FontStyle.italic),
          ),
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
  final Function(Size?) onChildSize;

  const SizeProviderWidget({
    super.key,
    required this.onChildSize,
    required this.child,
  });
  @override
  SizeProviderWidgetState createState() => SizeProviderWidgetState();
}

class SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        widget.onChildSize(context.size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class HighlightedWidget extends StatefulWidget {
  final Widget child;
  final Color color;
  final Duration duration;
  final bool animateBorder;

  const HighlightedWidget({
    super.key,
    required this.child,
    this.color = Colors.grey,
    this.duration = const Duration(milliseconds: 350),
    this.animateBorder = false,
  });

  @override
  HighlightedWidgetState createState() => HighlightedWidgetState();
}

class HighlightedWidgetState extends State<HighlightedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller with a duration of 500 milliseconds
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create a color tween animation to interpolate between the starting color and the target color
    _colorAnimation = ColorTween(
      begin: widget.animateBorder ? Colors.transparent : null,
      end: widget.color.withOpacity(0.5),
    ).animate(_controller);

    // Start the animation when the widget is created
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: widget.animateBorder && _colorAnimation.value != null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _colorAnimation.value!,
                    width: 2,
                  ),
                )
              : BoxDecoration(
                  color: _colorAnimation.value,
                ),
          child: widget.child,
        );
      },
    );
  }
}

RichText buildStyledText(String details, BuildContext context) {
  List<TextSpan> inlineList = [];
  int lastMatchEnd = 0;

  RegExp exp = RegExp(r'\*(.*?)\*');
  Iterable<RegExpMatch> matches = exp.allMatches(details);

  for (RegExpMatch match in matches) {
    // Add text between last matched pair of asterisks and the current pair
    String beforeText = details.substring(lastMatchEnd, match.start);
    if (beforeText.isNotEmpty) {
      inlineList.add(TextSpan(text: beforeText));
    }

    // Add the text between the asterisks in italic
    String italicText = match.group(1)!;
    inlineList.add(
      TextSpan(
        text: italicText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
            ),
      ),
    );

    lastMatchEnd = match.end;
  }

  // Add any remaining text after the last pair of asterisks
  if (lastMatchEnd < details.length) {
    inlineList.add(TextSpan(text: details.substring(lastMatchEnd)));
  }

  return RichText(
    text: TextSpan(
      children: inlineList,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  );
}
