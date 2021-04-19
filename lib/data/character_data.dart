import 'package:gloomhaven_enhancement_calc/models/perk.dart';

import '../models/player_class.dart';

class CharacterData {
  static final List<PlayerClass> playerClasses = [
    PlayerClass(
      'Inox',
      'Brute',
      'BR',
      'brute.png',
      false,
      '0xff4e7ec1',
    ),
    PlayerClass(
      'Quatryl',
      'Tinkerer',
      'TI',
      'tinkerer.png',
      false,
      '0xffc5b58d',
    ),
    PlayerClass(
      'Orchid',
      'Spellweaver',
      'SW',
      'spellweaver.png',
      false,
      '0xffb578b3',
    ),
    PlayerClass(
      'Human',
      'Scoundrel',
      'SC',
      'scoundrel.png',
      false,
      '0xffa5d166',
    ),
    PlayerClass(
      'Savvas',
      'Cragheart',
      'CH',
      'cragheart.png',
      false,
      '0xff899538',
    ),
    PlayerClass(
      'Vermling',
      'Mindthief',
      'MT',
      'mindthief.png',
      false,
      '0xff647c9d',
    ),
    PlayerClass(
      'Valrath',
      'Sunkeeper',
      'SK',
      'sunkeeper.png',
      true,
      '0xfff3c338',
    ),
    PlayerClass(
      'Valrath',
      'Quartermaster',
      'QM',
      'quartermaster.png',
      true,
      '0xffd98926',
    ),
    PlayerClass(
      'Aesther',
      'Summoner',
      'SU',
      'summoner.png',
      true,
      '0xffeb6ea3',
    ),
    PlayerClass(
      'Aesther',
      'Nightshroud',
      'NS',
      'nightshroud.png',
      true,
      '0xff9f9fcf',
    ),
    PlayerClass(
      'Harrower',
      'Plagueherald',
      'PH',
      'plagueherald.png',
      true,
      '0xff74c7bb',
    ),
    PlayerClass(
      'Inox',
      'Berserker',
      'BE',
      'berserker.png',
      true,
      '0xffd14e4e',
    ),
    PlayerClass(
      'Quatryl',
      'Soothsinger',
      'SS',
      'soothsinger.png',
      true,
      '0xffdf7e7a',
    ),
    PlayerClass(
      'Orchid',
      'Doomstalker',
      'DS',
      'doomstalker.png',
      true,
      '0xff38c3f1',
    ),
    PlayerClass(
      'Human',
      'Sawbones',
      'SB',
      'sawbones.png',
      true,
      '0xffdfddcb',
    ),
    PlayerClass(
      'Savvas',
      'Elementalist',
      'EL',
      'elementalist.png',
      true,
      '0xff9e9d9d',
    ),
    PlayerClass(
      'Vermling',
      'Beast Tyrant',
      'BT',
      'beast_tyrant.png',
      true,
      '0xffad745c',
    ),
    // ENVELOPE X
    PlayerClass(
      'Harrower',
      'Bladeswarm',
      'BS',
      'bladeswarm.png',
      false,
      '0xffae5a4d',
    ),
    // FORGOTTEN CIRCLES
    PlayerClass(
      'Aesther',
      'Diviner',
      'DV',
      'diviner.png',
      false,
      '0xff8bc5d3',
    ),
    // JAWS OF THE LION
    PlayerClass(
      'Quatryl',
      'Demolitionist',
      'DL',
      'demolitionist.png',
      false,
      '0xffe65c18',
    ),
    PlayerClass(
      'Inox',
      'Hatchet',
      'HC',
      'hatchet.png',
      false,
      '0xff78a1ad',
    ),
    PlayerClass(
      'Valrath',
      'Red Guard',
      'RG',
      'red_guard.png',
      false,
      '0xffe3393b',
    ),
    PlayerClass(
      'Human',
      'Voidwarden',
      'VW',
      'voidwarden.png',
      false,
      '0xffd9d9d9',
    ),
  ];

  static final List<int> levelXp = [45, 95, 150, 210, 275, 345, 420, 500];

