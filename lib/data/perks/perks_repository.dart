import 'package:gloomhaven_enhancement_calc/data/player_classes/character_constants.dart';
import 'package:gloomhaven_enhancement_calc/models/perk/perk.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class PerksRepository {
  // // Action verbs
  static const _add = 'Add';
  static const _addLowercase = 'add';
  static const _remove = 'Remove';
  static const _removeLowercase = 'remove';
  static const _replace = 'Replace';

  // Numbers
  static const _one = 'one';
  static const _two = 'two';
  static const _three = 'three';
  static const _four = 'four';
  static String xp(int num) => 'xp$num';

  // Words as numbers
  static const _plusZero = 'pluszero';
  static const _plusOne = 'plusone';
  static const _plusTwo = 'plustwo';

  // Card-related terms
  static const _card = 'card';
  static const _cards = 'cards';
  static const _rolling = 'Rolling';
  static const _loss = 'LOSS';
  static const _shuffle = 'SHUFFLE';
  static const _null = 'NULL';

  // Effects and conditions
  static const _damage = 'DAMAGE';
  static const _immobilize = 'IMMOBILIZE';
  static const _regenerate = 'REGENERATE';
  static const _retaliate = 'RETALIATE';
  static const _shield = 'SHIELD';
  static const _ward = 'WARD';
  static const _push = 'PUSH';
  static const _pull = 'PULL';
  static const _targetCircle = 'TARGET_CIRCLE';
  static const _targetDiamond = 'TARGET_DIAMOND';
  static const _pierce = 'PIERCE';
  static const _stun = 'STUN';
  static const _disarm = 'DISARM';
  static const _muddle = 'MUDDLE';
  static const _wound = 'WOUND';
  static const _heal = 'HEAL';
  static const _curse = 'CURSE';
  static const _bless = 'BLESS';
  static const _strengthen = 'STRENGTHEN';
  static const _project = 'PROJECT';
  static const _barrierPlus = 'BARRIER_PLUS';
  static const _poison = 'POISON';
  static const _critters = 'CRITTERS';
  static const _invisible = 'INVISIBLE';
  static const _impair = 'IMPAIR';
  static const _brittle = 'BRITTLE';
  static const _rupture = 'RUPTURE';
  static const _enfeeble = 'ENFEEBLE';
  static const _empower = 'EMPOWER';
  static const _safeguard = 'SAFEGUARD';

  static const _attack = 'ATTACK';
  static const _range = 'RANGE';
  static const _move = 'MOVE';
  static const _teleport = 'TELEPORT';
  static const _flying = 'FLYING'; // TODO: add this asset
  static const _loot = 'LOOT';
  static const _recover = 'RECOVER';
  static const _refresh = 'REFRESH';
  static const _scenarioIcon = 'SCENARIO'; // TODO: add this asset

  // Class specific
  static const _tear = 'TEAR'; // TODO: add this asset
  static const _supplies = 'SUPPLIES'; // TODO: add this asset
  static const _song = 'SONG'; // TODO: add this asset
  static const _prescription = 'PRESCRIPTION'; // TODO: add this asset
  static const _doom = 'DOOM'; // TODO: add this asset
  static const _bear = 'BEAR'; // TODO: add this asset
  static const _command = 'COMMAND'; // TODO: add this asset
  static const _rift = 'RIFT'; // TODO: add this asset
  static const _resolve = 'RESOLVE'; // TODO: add this asset
  static const _berserker = 'Berserker';
  static const _doomstalker = 'Doomstalker';
  static const _bladeswarm = 'Bladeswarm';
  static const _hail = 'Hail';
  static const _reaver = 'REAVER';
  static const _ritualist = 'RITUALIST';
  static const _conqueror = 'CONQUEROR';

  // Elements
  static const _fire = 'FIRE';
  static const _light = 'LIGHT';
  static const _dark = 'DARK';
  static const _earth = 'EARTH';
  static const _air = 'AIR';
  static const _ice = 'ICE';
  static const _anyElement = 'Any_Element';

  // Equipment slots
  static const _body = 'Body';
  static const _pocket = 'Pocket';
  // static const _head = 'Head';
  static const _oneHand = 'One_Hand';
  static const _twoHand = 'Two_Hand';

  // Scenario and Item related
  static const _negative = 'negative';
  static const _scenario = 'scenario';
  static const _atTheStartOfEachScenario = 'At the start of each $_scenario';
  static const _atTheEndOfEachScenario = 'At the end of each $_scenario';
  static const _ignoreItemMinusOneEffects =
      'Ignore item item_minus_one effects';
  static const _ignoreItemMinusOneEffectsAndAdd =
      'Ignore item item_minus_one effects and $_addLowercase';
  static const _ignoreItemMinusOneEffectsAndRemove =
      'Ignore item item_minus_one effects and $_removeLowercase';
  static const _ignoreNegativeItemEffects = 'Ignore $_negative item effects';
  static const _ignoreNegativeItemEffectsAndAdd =
      'Ignore $_negative item effects and add';
  static const _ignoreNegativeItemEffectsAndRemove =
      'Ignore $_negative item effects and remove';
  static const _ignoreNegativeScenarioEffects =
      'Ignore $_negative $_scenario effects';
  static const _ignoreNegativeScenarioEffectsAndAdd =
      'Ignore $_negative $_scenario effects and add';
  static const _ignoreNegativeScenarioEffectsAndRemove =
      'Ignore $_negative $_scenario effects and $_removeLowercase';
  static const _ignoreScenarioEffects = 'Ignore $_scenario effects';
  static const _ignoreScenarioEffectsAndAdd =
      'Ignore $_scenario effects and $_addLowercase';
  static const _ignoreScenarioEffectsAndRemove =
      'Ignore $_scenario effects and remove';
  static const _onceEachScenario = 'Once each $_scenario';
  static const _oncePerScenario = 'Once per $_scenario';

  // Rest-related
  static const _wheneverYouLongRest = 'Whenever you long rest';
  static const _wheneverYouShortRest = 'Whenever you short rest';

  static final Map<String, List<Perks>> perksMap = {
    // BRUTE/BRUISER
    ClassCodes.brute: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove $_one -1 $_card and $_addLowercase $_one +1 $_card'),
        Perk('$_add $_two +1 $_cards', quantity: 2),
        Perk('$_add $_one +3 $_card'),
        Perk('$_add $_three $_rolling $_push 1 $_cards', quantity: 2),
        Perk('$_add $_two $_rolling $_pierce 3 $_cards'),
        Perk('$_add $_one $_rolling $_stun $_card', quantity: 2),
        Perk(
          '$_add $_one $_rolling $_disarm $_card and $_one $_rolling $_muddle $_card',
        ),
        Perk('$_add $_one $_rolling ADD $_targetDiamond $_card', quantity: 2),
        Perk('$_add $_one +1 "$_shield  Self" $_card'),
        Perk('$_ignoreNegativeItemEffectsAndAdd $_one +1 $_card'),
      ], variant: Variant.base),
      Perks([
        Perk('Replace one -1 card with one +1 card', quantity: 2),
        Perk(
          'Replace one -1 card with three +0 $_push 1 $_rolling cards',
          quantity: 2,
        ),
        Perk('$_replace two +0 cards with two +0 $_pierce 3 $_rolling cards'),
        Perk('$_replace one +0 card with two +1 cards', quantity: 2),
        Perk(
          '$_replace one +0 card with one +0 "$_plusOne $_targetCircle" $_rolling card',
          quantity: 2,
        ),
        Perk('Add one +0 $_stun $_rolling card', quantity: 2),
        Perk(
          'Add one +0 $_disarm $_rolling card and one +0 $_muddle $_rolling card',
        ),
        Perk('$_add $_one +3 card'),
        Perk('$_ignoreItemMinusOneEffectsAndAdd $_one +1 "$_shield 1" card'),
        Perk(
          '**Rested and Ready:** $_wheneverYouLongRest, add +1 $_move to your first move ability the following round',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk(
          '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one "Add this card to your '
          'active area. On the next attack targeting you performed by an '
          'adjacent enemy, discard this card to gain $_retaliate 2 for the '
          'attack" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
        Perk('$_add $_one +1 "$_heal 2, self" $_card', quantity: 2),
        Perk('$_add $_one +2 $_push 2 $_card', quantity: 2),
        Perk('$_add $_one +3 $_card'),
        Perk(
          '$_add $_one $_disarm $_rolling and $_one $_muddle $_rolling $_card',
        ),
        Perk('$_ignoreItemMinusOneEffectsAndAdd $_two +1 $_cards'),
        Perk(
          '$_onceEachScenario, during your turn, you may perform: $_loot 1, if this ability loots at least one money token, you may $_refresh one $_body item',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          '$_wheneverYouLongRest, $_addLowercase $_plusOne $_move to your first move ability the following round',
        ),
        Perk(
          'Each character gains advantage on their first attack during the first round of each scenario',
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // TINKERER
    ClassCodes.tinkerer: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_add $_two +1 $_cards'),
        Perk('$_add $_one +3 $_card'),
        Perk('$_add $_two $_rolling $_fire $_cards'),
        Perk('$_add $_three $_rolling $_muddle $_cards'),
        Perk('$_add $_one +1 $_wound $_card', quantity: 2),
        Perk('$_add $_one +1 $_immobilize $_card', quantity: 2),
        Perk('$_add $_one +1 $_heal 2 $_card', quantity: 2),
        Perk('$_add $_one +0 ADD $_targetDiamond $_card'),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
      Perks([
        Perk('Remove two -1 cards'),
        Perk('Replace one -1 card with one +1 card', quantity: 2),
        Perk('Replace one -2 card with one +0 card'),
        Perk('Replace one +0 card with one +0 "$_plusOne $_targetCircle" card'),
        Perk('Replace one +0 card with one +1 $_wound card', quantity: 2),
        Perk('Replace one +0 card with one +1 $_immobilize card', quantity: 2),
        Perk('Replace two +0 cards with three +0 $_muddle $_rolling cards'),
        Perk('Add one +3 card'),
        Perk('Add two +1 "$_heal 2, self" cards'),
        Perk('$_ignoreScenarioEffectsAndAdd two +0 $_fire $_rolling cards'),
        Perk(
          '**Rejuvenating Vapor:** $_wheneverYouLongRest, you may perform "$_heal 2, $_range 3"',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 1, $_targetCircle 1 ally" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_wound $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_poison $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +2 "$_strengthen, $_targetCircle 1 ally" $_card',
          quantity: 3,
        ),
        Perk(
          '$_ignoreScenarioEffectsAndAdd $_one +0 "$_heal 1, $_targetCircle 1 ally" $_card',
        ),
        Perk(
          '$_onceEachScenario, one adjacent ally may use one of your *potion* $_pocket items during their turn without it becoming $_loss',
        ),
        Perk(
          'Whenever you perform an action with $_loss, you may $_anyElement',
        ),
        Perk(
          '$_wheneverYouLongRest, you may perform: $_heal 2, $_range 3',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // SPELLWEAVER
    ClassCodes.spellweaver: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk('$_add $_two +1 $_cards', quantity: 2),
        Perk('$_add $_one +0 $_stun $_card'),
        Perk('$_add $_one +1 $_wound $_card'),
        Perk('$_add $_one +1 $_immobilize $_card'),
        Perk('$_add $_one +1 $_curse $_card'),
        Perk('$_add $_one +2 $_fire $_card', quantity: 2),
        Perk('$_add $_one +2 $_ice $_card', quantity: 2),
        Perk('$_add $_one $_rolling $_earth and $_one $_rolling $_air $_card'),
        Perk('$_add $_one $_rolling $_light and $_one $_rolling $_dark $_card'),
      ], variant: Variant.base),
      Perks([
        Perk('Remove one -2 card'),
        Perk('Replace one -1 card with one +1 card', quantity: 2),
        Perk(
          'Replace one -1 card with one +0 $_air $_rolling card and one +0 $_earth $_rolling card',
        ),
        Perk(
          'Replace one -1 card with one +0 $_light $_rolling card and one +0 $_dark $_rolling card',
        ),
        Perk('Replace one +0 card with one +1 $_wound card'),
        Perk('Replace one +0 card with one +1 $_immobilize card'),
        Perk('Replace one +0 card with one +1 $_stun card'),
        Perk('Replace one +0 card with one +1 $_curse card'),
        Perk('Add one +2 $_fire card', quantity: 2),
        Perk('Add one +2 $_ice card', quantity: 2),
        Perk(_ignoreScenarioEffects),
        Perk(
          '**Etheric Bond:** $_wheneverYouShortRest, if *Reviving Ether* is in your discard pile, first return it to your hand',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_anyElement $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_add $_plusTwo $_attack if drawn during an action with $_loss" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_curse $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 $_stun $_card', quantity: 2),
        Perk('$_add $_one +2 $_fire/$_ice $_card', quantity: 2),
        Perk('$_ignoreScenarioEffectsAndRemove $_one +0 $_card'),
        Perk(
          '$_onceEachScenario, when you would suffer $_damage, you may gain $_invisible and $_stun to negate the $_damage',
        ),
        Perk(
          '$_wheneverYouShortRest, if *Reviving Ether* is in your discard pile, first $_recover it',
        ),
        Perk(
          'At the end of each of your turns during which you performed an action with $_loss, gain $_bless',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // SCOUNDREL
    ClassCodes.scoundrel: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_two $_rolling +1 $_cards', quantity: 2),
        Perk('$_add $_two $_rolling $_pierce 3 $_cards'),
        Perk('$_add $_two $_rolling $_poison $_cards', quantity: 2),
        Perk('$_add $_two $_rolling $_muddle $_cards'),
        Perk('$_add $_one $_rolling $_invisible $_card'),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
      Perks([
        Perk('Remove two -1 cards'),
        Perk('Replace one -1 card with one +1 card'),
        Perk(
          'Replace one -1 card with two +0 $_poison $_rolling cards',
          quantity: 2,
        ),
        Perk('Replace one -2 card with one +0 card'),
        Perk('Replace one +0 card with one +2 card', quantity: 2),
        Perk(
          'Replace two +0 cards with one +0 $_muddle $_rolling card and one +0 $_pierce 3 $_rolling card',
          quantity: 2,
        ),
        Perk('Add two +1 $_rolling cards', quantity: 2),
        Perk('Add one +0 "$_invisible, self", $_rolling card'),
        Perk(_ignoreScenarioEffects),
        Perk(
          '**Cloak of Invisibility:** $_onceEachScenario, during your turn, perform "$_invisible, self"',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      // SILENT KNIFE
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "Gain one money token if this attack targeted an adjacent enemy" $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk(
          '$_replace $_one +1 $_card with $_one +1 "$_invisible, self" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 $_disarm $_card', quantity: 2),
        Perk(
          'At the end of each of your rests, you may place one of your money tokens in the hex occupied by an enemy within $_range 3 to perform: $_attack 1, $_targetCircle that enemy, $_range 3',
        ),
        Perk(
          'Whenever you complete a city event, draw an attack modifier card as though you were performing an $_attack 4. Gain an amount of gold equal to the $_damage the attack would have dealt',
        ),
        Perk(
          '$_onceEachScenario, during your turn, you may perform: $_invisible, self',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // CRAGHEART
    ClassCodes.cragheart: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk('$_add $_one -2 $_card and $_two +2 $_cards'),
        Perk('$_add $_one +1 $_immobilize $_card', quantity: 2),
        Perk('$_add $_one +2 $_muddle $_card', quantity: 2),
        Perk('$_add $_two $_rolling $_push 2 $_cards'),
        Perk('$_add $_two $_rolling $_earth $_cards', quantity: 2),
        Perk('$_add $_two $_rolling $_air $_cards'),
        Perk(_ignoreNegativeItemEffects),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
      Perks([
        Perk('Replace one -1 card with one +1 card', quantity: 3),
        Perk('Replace one +0 card with two +0 $_push 2 $_rolling cards'),
        Perk('Replace one +0 card with one +1 $_immobilize card', quantity: 2),
        Perk('Replace one +0 card with one +2 card', quantity: 2),
        Perk(
          'Add one +2 $_muddle card and one +0 $_air $_rolling card',
          quantity: 2,
        ),
        Perk('Add four +0 $_earth $_rolling cards'),
        Perk(_ignoreItemMinusOneEffects),
        Perk(_ignoreScenarioEffects),
        Perk(
          '**Earthquakes:** Whenever a new room is revealed, control all enemies in the newly revealed room: $_move 1, this movement must end in an empty hex',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "Create one 1-hex obstacle tile in an empty hex adjacent to the target" $_rolling $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_two +1 $_push 1 $_cards',
          quantity: 2,
        ),
        Perk('$_add $_one +2 $_immobilize $_card', quantity: 3),
        Perk('$_ignoreScenarioEffectsAndAdd $_one $_muddle $_rolling $_card'),
        Perk(_ignoreItemMinusOneEffects),
        Perk(
          'Once each $_scenario, during your turn, you may destroy one 1-hex obstacle within $_range 5 to $_teleport to the hex it occupied',
        ),
        Perk(
          'At the end of each of your rests, you may destroy one 1-hex obstacle within $_range 3 to $_earth',
        ),
        Perk(
          'Whenever a new room is revealed, control all enemies in the newly revealed room: $_move 1, this movement must end in an empty hex',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // MINDTHIEF
    ClassCodes.mindthief: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_add $_one +2 $_ice $_card', quantity: 2),
        Perk('$_add $_two $_rolling +1 $_cards', quantity: 2),
        Perk('$_add $_three $_rolling $_pull 1 $_cards'),
        Perk('$_add $_three $_rolling $_muddle $_cards'),
        Perk('$_add $_two $_rolling $_immobilize $_cards'),
        Perk('$_add $_one $_rolling $_stun $_card'),
        Perk(
          '$_add $_one $_rolling $_disarm $_card and $_one $_rolling $_muddle $_card',
        ),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
      Perks([
        Perk('Remove two -1 cards'),
        Perk(
          'Replace one -1 card with one +0 $_immobilize $_rolling card',
          quantity: 2,
        ),
        Perk('Replace one -2 card with one +0 card'),
        Perk('Replace two +0 cards with three +0 $_push 1 $_rolling cards'),
        Perk('Replace two +0 cards with three +0 $_muddle $_rolling cards'),
        Perk('Replace two +1 cards with two +2 cards'),
        Perk('Add one +2 $_ice card', quantity: 2),
        Perk('Add two +1 $_rolling cards', quantity: 2),
        Perk('Add one +0 $_stun $_rolling card'),
        Perk(
          'Add one +0 $_disarm $_rolling card and one +0 $_muddle $_rolling card',
        ),
        Perk(_ignoreScenarioEffects),
        Perk(
          '**Lying Low:** You are considered to be last in initiative order when determining monster focus',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk(
          '$_replace $_two -1 $_cards with $_one +0 "After the attack ability, control the target: $_move 1" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "Add $_plusOne $_attack for each $_negative condition the target has" $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_two +1 $_immobilize $_cards'),
        Perk('$_add $_one +2 $_ice $_card', quantity: 3),
        Perk('$_add $_one "$_invisible, self" $_rolling $_card', quantity: 2),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_rolling $_card'),
        Perk(
          'Whenever you control the attack of an enemy, you may have the enemy use your attack modifier deck',
        ),
        Perk(
          'You are considered to be last in initiative order when determining monster focus',
        ),
        Perk(
          'At the end of each of your rests, you may consume_$_ice/$_dark to control one enemy within $_range 5: $_attack 1',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // SUNKEEPER
    ClassCodes.sunkeeper: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
        Perk('$_add $_two $_rolling +1 $_cards', quantity: 2),
        Perk('$_add $_two $_rolling $_heal 1 $_cards', quantity: 2),
        Perk('$_add $_one $_rolling $_stun $_card'),
        Perk('$_add $_two $_rolling $_light $_cards', quantity: 2),
        Perk('$_add $_two $_rolling "$_shield 1, Self" $_cards'),
        Perk('$_ignoreNegativeItemEffectsAndAdd $_two +1 $_cards'),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
      Perks([
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
        Perk('Add two +1 $_rolling cards', quantity: 2),
        Perk('Add one +0 $_stun $_rolling card'),
        Perk('Add two +0 "$_heal 1, self" $_rolling cards', quantity: 2),
        Perk('$_ignoreItemMinusOneEffects, and add two +1 cards'),
        Perk(_ignoreScenarioEffects),
        Perk(
          '**Shielding Light:** Whenever one of your heals would cause an ally\'s current hit point value to increase beyond their maximum hit point value, that ally gains $_ward',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_two +0 $_light $_cards',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_shield 1" $_rolling $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_two +1 "$_heal 1, $_range 3" $_cards', quantity: 2),
        Perk(
          '$_add $_one -1 "You or an adjacent ally may $_recover one level 1 card from the discard pile" $_card',
        ),
        Perk('$_add $_one $_stun $_rolling $_card'),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_card'),
        Perk('$_ignoreItemMinusOneEffectsAndRemove $_one -1 $_card'),
        Perk(
          'Whenever you open one or more doors during your turn, gain $_shield 1, $_retaliate 1 for the round',
          quantity: 2,
          grouped: true,
        ),
        Perk('$_wheneverYouLongRest, you may $_light'),
        Perk(
          'Whenever one of your heals would cause an ally\'s current hit point value to increase beyond their maximum hit point value, that ally gains $_ward',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // QUARTERMASTER
    ClassCodes.quartermaster: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_two $_rolling +1 $_cards', quantity: 2),
        Perk('$_add $_three $_rolling $_muddle $_cards'),
        Perk('$_add $_two $_rolling $_pierce 3 $_cards'),
        Perk('$_add $_one $_rolling $_stun $_card'),
        Perk('$_add $_one $_rolling ADD $_targetDiamond $_card'),
        Perk('$_add $_one +0 "$_recover an item" $_card', quantity: 3),
        Perk('$_ignoreNegativeItemEffectsAndAdd $_two +1 $_cards'),
      ], variant: Variant.base),
      Perks([
        Perk('Remove two -1 cards', quantity: 2),
        Perk('Replace two +0 cards with two +0 $_pierce 3 $_rolling cards'),
        Perk('Replace one +0 card with one +0 "$_plusOne $_targetCircle" card'),
        Perk('Replace one +0 card with one +2 card', quantity: 2),
        Perk('Add one +0 "$_recover one item" card', quantity: 3),
        Perk('Add two +1 $_rolling cards', quantity: 2),
        Perk('Add one +0 $_stun $_rolling card'),
        Perk('$_ignoreItemMinusOneEffects, and add two +1 cards'),
        Perk(
          '**Well Supplied:** $_onceEachScenario, during your turn, if you have a persistent Quartermaster ability card in your active area, you may recover up to four cards from your discard pile',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk(
          '$_replace $_two -1 $_cards with $_one +0 $_muddle $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +0 "Gain 10 $_supplies" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two $_pierce 3 $_rolling $_cards',
        ),
        Perk(
          '$_replace $_one +1 $_card with $_two +0 "Gain the *Barbed Strip* or *Iron Plate* item" $_cards',
          quantity: 2,
        ),
        Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
        Perk(
          '$_add $_one "Gain the *Scroll of Relocation* or *Sharpened Dirk* item" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_add $_one $_stun $_rolling $_card', quantity: 2),
        Perk('$_ignoreItemMinusOneEffectsAndRemove $_one +0 $_card'),
        Perk('You may bring one additional $_pocket item into each $_scenario'),
        Perk(
          'Your party may purchase items from each faction as though the items\' costs were five gold less and your reputation with that faction was two greater',
        ),
        Perk(
          '$_wheneverYouLongRest, gain 10 $_supplies',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // SUMMONER/SOULTETHER
    ClassCodes.summoner: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk('$_add $_one +2 $_card', quantity: 2),
        Perk('$_add $_two $_rolling $_wound $_cards'),
        Perk('$_add $_two $_rolling $_poison $_cards'),
        Perk('$_add $_two $_rolling $_heal 1 $_cards', quantity: 3),
        Perk('$_add $_one $_rolling $_fire and $_one $_rolling $_air $_card'),
        Perk('$_add $_one $_rolling $_dark and $_one $_rolling $_earth $_card'),
        Perk('$_ignoreNegativeScenarioEffectsAndAdd $_two +1 $_cards'),
      ], variant: Variant.base),
      Perks([
        Perk('Remove two -1 cards'),
        Perk('Replace one -1 card with one +1 card', quantity: 3),
        Perk('Replace one -2 card with one +0 card'),
        Perk(
          'Replace two +0 cards with one +0 $_fire $_rolling card and one +0 $_earth $_rolling card',
        ),
        Perk(
          'Replace two +0 cards with one +0 $_air $_rolling card and one +0 $_dark $_rolling card',
        ),
        Perk('Replace two +1 cards with two +2 cards'),
        Perk('Add two +0 $_wound $_rolling cards'),
        Perk('Add two +0 $_poison $_rolling cards'),
        Perk('Add three +0 "$_heal 1, self" $_rolling cards', quantity: 2),
        Perk('$_ignoreScenarioEffectsAndAdd two +1 cards'),
        Perk(
          '**Phase Out:** $_onceEachScenario, during ordering of initiative, after all ability cards have been revealed, all your summons gain $_invisible',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "After the attack ability, grant one of your summons: $_teleport 2" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_invisible, $_targetCircle 1 of your summons" $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +0 $_card with $_two $_wound $_rolling $_cards'),
        Perk('$_replace $_one +0 $_card with $_two $_poison $_rolling $_cards'),
        Perk('$_replace $_two +1 $_cards with $_two +1 $_curse $_cards'),
        Perk('$_add $_one +2 $_fire/$_air $_card'),
        Perk('$_add $_one +2 $_fire/$_dark $_card'),
        Perk('$_add $_one +2 $_air/$_dark $_card'),
        Perk('$_ignoreScenarioEffectsAndAdd $_two +1 $_cards'),
        Perk(
          'At the beginning of each round in which you long rest, all your summons gain $_shield 1 for the round',
        ),
        Perk(
          '$_onceEachScenario, during your turn, $_teleport one of your summons to an empty hex adjacent to you',
        ),
        Perk(
          '$_onceEachScenario, during ordering of initiative, after all ability cards have been revealed, all your summons gain $_invisible',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // NIGHTSHROUD
    ClassCodes.nightshroud: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove four +0 $_cards'),
        Perk('$_add $_one -1 $_dark $_card', quantity: 2),
        Perk(
          '$_replace $_one -1 $_dark $_card with $_one +1 $_dark $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 $_invisible $_card', quantity: 2),
        Perk('$_add $_three $_rolling $_muddle $_cards', quantity: 2),
        Perk('$_add $_two $_rolling $_heal 1 $_cards'),
        Perk('$_add $_two $_rolling $_curse $_cards'),
        Perk('$_add $_one $_rolling ADD $_targetDiamond $_card'),
        Perk('$_ignoreNegativeScenarioEffectsAndAdd $_two +1 $_cards'),
      ], variant: Variant.base),
      Perks([
        Perk('Remove two -1 cards', quantity: 2),
        Perk('Replace one -2 card with one -1 $_dark card'),
        Perk(
          'Replace one +0 card with one +0 "$_plusOne $_targetCircle" $_rolling card',
        ),
        Perk(
          'Replace two +0 cards with three +0 $_muddle $_rolling cards',
          quantity: 2,
        ),
        Perk('Replace one +1 card with one +1 $_invisible card', quantity: 2),
        Perk('Add one +1 $_dark card', quantity: 2),
        Perk('Add two +0 $_curse $_rolling cards'),
        Perk('Add two +0 "$_heal 1, self" $_rolling cards'),
        Perk('$_ignoreScenarioEffectsAndAdd two +1 cards'),
        Perk(
          '**Empowering Night:** At the start of the scenario, you may discard two cards to add a card with an action containing a persistent symbol from your pool to your hand and immediately play it, performing that action',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk(
          '$_replace $_one -1 $_card with $_two "After the attack ability, grant one adjacent ally or self: $_teleport 2" $_rolling $_cards',
        ),
        Perk('$_replace $_one $_null $_card with $_one -2 $_shuffle $_card'),
        Perk(
          '$_replace $_two +0 $_cards with $_two +1 "If this attack kills the target, shuffle one $_curse card into the monster attack modifier deck" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 $_dark $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +0 "Place one $_tear in a hex adjacent to the target" $_card',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndAdd $_two +1 $_cards'),
        Perk('$_wheneverYouLongRest, you may $_dark'),
        Perk(
          '$_onceEachScenario, during your turn, place one $_tear in an adjacent hex',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'If a $_curse causes an enemy to deal no $_damage during its attack, that enemy suffers $_damage 3',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // PLAGUEHERALD
    ClassCodes.plagueherald: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_two +1 $_cards'),
        Perk('$_add $_one +1 $_air $_card', quantity: 3),
        Perk('$_add $_three $_rolling $_poison $_cards'),
        Perk('$_add $_two $_rolling $_curse $_cards'),
        Perk('$_add $_two $_rolling $_immobilize $_cards'),
        Perk('$_add $_one $_rolling $_stun $_card', quantity: 2),
        Perk('$_ignoreNegativeScenarioEffectsAndAdd $_one +1 $_card'),
      ], variant: Variant.base),
      Perks([
        Perk('Remove one -2 card'),
        Perk('Replace one -1 card with one +1 card', quantity: 3),
        Perk('Replace one +0 card with one +2 card', quantity: 2),
        Perk('Add three +1 $_air cards'),
        Perk('Add three +0 $_poison $_rolling cards'),
        Perk('Add two +0 $_immobilize $_rolling cards'),
        Perk('Add one +0 $_stun $_rolling card', quantity: 2),
        Perk('Add two +0 $_curse $_rolling cards'),
        Perk('$_ignoreScenarioEffectsAndAdd one +1 card'),
        Perk(
          '**Xorn\'s Boon:** $_onceEachScenario, during your turn, cause each enemy that has $_poison to suffer $_damage 1 and gain $_muddle and each ally who has $_poison to suffer $_damage 1 and gain $_strengthen',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Give the target or one enemy within $_range 2 of the target $_brittle" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_curse $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
          quantity: 2,
        ),
        Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
        Perk('$_add $_one +1 $_stun $_card', quantity: 2),
        Perk(
          '$_add $_three +0 "Give the target or one enemy within $_range 2 of the target $_poison" $_rolling $_cards',
        ),
        Perk('$_add $_two "$_heal 1, $_targetCircle 1 ally" $_rolling $_cards'),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_card'),
        Perk('You have $_flying'),
        Perk(
          'Whenever you heal from a long rest, you may remove $_poison from one ally to add $_plusOne $_heal',
        ),
        Perk(
          '$_onceEachScenario, when an enemy that has $_brittle would die, first control that enemy and have it perform the abilities on its ability card, adding $_brittle to all its attacks, then it dies',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // BERSERKER
    ClassCodes.berserker: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk(
          '$_replace $_one +0 $_card with $_one $_rolling +2 $_card',
          quantity: 2,
        ),
        Perk('$_add $_two $_rolling $_wound $_cards', quantity: 2),
        Perk('$_add $_one $_rolling $_stun $_card', quantity: 2),
        Perk('$_add $_one $_rolling +1 $_disarm $_card'),
        Perk('$_add $_two $_rolling $_heal 1 $_cards'),
        Perk('$_add $_one +2 $_fire $_card', quantity: 2),
        Perk(_ignoreNegativeItemEffects),
      ], variant: Variant.base),
      Perks([
        Perk('Remove two -1 cards'),
        Perk('Replace one -1 card with one +1 card', quantity: 2),
        Perk(
          'Replace one +0 card with two +0 $_wound $_rolling cards',
          quantity: 2,
        ),
        Perk('Replace one +1 card with one +2 $_rolling card', quantity: 2),
        Perk('Add one +2 $_fire card', quantity: 2),
        Perk('Add one +0 $_stun $_rolling card', quantity: 2),
        Perk('Add one +1 $_disarm $_rolling card'),
        Perk('Add two +0 "$_heal 1, self" $_rolling cards'),
        Perk(_ignoreItemMinusOneEffects),
        Perk(
          '**Rapid Recovery:** Whenever you heal from a long rest, add $_plusOne $_heal',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 1, self" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "You may suffer $_damage 2 to add $_plusTwo $_attack" $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_two $_wound $_rolling $_cards'),
        Perk('$_add $_one +2 $_fire $_card', quantity: 2),
        Perk('$_add $_one $_stun $_rolling $_card'),
        Perk(
          '$_add $_one 2x "Suffer $_damage equal to half your current hit point value (rounded down)" $_card',
        ),
        Perk('$_ignoreItemMinusOneEffectsAndAdd $_one +1 $_card'),
        Perk('Whenever you heal from a long rest, $_addLowercase +1 $_heal'),
        Perk(
          '$_onceEachScenario, when $_damage from an attack would reduce your current hit point value to less than 1, instead set your current hit point value to 1 and perform: $_attack 2, $_targetCircle the attacker',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'At the end of each of your turns, you may control all adjacent enemies: $_attack $_plusZero, $_targetCircle $_berserker',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // SOOTHSINGER
    ClassCodes.soothsinger: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_one -2 $_card'),
        Perk('$_replace $_two +1 $_cards with $_one +4 $_card', quantity: 2),
        Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_disarm $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_wound $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_poison $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
        Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_stun $_card'),
        Perk('$_add $_three $_rolling +1 $_cards'),
        Perk('$_add $_two $_rolling $_curse $_cards', quantity: 2),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_one -2 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_stun $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_disarm $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_wound $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_poison $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
        Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
        Perk('$_replace $_two +1 $_cards with $_one +4 $_card', quantity: 2),
        Perk('$_add $_three +1 $_rolling $_cards'),
        Perk('$_add $_three +0 $_curse $_rolling $_cards'),
        Perk(
          '**Storyteller:** $_atTheEndOfEachScenario, each character in that scenario gains 8 experience if you successfully completed your battle goal',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one -2 "$_bless, $_targetCircle 2" $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Skip moving your character tokens on active $_song at the end of this round" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_stun $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "$_strengthen, $_targetCircle 1 ally" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card and $_one +1 $_card with $_two +2 $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_one "Grant one ally: $_move 2 or $_attack 2" $_rolling $_card',
          quantity: 3,
        ),
        Perk('$_add $_three $_curse $_rolling $_cards'),
        Perk(
          '$_atTheEndOfEachScenario, each character in that scenario gains ${xp(8)} if you completed your battle goal',
        ),
        Perk(
          'Whenever you perform a $_song action, if you have any unused Notes, gain one Note of your choice in addition to any other Note gained that round',
        ),
        Perk(
          'During ordering of initiative in rounds in which you declare a long rest, gain one Note of your choice, and each of your allies may decrease their initiative by 10',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // DOOMSTALKER
    ClassCodes.doomstalker: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_replace $_two +0 $_cards with $_two +1 $_cards', quantity: 3),
        Perk('$_add $_two $_rolling +1 $_cards', quantity: 2),
        Perk('$_add $_one +2 $_muddle $_card'),
        Perk('$_add $_one +1 $_poison $_card'),
        Perk('$_add $_one +1 $_wound $_card'),
        Perk('$_add $_one +1 $_immobilize $_card'),
        Perk('$_add $_one +0 $_stun $_card'),
        Perk('$_add $_one $_rolling ADD $_targetDiamond $_card', quantity: 2),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 4),
        Perk(
          '$_replace $_one +0 $_card with $_one +0 "$_plusOne $_targetCircle" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_poison $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_muddle $_card'),
        Perk('$_add $_two +1 $_rolling $_cards', quantity: 2),
        Perk('$_ignoreScenarioEffectsAndAdd one +1 $_immobilize card'),
        Perk(
          '**Marked for the Hunt:** At the beginning of each round in which you long rest, you may choose one ally to gain the benefits of any of your active Dooms as if the Dooms were in that ally\'s active area for the round',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one -1 "$_doomstalker performs: $_attack 2, $_range 5" $_card',
          quantity: 3,
        ),
        Perk('$_replace $_two +0 $_cards with $_two +1 $_cards', quantity: 2),
        Perk(
          '$_add $_one +0 "Grant one of your summons adjacent to the target: $_attack $_plusZero" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +3 $_card', quantity: 2),
        Perk('$_add $_one $_stun $_rolling $_card', quantity: 2),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_rolling $_card'),
        Perk(
          '$_atTheStartOfEachScenario, reveal the top $_card of each monster ability $_card deck in the $_scenario',
        ),
        Perk(
          '$_wheneverYouLongRest, after you $_recover your $_cards from your discard pile, you may play one $_card from your hand to perform a $_doom action of the card',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'On each of your summons\' turns, you may have them skip their turn and instead perform $_move $_plusZero treating you as their focus',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // SAWBONES
    ClassCodes.sawbones: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_one $_rolling +2 $_card', quantity: 2),
        Perk('$_add $_one +1 $_immobilize $_card', quantity: 2),
        Perk('$_add $_two $_rolling $_wound $_cards', quantity: 2),
        Perk('$_add $_one $_rolling $_stun $_card'),
        Perk('$_add $_one $_rolling $_heal 3 $_card', quantity: 2),
        Perk('$_add $_one +0 "$_recover an item" $_card'),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_wound $_rolling $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +0 "$_recover one item" $_card'),
        Perk('$_add $_one +2 $_rolling $_card', quantity: 2),
        Perk('$_add $_one +0 $_stun $_rolling $_card'),
        Perk('$_add $_one +0 "$_heal 3, self" $_rolling $_card', quantity: 2),
        Perk(
          '**Revitalizing Medicine:** Whenever an ally performs the Heal ability of *Medical Pack* or *Large Medical Pack*, that character may first remove one negative condition',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk(
          '$_replace $_one -2 $_card with $_one -2 "Give one adjacent ally or self one medical pack" $_card',
        ),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "You may gain $_disarm to add $_stun" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_two +1 "Add $_plusOne $_attack if an ally has an active $_prescription" $_cards',
          quantity: 2,
        ),
        Perk('$_add $_one "$_heal 3, $_range 1" $_rolling $_card', quantity: 2),
        Perk(
          'Add $_plusOne $_heal to all heal abilities on "Medical Pack" ability cards',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'Each City Phase after completing a scenario, your or one ally\'s donation to the Sanctuary of the Great Oak is free',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'At the end of each of your rests, if an ally has an active $_prescription, gain one "Medical Pack" ability card and move the token on one ally\'s active $_prescription backward one slot',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // ELEMENTALIST
    ClassCodes.elementalist: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_three +0 $_fire $_cards'),
        Perk('$_add $_three +0 $_ice $_cards'),
        Perk('$_add $_three +0 $_air $_cards'),
        Perk('$_add $_three +0 $_earth $_cards'),
        Perk(
          '$_replace $_two +0 $_cards with $_one +0 $_fire $_card and $_one +0 $_earth $_card',
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +0 $_ice $_card and $_one +0 $_air $_card',
        ),
        Perk('$_add $_two +1 $_push 1 $_cards'),
        Perk('$_add $_one +1 $_wound $_card'),
        Perk('$_add $_one +0 $_stun $_card'),
        Perk('$_add $_one +0 ADD $_targetDiamond $_card'),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_one -2 $_card'),
        Perk('$_remove $_four +0 $_cards'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_plusOne $_targetCircle" $_card',
        ),
        Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
        Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
        Perk('$_add $_four +0 $_fire $_cards'),
        Perk('$_add $_four +0 $_ice $_cards'),
        Perk('$_add $_four +0 $_air $_cards'),
        Perk('$_add $_four +0 $_earth $_cards'),
        Perk(_ignoreScenarioEffects),
        Perk(
          '**Elemental Proficiency:** $_atTheStartOfEachScenario and whenever you long rest, $_anyElement',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk('$_replace $_one -1 $_card with $_one +0 $_fire/$_air $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_fire/$_earth $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_ice/$_air $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_ice/$_earth $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_fire/$_ice $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_air/$_earth $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_light/$_dark $_card',
          quantity: 2,
        ),
        Perk('$_add $_two $_anyElement $_rolling $_cards', quantity: 2),
        Perk(
          '$_ignoreScenarioEffectsAndAdd $_one $_anyElement $_rolling $_card',
        ),
        Perk('$_atTheStartOfEachScenario, you may $_anyElement'),
        Perk('$_wheneverYouLongRest, consume_$_anyElement : $_anyElement'),
        Perk(
          '$_fire, $_ice, $_air, and $_earth do not wane at the end of each round',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // BEAST TYRANT
    ClassCodes.beastTyrant: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_one +1 $_wound $_card', quantity: 2),
        Perk('$_add $_one +1 $_immobilize $_card', quantity: 2),
        Perk('$_add $_two $_rolling $_heal 1 $_cards', quantity: 3),
        Perk('$_add $_two $_rolling $_earth $_cards'),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_wound $_card',
          quantity: 2,
        ),
        Perk('$_add $_two +1 $_immobilize $_cards'),
        Perk('$_add $_two +0 "$_heal 1, self" $_rolling $_cards', quantity: 3),
        Perk(
          '$_ignoreScenarioEffectsAndAdd $_two +0 $_earth $_rolling $_cards',
        ),
        Perk(
          '**Bear Treat:** During each round in which you long rest, at initiative 99, you may skip the bear\'s normal turn to Command: "$_move 3; $_loot 1; If the loot ability was performed: $_heal 3, self"',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
      // WILDFURY
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one "$_heal 2, $_targetCircle $_bear" $_rolling $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_wound $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 "Add $_plusOne $_attack if the Wildfury and $_bear are within $_range 4 of each other" $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +2 $_card with $_one +4 $_card'),
        Perk('$_add $_two +1 $_air/$_earth $_cards', quantity: 2),
        Perk('$_add $_one +2 $_push $_card', quantity: 2),
        Perk(
          '$_ignoreScenarioEffectsAndAdd $_one +1 "$_safeguard, $_targetCircle 1 ally" $_card',
        ),
        Perk(
          'Whenever $_bear is attacked, treat any 2x attack modifier $_card the enemy draws as +0 instead',
        ),
        Perk(
          '$_onceEachScenario, during your turn, $_command: $_move 4.\nIf $_bear exits a hex adjacent to you during this movement, you may $_teleport to an empty hex adjacent to $_bear at the end of the movement',
        ),
        Perk(
          'At the start or end of each of your long rests, you may $_air/$_earth and reduce your current hit point value by X (X must be at least 1) to $_command: $_heal X, self',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    ClassCodes.bladeswarm: [
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_air $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_earth $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_light $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_dark $_card'),
        Perk('$_add $_two $_rolling $_heal 1 $_cards', quantity: 2),
        Perk('$_add $_one +1 $_wound $_card', quantity: 2),
        Perk('$_add $_one +1 $_poison $_card', quantity: 2),
        Perk('$_add $_one +2 $_muddle $_card'),
        Perk('$_ignoreNegativeItemEffectsAndAdd $_one +1 $_card'),
        Perk('$_ignoreNegativeScenarioEffectsAndAdd $_one +1 $_card'),
      ], variant: Variant.base),
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_wound $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_poison $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +1 $_air $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_earth $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_light $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_dark $_card'),
        Perk('$_add $_one +2 $_muddle $_card', quantity: 2),
        Perk('$_add $_two $_heal 1 $_rolling $_cards', quantity: 2),
        Perk('$_ignoreNegativeItemEffectsAndAdd $_one +1 $_card'),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_card'),
        Perk(
          '**Spinning Up:** At the start of your first turn each scenario, you may play one card from your hand to perform a persistent loss action of that card',
        ),
      ], variant: Variant.frosthavenCrossover),
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_wound $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_poison $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_air/$_dark $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_earth/$_light $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +0 "$_add $_plusOne for each card with $_loss in $_bladeswarm\'s active area" $_card',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_card'),
        Perk('$_ignoreItemMinusOneEffectsAndAdd $_one +1 $_card'),
        Perk(
          '$_wheneverYouLongRest, you may $_teleport to the hex occupied by one of your summons and simultaneously $_teleport that summon to the hex you occupied',
        ),
        Perk(
          '$_onceEachScenario, when you perform an action with $_loss, you may immediately play one card from your hand to perform an action with $_loss of the card',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'You may additionally bring four $_oneHand items, two $_twoHand items, or two $_oneHand items and one $_twoHand item into each $_scenario',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.gloomhaven2E),
    ],
    // DIVINER
    ClassCodes.diviner: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_two +1 $_cards with $_one +3 "$_shield 1, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Affect any Ally" $_card',
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_dark $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_light $_card'),
        Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 "$_regenerate, Self" $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 "$_heal 2, Affect any Ally" $_card',
        ),
        Perk('$_add $_two $_rolling "$_heal 1, Self" $_cards'),
        Perk('$_add $_two $_rolling $_curse $_cards'),
        Perk('$_ignoreNegativeScenarioEffectsAndAdd $_two +1 $_cards'),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_two +1 $_cards with $_one +3 "SHIELD 1" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "Any ally gains SHIELD 1" $_card',
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_dark $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_light $_card'),
        Perk('$_replace $_one +0 $_card with $_one +3 $_muddle $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_curse $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 "$_regenerate, self" $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 "$_heal 2, $_targetCircle 1 ally" $_card',
        ),
        Perk('$_add $_two +0 $_curse $_rolling $_cards'),
        Perk('$_ignoreScenarioEffectsAndAdd $_two +1 $_cards'),
        Perk(
          '**Tip the Scales:** Whenever you rest, you may look at the top card of one attack modifier deck, then you may consume_$_light/$_dark to place one card on the bottom of the deck',
        ),
      ], variant: Variant.frosthavenCrossover),
    ],
    ClassCodes.demolitionist: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 $_muddle $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one -1 $_card with $_one +0 $_poison $_card'),
        Perk('$_add $_one +2 $_card', quantity: 2),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_earth $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_fire $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +0 "All adjacent enemies suffer 1 $_damage" $_card',
          quantity: 2,
        ),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_four +0 $_cards'),
        Perk('$_replace $_one -2 $_card with $_one +0 $_poison $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 $_muddle $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +1 $_card with $_two +2 $_cards'),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_fire $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_earth $_card',
          quantity: 2,
        ),
        Perk('$_add $_two +0 "All adjacent enemies suffer $_damage 1" $_cards'),
        Perk('$_ignoreScenarioEffectsAndRemove $_one -1 $_card'),
        Perk(
          '**Remodeling:** Whenever you rest while adjacent to a wall or obstacle, you may place an obstacle in an empty hex within $_range 2 (of you)',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
    ],
    ClassCodes.hatchet: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_replace $_one +0 $_card with $_one +2 $_muddle $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_poison $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_push 2 $_card'),
        Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
        Perk('$_replace $_one +1 $_card with $_one +1 $_stun $_card'),
        Perk('$_add $_one +2 $_air $_card', quantity: 3),
        Perk('$_replace $_one +1 $_card with $_one +3 $_card', quantity: 3),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
        Perk('$_replace $_one +1 $_card with $_one +1 $_stun $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_poison $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_muddle $_card'),
        Perk('$_replace $_one +1 $_card with $_one +3 $_card', quantity: 3),
        Perk('$_add $_one +2 $_air $_card', quantity: 3),
        Perk(
          '**Hasty Pick-up:** $_onceEachScenario, during your turn, if the Favourite is in a hex on the map, you may consume_$_air to return it to its ability card',
        ),
      ], variant: Variant.frosthavenCrossover),
    ],
    ClassCodes.redGuard: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_fire $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_light $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 $_fire&$_light $_card', quantity: 2),
        Perk('$_add $_one +1 $_shield 1 $_card', quantity: 2),
        Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove $_one -2 $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_wound $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
        Perk(
          '$_replace $_one +0 $_card and $_one +1 $_card with $_two +1 "$_shield 1" $_cards',
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_fire $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_light $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 $_fire/$_light $_card', quantity: 2),
        Perk('$_ignoreItemMinusOneEffectsAndAdd $_two +1 $_cards'),
        Perk(
          '**Brilliant Aegis:** Whenever you are attacked, you may consume_$_light to gain $_shield 1 for the attack and have the attacker gain disadvantage for the attack',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.frosthavenCrossover),
    ],
    ClassCodes.vimthreader: [
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one -1 "If the target has an attribute, $_addLowercase $_wound, $_poison, $_muddle" $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_enfeeble $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_empower, $_range 2" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_heal 1, $_targetDiamond 1 ally" $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +2 $_card with $_four +1 $_rolling $_cards'),
        Perk('$_add $_two $_pierce 2 $_poison $_rolling $_cards'),
        Perk(
          '$_add $_three "$_heal 1, $_range 1" $_rolling $_cards',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndRemove $_one +0 $_card'),
        // here
        Perk('$_ignoreItemMinusOneEffectsAndRemove $_one +0 $_card'),
        Perk(
          '$_wheneverYouShortRest, $_one adjacent enemy suffers $_damage 1, and you perform "$_heal 1, self"',
        ),
        Perk(
          '$_atTheStartOfEachScenario, you may suffer $_damage 1 to grant all allies and self $_move 3',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'Once each $_scenario, $_removeLowercase all $_negative conditions you have. One adjacent enemy suffers $_damage equal to the number of conditions removed',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.core: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_wound, "$_wound, self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_poison, "$_poison, self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +0 "Add $_plusOne $_attack for each condition you have" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_two "$_heal 1, $_range 1" $_rolling $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_one "$_ward, $_regenerate, self" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_add $_one -2 $_brittle and one +3 "$_brittle, self" $_card'),
        Perk('$_ignoreItemMinusOneEffectsAndRemove $_one +0 $_card'),
        Perk(
          '$_atTheStartOfEachScenario, you may perform "$_strengthen, $_wound, self" or "$_ward, $_immobilize, self"',
        ),
        Perk('Once each $_scenario, avoid an Overdrive exhaustion check'),
        Perk(
          'Once each $_scenario, during your turn, $_removeLowercase any number of $_negative conditions you have',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.voidwarden: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_dark $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_ice $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Ally" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 "$_heal 1, Ally" $_card', quantity: 3),
        Perk('$_add $_one +1 $_poison $_card'),
        Perk('$_add $_one +3 $_card'),
        Perk('$_add $_one +1 $_curse $_card', quantity: 2),
      ], variant: Variant.base),
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 1, $_targetCircle 1 ally" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_heal 1, $_targetCircle 1 ally" $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +0 $_card with $_one +1 $_poison $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_curse $_card',
          quantity: 2,
        ),
        Perk('$_add $_two +1 $_ice $_cards'),
        Perk('$_add $_two +1 $_dark $_cards'),
        Perk('$_add $_one +3 $_card'),
        Perk(_ignoreScenarioEffects),
        Perk(
          '**Grave Defense:** Whenever you rest, you may consume_$_ice/$_dark to give $_ward to one ally who has $_poison',
        ),
      ], variant: Variant.frosthavenCrossover),
    ],
    ClassCodes.amberAegis: [
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one -1 "Place $_one Colony token of your choice on any empty hex within $_range 2" $_card',
        ),
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +2 $_muddle $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_poison $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_wound $_card'),
        Perk('$_add $_two $_rolling +1 $_immobilize $_cards', quantity: 2),
        Perk(
          '$_add $_one $_rolling "$_heal 1, Self" $_card and $_one $_rolling "$_shield 1, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one $_rolling "$_retaliate 1, $_range 3" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +2 $_fire/$_earth $_card'),
        Perk('$_ignoreNegativeItemEffectsAndAdd $_one +1 $_card'),
        Perk(
          '$_ignoreScenarioEffectsAndAdd $_one "+X, where X is the number of active Cultivate actions" card',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.artificer: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one -1 $_anyElement $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_disarm $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_push 1 $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_pull 1 $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +0 "$_recover a spent item" $_card',
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
        Perk('$_replace $_one +2 $_card with $_one +3 "$_heal 2, Self" $_card'),
        Perk(
          '$_replace $_two +1 $_cards with $_two $_rolling +1 $_poison $_cards',
        ),
        Perk(
          '$_replace $_two +1 $_cards with $_two $_rolling +1 $_wound $_cards',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.bombard: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk(
          '$_replace $_two +0 $_cards with $_two $_rolling $_pierce 3 $_cards',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "+3 if Projectile" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +2 $_immobilize $_card', quantity: 2),
        Perk(
          '$_replace $_one +1 $_card with $_two +1 "$_retaliate 1, $_range 3" $_cards',
        ),
        Perk('$_add $_two +1 "$_pull 3, Self, toward the target" $_cards'),
        Perk('$_add $_one +0 "$_strengthen, Self" $_card'),
        Perk('$_add $_one +0 $_stun $_card'),
        Perk('$_add $_one +1 $_wound $_card'),
        Perk('$_add $_two $_rolling "$_shield 1, Self" $_cards'),
        Perk('$_add $_two $_rolling "$_heal 1, Self" $_cards'),
        Perk('$_ignoreNegativeScenarioEffectsAndRemove $_one +0 $_card'),
        Perk('$_ignoreNegativeItemEffectsAndRemove $_one +0 $_card'),
      ], variant: Variant.base),
    ],
    ClassCodes.brewmaster: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one -1 $_stun $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk(
          '$_replace $_one -1 $_card with $_two $_rolling $_muddle $_cards',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two +0 "$_heal 1, Self" $_cards',
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +0 "Give yourself or an adjacent Ally a \'Liquid Rage\' item $_card" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +2 PROVOKE $_card', quantity: 2),
        Perk('$_add four $_rolling Shrug_Off 1 $_cards', quantity: 2),
        Perk('$_ignoreNegativeScenarioEffectsAndAdd $_one +1 $_card'),
        Perk('Each time you long rest, perform Shrug_Off 1', quantity: 2),
      ], variant: Variant.base),
    ],
    ClassCodes.brightspark: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Consume_$_anyElement to $_addLowercase +2 $_attack" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one -2 $_card with $_one -2 "$_recover $_one random $_card from your discard pile" $_card',
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "$_heal 1, Affect $_one Ally within $_range 2" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "$_shield 1, Affect $_one Ally within $_range 2" $_card',
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 $_anyElement $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +1 "$_strengthen, Affect $_one Ally within $_range 2" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one $_rolling "$_push 1 or $_pull 1, $_air" $_card and $_one $_rolling "$_immobilize, $_ice" $_card',
        ),
        Perk(
          '$_add $_one $_rolling "$_heal 1, $_range 3, $_light" $_card and $_one $_rolling "$_pierce 2, $_fire" $_card',
        ),
        Perk(
          '$_add $_three $_rolling "Consume_$_anyElement : $_anyElement" $_cards',
        ),
        Perk('$_ignoreNegativeScenarioEffectsAndRemove $_one -1 $_card'),
      ], variant: Variant.base),
    ],
    ClassCodes.chieftain: [
      Perks([
        Perk('$_replace $_one -1 $_card with $_one +0 $_poison $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Chieftain" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 1, Affect all summoned allies owned" $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one -2 $_card with $_one -2 "$_bless, Self" $_card'),
        Perk(
          '$_replace $_two +0 $_cards with $_one +0 "$_immobilize and $_push 1" $_card',
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one "+X, where X is the number of summoned allies you own" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_two +1 "$_rolling +1, if summon is attacking" $_cards',
        ),
        Perk('$_add $_one +0 $_wound, $_pierce 1 $_card'),
        Perk('$_add $_one +1 $_earth $_card', quantity: 2),
        Perk(
          '$_add $_two $_rolling "$_pierce 2, ignore $_retaliate on the target" $_cards',
        ),
        Perk('$_ignoreNegativeScenarioEffectsAndAdd $_one +1 $_card'),
      ], variant: Variant.base),
    ],
    ClassCodes.fireKnight: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_strengthen, Ally" $_card',
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
        Perk('$_add $_one +1 "$_strengthen, Ally" $_card'),
        Perk(
          '$_add $_two $_rolling "$_heal 1, $_range 1" $_cards',
          quantity: 2,
        ),
        Perk('$_add $_two $_rolling $_wound $_cards'),
        Perk('$_ignoreNegativeItemEffectsAndAdd $_one $_rolling $_fire $_card'),
        Perk(
          '$_ignoreNegativeScenarioEffectsAndAdd $_one $_rolling $_fire $_card',
        ),
      ], variant: Variant.base),
    ],

    ClassCodes.frostborn: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_replace $_one -2 $_card with $_one +0 CHILL $_card'),
        Perk(
          '$_replace $_two +0 $_cards with $_two +1 $_push 1 $_cards',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_ice CHILL $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +1 $_card with $_one +3 $_card'),
        Perk('$_add $_one +0 $_stun $_card'),
        Perk('$_add $_one $_rolling ADD $_targetDiamond $_card', quantity: 2),
        Perk('$_add $_three $_rolling CHILL $_cards'),
        Perk('$_add $_three $_rolling $_push 1 $_cards'),
        Perk('Ignore difficult and hazardous terrain during move actions'),
        Perk(_ignoreScenarioEffects),
      ], variant: Variant.base),
    ],
    ClassCodes.hollowpact: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 2, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +0 VOIDSIGHT $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one -2 $_earth $_card and $_two +2 $_dark $_cards',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one -2 $_stun $_card and $_one +0 VOIDSIGHT $_card',
        ),
        Perk(
          '$_replace $_one -2 $_card with $_one +0 $_disarm $_card and $_one -1 $_anyElement $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one $_rolling +1 VOID $_card and $_one $_rolling -1 $_curse $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +1 $_cards with $_one +3 "$_regenerate, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "Create a Void pit in an empty hex within $_range 2" $_card',
          quantity: 2,
        ),
        Perk(
          '$_ignoreNegativeScenarioEffectsAndAdd $_one +0 "$_ward, Self" $_card',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.mirefoot: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk(
          '$_replace $_two +0 $_cards with $_two "+X, where X is the $_poison value of the target" $_cards',
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
          '$_add four $_rolling +0 "+1 if the target occupies difficult terrain" $_cards',
        ),
        Perk(
          '$_add $_two $_rolling "$_invisible, Self, if you occupy difficult terrain" $_cards',
        ),
        Perk(
          'Gain "Poison Dagger" (Item 011). You may carry $_one additional $_oneHand item with "Dagger" in its name',
        ),
        Perk(
          'Ignore damage, $_negative conditions, and modifiers from Events, and $_removeLowercase $_one -1 $_card',
        ),
        Perk('$_ignoreNegativeScenarioEffectsAndRemove $_one -1 $_card'),
      ], variant: Variant.base),
    ],
    // May be dead Perks if Rootwhisperer has a big overhaul - this is fine
    ClassCodes.rootwhisperer: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk('$_add $_one $_rolling +2 $_card', quantity: 2),
        Perk('$_add $_one +1 $_immobilize $_card', quantity: 2),
        Perk('$_add $_two $_rolling $_poison $_cards', quantity: 2),
        Perk('$_add $_one $_rolling $_disarm $_card'),
        Perk('$_add $_one $_rolling $_heal 2 $_earth $_card', quantity: 2),
        Perk(_ignoreNegativeScenarioEffects),
      ], variant: Variant.base),
    ],
    ClassCodes.chainguard: [
      Perks([
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
          '$_add $_one +1 "Create a 2 $_damage trap in an empty hex within $_range 2" $_card',
        ),
        Perk('$_add $_two $_rolling "$_heal 1, Self" $_cards'),
        Perk('$_add $_one +2 Shackle $_card', quantity: 2),
        Perk('$_ignoreNegativeItemEffectsAndRemove $_one +0 $_card'),
      ], variant: Variant.base),
    ],
    ClassCodes.hierophant: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_two +0 $_cards with $_one $_rolling $_light $_card'),
        Perk('$_replace $_two +0 $_cards with $_one $_rolling $_earth $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_curse $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Ally" $_card',
        ),
        Perk(
          '$_replace $_one -2 $_card with $_one -1 "Give $_one Ally a \'Prayer\' ability $_card" and $_one +0 $_card',
        ),
        Perk('$_replace $_one +1 $_card with $_one +3 $_card', quantity: 2),
        Perk(
          '$_add $_two $_rolling "$_heal 1, Self or Ally" $_cards',
          quantity: 2,
        ),
        Perk('$_add $_one +1 $_wound, $_muddle $_card', quantity: 2),
        Perk('At the start of your first turn each $_scenario, gain $_bless'),
        Perk('$_ignoreNegativeScenarioEffectsAndRemove $_one +0 $_card'),
      ], variant: Variant.base),
    ],
    ClassCodes.luminary: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_ice $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_fire $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_light $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_dark $_card'),
        Perk(
          '$_replace $_one -2 $_card with $_one -2 "Perform $_one Glow ability" $_card',
        ),
        Perk('$_add $_one +0 $_anyElement $_card', quantity: 2),
        Perk('$_add $_one $_rolling +1 "$_heal 1, Self" $_card', quantity: 2),
        Perk(
          '$_add $_one "$_poison, target all enemies in the depicted LUMINARY_HEXES area" $_card',
          quantity: 2,
        ),
        Perk('$_ignoreNegativeScenarioEffectsAndRemove $_one +0 $_card'),
        Perk(
          '$_ignoreNegativeItemEffectsAndAdd $_one $_rolling "Consume_$_anyElement : $_anyElement" $_card',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.spiritCaller: [
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one -1 $_card and $_one +1 $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "+2 if a Spirit performed the attack" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_card and $_one $_rolling $_poison $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_air $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_dark $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +1 $_pierce 2 $_card'),
        Perk('$_add $_three $_rolling $_pierce 3 $_cards'),
        Perk('$_add $_one +1 $_curse $_card'),
        Perk('$_add $_one $_rolling ADD $_targetDiamond $_card'),
        Perk('$_replace $_one +1 $_card with $_one +2 $_push 2 $_card'),
        Perk('$_ignoreNegativeScenarioEffectsAndRemove $_one +0 $_card'),
      ], variant: Variant.base),
    ],
    ClassCodes.starslinger: [
      Perks([
        Perk(
          '$_replace $_two +0 $_cards with $_one $_rolling "$_heal 1, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -2 $_card with $_one -1 "$_invisible, Self" $_card',
        ),
        Perk('$_replace $_two -1 $_cards with $_one +0 $_dark $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_light $_card',
          quantity: 2,
        ),
        Perk('$_add $_one $_rolling $_loot 1 $_card'),
        Perk(
          '$_add $_one +1 "+3 if you are at full health" $_card',
          quantity: 2,
        ),
        Perk('$_add $_two $_rolling $_immobilize $_cards'),
        Perk('$_add $_one +1 "$_heal 1, $_range 3" $_card', quantity: 2),
        Perk(
          '$_add $_two $_rolling "Force the target to perform a \'$_move 1\' ability" $_cards',
        ),
        Perk('$_add $_two $_rolling "$_heal 1, $_range 1" $_cards'),
        Perk('$_ignoreNegativeScenarioEffectsAndRemove $_one +0 $_card'),
      ], variant: Variant.base),
    ],
    ClassCodes.ruinmaw: [
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one -1 $_rupture and $_wound $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_wound $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_rupture $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_add +3 instead if the target has $_rupture or $_wound" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one $_rolling "$_heal 1, Self, $_empower" $_card',
          quantity: 3,
        ),
        Perk(
          'Once each $_scenario, become SATED after collecting your 5th loot token',
        ),
        Perk(
          'Become SATED each time you lose a $_card to negate suffering damage',
        ),
        Perk(
          'Whenever $_one of your abilities causes at least $_one enemy to gain $_rupture, immediately after that ability perform "$_move 1"',
        ),
        Perk(
          '$_ignoreNegativeScenarioEffects, and $_removeLowercase $_one -1 $_card',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.drifter: [
      Perks([
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one +1 $_card with $_two +0 "Move $_one of your character tokens backward $_one slot" $_cards',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two $_pierce 3 $_rolling $_cards',
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two $_push 2 $_rolling $_cards',
        ),
        Perk('$_add $_one +3 $_card'),
        Perk('$_add $_one +2 $_immobilize $_card', quantity: 2),
        Perk('$_add $_two "$_heal 1, self" $_rolling $_cards'),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_card'),
        Perk('$_ignoreItemMinusOneEffectsAndAdd $_one +1 $_card'),
        Perk(
          '$_wheneverYouLongRest, you may move $_one of your character tokens backward $_one slot',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'You may bring $_one additional $_oneHand item into each $_scenario',
        ),
        Perk(
          'At the end of each $_scenario, you may discard up to $_two loot $_cards, except *Random Item*, to draw that many new loot $_cards',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.blinkBlade: [
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 2),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_wound $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one "Place this $_card in your active area. On your next attack, discard this $_card to $_addLowercase $_plusTwo $_attack" $_rolling $_card',
          quantity: 3,
        ),
        Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
        Perk('$_add $_one -1 "Gain $_one TIME_TOKEN" $_card', quantity: 2),
        Perk(
          '$_add $_one +2 "$_regenerate, self" $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          '$_wheneverYouShortRest, you may spend $_one unspent SPENT item for no effect to $_recover a different spent item',
        ),
        Perk(
          'At the start of your first turn each $_scenario, you may perform $_move 3',
        ),
        Perk('Whenever you would gain $_immobilize, prevent the condition'),
      ], variant: Variant.base),
    ],
    ClassCodes.bannerSpear: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_add $_plusOne $_attack for each ally adjacent to the target" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 $_disarm $_card', quantity: 2),
        Perk('$_add $_one +2 $_push 1 $_card', quantity: 2),
        Perk('$_add $_two +1 $_rolling $_cards', quantity: 2),
        Perk('$_add $_two "$_heal 1, self" $_rolling $_cards', quantity: 2),
        Perk('$_ignoreItemMinusOneEffectsAndRemove $_one -1 $_card'),
        Perk(
          'At the end of each of your long rests, grant $_one ally within $_range 3: $_move 2',
        ),
        Perk(
          'Whenever you open a door with a move ability, $_addLowercase +3 $_move',
        ),
        Perk(
          'Once each $_scenario, during your turn, gain $_shield 2 for the round',
          grouped: true,
          quantity: 2,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.deathwalker: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 $_card', quantity: 3),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_curse $_card',
          quantity: 3,
        ),
        Perk('$_add $_one +2 $_dark $_card', quantity: 2),
        Perk(
          '$_add $_one $_disarm $_rolling and $_one $_muddle $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_two "$_heal 1, $_targetCircle 1 ally" $_rolling $_cards',
          quantity: 2,
        ),
        Perk(_ignoreScenarioEffects),
        Perk('$_wheneverYouLongRest, you may move $_one SHADOW up to 3 hexes'),
        Perk(
          '$_wheneverYouShortRest, you may consume_$_dark to perform $_muddle, $_curse, $_range 2 as if you were occupying a hex with a SHADOW',
        ),
        Perk(
          'While you are occupying a hex with a SHADOW, all attacks targeting you gain disadvantage',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.boneshaper: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_curse $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_poison $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "Kill the attacking summon to instead $_addLowercase +4" $_card',
          quantity: 3,
        ),
        Perk(
          '$_add $_three "$_heal 1, $_targetCircle Boneshaper" $_rolling $_cards',
          quantity: 2,
        ),
        Perk('$_add $_one +2 $_earth/$_dark $_card', quantity: 3),
        Perk('$_ignoreScenarioEffectsAndAdd $_two +1 $_cards'),
        Perk(
          'Immediately before each of your rests, you may kill $_one of your summons to perform $_bless, self',
        ),
        Perk(
          'Once each $_scenario, when any character ally would become exhausted by suffering $_damage, you may suffer $_damage 2 to reduce their hit point value to 1 instead',
        ),
        Perk(
          'At the start of each $_scenario, you may play a level 1 $_card from your hand to perform a summon action of the $_card',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.geminate: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Consume_$_anyElement : $_anyElement" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_poison $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_wound $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two $_pierce 3 $_rolling $_cards',
        ),
        Perk('$_add $_two +1 $_push 3 $_cards'),
        Perk('$_add $_one 2x "$_brittle, self" $_card'),
        Perk('$_add $_one +1 "$_regenerate, self" $_rolling card', quantity: 2),
        Perk(_ignoreScenarioEffects),
        Perk(
          '$_wheneverYouShortRest, you may $_removeLowercase $_one $_negative condition from $_one ally within $_range 3',
        ),
        Perk(
          'Once each $_scenario, when you would give yourself a $_negative condition, prevent the condition',
        ),
        Perk(
          'Whenever you perform an action with a lost icon, you may discard $_one $_card to $_recover $_one card from your discard pile of equal or lower level',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.infuser: [
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one -1 $_card and $_one -1 $_air $_earth $_dark $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_air/$_earth $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_air/$_dark $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_earth/$_dark $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card', quantity: 2),
        Perk(
          '$_replace $_one +0 $_card with $_three "Move one waning element to strong" $_rolling $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_two "$_plusOne $_attack for each pair of active INFUSION" $_rolling $_cards',
          quantity: 2,
        ),
        Perk(_ignoreScenarioEffects),
        Perk(
          '$_ignoreItemMinusOneEffects. Whenever you become exhausted, keep all your active bonuses in play, with your summons acting on initiative 99 each round',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          '$_wheneverYouShortRest, you may Consume_$_anyElement to $_recover $_one spent $_oneHand or $_twoHand item',
        ),
        Perk(
          'Once each $_scenario, during ordering of initiative, after all ability cards have been revealed, $_anyElement',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.pyroclast: [
      Perks([
        Perk('Remove two -1 cards'),
        Perk('Remove one -2 card'),
        Perk('Replace one +0 card with one +1 $_wound card', quantity: 2),
        Perk(
          'Replace one -1 card with one +0 "Create one 1-hex hazardous terrain tile in a featureless hex adjacent to the target" card',
          quantity: 2,
        ),
        Perk(
          'Replace two +0 cards with two $_push 2 $_rolling cards',
          quantity: 2,
        ),
        Perk('Replace two +1 cards with two +2 cards'),
        Perk('Add two +1 $_fire/$_earth cards', quantity: 2),
        Perk('Add two +1 $_muddle $_rolling cards'),
        Perk(_ignoreScenarioEffects),
        Perk(
          '$_wheneverYouLongRest, you may destroy one adjacent obstacle to gain $_ward',
        ),
        Perk(
          '$_wheneverYouShortRest, you may consume_$_fire to perform $_wound, $_targetCircle 1 enemy occupying or adjacent to hazardous terrain',
        ),
        Perk(
          'You and all allies are unaffected by hazardous terrain you create',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.shattersong: [
      Perks([
        Perk('Remove four +0 cards'),
        Perk(
          'Replace two -1 cards with two +0 "Reveal the top card of the target\'s monster ability deck" cards',
          quantity: 2,
        ),
        Perk('Replace one -2 card with one -1 $_stun card'),
        Perk('Replace one +0 card with one +0 $_brittle card', quantity: 2),
        Perk(
          'Replace two +1 cards with two +2 $_air/$_light cards',
          quantity: 2,
        ),
        Perk(
          'Add one "$_heal 2, $_bless, $_targetCircle 1 ally" $_rolling card',
          quantity: 2,
        ),
        Perk('Add one +1 "Gain 1 RESONANCE" card', quantity: 3),
        Perk(_ignoreScenarioEffects),
        Perk(
          '$_wheneverYouShortRest, you may consume_$_air to perform $_strengthen, $_range 3 and consume_$_light to perform $_bless, $_range 3',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          '$_atTheStartOfEachScenario, you may gain $_brittle to gain 2 RESONANCE',
        ),
        Perk(
          'Whenever a new room is revealed, you may reveal the top card of both the monster attack modifier deck and all allies\' attack modifier decks',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.trapper: [
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Create $_one $_heal 2 trap in an empty hex adjacent to the target" card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Create $_one $_damage 1 trap in an empty hex adjacent to the target" card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two +0 "Add $_damage 2 or $_heal 2 to a trap within $_range 2 of you" $_cards',
          quantity: 3,
        ),
        Perk(
          '$_replace $_two +1 $_cards with $_two +2 $_immobilize $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_two "Add $_push 2 or $_pull 2" $_rolling $_cards',
          quantity: 3,
        ),
        Perk(_ignoreScenarioEffects),
        Perk(
          '$_wheneverYouLongRest, you may create $_one $_damage 1 trap in an adjacent empty hex',
        ),
        Perk(
          'Whenever you enter a hex with a trap, you may choose to not spring the trap',
        ),
        Perk(
          '$_atTheStartOfEachScenario, you may create $_one $_damage 2 trap in an adjacent empty hex',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.painConduit: [
      Perks([
        Perk('$_remove $_two -1 $_cards', quantity: 2),
        Perk('$_replace $_one -2 $_card with $_one -2 $_curse $_curse $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 $_disarm $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_fire/$_air $_card',
          quantity: 3,
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
        Perk('$_replace $_three +1 $_cards with $_three +1 $_curse $_cards'),
        Perk('$_add $_three "$_heal 1, self" $_rolling $_cards', quantity: 2),
        Perk(
          '$_add $_one +0 "Add $_plusOne $_attack for each negative condition you have" $_card',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndAdd $_two +1 $_cards'),
        Perk(
          'Each round in which you long rest, you may ignore all negative conditions you have. If you do, they cannot be removed that round',
        ),
        Perk(
          'Whenever you become exhausted, first perform $_curse, $_targetCircle all, $_range 3',
        ),
        Perk(
          'Increase your maximum hit point value by 5',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.snowdancer: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_heal 1, $_targetCircle 1 ally" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_immobilize $_card',
          quantity: 2,
        ),
        Perk('$_add $_two +1 $_ice/$_air $_cards', quantity: 2),
        Perk(
          '$_replace $_two +0 $_cards with $_two "If this action forces the target to move, it suffers $_damage 1" $_rolling $_cards',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_strengthen, $_targetCircle 1 ally" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one "$_heal 1, $_ward, $_targetCircle 1 ally" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_wheneverYouLongRest, you may $_ice/$_air'),
        Perk(
          '$_wheneverYouShortRest, you may consume_$_ice to perform $_regenerate, $_range 3 and consume_$_air to perform $_ward, $_range 3',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          '$_atTheStartOfEachScenario, all enemies gain $_muddle. Whenever a new room is revealed, all enemies in the newly revealed room gain $_muddle',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.frozenFist: [
      Perks([
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
          '$_replace $_one +0 $_card with $_one +1 $_ice/$_earth $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 "Create $_one 1-hex icy terrain tile in a featureless hex adjacent to the target" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +3 $_card'),
        Perk('$_add $_two "$_heal 1, self" $_rolling $_cards', quantity: 3),
        Perk(
          '$_ignoreItemMinusOneEffects, and, whenever you enter icy terrain with a move ability, you may ignore the effect to add $_plusOne $_move',
        ),
        Perk(
          'Whenever you heal from a long rest, you may consume_$_ice/$_earth to add $_plusTwo $_heal',
        ),
        Perk(
          '$_onceEachScenario, when you would suffer $_damage, you may negate the $_damage',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.hive: [
      Perks([
        Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "After this attack ability, grant one of your summons: $_move 2" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "After this attack ability, TRANSFER" $_card',
          quantity: 3,
        ),
        Perk('$_add $_one +1 "$_heal 1, self" $_card', quantity: 3),
        Perk('$_add $_one +2 $_muddle $_card', quantity: 2),
        Perk('$_add $_two $_poison $_rolling $_cards'),
        Perk('$_add $_two $_wound $_rolling $_cards'),
        Perk(
          '$_wheneverYouLongRest, you may do so on any initiative value, choosing your initiative after all ability cards have been revealed, and you decide how your summons perform their abilities for the round',
          quantity: 2,
          grouped: true,
        ),
        Perk('At the end of each of your short rests, you may TRANSFER'),
        Perk('Whenever you would gain $_wound, prevent the condition'),
      ], variant: Variant.base),
    ],
    ClassCodes.metalMosaic: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "PRESSURE_GAIN or PRESSURE_LOSE" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +0 "The target and all enemies adjacent to it suffer $_damage 1" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one $_pierce 3 $_rolling and $_one "$_retaliate 2" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +1 "$_heal 2, self" $_card', quantity: 2),
        Perk('$_add $_one +3 $_card'),
        Perk('$_ignoreItemMinusOneEffectsAndAdd two +1 $_cards'),
        Perk('$_wheneverYouLongRest, you may PRESSURE_GAIN or PRESSURE_LOSE'),
        Perk(
          'Whenever you would gain $_poison, you may suffer $_damage 1 to prevent the condition',
        ),
        Perk(
          '$_onceEachScenario, when you would become exhausted, instead gain $_stun and $_invisible, lose all your cards, $_recover four lost cards, and then discard the recovered cards',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.deepwraith: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_one -1 card with one +0 $_disarm card', quantity: 2),
        Perk('Replace one -2 card with one -1 $_stun card'),
        Perk(
          'Replace one +0 card with one +0 "$_invisible, self" card',
          quantity: 2,
        ),
        Perk('Replace two +0 cards with two $_pierce 3 $_rolling cards'),
        Perk('Replace two +1 cards with two +2 cards'),
        Perk('Replace three +1 cards with three +1 $_curse cards'),
        Perk('Add two +1 "Gain 1 TROPHY" cards', quantity: 3),
        Perk('$_ignoreScenarioEffectsAndRemove two +0 cards'),
        Perk(
          '$_wheneverYouLongRest, you may $_loot one adjacent hex. If you gain any loot tokens, gain 1 TROPHY',
        ),
        Perk('$_atTheStartOfEachScenario, gain 2 TROPHY'),
        Perk(
          'While you have $_invisible, gain advantage on all your attacks',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.crashingTide: [
      Perks([
        Perk(
          'Replace one -1 card with two $_pierce 3 $_rolling cards',
          quantity: 2,
        ),
        Perk(
          'Replace one -1 card with one +0 "$_plusOne $_targetCircle" card',
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
        Perk('Add one +2 $_muddle card', quantity: 2),
        Perk('Add one +1 $_disarm card'),
        Perk('Add two "$_heal 1, self" $_rolling cards', quantity: 2),
        Perk(
          '$_ignoreItemMinusOneEffects, and, whenever you would gain $_impair, prevent the condition',
        ),
        Perk(
          'Whenever you declare a long rest during card selection, gain $_shield 1 for the round',
        ),
        Perk(
          'Gain advantage on all your attacks performed while occupying or targeting enemies occupying water hexes',
          quantity: 3,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.anaphi: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_poison $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "Add $_plusOne $_attack when drawn by a summon" $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +0 $_stun $_card'),
        Perk(
          '$_replace $_one +1 $_card with $_one +1 "$_invisible, self" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +2 $_air/$_dark $_card', quantity: 3),
        Perk(
          '$_add $_one +2 "$_strengthen, $_targetCircle 1 of your summons" $_card',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndRemove $_one +0 $_card'),
        Perk('$_wheneverYouLongRest, you may $_air/$_dark'),
        Perk(
          '$_onceEachScenario, during your turn, all enemies adjacent to a wall suffer $_damage 1',
        ),
        Perk(
          'At the start of the first round of each $_scenario, after all ability cards have been revealed, control one enemy within $_range 5: $_move 2',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.cassandra: [
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk('$_remove $_two -1 $_cards'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_bless, $_targetCircle self or 1 ally" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 "Add $_plusOne $_attack if the top card of the monster attack modifier deck is revealed" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 $_light/$_dark $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +1 "Place this card in your active area. When you next place a $_rift, discard this card to place another $_rift within $_range 1 of it" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndAdd $_two +1 $_cards'),
        Perk(
          '$_wheneverYouLongRest, you may read one unread $_scenarioIcon from the current $_scenario\'s "Section Links"',
        ),
        Perk(
          'Whenever you place a $_rift, you may perform "$_pull 1, $_targetCircle 1 ally or enemy, $_range 1" as if you occupied a hex containing a $_rift',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'Whenever a deck is shuffled, you may set aside all revealed cards from that deck and place them back on top after shuffling',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.hail: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_wound or $_immobilize $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_anyElement $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 $_poison or $_muddle $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_heal 1, $_targetCircle 1 ally" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
        Perk('$_add $_one +1 $_stun $_card', quantity: 2),
        Perk(
          '$_add $_one +3 "$_safeguard, $_targetCircle 1 ally" $_card',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndAdd $_two +1 $_cards'),
        Perk('$_wheneverYouShortRest, you may choose which $_card to lose'),
        Perk(
          'Your and your allies\' enhancements cost five gold less and whenever an ally enhances a $_card, you gain five gold',
        ),
        Perk(
          '$_add $_one +1 "$_hail gains 1 $_resolve" $_card to the monster attack modifier deck',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.satha: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_ice $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "$_heal 1, $_targetCircle 1 ally and self" $_card',
          quantity: 2,
        ),
        Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
        Perk(
          '$_add $_one +0 "Grant one ally within $_range 3: $_attack 2 $_range 3 or $_attack 3" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one $_disarm $_rolling and $_one +0 "Grant one ally within $_range 3: $_move 2" $_rolling $_card',
          quantity: 2,
        ),
        Perk('$_add $_two "$_ward, $_range 1" $_rolling $_cards', quantity: 2),
        Perk(
          '$_ignoreItemMinusOneEffects and whenever you would gain $_stun, prevent the condition',
        ),
        Perk(
          '$_wheneverYouLongRest, perform: $_strengthen, $_targetCircle 1 ally, $_range 3',
        ),
        Perk('All initiative values may be discussed freely and precisely'),
        Perk(
          'The first time each $_scenario that you or an ally exhaust, perform: $_heal 3, $_targetCircle all, $_ward, $_strengthen',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.thornreaper: [
      Perks([
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
          '$_add $_three $_rolling "$_earth if $_light is Strong or Waning" $_cards',
        ),
        Perk(
          '$_add $_one "Create hazardous terrain in $_one hex within $_range 1" $_card',
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
          '$_ignoreNegativeItemEffectsAndAdd $_one $_rolling "+1 if $_light is Strong or Waning" $_card',
        ),
        Perk(
          'Gain $_shield 1 while you occupy hazardous terrain',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.incarnate: [
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one $_rolling ALL_STANCES $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one $_rolling $_pierce 2, $_fire $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one $_rolling "$_shield 1, Self, $_earth" $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one $_rolling $_push 1, $_air $_card',
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_ritualist : $_enfeeble / $_conqueror : $_empower, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_reaver : $_rupture / $_conqueror : $_empower, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_reaver : $_rupture / $_ritualist : $_enfeeble" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one $_rolling "$_recover $_one $_oneHand or $_twoHand item" $_card',
        ),
        Perk('Each time you long rest, perform: ALL_STANCES'),
        Perk(
          'You may bring one additional $_oneHand item into each $_scenario',
        ),
        Perk('Each time you short rest, $_recover one spent $_oneHand item'),
        Perk('$_ignoreNegativeItemEffectsAndRemove one -1 $_card'),
      ], variant: Variant.base),
      Perks([
        Perk(
          '$_replace $_one -2 $_card with $_one +0 $_reaver $_ritualist $_conqueror $_rolling $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_pierce 2 $_fire $_rolling $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_push 1 $_air $_rolling $_card',
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "$_shield 1" $_earth $_rolling $_card',
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_reaver : $_rupture or $_ritualist : $_enfeeble" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_reaver : $_rupture or $_conqueror : $_empower, self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_ritualist : $_enfeeble or $_conqueror : $_empower, self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +0 "$_recover one $_oneHand or $_twoHand item" $_rolling $_card',
        ),
        Perk('$_ignoreItemMinusOneEffectsAndRemove $_one -1 $_card'),
        Perk(
          '**Eyes of the Ritualist:** $_wheneverYouLongRest, perform $_reaver $_ritualist $_conqueror',
        ),
        Perk(
          '**Hands of the Reaver:** $_wheneverYouShortRest, $_recover one spent $_oneHand item',
        ),
        Perk(
          '**Shoulders of the Conqueror:** You may bring one additional $_oneHand item into each $_scenario',
        ),
      ], variant: Variant.frosthavenCrossover),
    ],

    ClassCodes.rimehearth: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one $_rolling $_wound $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one $_rolling "$_heal 3, $_wound, Self" $_card',
        ),
        Perk('$_replace $_two +0 $_cards with $_two $_rolling $_fire $_cards'),
        Perk(
          '$_replace $_three +1 $_cards with $_one $_rolling +1 card, $_one +1 $_wound $_card, and $_one +1 "$_heal 1, Self" $_card',
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_ice $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 CHILL $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +2 $_card with $_one +3 CHILL $_card'),
        Perk('$_add $_one +2 $_fire/$_ice $_card', quantity: 2),
        Perk('$_add $_one +0 $_brittle $_card'),
        Perk(
          'At the start of each $_scenario, you may either gain $_wound to generate $_fire or gain CHILL to generate $_ice',
        ),
        Perk(
          '$_ignoreNegativeItemEffectsAndAdd $_one $_rolling $_fire/$_ice $_card',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.shardrender: [
      Perks([
        Perk('Remove one -2 card'),
        Perk('$_replace $_one -1 $_card with $_one +1 card', quantity: 2),
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
          'Add two +1 "+2 instead if you CRYSTALLIZE PERSIST one space" cards',
        ),
        Perk('Add one +0 $_brittle card'),
        Perk(
          '$_ignoreNegativeItemEffects and at the start of each scenario, you may play a level 1 card from your hand to perform a CRYSTALLIZE action of the card',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          '$_onceEachScenario, when you would suffer damage from an attack, gain "$_shield 3" for that attack',
        ),
        Perk('Each time you long rest, perform "$_regenerate, Self"'),
      ], variant: Variant.base),
    ],
    ClassCodes.tempest: [
      Perks([
        Perk('Replace one -2 card with one -1 $_air/$_light card'),
        Perk(
          'Replace one -1 $_air/$_light card with one +1 $_air/$_light card',
        ),
        Perk('Replace one -1 card with one +0 $_wound card', quantity: 2),
        Perk(
          '$_replace one -1 card with one $_rolling "$_regenerate, $_range 1" card',
          quantity: 2,
        ),
        Perk('Replace one +0 card with one +2 $_muddle card'),
        Perk('Replace two +0 cards with one +1 $_immobilize card'),
        Perk('Add one +1 "DODGE, Self" card', quantity: 2),
        Perk('Add one +2 $_air/$_light card'),
        Perk('Whenever you dodge an attack, gain one SPARK'),
        Perk(
          '$_wheneverYouLongRest, you may gain DODGE',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          '$_wheneverYouShortRest, you may consume_SPARK one Spark. If you do, one enemy within $_range 2 suffers one damage',
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.vanquisher: [
      Perks([
        Perk('Replace two -1 cards with one +0 $_muddle card'),
        Perk('Replace two -1 cards with one -1 "$_heal 2, Self" card'),
        Perk('Replace one -2 card with one -1 $_poison $_wound card'),
        Perk(
          '$_replace one +0 card with one +1 "$_heal 1, Self" card',
          quantity: 2,
        ),
        Perk(
          'Replace two +0 cards with one +0 $_curse card and one +0 $_immobilize card',
        ),
        Perk('Replace one +1 card with one +2 $_fire/$_air card', quantity: 2),
        Perk('Replace one +2 card with one $_rolling "Gain one RAGE" card'),
        Perk(
          'Add one +1 "$_retaliate 1, Self" card and one $_rolling $_pierce 3 card',
          quantity: 2,
        ),
        Perk('Add one +0 "$_bless, Self" card'),
        Perk('Add two +1 "+2 instead if you suffer 1 damage" cards'),
        Perk('Add one +2 "+3 instead if you suffer 1 damage" card'),
        Perk('$_ignoreNegativeItemEffectsAndRemove one -1 card'),
      ], variant: Variant.base),
    ],
    ClassCodes.dome: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_strengthen $_targetCircle 1 ally $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Grant the ally with $_project : $_attack 2" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +0 "Place this card in your active area. On your next attack granting ability, discard this card to add $_plusTwo $_attack" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two +0 $_pierce 3 $_rolling $_cards',
        ),
        Perk('$_add $_three $_barrierPlus 1 $_rolling $_cards', quantity: 2),
        Perk('$_add $_one +2 $_light $_card', quantity: 2),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_regenerate, self" $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          'Your summons gain $_retaliate 1. Whenever one of your summons dies, perform: $_barrierPlus 3',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          'At the end of each of your rests, perform: $_barrierPlus 1 and $_project $_range 4',
        ),
        Perk(
          '$_onceEachScenario, at the end of an ally\'s turn, perform: $_barrierPlus 5 and $_project, $_targetCircle that ally',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
    ClassCodes.skitterclaw: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 $_immobilize $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "After the attack ability, grant one of your summons: $_move 2" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "If the target is Latched, +2 instead" $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +1 $_poison $_card'),
        Perk(
          '$_add $_two "$_heal 1, $_targetCircle 1 ally." $_rolling $_cards',
        ),
        Perk(
          '$_add $_one +1 "All Latched enemies suffer $_damage 1" $_card',
          quantity: 2,
        ),
        Perk('$_ignoreScenarioEffectsAndAdd $_one +1 $_card'),
        Perk('You may summon $_critters summons in adjacent occupied hexes'),
        Perk(
          '$_oncePerScenario, when you or an ally would suffer $_damage from an attack, $_removeLowercase a Latched summon from the attacker or the target to negate the damage instead',
          quantity: 2,
          grouped: true,
        ),
        Perk(
          '$_atTheStartOfEachScenario, you may play a card from your hand to perform a summon action of the card',
          quantity: 2,
          grouped: true,
        ),
      ], variant: Variant.base),
    ],
  };
  // Private constructor to prevent instantiation
  const PerksRepository._();
}
