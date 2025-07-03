import 'package:gloomhaven_enhancement_calc/data/player_classes/character_constants.dart';
import 'package:gloomhaven_enhancement_calc/models/perk/perk.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class PerksRepository {
  // Action verbs
  static const _add = 'Add';
  static const _addLowercase = 'add';
  static const _remove = 'Remove';
  static const _removeLowercase = 'remove';
  static const _replace = 'Replace';

  // Numbers as words
  static const _one = 'one';
  static const _two = 'two';
  static const _three = 'three';
  static const _four = 'four';

  // Card-related terms
  static const _card = 'card';
  static const _cards = 'cards';
  static const _rolling = 'Rolling';

  // Effects and conditions
  static const _effects = 'effects';
  static const _immobilize = 'IMMOBILIZE';
  static const _regenerate = 'REGENERATE';
  static const _retaliate = 'RETALIATE';
  static const _shield = 'SHIELD';
  static const _ward = 'WARD';
  static const _push = 'PUSH';
  static const _pierce = 'PIERCE';
  static const _stun = 'STUN';
  static const _disarm = 'DISARM';
  static const _muddle = 'MUDDLE';
  static const _fire = 'FIRE';
  static const _light = 'LIGHT';
  static const _wound = 'WOUND';
  static const _heal = 'HEAL';
  static const _curse = 'CURSE';

  // Modifiers
  static const _negative = 'negative';

  // Scenario-related
  static const _scenario = 'scenario';
  static const _atTheStartOfEachScenario = 'At the start of each scenario';

  // Item-related
  static const _ignoreItemMinusOneEffects =
      'Ignore item item_minus_one effects';
  static const _ignoreNegativeItemEffects = 'Ignore negative item effects';
  static const _ignoreScenarioEffects = 'Ignore scenario effects';

  // Rest-related
  static const _wheneverYouLongRest = 'Whenever you long rest';
  static const _wheneverYouShortRest = 'Whenever you short rest';

  static final Map<String, List<Perks>> perksMap = {
    // BRUTE
    ClassCodes.brute: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove $_one -1 $_card and $_addLowercase $_one +1 $_card'),
          Perk(
            '$_add $_two +1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one +3 $_card'),
          Perk(
            '$_add $_three $_rolling $_push 1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_pierce 3 $_cards'),
          Perk(
            '$_add $_one $_rolling $_stun $_card',
            quantity: 2,
          ),
          Perk(
              '$_add $_one $_rolling $_disarm $_card and $_one $_rolling $_muddle $_card'),
          Perk(
            '$_add $_one $_rolling ADD TARGET $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +1 "$_shield  Self" $_card'),
          Perk(
              'Ignore $_negative item $_effects and $_addLowercase $_one +1 $_card'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 2,
          ),
          Perk(
            'Replace one -1 card with three +0 $_push 1 $_rolling cards',
            quantity: 2,
          ),
          Perk('$_replace two +0 cards with two +0 $_pierce 3 $_rolling cards'),
          Perk(
            '$_replace one +0 card with two +1 cards',
            quantity: 2,
          ),
          Perk(
            '$_replace one +0 card with one +0 "plusone Target" $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add one +0 $_stun $_rolling card',
            quantity: 2,
          ),
          Perk(
              'Add one +0 $_disarm $_rolling card and one +0 $_muddle $_rolling card'),
          Perk('$_add $_one +3 card'),
          Perk(
              '$_ignoreItemMinusOneEffects and $_addLowercase $_one +1 "$_shield 1" card'),
          Perk(
              '[Rested and Ready:] $_wheneverYouLongRest, add +1 MOVE to your first move ability the following round'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.tinkerer: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -2 $_card with $_one +0 $_card',
          ),
          Perk(
            '$_add $_two +1 $_cards',
          ),
          Perk(
            '$_add $_one +3 $_card',
          ),
          Perk(
            '$_add $_two $_rolling $_fire $_cards',
          ),
          Perk(
            '$_add $_three $_rolling $_muddle $_cards',
          ),
          Perk(
            '$_add $_one +1 $_wound $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_heal 2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +0 ADD TARGET $_card',
          ),
          Perk(
            'Ignore $_negative $_scenario $_effects',
          ),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one +0 card'),
          Perk('Replace one +0 card with one +0 "plusone Target" card'),
          Perk(
            'Replace one +0 card with one +1 $_wound card',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with one +1 $_immobilize card',
            quantity: 2,
          ),
          Perk('Replace two +0 cards with three +0 $_muddle $_rolling cards'),
          Perk('Add one +3 card'),
          Perk('Add two +1 "$_heal 2, self" cards'),
          Perk('$_ignoreScenarioEffects and add two +0 $_fire $_rolling cards'),
          Perk(
            '[Rejuvenating Vapor:] $_wheneverYouLongRest, you may perform "$_heal 2, RANGE 3"',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.spellweaver: [
      Perks(
        [
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two +1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one +0 $_stun $_card'),
          Perk('$_add $_one +1 $_wound $_card'),
          Perk('$_add $_one +1 $_immobilize $_card'),
          Perk('$_add $_one +1 $_curse $_card'),
          Perk(
            '$_add $_one +2 $_fire $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 ICE $_card',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling EARTH and $_one $_rolling AIR $_card'),
          Perk('$_add $_one $_rolling $_light and $_one $_rolling DARK $_card'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove one -2 card'),
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 2,
          ),
          Perk(
              'Replace one -1 card with one +0 AIR $_rolling card and one +0 EARTH $_rolling card'),
          Perk(
              'Replace one -1 card with one +0 $_light $_rolling card and one +0 DARK $_rolling card'),
          Perk('Replace one +0 card with one +1 $_wound card'),
          Perk('Replace one +0 card with one +1 $_immobilize card'),
          Perk('Replace one +0 card with one +1 $_stun card'),
          Perk('Replace one +0 card with one +1 $_curse card'),
          Perk(
            'Add one +2 $_fire card',
            quantity: 2,
          ),
          Perk(
            'Add one +2 ICE card',
            quantity: 2,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
              '[Etheric Bond:] $_wheneverYouShortRest, if ~Reviving ~Ether is in your discard pile, first return it to your hand'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.scoundrel: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove four +0 $_cards'),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling +1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_pierce 3 $_cards'),
          Perk(
            '$_add $_two $_rolling POISON $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_muddle $_cards'),
          Perk('$_add $_one $_rolling INVISIBLE $_card'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk('Replace one -1 card with one +1 card'),
          Perk(
            'Replace one -1 card with two +0 POISON $_rolling cards',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one +0 card'),
          Perk(
            'Replace one +0 card with one +2 card',
            quantity: 2,
          ),
          Perk(
            'Replace two +0 cards with one +0 $_muddle $_rolling card and one +0 $_pierce 3 $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add two +1 $_rolling cards',
            quantity: 2,
          ),
          Perk('Add one +0 "INVISIBLE, self", $_rolling card'),
          Perk(_ignoreScenarioEffects),
          Perk(
            '[Cloak of Invisibility:] Once each scenario, during your turn, perform "INVISIBLE, self"',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.cragheart: [
      Perks(
        [
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 3,
          ),
          Perk('$_add $_one -2 $_card and $_two +2 $_cards'),
          Perk(
            '$_add $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 $_muddle $_card',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_push 2 $_cards'),
          Perk(
            '$_add $_two $_rolling EARTH $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling AIR $_cards'),
          Perk('Ignore $_negative item $_effects'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 3,
          ),
          Perk('Replace one +0 card with two +0 $_push 2 $_rolling cards'),
          Perk(
            'Replace one +0 card with one +1 $_immobilize card',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with one +2 card',
            quantity: 2,
          ),
          Perk(
            'Add one +2 $_muddle card and one +0 AIR $_rolling card',
            quantity: 2,
          ),
          Perk('Add four +0 EARTH $_rolling cards'),
          Perk(_ignoreItemMinusOneEffects),
          Perk(_ignoreScenarioEffects),
          Perk(
            '[Earthquakes:] Whenever a new room is revealed, control all enemies in the newly revealed room: MOVE 1, this movement must end in an empty hex',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.mindthief: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove four +0 $_cards'),
          Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_add $_one +2 ICE $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling +1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_three $_rolling PULL 1 $_cards'),
          Perk('$_add $_three $_rolling $_muddle $_cards'),
          Perk('$_add $_two $_rolling $_immobilize $_cards'),
          Perk('$_add $_one $_rolling $_stun $_card'),
          Perk(
              '$_add $_one $_rolling $_disarm $_card and $_one $_rolling $_muddle $_card'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk(
            'Replace one -1 card with one +0 $_immobilize $_rolling card',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one +0 card'),
          Perk('Replace two +0 cards with three +0 $_push 1 $_rolling cards'),
          Perk('Replace two +0 cards with three +0 $_muddle $_rolling cards'),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk(
            'Add one +2 ICE card',
            quantity: 2,
          ),
          Perk(
            'Add two +1 $_rolling cards',
            quantity: 2,
          ),
          Perk('Add one +0 $_stun $_rolling card'),
          Perk(
              'Add one +0 $_disarm $_rolling card and one +0 $_muddle $_rolling card'),
          Perk(_ignoreScenarioEffects),
          Perk(
              '[Lying Low:] You are considered to be last in initiative order when determining monster focus'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.sunkeeper: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove four +0 $_cards'),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
          Perk(
            '$_add $_two $_rolling +1 $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling $_heal 1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling $_stun $_card'),
          Perk(
            '$_add $_two $_rolling $_light $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling "$_shield 1, Self" $_cards'),
          Perk(
              'Ignore $_negative item $_effects and $_addLowercase $_two +1 $_cards'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove four +0 cards'),
          Perk(
            'Replace one -1 card with two +0 $_light $_rolling cards',
            quantity: 2,
          ),
          Perk(
            'Replace one -1 card with one +0 "$_shield 1" $_rolling card',
            quantity: 2,
          ),
          Perk('Replace one +0 card with one +2 card'),
          Perk(
            'Add two +1 $_rolling cards',
            quantity: 2,
          ),
          Perk('Add one +0 $_stun $_rolling card'),
          Perk(
            'Add two +0 "$_heal 1, self" $_rolling cards',
            quantity: 2,
          ),
          Perk('$_ignoreItemMinusOneEffects, and add two +1 cards'),
          Perk(_ignoreScenarioEffects),
          Perk(
            '[Shielding Light:] Whenever one of your heals would cause an ally\'s current hit point value to increase beyond their maximum hit point value, that ally gains $_ward',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.quartermaster: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling +1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_three $_rolling $_muddle $_cards'),
          Perk('$_add $_two $_rolling $_pierce 3 $_cards'),
          Perk('$_add $_one $_rolling $_stun $_card'),
          Perk('$_add $_one $_rolling ADD TARGET $_card'),
          Perk(
            '$_add $_one +0 "RECOVER an item" $_card',
            quantity: 3,
          ),
          Perk(
              'Ignore $_negative item $_effects and $_addLowercase $_two +1 $_cards'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            'Remove two -1 cards',
            quantity: 2,
          ),
          Perk('Replace two +0 cards with two +0 $_pierce 3 $_rolling cards'),
          Perk('Replace one +0 card with one +0 "plusone Target" card'),
          Perk(
            'Replace one +0 card with one +2 card',
            quantity: 2,
          ),
          Perk(
            'Add one +0 "RECOVER one item" card',
            quantity: 3,
          ),
          Perk(
            'Add two +1 $_rolling cards',
            quantity: 2,
          ),
          Perk('Add one +0 $_stun $_rolling card'),
          Perk('$_ignoreItemMinusOneEffects, and add two +1 cards'),
          Perk(
            '[Well Supplied:] Once each scenario, during your turn, if you have a persistent Quartermaster ability card in your active area, you may recover up to four cards from your discard pile',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.summoner: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 3,
          ),
          Perk(
            '$_add $_one +2 $_card',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_wound $_cards'),
          Perk('$_add $_two $_rolling POISON $_cards'),
          Perk(
            '$_add $_two $_rolling $_heal 1 $_cards',
            quantity: 3,
          ),
          Perk('$_add $_one $_rolling $_fire and $_one $_rolling AIR $_card'),
          Perk('$_add $_one $_rolling DARK and $_one $_rolling EARTH $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_two +1 $_cards'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 3,
          ),
          Perk('Replace one -2 card with one +0 card'),
          Perk(
              'Replace two +0 cards with one +0 $_fire $_rolling card and one +0 EARTH $_rolling card'),
          Perk(
              'Replace two +0 cards with one +0 AIR $_rolling card and one +0 DARK $_rolling card'),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk('Add two +0 $_wound $_rolling cards'),
          Perk('Add two +0 POISON $_rolling cards'),
          Perk(
            'Add three +0 "$_heal 1, self" $_rolling cards',
            quantity: 2,
          ),
          Perk('$_ignoreScenarioEffects and add two +1 cards'),
          Perk(
            '[Phase Out:] Once each scenario, during ordering of initiative, after all ability cards have been revealed, all your summons gain INVISIBLE',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.nightshroud: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_add $_one -1 DARK $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 DARK $_card with $_one +1 DARK $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 INVISIBLE $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_three $_rolling $_muddle $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_heal 1 $_cards'),
          Perk('$_add $_two $_rolling $_curse $_cards'),
          Perk('$_add $_one $_rolling ADD TARGET $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_two +1 $_cards'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            'Remove two -1 cards',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one -1 DARK card'),
          Perk(
              'Replace one +0 card with one +0 "plusone Target" $_rolling card'),
          Perk(
            'Replace two +0 cards with three +0 $_muddle $_rolling cards',
            quantity: 2,
          ),
          Perk(
            'Replace one +1 card with one +1 INVISIBLE card',
            quantity: 2,
          ),
          Perk(
            'Add one +1 DARK card',
            quantity: 2,
          ),
          Perk('Add two +0 $_curse $_rolling cards'),
          Perk('Add two +0 "$_heal 1, self" $_rolling cards'),
          Perk('$_ignoreScenarioEffects and add two +1 cards'),
          Perk(
            '[Empowering Night:] At the start of the scenario, you may discard two cards to add a card with an action containing a persistent symbol from your pool to your hand and immediately play it, performing that action',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.plagueherald: [
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk('$_add $_two +1 $_cards'),
          Perk(
            '$_add $_one +1 AIR $_card',
            quantity: 3,
          ),
          Perk('$_add $_three $_rolling POISON $_cards'),
          Perk('$_add $_two $_rolling $_curse $_cards'),
          Perk('$_add $_two $_rolling $_immobilize $_cards'),
          Perk(
            '$_add $_one $_rolling $_stun $_card',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_one +1 $_card'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove one -2 card'),
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 3,
          ),
          Perk(
            'Replace one +0 card with one +2 card',
            quantity: 2,
          ),
          Perk('Add three +1 AIR cards'),
          Perk('Add three +0 POISON $_rolling cards'),
          Perk('Add two +0 $_immobilize $_rolling cards'),
          Perk(
            'Add one +0 $_stun $_rolling card',
            quantity: 2,
          ),
          Perk('Add two +0 $_curse $_rolling cards'),
          Perk('$_ignoreScenarioEffects and add one +1 card'),
          Perk(
            '[Xorn\'s Boon:] Once each scenario, during your turn, cause each enemy that has POISON to suffer DAMAGE 1 and gain $_muddle and each ally who has POISON to suffer DAMAGE 1 and gain STRENGTHEN',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      )
    ],
    ClassCodes.berserker: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one $_rolling +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling $_wound $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_rolling $_stun $_card',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling +1 $_disarm $_card'),
          Perk('$_add $_two $_rolling $_heal 1 $_cards'),
          Perk(
            '$_add $_one +2 $_fire $_card',
            quantity: 2,
          ),
          Perk('Ignore $_negative item $_effects'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with two +0 $_wound $_rolling cards',
            quantity: 2,
          ),
          Perk(
            'Replace one +1 card with one +2 $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add one +2 $_fire card',
            quantity: 2,
          ),
          Perk(
            'Add one +0 $_stun $_rolling card',
            quantity: 2,
          ),
          Perk('Add one +1 $_disarm $_rolling card'),
          Perk('Add two +0 "$_heal 1, self" $_rolling cards'),
          Perk(_ignoreItemMinusOneEffects),
          Perk(
              '[Rapid Recovery:] Whenever you heal from a long rest, add plusone $_heal'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.soothsinger: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_two +1 $_cards with $_one +4 $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_disarm $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_wound $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
          Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 $_stun $_card'),
          Perk('$_add $_three $_rolling +1 $_cards'),
          Perk(
            '$_add $_two $_rolling $_curse $_cards',
            quantity: 2,
          ),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 $_stun $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_disarm $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_wound $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
          Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
          Perk(
            '$_replace $_two +1 $_cards with $_one +4 $_card',
            quantity: 2,
          ),
          Perk('$_add $_three +1 $_rolling $_cards'),
          Perk('$_add $_three +0 $_curse $_rolling $_cards'),
          Perk(
              '[Storyteller:] At the end of each scenario, each character in that scenario gains 8 experience if you successfully completed your battle goal'),
        ],
        variant: Variant.frosthavenCrossover,
      )
    ],
    ClassCodes.doomstalker: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_two +1 $_cards',
            quantity: 3,
          ),
          Perk(
            '$_add $_two $_rolling +1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one +2 $_muddle $_card'),
          Perk('$_add $_one +1 POISON $_card'),
          Perk('$_add $_one +1 $_wound $_card'),
          Perk('$_add $_one +1 $_immobilize $_card'),
          Perk('$_add $_one +0 $_stun $_card'),
          Perk(
            '$_add $_one $_rolling ADD TARGET $_card',
            quantity: 2,
          ),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 4,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +0 "plusone Target" $_rolling $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_muddle $_card'),
          Perk(
            '$_add $_two +1 $_rolling $_cards',
            quantity: 2,
          ),
          Perk('$_ignoreScenarioEffects and add one +1 $_immobilize card'),
          Perk(
              '[Marked for the Hunt:] At the beginning of each round in which you long rest, you may choose one ally to gain the benefits of any of your active Dooms as if the Dooms were in that ally\'s active area for the round'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.sawbones: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_rolling +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling $_wound $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling $_stun $_card'),
          Perk(
            '$_add $_one $_rolling $_heal 3 $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +0 "RECOVER an item" $_card'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_wound $_rolling $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +0 "RECOVER one item" $_card'),
          Perk(
            '$_add $_one +2 $_rolling $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +0 $_stun $_rolling $_card'),
          Perk(
            '$_add $_one +0 "$_heal 3, self" $_rolling $_card',
            quantity: 2,
          ),
          Perk(
              '[Revitalizing Medicine:] Whenever an ally performs the Heal ability of ~Medical ~Pack or ~Large ~Medical ~Pack, that character may first remove one negative condition'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],

    ClassCodes.elementalist: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_replace $_one -1 $_card with $_one +1 $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk('$_add $_three +0 $_fire $_cards'),
          Perk('$_add $_three +0 ICE $_cards'),
          Perk('$_add $_three +0 AIR $_cards'),
          Perk('$_add $_three +0 EARTH $_cards'),
          Perk(
              '$_replace $_two +0 $_cards with $_one +0 $_fire $_card and $_one +0 EARTH $_card'),
          Perk(
              '$_replace $_two +0 $_cards with $_one +0 ICE $_card and $_one +0 AIR $_card'),
          Perk('$_add $_two +1 $_push 1 $_cards'),
          Perk('$_add $_one +1 $_wound $_card'),
          Perk('$_add $_one +0 $_stun $_card'),
          Perk('$_add $_one +0 ADD TARGET $_card'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk('$_remove $_four +0 $_cards'),
          Perk(
              '$_replace $_one -1 $_card with $_one +0 "plusone Target" $_card'),
          Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
          Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
          Perk('$_add $_four +0 $_fire $_cards'),
          Perk('$_add $_four +0 ICE $_cards'),
          Perk('$_add $_four +0 AIR $_cards'),
          Perk('$_add $_four +0 EARTH $_cards'),
          Perk(_ignoreScenarioEffects),
          Perk(
            '[Elemental Proficiency:] $_atTheStartOfEachScenario and whenever you long rest, Any_Element',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],

    ClassCodes.beastTyrant: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_wound $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling $_heal 1 $_cards',
            quantity: 3,
          ),
          Perk('$_add $_two $_rolling EARTH $_cards'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_wound $_card',
            quantity: 2,
          ),
          Perk('$_add $_two +1 $_immobilize $_cards'),
          Perk(
            '$_add $_two +0 "$_heal 1, self" $_rolling $_cards',
            quantity: 3,
          ),
          Perk(
              '$_ignoreScenarioEffects and $_addLowercase $_two +0 EARTH $_rolling $_cards'),
          Perk(
            '[Bear Treat:] During each round in which you long rest, at initiative 99, you may skip the bear\'s normal turn to Command: "MOVE 3; LOOT 1; If the loot ability was performed: $_heal 3, self"',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.bladeswarm: [
      Perks(
        [
          Perk('$_remove $_one -2 $_card'),
          Perk('$_remove four +0 $_cards'),
          Perk('$_replace $_one -1 $_card with $_one +1 AIR $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 EARTH $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 $_light $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 DARK $_card'),
          Perk(
            '$_add $_two $_rolling $_heal 1 $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_wound $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 POISON $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +2 $_muddle $_card'),
          Perk(
              'Ignore $_negative item $_effects and $_addLowercase $_one +1 $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_one +1 $_card'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_wound $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 POISON $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 AIR $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 EARTH $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_light $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 DARK $_card'),
          Perk(
            '$_add $_one +2 $_muddle $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_heal 1 $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
              '$_ignoreNegativeItemEffects and $_addLowercase $_one +1 $_card'),
          Perk('$_ignoreScenarioEffects and $_addLowercase $_one +1 $_card'),
          Perk(
              '[Spinning Up:] At the start of your first turn each scenario, you may play one card from your hand to perform a persistent loss action of that card'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.diviner: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_two +1 $_cards with $_one +3 "$_shield 1, Self" $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Affect any Ally" $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 DARK $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_light $_card'),
          Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
          Perk(
              '$_replace $_one +0 $_card with $_one +2 "$_regenerate, Self" $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one +1 "$_heal 2, Affect any Ally" $_card'),
          Perk('$_add $_two $_rolling "$_heal 1, Self" $_cards'),
          Perk('$_add $_two $_rolling $_curse $_cards'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_two +1 $_cards'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_two +1 $_cards with $_one +3 "SHIELD 1" $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one +0 $_card with $_one +1 "Any ally gains SHIELD 1" $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 DARK $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_light $_card'),
          Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
          Perk(
              '$_replace $_one +0 $_card with $_one +2 "$_regenerate, self" $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one +1 "$_heal 2, Target 1 ally" $_card'),
          Perk('$_add $_two +0 $_curse $_rolling $_cards'),
          Perk('$_ignoreScenarioEffects and add $_two +1 $_cards'),
          Perk(
              '[Tip the Scales:] Whenever you rest, you may look at the top card of one attack modifier deck, then you may consume_$_light/DARK to place one card on the bottom of the deck'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.demolitionist: [
      Perks(
        [
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_muddle $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one -1 $_card with $_one +0 POISON $_card'),
          Perk(
            '$_add $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 EARTH $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 $_fire $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +0 "All adjacent enemies suffer 1 DAMAGE" $_card',
            quantity: 2,
          ),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_four +0 $_cards'),
          Perk('$_replace $_one -2 $_card with $_one +0 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_muddle $_card',
              quantity: 2),
          Perk('$_replace $_one +1 $_card with $_two +2 $_cards'),
          Perk('$_replace $_one +1 $_card with $_one +2 $_fire $_card',
              quantity: 2),
          Perk('$_replace $_one +1 $_card with $_one +2 EARTH $_card',
              quantity: 2),
          Perk('$_add $_two +0 "All adjacent enemies suffer DAMAGE 1" $_cards'),
          Perk('$_ignoreScenarioEffects and $_remove $_one -1 $_card'),
          Perk(
            '[Remodeling:] Whenever you rest while adjacent to a wall or obstacle, you may place an obstacle in an empty hex within RANGE 2 (of you)',
            quantity: 2,
            grouped: true,
          )
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.hatchet: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +2 $_muddle $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_push 2 $_card'),
          Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
          Perk('$_replace $_one +1 $_card with $_one +1 $_stun $_card'),
          Perk(
            '$_add $_one +2 AIR $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +3 $_card',
            quantity: 3,
          ),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
          Perk('$_replace $_one +1 $_card with $_one +1 $_stun $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_muddle $_card'),
          Perk(
            '$_replace $_one +1 $_card with $_one +3 $_card',
            quantity: 3,
          ),
          Perk(
            '$_add $_one +2 AIR $_card',
            quantity: 3,
          ),
          Perk(
              '[Hasty Pick-up:] Once each scenario, during your turn, if the Favourite is in a hex on the map, you may consume_AIR to return it to its ability card')
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.redGuard: [
      Perks(
        [
          Perk('$_remove four +0 $_cards'),
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 $_fire $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 $_light $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_fire&$_light $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_shield 1 $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk(
              '$_replace $_one +0 $_card and $_one +1 $_card with $_two +1 "$_shield 1" $_cards'),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 $_fire $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 $_light $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_fire/$_light $_card',
            quantity: 2,
          ),
          Perk(
              '$_ignoreItemMinusOneEffects and $_addLowercase $_two +1 $_cards'),
          Perk(
            '[Brilliant Aegis:] Whenever you are attacked, you may consume_$_light to gain $_shield 1 for the attack and have the attacker gain disadvantage for the attack',
            quantity: 2,
            grouped: true,
          )
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.vimthreader: [
      Perks(
        [
          Perk(
              '$_replace $_one -2 $_card with $_one -1 "If the target has an attribute, $_addLowercase $_wound, POISON, $_muddle" $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 ENFEEBLE $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "EMPOWER, RANGE 2" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "$_heal 1, TARGET 1 ally" $_card',
            quantity: 3,
          ),
          Perk('$_replace $_one +2 $_card with $_four +1 $_rolling $_cards'),
          Perk('$_add $_two $_pierce 2 POISON $_rolling $_cards'),
          Perk(
            '$_add $_three "$_heal 1, RANGE 1" $_rolling $_cards',
            quantity: 2,
          ),
          Perk('$_ignoreScenarioEffects and $_removeLowercase $_one +0 $_card'),
          // here
          Perk(
              '$_ignoreItemMinusOneEffects and $_removeLowercase $_one +0 $_card'),
          Perk(
              '$_wheneverYouShortRest, $_one adjacent enemy suffers DAMAGE 1, and you perform "$_heal 1, self"'),
          Perk(
            '$_atTheStartOfEachScenario, you may suffer DAMAGE 1 to grant all allies and self MOVE 3',
            quantity: 2,
            grouped: true,
          ),
          Perk(
              'Once each $_scenario, $_removeLowercase all $_negative conditions you have. One adjacent enemy suffers DAMAGE equal to the number of conditions removed'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.core: [
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_wound, "$_wound, self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 POISON, "POISON, self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +0 "Add plusone ATTACK for each condition you have" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two "$_heal 1, RANGE 1" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one "$_ward, $_regenerate, self" $_rolling $_card',
            quantity: 2,
          ),
          Perk('$_add $_one -2 BRITTLE and one +3 "BRITTLE, self" $_card'),
          Perk(
              '$_ignoreItemMinusOneEffects and $_removeLowercase $_one +0 $_card'),
          Perk(
              '$_atTheStartOfEachScenario, you may perform "STRENGTHEN, $_wound, self" or "$_ward, $_immobilize, self"'),
          Perk('Once each $_scenario, avoid an Overdrive exhaustion check'),
          Perk(
              'Once each $_scenario, during your turn, $_removeLowercase any number of $_negative conditions you have'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.voidwarden: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 DARK $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 ICE $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Ally" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 "$_heal 1, Ally" $_card',
            quantity: 3,
          ),
          Perk('$_add $_one +1 POISON $_card'),
          Perk('$_add $_one +3 $_card'),
          Perk(
            '$_add $_one +1 $_curse $_card',
            quantity: 2,
          ),
        ],
        variant: Variant.base,
      ),
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Target 1 ally" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "$_heal 1, Target 1 ally" $_card',
            quantity: 3,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_curse $_card',
            quantity: 2,
          ),
          Perk('$_add $_two +1 ICE $_cards'),
          Perk('$_add $_two +1 DARK $_cards'),
          Perk('$_add $_one +3 $_card'),
          Perk(_ignoreScenarioEffects),
          Perk(
              '[Grave Defense:] Whenever you rest, you may consume_ICE/DARK to give $_ward to one ally who has POISON')
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    ClassCodes.amberAegis: [
      Perks(
        [
          Perk(
              '$_replace $_one -2 $_card with $_one -1 "Place $_one Colony token of your choice on any empty hex within RANGE 2" $_card'),
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove four +0 $_cards'),
          Perk('$_replace $_one -1 $_card with $_one +2 $_muddle $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 POISON $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 $_wound $_card'),
          Perk(
            '$_add $_two $_rolling +1 $_immobilize $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_rolling "$_heal 1, Self" $_card and $_one $_rolling "$_shield 1, Self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_rolling "$_retaliate 1, RANGE 3" $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +2 $_fire/EARTH $_card'),
          Perk(
              'Ignore $_negative item $_effects and $_addLowercase $_one +1 $_card'),
          Perk(
              'Ignore $_scenario $_effects and $_addLowercase $_one "+X, where X is the number of active Cultivate actions" card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.artificer: [
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one -1 Any_Element $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 $_disarm $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_push 1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 PULL 1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +0 "RECOVER a spent item" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_pierce 2 $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one +2 $_card with $_one +3 "$_heal 2, Self" $_card'),
          Perk(
              '$_replace $_two +1 $_cards with $_two $_rolling +1 POISON $_cards'),
          Perk(
              '$_replace $_two +1 $_cards with $_two $_rolling +1 $_wound $_cards'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.bombard: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk(
              '$_replace $_two +0 $_cards with $_two $_rolling $_pierce 3 $_cards'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "+3 if Projectile" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one +1 $_card with $_two +1 "$_retaliate 1, RANGE 3" $_cards'),
          Perk('$_add $_two +1 "PULL 3, Self, toward the target" $_cards'),
          Perk('$_add $_one +0 "STRENGTHEN, Self" $_card'),
          Perk('$_add $_one +0 $_stun $_card'),
          Perk('$_add $_one +1 $_wound $_card'),
          Perk('$_add $_two $_rolling "$_shield 1, Self" $_cards'),
          Perk('$_add $_two $_rolling "$_heal 1, Self" $_cards'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeLowercase $_one +0 $_card'),
          Perk(
              'Ignore $_negative item $_effects and $_removeLowercase $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.brewmaster: [
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one -1 $_stun $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_two $_rolling $_muddle $_cards',
            quantity: 2,
          ),
          Perk(
              '$_replace $_two +0 $_cards with $_two +0 "$_heal 1, Self" $_cards'),
          Perk(
            '$_replace $_one +0 $_card with $_one +0 "Give yourself or an adjacent Ally a \'Liquid Rage\' item $_card" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 PROVOKE $_card',
            quantity: 2,
          ),
          Perk(
            '$_add four $_rolling Shrug_Off 1 $_cards',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_one +1 $_card'),
          Perk(
            'Each time you long rest, perform Shrug_Off 1',
            quantity: 2,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.brightspark: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element to $_addLowercase +2 ATTACK" $_card',
            quantity: 3,
          ),
          Perk(
              '$_replace $_one -2 $_card with $_one -2 "RECOVER $_one random $_card from your discard pile" $_card'),
          Perk(
            '$_replace $_two +0 $_cards with $_one +1 "$_heal 1, Affect $_one Ally within RANGE 2" $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_two +0 $_cards with $_one +1 "$_shield 1, Affect $_one Ally within RANGE 2" $_card'),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 Any_Element $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 "STRENGTHEN, Affect $_one Ally within RANGE 2" $_card',
            quantity: 2,
          ),
          Perk(
              '$_add $_one $_rolling "$_push 1 or PULL 1, AIR" $_card and $_one $_rolling "$_immobilize, ICE" $_card'),
          Perk(
              '$_add $_one $_rolling "$_heal 1, RANGE 3, $_light" $_card and $_one $_rolling "$_pierce 2, $_fire" $_card'),
          Perk(
              '$_add $_three $_rolling "Consume_Any_Element : Any_Element" $_cards'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeLowercase $_one -1 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.chieftain: [
      Perks(
        [
          Perk('$_replace $_one -1 $_card with $_one +0 POISON $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Chieftain" $_card',
              quantity: 2),
          Perk(
              '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Affect all summoned allies owned" $_card',
              quantity: 2),
          Perk('$_replace $_one -2 $_card with $_one -2 "BLESS, Self" $_card'),
          Perk(
              '$_replace $_two +0 $_cards with $_one +0 "$_immobilize and $_push 1" $_card'),
          Perk(
              '$_replace $_one +0 $_card with $_one "+X, where X is the number of summoned allies you own" $_card',
              quantity: 2),
          Perk(
              '$_replace $_one +1 $_card with $_two +1 "$_rolling +1, if summon is attacking" $_cards'),
          Perk('$_add $_one +0 $_wound, $_pierce 1 $_card'),
          Perk('$_add $_one +1 EARTH $_card', quantity: 2),
          Perk(
              '$_add $_two $_rolling "$_pierce 2, ignore $_retaliate on the target" $_cards'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_one +1 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.fireKnight: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "STRENGTHEN, Ally" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_two +0 "+2 if you are on Ladder" $_cards',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 $_fire $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
          Perk('$_replace $_two +1 $_cards with $_one +2 $_fire $_card'),
          Perk('$_replace $_two +1 $_cards with $_one +2 $_wound $_card'),
          Perk('$_add $_one +1 "STRENGTHEN, Ally" $_card'),
          Perk(
            '$_add $_two $_rolling "$_heal 1, RANGE 1" $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_wound $_cards'),
          Perk(
              'Ignore $_negative item $_effects and $_addLowercase $_one $_rolling $_fire $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_one $_rolling $_fire $_card'),
        ],
        variant: Variant.base,
      ),
    ],

    ClassCodes.frostborn: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_replace $_one -2 $_card with $_one +0 CHILL $_card'),
          Perk(
            '$_replace $_two +0 $_cards with $_two +1 $_push 1 $_cards',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 ICE CHILL $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +1 $_card with $_one +3 $_card'),
          Perk('$_add $_one +0 $_stun $_card'),
          Perk(
            '$_add $_one $_rolling ADD TARGET $_card',
            quantity: 2,
          ),
          Perk('$_add $_three $_rolling CHILL $_cards'),
          Perk('$_add $_three $_rolling $_push 1 $_cards'),
          Perk('Ignore difficult and hazardous terrain during move actions'),
          Perk('Ignore $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.hollowpact: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "$_heal 2, Self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_one +0 VOIDSIGHT $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one -2 EARTH $_card and $_two +2 DARK $_cards',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one -1 $_card with $_one -2 $_stun $_card and $_one +0 VOIDSIGHT $_card'),
          Perk(
              '$_replace $_one -2 $_card with $_one +0 $_disarm $_card and $_one -1 Any_Element $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one $_rolling +1 VOID $_card and $_one $_rolling -1 $_curse $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +1 $_cards with $_one +3 "$_regenerate, Self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "Create a Void pit in an empty hex within RANGE 2" $_card',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addLowercase $_one +0 "$_ward, Self" $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.mirefoot: [
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_two "+X, where X is the POISON value of the target" $_cards',
            quantity: 2,
          ),
          Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
          Perk(
            '$_replace $_one +0 $_card with $_two $_rolling "Create difficult terrain in the hex occupied by the target" $_cards',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +0 $_wound 2 $_card',
            quantity: 2,
          ),
          Perk(
              '$_add four $_rolling +0 "+1 if the target occupies difficult terrain" $_cards'),
          Perk(
              '$_add $_two $_rolling "INVISIBLE, Self, if you occupy difficult terrain" $_cards'),
          Perk(
              'Gain "Poison Dagger" (Item 011). You may carry $_one additional One_Hand item with "Dagger" in its name'),
          Perk(
              'Ignore damage, $_negative conditions, and modifiers from Events, and $_removeLowercase $_one -1 $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeLowercase $_one -1 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    // May be dead Perks if Rootwhisperer has a big overhaul - this is fine
    ClassCodes.rootwhisperer: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove four +0 $_cards'),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_rolling +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling POISON $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling $_disarm $_card'),
          Perk(
            '$_add $_one $_rolling $_heal 2 EARTH $_card',
            quantity: 2,
          ),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.chainguard: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +1 Shackle $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "+2 if the target is Shackled" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_one $_rolling "$_shield 1, Self" $_card',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling "$_retaliate 1, Self" $_cards'),
          Perk('$_add $_three $_rolling SWING 3 $_cards'),
          Perk('$_replace $_one +1 $_card with $_one +2 $_wound $_card'),
          Perk('$_add $_one +1 "$_disarm if the target is Shackled" $_card'),
          Perk(
              '$_add $_one +1 "Create a 2 DAMAGE trap in an empty hex within RANGE 2" $_card'),
          Perk('$_add $_two $_rolling "$_heal 1, Self" $_cards'),
          Perk(
            '$_add $_one +2 Shackle $_card',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative item $_effects and $_removeLowercase $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.hierophant: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk(
              '$_replace $_two +0 $_cards with $_one $_rolling $_light $_card'),
          Perk('$_replace $_two +0 $_cards with $_one $_rolling EARTH $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_curse $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Ally" $_card'),
          Perk(
              '$_replace $_one -2 $_card with $_one -1 "Give $_one Ally a \'Prayer\' ability $_card" and $_one +0 $_card'),
          Perk(
            '$_replace $_one +1 $_card with $_one +3 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling "$_heal 1, Self or Ally" $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_wound, $_muddle $_card',
            quantity: 2,
          ),
          Perk('At the start of your first turn each $_scenario, gain BLESS'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeLowercase $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.luminary: [
      Perks(
        [
          Perk('$_remove four +0 $_cards'),
          Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 ICE $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 $_fire $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 $_light $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 DARK $_card'),
          Perk(
              '$_replace $_one -2 $_card with $_one -2 "Perform $_one Glow ability" $_card'),
          Perk(
            '$_add $_one +0 Any_Element $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_rolling +1 "$_heal 1, Self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one "POISON, target all enemies in the depicted LUMINARY_HEXES area" $_card',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeLowercase $_one +0 $_card'),
          Perk(
              'Ignore $_negative item $_effects and $_addLowercase $_one $_rolling "Consume_Any_Element : Any_Element" $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.spiritCaller: [
      Perks(
        [
          Perk(
              '$_replace $_one -2 $_card with $_one -1 $_card and $_one +1 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "+2 if a Spirit performed the attack" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_card and $_one $_rolling POISON $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 AIR $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 DARK $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 $_pierce 2 $_card'),
          Perk('$_add $_three $_rolling $_pierce 3 $_cards'),
          Perk('$_add $_one +1 $_curse $_card'),
          Perk('$_add $_one $_rolling ADD TARGET $_card'),
          Perk('$_replace $_one +1 $_card with $_one +2 $_push 2 $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeLowercase $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.starslinger: [
      Perks(
        [
          Perk(
            '$_replace $_two +0 $_cards with $_one $_rolling "$_heal 1, Self" $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one -2 $_card with $_one -1 "INVISIBLE, Self" $_card'),
          Perk('$_replace $_two -1 $_cards with $_one +0 DARK $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_light $_card',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling LOOT 1 $_card'),
          Perk(
            '$_add $_one +1 "+3 if you are at full health" $_card',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_immobilize $_cards'),
          Perk(
            '$_add $_one +1 "$_heal 1, RANGE 3" $_card',
            quantity: 2,
          ),
          Perk(
              '$_add $_two $_rolling "Force the target to perform a \'MOVE 1\' ability" $_cards'),
          Perk('$_add $_two $_rolling "$_heal 1, RANGE 1" $_cards'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeLowercase $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.ruinmaw: [
      Perks(
        [
          Perk(
              '$_replace $_one -2 $_card with $_one -1 RUPTURE and $_wound $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_wound $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 RUPTURE $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "$_add +3 instead if the target has RUPTURE or $_wound" $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one $_rolling "$_heal 1, Self, EMPOWER" $_card',
            quantity: 3,
          ),
          Perk(
              'Once each $_scenario, become SATED after collecting your 5th loot token'),
          Perk(
              'Become SATED each time you lose a $_card to negate suffering damage'),
          Perk(
              'Whenever $_one of your abilities causes at least $_one enemy to gain RUPTURE, immediately after that ability perform "MOVE 1"'),
          Perk(
              'Ignore $_negative $_scenario $_effects, and $_removeLowercase $_one -1 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.drifter: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 3,
          ),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one +1 $_card with $_two +0 "Move $_one of your character tokens backward $_one slot" $_cards',
            quantity: 2,
          ),
          Perk(
              '$_replace $_two +0 $_cards with $_two $_pierce 3 $_rolling $_cards'),
          Perk(
              '$_replace $_two +0 $_cards with $_two $_push 2 $_rolling $_cards'),
          Perk('$_add $_one +3 $_card'),
          Perk(
            '$_add $_one +2 $_immobilize $_card',
            quantity: 2,
          ),
          Perk('$_add $_two "$_heal 1, self" $_rolling $_cards'),
          Perk('$_ignoreScenarioEffects and $_addLowercase $_one +1 $_card'),
          Perk(
              '$_ignoreItemMinusOneEffects and $_addLowercase $_one +1 $_card'),
          Perk(
            '$_wheneverYouLongRest, you may move $_one of your character tokens backward $_one slot',
            quantity: 2,
            grouped: true,
          ),
          Perk(
              'You may bring $_one additional One_Hand item into each $_scenario'),
          Perk(
              'At the end of each $_scenario, you may discard up to $_two loot $_cards, except ~Random ~Item, to draw that many new loot $_cards'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.blinkBlade: [
      Perks(
        [
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_wound $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one "Place this $_card in your active area. On your next attack, discard this $_card to $_addLowercase plustwo ATTACK" $_rolling $_card',
            quantity: 3,
          ),
          Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
          Perk(
            '$_add $_one -1 "Gain $_one TIME_TOKEN" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 "$_regenerate, self" $_rolling $_card',
            quantity: 2,
          ),
          Perk(
              '$_wheneverYouShortRest, you may spend $_one unspent SPENT item for no effect to RECOVER a different spent item'),
          Perk(
              'At the start of your first turn each $_scenario, you may perform MOVE 3'),
          Perk('Whenever you would gain $_immobilize, prevent the condition'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.bannerSpear: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "$_add plusone ATTACK for each ally adjacent to the target" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_disarm $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 $_push 1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two +1 $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_two "$_heal 1, self" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
              '$_ignoreItemMinusOneEffects and $_removeLowercase $_one -1 $_card'),
          Perk(
              'At the end of each of your long rests, grant $_one ally within RANGE 3: MOVE 2'),
          Perk(
              'Whenever you open a door with a move ability, $_addLowercase +3 MOVE'),
          Perk(
            'Once each $_scenario, during your turn, gain $_shield 2 for the round',
            grouped: true,
            quantity: 2,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.deathwalker: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_curse $_card',
            quantity: 3,
          ),
          Perk(
            '$_add $_one +2 DARK $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_disarm $_rolling and $_one $_muddle $_rolling $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two "$_heal 1, Target 1 ally" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
              '$_wheneverYouLongRest, you may move $_one SHADOW up to 3 hexes'),
          Perk(
              '$_wheneverYouShortRest, you may consume_DARK to perform $_muddle, $_curse, RANGE 2 as if you were occupying a hex with a SHADOW'),
          Perk(
              'While you are occupying a hex with a SHADOW, all attacks targeting you gain disadvantage'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.boneshaper: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_curse $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 POISON $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "Kill the attacking summon to instead $_addLowercase +4" $_card',
            quantity: 3,
          ),
          Perk(
            '$_add $_three "$_heal 1, Target Boneshaper" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 EARTH/DARK $_card',
            quantity: 3,
          ),
          Perk('$_ignoreScenarioEffects and $_addLowercase $_two +1 $_cards'),
          Perk(
              'Immediately before each of your rests, you may kill $_one of your summons to perform BLESS, self'),
          Perk(
              'Once each $_scenario, when any character ally would become exhausted by suffering DAMAGE, you may suffer DAMAGE 2 to reduce their hit point value to 1 instead'),
          Perk(
            'At the start of each $_scenario, you may play a level 1 $_card from your hand to perform a summon action of the $_card',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.geminate: [
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element : Any_Element" $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 POISON $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_wound $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_two +0 $_cards with $_two $_pierce 3 $_rolling $_cards'),
          Perk('$_add $_two +1 $_push 3 $_cards'),
          Perk('$_add $_one 2x "BRITTLE, self" $_card'),
          Perk(
            '$_add $_one +1 "$_regenerate, self" $_rolling card',
            quantity: 2,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
              '$_wheneverYouShortRest, you may $_removeLowercase $_one $_negative condition from $_one ally within RANGE 3'),
          Perk(
              'Once each $_scenario, when you would give yourself a $_negative condition, prevent the condition'),
          Perk(
            'Whenever you perform an action with a lost icon, you may discard $_one $_card to RECOVER $_one card from your discard pile of equal or lower level',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.infuser: [
      Perks(
        [
          Perk(
              '$_replace $_one -2 $_card with $_one -1 $_card and $_one -1 AIR EARTH DARK $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 AIR/EARTH $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 AIR/DARK $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 EARTH/DARK $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_three "Move one waning element to strong" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_two "plusone ATTACK for each pair of active INFUSION" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
            '$_ignoreItemMinusOneEffects. Whenever you become exhausted, keep all your active bonuses in play, with your summons acting on initiative 99 each round',
            quantity: 2,
            grouped: true,
          ),
          Perk(
              '$_wheneverYouShortRest, you may Consume_Any_Element to RECOVER $_one spent One_Hand or Two_Hand item'),
          Perk(
              'Once each $_scenario, during ordering of initiative, after all ability cards have been revealed, Any_Element'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.pyroclast: [
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk('Remove one -2 card'),
          Perk(
            'Replace one +0 card with one +1 $_wound card',
            quantity: 2,
          ),
          Perk(
            'Replace one -1 card with one +0 "Create one 1-hex hazardous terrain tile in a featureless hex adjacent to the target" card',
            quantity: 2,
          ),
          Perk(
            'Replace two +0 cards with two $_push 2 $_rolling cards',
            quantity: 2,
          ),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk(
            'Add two +1 $_fire/EARTH cards',
            quantity: 2,
          ),
          Perk('Add two +1 $_muddle $_rolling cards'),
          Perk(_ignoreScenarioEffects),
          Perk(
              '$_wheneverYouLongRest, you may destroy one adjacent obstacle to gain $_ward'),
          Perk(
              '$_wheneverYouShortRest, you may consume_$_fire to perform $_wound, Target 1 enemy occupying or adjacent to hazardous terrain'),
          Perk(
            'You and all allies are unaffected by hazardous terrain you create',
            quantity: 3,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.shattersong: [
      Perks(
        [
          Perk('Remove four +0 cards'),
          Perk(
            'Replace two -1 cards with two +0 "Reveal the top card of the target\'s monster ability deck" cards',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one -1 $_stun card'),
          Perk(
            'Replace one +0 card with one +0 BRITTLE card',
            quantity: 2,
          ),
          Perk(
            'Replace two +1 cards with two +2 AIR/$_light cards',
            quantity: 2,
          ),
          Perk(
            'Add one "$_heal 2, BLESS, Target 1 ally" $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add one +1 "Gain 1 RESONANCE" card',
            quantity: 3,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
            '$_wheneverYouShortRest, you may consume_AIR to perform STRENGTHEN, RANGE 3 and consume_$_light to perform BLESS, RANGE 3',
            quantity: 2,
            grouped: true,
          ),
          Perk(
              '$_atTheStartOfEachScenario, you may gain BRITTLE to gain 2 RESONANCE'),
          Perk(
              'Whenever a new room is revealed, you may reveal the top card of both the monster attack modifier deck and all allies\' attack modifier decks'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.trapper: [
      Perks(
        [
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "Create $_one $_heal 2 trap in an empty hex adjacent to the target" card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "Create $_one DAMAGE 1 trap in an empty hex adjacent to the target" card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_two +0 "Add DAMAGE 2 or $_heal 2 to a trap within RANGE 2 of you" $_cards',
            quantity: 3,
          ),
          Perk(
            '$_replace $_two +1 $_cards with $_two +2 $_immobilize $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_two "Add $_push 2 or PULL 2" $_rolling $_cards',
            quantity: 3,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
              '$_wheneverYouLongRest, you may create $_one DAMAGE 1 trap in an adjacent empty hex'),
          Perk(
              'Whenever you enter a hex with a trap, you may choose to not spring the trap'),
          Perk(
              '$_atTheStartOfEachScenario, you may create $_one DAMAGE 2 trap in an adjacent empty hex'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.painConduit: [
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one -2 $_card with $_one -2 $_curse $_curse $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 $_disarm $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 $_fire/AIR $_card',
            quantity: 3,
          ),
          Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
          Perk('$_replace $_three +1 $_cards with $_three +1 $_curse $_cards'),
          Perk(
            '$_add $_three "$_heal 1, self" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +0 "Add plusone ATTACK for each negative condition you have" $_card',
            quantity: 2,
          ),
          Perk('$_ignoreScenarioEffects and $_add $_two +1 $_cards'),
          Perk(
              'Each round in which you long rest, you may ignore all negative conditions you have. If you do, they cannot be removed that round'),
          Perk(
              'Whenever you become exhausted, first perform $_curse, Target all, RANGE 3'),
          Perk(
            'Increase your maximum hit point value by 5',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.snowdancer: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Target 1 ally" $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two +1 ICE/AIR $_cards',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_two "If this action forces the target to move, it suffers DAMAGE 1" $_rolling $_cards',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "STRENGTHEN, Target 1 ally" $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one "$_heal 1, $_ward, Target 1 ally" $_rolling $_card',
            quantity: 2,
          ),
          Perk('$_wheneverYouLongRest, you may ICE/AIR'),
          Perk(
            '$_wheneverYouShortRest, you may consume_ICE to perform $_regenerate, RANGE 3 and consume_AIR to perform $_ward, RANGE 3',
            quantity: 2,
            grouped: true,
          ),
          Perk(
            '$_atTheStartOfEachScenario, all enemies gain $_muddle. Whenever a new room is revealed, all enemies in the newly revealed room gain $_muddle',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.frozenFist: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +0 $_disarm $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one -1 $_card with $_one +1 $_card'),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "$_shield 1" $_rolling $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 ICE/EARTH $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +2 "Create $_one 1-hex icy terrain tile in a featureless hex adjacent to the target" $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +3 $_card'),
          Perk(
            '$_add $_two "$_heal 1, self" $_rolling $_cards',
            quantity: 3,
          ),
          Perk(
              '$_ignoreItemMinusOneEffects, and, whenever you enter icy terrain with a move ability, you may ignore the effect to add plusone MOVE'),
          Perk(
              'Whenever you heal from a long rest, you may consume_ICE/EARTH to add plustwo $_heal'),
          Perk(
            'Once each scenario, when you would suffer DAMAGE, you may negate the DAMAGE',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.hive: [
      Perks(
        [
          Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "After this attack ability, grant one of your summons: MOVE 2" $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "After this attack ability, TRANSFER" $_card',
            quantity: 3,
          ),
          Perk(
            '$_add $_one +1 "$_heal 1, self" $_card',
            quantity: 3,
          ),
          Perk(
            '$_add $_one +2 $_muddle $_card',
            quantity: 2,
          ),
          Perk('$_add $_two POISON $_rolling $_cards'),
          Perk('$_add $_two $_wound $_rolling $_cards'),
          Perk(
            '$_wheneverYouLongRest, you may do so on any initiative value, choosing your initiative after all ability cards have been revealed, and you decide how your summons perform their abilities for the round',
            quantity: 2,
            grouped: true,
          ),
          Perk('At the end of each of your short rests, you may TRANSFER'),
          Perk('Whenever you would gain $_wound, prevent the condition'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.metalMosaic: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "PRESSURE_GAIN or PRESSURE_LOSE" $_card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +0 "The target and all enemies adjacent to it suffer DAMAGE 1" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_one $_pierce 3 $_rolling and $_one "$_retaliate 2" $_rolling $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 "$_heal 2, self" $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +3 $_card'),
          Perk('$_ignoreItemMinusOneEffects and add two +1 $_cards'),
          Perk('$_wheneverYouLongRest, you may PRESSURE_GAIN or PRESSURE_LOSE'),
          Perk(
              'Whenever you would gain POISON, you may suffer DAMAGE 1 to prevent the condition'),
          Perk(
            'Once each scenario, when you would become exhausted, instead gain $_stun and INVISIBLE, lose all your cards, RECOVER four lost cards, and then discard the recovered cards',
            quantity: 3,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.deepwraith: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk(
            '$_replace $_one -1 card with one +0 $_disarm card',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one -1 $_stun card'),
          Perk(
            'Replace one +0 card with one +0 "INVISIBLE, self" card',
            quantity: 2,
          ),
          Perk('Replace two +0 cards with two $_pierce 3 $_rolling cards'),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk('Replace three +1 cards with three +1 $_curse cards'),
          Perk(
            'Add two +1 "Gain 1 TROPHY" cards',
            quantity: 3,
          ),
          Perk('$_ignoreScenarioEffects and remove two +0 cards'),
          Perk(
              '$_wheneverYouLongRest, you may LOOT one adjacent hex. If you gain any loot tokens, gain 1 TROPHY'),
          Perk('$_atTheStartOfEachScenario, gain 2 TROPHY'),
          Perk(
            'While you have INVISIBLE, gain advantage on all your attacks',
            quantity: 3,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.crashingTide: [
      Perks(
        [
          Perk(
            'Replace one -1 card with two $_pierce 3 $_rolling cards',
            quantity: 2,
          ),
          Perk(
            'Replace one -1 card with one +0 "plusone Target" card',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with one +1 "$_shield 1" $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add two +1 "If you performed a TIDE action this round, +2 instead" cards',
            quantity: 2,
          ),
          Perk(
            'Add one +2 $_muddle card',
            quantity: 2,
          ),
          Perk('Add one +1 $_disarm card'),
          Perk(
            'Add two "$_heal 1, self" $_rolling cards',
            quantity: 2,
          ),
          Perk(
              '$_ignoreItemMinusOneEffects, and, whenever you would gain IMPAIR, prevent the condition'),
          Perk(
              'Whenever you declare a long rest during card selection, gain $_shield 1 for the round'),
          Perk(
            'Gain advantage on all your attacks performed while occupying or targeting enemies occupying water hexes',
            quantity: 3,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.thornreaper: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one $_rolling "+1 if $_light is Strong or Waning" $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            'Add three $_rolling "+1 if $_light is Strong or Waning" cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling $_light $_cards'),
          Perk(
            '$_add $_three $_rolling "EARTH if $_light is Strong or Waning" $_cards',
          ),
          Perk(
            '$_add $_one "Create hazardous terrain in $_one hex within RANGE 1" $_card',
          ),
          Perk(
            'Add one $_rolling "On the next attack targeting you while occupying hazardous terrain, discard this card to gain $_retaliate 3" card',
            quantity: 2,
          ),
          Perk(
            'Add one $_rolling "On the next attack targeting you while occupying hazardous terrain, discard this card to gain $_shield 3" card',
            quantity: 2,
          ),
          Perk(
            'Ignore $_negative item $_effects and $_addLowercase $_one $_rolling "+1 if $_light is Strong or Waning" $_card',
          ),
          Perk(
            'Gain $_shield 1 while you occupy hazardous terrain',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.incarnate: [
      Perks(
        [
          Perk(
              '$_replace $_one -2 $_card with $_one $_rolling ALL_STANCES $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one $_rolling $_pierce 2, $_fire $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one $_rolling "$_shield 1, Self, EARTH" $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one $_rolling $_push 1, AIR $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "RITUALIST : ENFEEBLE / CONQUEROR : EMPOWER, Self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE / CONQUEROR : EMPOWER, Self" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE / RITUALIST : ENFEEBLE" $_card',
            quantity: 2,
          ),
          Perk(
              '$_add $_one $_rolling "RECOVER $_one One_Hand or Two_Hand item" $_card'),
          Perk('Each time you long rest, perform: ALL_STANCES'),
          Perk('You may bring one additional One_Hand item into each scenario'),
          Perk('Each time you short rest, RECOVER one spent One_Hand item'),
          Perk(
              '$_ignoreNegativeItemEffects and $_removeLowercase one -1 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.rimehearth: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one $_rolling $_wound $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one +0 $_card with $_one $_rolling "$_heal 3, $_wound, Self" $_card'),
          Perk(
              '$_replace $_two +0 $_cards with $_two $_rolling $_fire $_cards'),
          Perk(
              '$_replace $_three +1 $_cards with $_one $_rolling +1 card, $_one +1 $_wound $_card, and $_one +1 "$_heal 1, Self" $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 ICE $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 CHILL $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +2 $_card with $_one +3 CHILL $_card'),
          Perk(
            '$_add $_one +2 $_fire/ICE $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +0 BRITTLE $_card'),
          Perk(
              'At the start of each $_scenario, you may either gain $_wound to generate $_fire or gain CHILL to generate ICE'),
          Perk(
              '$_ignoreNegativeItemEffects and $_add $_one $_rolling $_fire/ICE $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.shardrender: [
      Perks(
        [
          Perk('Remove one -2 card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one $_rolling "$_shield 1, Self" card',
            quantity: 2,
          ),
          Perk(
            '$_replace two +0 cards with two +0 "Move one character token on a CRYSTALLIZE back one space" cards',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with one $_rolling +1 "+2 instead if the attack has $_pierce" card',
            quantity: 2,
          ),
          Perk(
              'Add two +1 "+2 instead if you CRYSTALLIZE PERSIST one space" cards'),
          Perk('Add one +0 BRITTLE card'),
          Perk(
            '$_ignoreNegativeItemEffects and at the start of each scenario, you may play a level 1 card from your hand to perform a CRYSTALLIZE action of the card',
            quantity: 2,
            grouped: true,
          ),
          Perk(
              'Once each scenario, when you would suffer damage from an attack, gain "$_shield 3" for that attack'),
          Perk('Each time you long rest, perform "$_regenerate, Self"'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.tempest: [
      Perks(
        [
          Perk('Replace one -2 card with one -1 AIR/$_light card'),
          Perk('Replace one -1 AIR/$_light card with one +1 AIR/$_light card'),
          Perk(
            'Replace one -1 card with one +0 $_wound card',
            quantity: 2,
          ),
          Perk(
            '$_replace one -1 card with one $_rolling "$_regenerate, RANGE 1" card',
            quantity: 2,
          ),
          Perk('Replace one +0 card with one +2 $_muddle card'),
          Perk('Replace two +0 cards with one +1 $_immobilize card'),
          Perk(
            'Add one +1 "DODGE, Self" card',
            quantity: 2,
          ),
          Perk('Add one +2 AIR/$_light card'),
          Perk('Whenever you dodge an attack, gain one SPARK'),
          Perk(
            '$_wheneverYouLongRest, you may gain DODGE',
            quantity: 2,
            grouped: true,
          ),
          Perk(
              '$_wheneverYouShortRest, you may consume_SPARK one Spark. If you do, one enemy within RANGE 2 suffers one damage'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.vanquisher: [
      Perks(
        [
          Perk('Replace two -1 cards with one +0 $_muddle card'),
          Perk('Replace two -1 cards with one -1 "$_heal 2, Self" card'),
          Perk('Replace one -2 card with one -1 POISON $_wound card'),
          Perk(
            '$_replace one +0 card with one +1 "$_heal 1, Self" card',
            quantity: 2,
          ),
          Perk(
              'Replace two +0 cards with one +0 $_curse card and one +0 $_immobilize card'),
          Perk(
            'Replace one +1 card with one +2 $_fire/AIR card',
            quantity: 2,
          ),
          Perk('Replace one +2 card with one $_rolling "Gain one RAGE" card'),
          Perk(
            'Add one +1 "$_retaliate 1, Self" card and one $_rolling $_pierce 3 card',
            quantity: 2,
          ),
          Perk('Add one +0 "BLESS, Self" card'),
          Perk('Add two +1 "+2 instead if you suffer 1 damage" cards'),
          Perk('Add one +2 "+3 instead if you suffer 1 damage" card'),
          Perk('$_ignoreNegativeItemEffects and remove one -1 card'),
        ],
        variant: Variant.base,
      ),
    ],
  };
}