  static final List<Perk> perks = [
    // BRUTE
    Perk('BR', 1, 'Remove two -1 cards'),
    Perk('BR', 1, 'Remove one -1 card and add one +1 card'),
    Perk('BR', 2, 'Add two +1 cards'),
    Perk('BR', 1, 'Add one +3 card'),
    Perk('BR', 2, 'Add three Rolling PUSH 1 cards'),
    Perk('BR', 1, 'Add two Rolling PIERCE 3 cards'),
    Perk('BR', 2, 'Add one Rolling STUN card'),
    Perk('BR', 1, 'Add one Rolling DISARM card and one Rolling MUDDLE card'),
    Perk('BR', 2, 'Add one Rolling ADD TARGET card'),
    Perk('BR', 1, 'Add one +1 SHIELD 1, Self card'),
    Perk('BR', 1, 'Ignore negative ITEM effects and add one +1 card'),
    // TINKERER
    Perk('TI', 2, 'Remove two -1 cards'),
    Perk('TI', 1, 'Replace one -2 card with one +0 card'),
    Perk('TI', 1, 'Add two +1 cards'),
    Perk('TI', 1, 'Add one +3 card'),
    Perk('TI', 1, 'Add two Rolling FIRE cards'),
    Perk('TI', 1, 'Add three Rolling MUDDLE cards'),
    Perk('TI', 2, 'Add one +1 WOUND card'),
    Perk('TI', 2, 'Add one +1 IMMOBILIZE card'),
    Perk('TI', 2, 'Add one +1 HEAL 2 card'),
    Perk('TI', 1, 'Add one +0 ADD TARGET card'),
    Perk('TI', 1, 'Ignore negative SCENARIO effects'),
    // SPELLWEAVER
    Perk('SW', 1, 'Remove four +0 cards'),
    Perk('SW', 2, 'replace one -1 card with one +1 card'),
    Perk('SW', 2, 'Add two +1 cards'),
    Perk('SW', 1, 'Add one +0 STUN card'),
    Perk('SW', 1, 'Add one +1 WOUND card'),
    Perk('SW', 1, 'Add one +1 IMMOBILIZE card'),
    Perk('SW', 1, 'Add one +1 CURSE card'),
    Perk('SW', 2, 'Add one +2 FIRE card'),
    Perk('SW', 2, 'Add one +2 ICE card'),
    Perk('SW', 1, 'Add one Rolling EARTH and one Rolling AIR card'),
    Perk('SW', 1, 'Add one Rolling LIGHT and one Rolling DARK card'),
    // SCOUNDREL
    Perk('SC', 2, 'Remove two -1 cards'),
    Perk('SC', 1, 'Remove four +0 cards'),
    Perk('SC', 1, 'Replace one -2 card with one +0 card'),
    Perk('SC', 1, 'Replace one -1 card with one +1 card'),
    Perk('SC', 2, 'Replace one +0 card with one +2 card'),
    Perk('SC', 2, 'Add two Rolling +1 cards'),
    Perk('SC', 1, 'Add two Rolling PIERCE 3 cards'),
    Perk('SC', 2, 'Add two Rolling POISON cards'),
    Perk('SC', 1, 'Add two Rolling MUDDLE cards'),
    Perk('SC', 1, 'Add one Rolling INVISIBLE card'),
    Perk('SC', 1, 'Ignore negative SCENARIO effects'),
    // CRAGHEART
    Perk('CH', 1, 'Remove four +0 cards'),
    Perk('CH', 3, 'Replace one -1 card with one +1 card'),
    Perk('CH', 1, 'Add one -2 card and two +2 cards'),
    Perk('CH', 2, 'Add one +1 IMMOBILIZE card'),
    Perk('CH', 2, 'Add one +2 MUDDLE card'),
    Perk('CH', 1, 'Add two Rolling PUSH 2 cards'),
    Perk('CH', 2, 'Add two Rolling EARTH cards'),
    Perk('CH', 1, 'Add two Rolling AIR cards'),
    Perk('CH', 1, 'Ignore negative ITEM effects'),
    Perk('CH', 1, 'Ignore negative SCENARIO effects'),
    // MINDTHIEF
    Perk('MT', 2, 'Remove two -1 cards'),
    Perk('MT', 1, 'Remove four +0 cards'),
    Perk('MT', 1, 'Replace two +1 cards with two +2 cards'),
    Perk('MT', 1, 'Replace one -2 card with one +0 card'),
    Perk('MT', 2, 'Add one +2 ICE card'),
    Perk('MT', 2, 'Add two Rolling +1 cards'),
    Perk('MT', 1, 'Add three Rolling PULL 1 cards'),
    Perk('MT', 1, 'Add three Rolling MUDDLE cards'),
    Perk('MT', 1, 'Add two Rolling IMMOBILIZE cards'),
    Perk('MT', 1, 'Add one Rolling STUN card'),
    Perk('MT', 1, 'Add one Rolling DISARM card and one Rolling MUDDLE card'),
    Perk('MT', 1, 'Ignore negative SCENARIO effects'),
    // SUNKEEPER
    Perk('SK', 2, 'Remove two -1 cards'),
    Perk('SK', 1, 'Remove four +0 cards'),
    Perk('SK', 1, 'Replace one -2 card with one +0 card'),
    Perk('SK', 1, 'Replace one +0 card with one +2 card'),
    Perk('SK', 2, 'Add two Rolling +1 cards'),
    Perk('SK', 2, 'Add two Rolling HEAL 1 cards'),
    Perk('SK', 1, 'Add one Rolling STUN card'),
    Perk('SK', 2, 'Add two Rolling LIGHT cards'),
    Perk('SK', 1, 'Add two Rolling SHIELD 1, Self cards'),
    Perk('SK', 1, 'Ignore negative ITEM effects and add two +1 cards'),
    Perk('SK', 1, 'Ignore negative SCENARIO effects'),
    // QUARTERMASTER
    Perk('QM', 2, 'Remove two -1 cards'),
    Perk('QM', 1, 'Remove four +0 cards'),
    Perk('QM', 2, 'Replace one +0 card with one +2 card'),
    Perk('QM', 2, 'Add two Rolling +1 cards'),
    Perk('QM', 1, 'Add three Rolling MUDDLE cards'),
    Perk('QM', 1, 'Add two Rolling PIERCE 3 cards'),
    Perk('QM', 1, 'Add one Rolling STUN card'),
    Perk('QM', 1, 'Add one Rolling ADD TARGET card'),
    Perk('QM', 3, 'Add one +0 Refresh an item card'),
    Perk('QM', 1, 'Ignore negative ITEM effects and add two +1 cards'),
    // SUMMONER
    Perk('SU', 1, 'Remove two -1 cards'),
    Perk('SU', 1, 'Replace one -2 card with one +0 card'),
    Perk('SU', 3, 'Replace one -1 card with one +1 card'),
    Perk('SU', 2, 'Add one +2 card'),
    Perk('SU', 1, 'Add two Rolling WOUND cards'),
    Perk('SU', 1, 'Add two Rolling POISON cards'),
    Perk('SU', 3, 'Add two Rolling HEAL 1 cards'),
    Perk('SU', 1, 'Add one Rolling FIRE and one Rolling AIR card'),
    Perk('SU', 1, 'Add one Rolling DARK and one Rolling EARTH card'),
    Perk('SU', 1, 'Ignore negative SCENARIO effects and add two +1 cards'),
    // NIGHTSHROUD
    Perk('NS', 2, 'Remove two -1 cards'),
    Perk('NS', 1, 'Remove four +0 cards'),
    Perk('NS', 2, 'Add one -1 DARK card'),
    Perk('NS', 2, 'Replace one -1 DARK card with one +1 DARK card'),
    Perk('NS', 2, 'Add one +1 INVISIBLE card'),
    Perk('NS', 2, 'Add three Rolling MUDDLE cards'),
    Perk('NS', 1, 'Add two Rolling HEAL 1 cards'),
    Perk('NS', 1, 'Add two Rolling CURSE cards'),
    Perk('NS', 1, 'Add one Rolling ADD TARGET card'),
    Perk('NS', 1, 'Ignore negative SCENARIO effects and add two +1 cards'),
    // PLAGUEHERALD
    Perk('PH', 1, 'Replace one -2 card with one +0 card'),
    Perk('PH', 2, 'Replace one -1 card with one +1 card'),
    Perk('PH', 2, 'Replace one +0 card with one +2 card'),
    Perk('PH', 1, 'Add two +1 cards'),
    Perk('PH', 3, 'Add one +1 AIR card'),
    Perk('PH', 1, 'Add three Rolling POISON cards'),
    Perk('PH', 1, 'Add two Rolling CURSE cards'),
    Perk('PH', 1, 'Add two Rolling IMMOBILIZE cards'),
    Perk('PH', 2, 'Add one Rolling STUN card'),
    Perk('PH', 1, 'Ignore negative SCENARIO effects and add one +1 card'),
    // BERSERKER
    Perk('BE', 1, 'Remove two -1 cards'),
    Perk('BE', 1, 'Remove four +0 cards'),
    Perk('BE', 2, 'Replace one -1 card with one +1 card'),
    Perk('BE', 2, 'Replace one +0 card with one Rolling +2 card'),
    Perk('BE', 2, 'Add two Rolling WOUND cards'),
    Perk('BE', 2, 'Add one Rolling STUN card'),
    Perk('BE', 1, 'Add one Rolling +1 DISARM card'),
    Perk('BE', 1, 'Add two Rolling HEAL 1 cards'),
    Perk('BE', 2, 'Add one +2 FIRE card'),
    Perk('BE', 1, 'Ignore negative ITEM effects'),
    //SOOTHSAYER
    Perk('SS', 2, 'Remove two -1 cards'),
    Perk('SS', 1, 'Remove one -2 card'),
    Perk('SS', 2, 'Replace two +1 cards with one +4 card'),
    Perk('SS', 1, 'Replace one +0 card with one +1 IMMOBILIZE card'),
    Perk('SS', 1, 'Replace one +0 card with one +1 DISARM card'),
    Perk('SS', 1, 'Replace one +0 card with one +2 WOUND card'),
    Perk('SS', 1, 'Replace one +0 card with one +2 POISON card'),
    Perk('SS', 1, 'Replace one +0 card with one +2 CURSE card'),
    Perk('SS', 1, 'Replace one +0 card with one +3 MUDDLE card'),
    Perk('SS', 1, 'Replace one -1 card with one +0 STUN card'),
    Perk('SS', 1, 'Add three Rolling +1 cards'),
    Perk('SS', 2, 'Add two Rolling CURSE cards'),
    // DOOMSTALKER
    Perk('DS', 2, 'Remove two -1 cards'),
    Perk('DS', 3, 'Replace two +0 cards with two +1 cards'),
    Perk('DS', 2, 'Add two Rolling +1 cards'),
    Perk('DS', 1, 'Add one +2 MUDDLE card'),
    Perk('DS', 1, 'Add one +1 POISON card'),
    Perk('DS', 1, 'Add one +1 WOUND card'),
    Perk('DS', 1, 'Add one +1 IMMOBILIZE card'),
    Perk('DS', 1, 'Add one +0 STUN card'),
    Perk('DS', 2, 'Add one Rolling ADD TARGET card'),
    Perk('DS', 1, 'Ignore negative SCENARIO effects'),
    // SAWBONES
    Perk('SB', 2, 'Remove two -1 cards'),
    Perk('SB', 1, 'Remove four +0 cards'),
    Perk('SB', 2, 'Replace one +0 card with one +2 card'),
    Perk('SB', 2, 'Add one Rolling +2 card'),
    Perk('SB', 2, 'Add one +1 IMMOBILIZE card'),
    Perk('SB', 2, 'Add two Rolling WOUND cards'),
    Perk('SB', 1, 'Add one Rolling STUN card'),
    Perk('SB', 2, 'Add one Rolling HEAL 3 card'),
    Perk('SB', 1, 'Add one +0 Refresh and item card'),
    // ELEMENTALIST
    Perk('EL', 2, 'Remove two -1 cards'),
    Perk('EL', 1, 'Replace one -1 card with one +1 card'),
    Perk('EL', 2, 'Replace one +0 card with one +2 card'),
    Perk('EL', 1, 'Add three +0 FIRE cards'),
    Perk('EL', 1, 'Add three +0 ICE cards'),
    Perk('EL', 1, 'Add three +0 AIR cards'),
    Perk('EL', 1, 'Add three +0 EARTH cards'),
    Perk('EL', 1,
        'Replace two +0 cards with one +0 FIRE card and one +0 EARTH card'),
    Perk('EL', 1,
        'Replace two +0 cards with one +0 ICE card and one +0 AIR card'),
    Perk('EL', 1, 'Add two +1 PUSH 1 cards'),
    Perk('EL', 1, 'Add one +1 WOUND card'),
    Perk('EL', 1, 'Add one +0 STUN card'),
    Perk('EL', 1, 'Add one +0 ADD TARGET card'),
    // BEAST TYRANT
    Perk('BT', 1, 'Remove two -1 cards'),
    Perk('BT', 3, 'Replace one -1 card with one +1 card'),
    Perk('BT', 2, 'Replace one +0 card with one +2 card'),
    Perk('BT', 2, 'Add one +1 WOUND card'),
    Perk('BT', 2, 'Add one +1 IMMOBILIZE card'),
    Perk('BT', 3, 'Add two Rolling HEAL 1 cards'),
    Perk('BT', 1, 'Add two Rolling EARTH cards'),
    Perk('BT', 1, 'Ignore negative SCENARIO effects'),
    // BLADESWARM
    Perk('BS', 1, 'Remove one -2 card'),
    Perk('BS', 1, 'Remove four +0 cards'),
    Perk('BS', 1, 'Replace one -1 card with one +1 AIR card'),
    Perk('BS', 1, 'Replace one -1 card with one +1 EARTH card'),
    Perk('BS', 1, 'Replace one -1 card with one +1 LIGHT card'),
    Perk('BS', 1, 'Replace one -1 card with one +1 DARK card'),
    Perk('BS', 2, 'Add two Rolling HEAL 1 cards'),
    Perk('BS', 2, 'Add one +1 WOUND card'),
    Perk('BS', 2, 'Add one +1 POISON card'),
    Perk('BS', 1, 'Add one +2 MUDDLE card'),
    Perk('BS', 1, 'Ignore negative ITEM effects and add one +1 card'),
    Perk('BS', 1, 'Ignore negative SCENARIO effects and add one +1 card'),
    // DIVINER
    Perk('DV', 2, 'Remove two -1 cards'),
    Perk('DV', 1, 'Remove one -2 card'),
    Perk('DV', 2, 'Replace two +1 cards with one +3 SHIELD 1, Self card'),
    Perk('DV', 1,
        'Replace one +0 card with one +1 SHIELD 1, Affect any ally card'),
    Perk('DV', 1, 'Replace one +0 card with one +2 DARK card'),
    Perk('DV', 1, 'Replace one +0 card with one +2 LIGHT card'),
    Perk('DV', 1, 'Replace one +0 card with one +3 MUDDLE card'),
    Perk('DV', 1, 'Replace one +0 card with one +2 CURSE card'),
    Perk('DV', 1, 'Replace one +0 card with one +2 REGENERATE, Self card'),
    Perk('DV', 1,
        'Replace one -1 card with one +1 HEAL 2, Affect any ally card'),
    Perk('DV', 1, 'Add two Rolling HEAL 1, Self cards'),
    Perk('DV', 1, 'Add two Rolling CURSE cards'),
    Perk('DV', 1, 'Ignore negative SCENARIO effects and add two +1 cards'),
    // DEMOLITIONIST
    Perk('DL', 1, 'Remove four +0 cards'),
    Perk('DL', 2, 'Remove two -1 cards'),
    Perk('DL', 1, 'Remove one -2 card and one +1 card'),
    Perk('DL', 2, 'Replace one +0 card with one +2 MUDDLE card'),
    Perk('DL', 1, 'Replace one -1 card with one +0 POISON card'),
    Perk('DL', 2, 'Add one +2 card'),
    Perk('DL', 2, 'Replace one +1 card with one +2 EARTH card'),
    Perk('DL', 2, 'Replace one +1 card with one +2 FIRE card'),
    Perk('DL', 2, 'Add one +0 All adjacent enemies SUFFER 1 damage card'),
    // HATCHET
    Perk('HC', 2, 'Remove two -1 cards'),
    Perk('HC', 1, 'Replace one +0 card with one +2 MUDDLE card'),
    Perk('HC', 1, 'Replace one +0 card with one +1 POISON card'),
    Perk('HC', 1, 'Replace one +0 card with one +1 WOUND card'),
    Perk('HC', 1, 'Replace one +0 card with one +1 IMMOBILIZE card'),
    Perk('HC', 1, 'Replace one +0 card with one +1 PUSH 2 card'),
    Perk('HC', 1, 'Replace one +0 card with one +0 STUN card'),
    Perk('HC', 1, 'Replace one +1 card with one +1 STUN card'),
    Perk('HC', 3, 'Add one +2 AIR card'),
    Perk('HC', 3, 'Replace one +1 card with one +3 card'),
    // RED GUARD
    Perk('RG', 1, 'Remove four +0 cards'),
    Perk('RG', 1, 'Remove two -1 cards'),
    Perk('RG', 1, 'Remove one -2 card and one +1 card'),
    Perk('RG', 2, 'Replace one -1 card with one +1 card'),
    Perk('RG', 2, 'Replace one +1 card with one +2 FIRE card'),
    Perk('RG', 2, 'Replace one +1 card with one +2 LIGHT card'),
    Perk('RG', 2, 'Add one +1 FIRE/LIGHT card'),
    Perk('RG', 2, 'Add one +1 SHIELD 1 card'),
    Perk('RG', 1, 'Replace one +0 card with one +1 IMMOBILIZE card'),
    Perk('RG', 1, 'Replace one +0 card with one +1 WOUND card'),
    // VOIDWARDEN
    Perk('VW', 1, 'Remove two -1 cards'),
    Perk('VW', 1, 'Remove one -2 card'),
    Perk('VW', 2, 'Replace one +0 card with one +1 DARK card'),
    Perk('VW', 2, 'Replace one +0 card with one +1 ICE card'),
    Perk('VW', 2, 'Replace one -1 card with one +0 HEAL 1, Ally card'),
    Perk('VW', 3, 'Add one +1 HEAL 1, Ally card'),
    Perk('VW', 1, 'Add one +1 POISON card'),
    Perk('VW', 1, 'Add one +3 card'),
    Perk('VW', 2, 'Add one +1 CURSE card'),
  ];
}
