import 'package:gloomhaven_enhancement_calc/models/mastery.dart';

import '../models/goal.dart';
import '../models/perk.dart';
import '../models/personal_goal.dart';
import '../models/player_class.dart';
import '../models/resource.dart';

enum ClassCategory {
  gloomhaven,
  jawsOfTheLion,
  frosthaven,
  crimsonScales,
  custom,
}

abstract class CharacterData {
  static const _aesther = 'Aesther';
  static const _harrower = 'Harrower';
  static const _human = 'Human';
  static const _inox = 'Inox';
  static const _lurker = 'Lurker';
  static const _orchid = 'Orchid';
  static const _quatryl = 'Quatryl';
  static const _savvas = 'Savvas';
  static const _valrath = 'Valrath';
  static const _vermling = 'Vermling';
  static const _algox = 'Algox';
  static const _unfettered = 'Unfettered';

  static const _one = 'one';
  static const _two = 'two';
  static const _three = 'three';
  static const _four = 'four';
  static const _card = 'card';
  static const _cards = 'cards';
  static const _add = 'Add';
  static const _addL = 'add';
  static const _removeL = 'remove';
  static const _remove = 'Remove';
  static const _replace = 'Replace';
  static const _rolling = 'Rolling';
  static const _negative = 'negative';
  static const _scenario = 'scenario';
  static const _effects = 'effects';

  static const _brute = 'br';
  static const _tinkerer = 'ti';
  static const _spellweaver = 'sw';
  static const _scoundrel = 'sc';
  static const _cragheart = 'ch';
  static const _mindthief = 'mt';
  static const _sunkeeper = 'sk';
  static const _quartermaster = 'qm';
  static const _summoner = 'su';
  static const _nightshround = 'ns';
  static const _plagueherald = 'ph';
  static const _berserker = 'be';
  static const _soothsinger = 'ss';
  static const _doomstalker = 'ds';
  static const _sawbones = 'sb';
  static const _elementalist = 'el';
  static const _beastTyrant = 'bt';
  static const _bladeswarm = 'bs';
  static const _diviner = 'dv';
  static const _demolitionist = 'dl';
  static const _hatchet = 'hc';
  static const _redGuard = 'rg';
  static const _voidwarden = 'vw';

  static final List<PlayerClass> playerClasses = [
    PlayerClass(
      race: _inox,
      className: 'Brute',
      classCode: _brute,
      classIconUrl: 'brute.svg',
      locked: false,
      classColor: '0xff4e7ec1',
    ),
    PlayerClass(
      race: _quatryl,
      className: 'Tinkerer',
      classCode: _tinkerer,
      classIconUrl: 'tinkerer.svg',
      locked: false,
      classColor: '0xffc5b58d',
    ),
    PlayerClass(
      race: _orchid,
      className: 'Spellweaver',
      classCode: _spellweaver,
      classIconUrl: 'spellweaver.svg',
      locked: false,
      classColor: '0xffb578b3',
    ),
    PlayerClass(
      race: _human,
      className: 'Scoundrel',
      classCode: _scoundrel,
      classIconUrl: 'scoundrel.svg',
      locked: false,
      classColor: '0xffa5d166',
    ),
    PlayerClass(
      race: _savvas,
      className: 'Cragheart',
      classCode: _cragheart,
      classIconUrl: 'cragheart.svg',
      locked: false,
      classColor: '0xff899538',
    ),
    PlayerClass(
      race: _vermling,
      className: 'Mindthief',
      classCode: _mindthief,
      classIconUrl: 'mindthief.svg',
      locked: false,
      classColor: '0xff647c9d',
    ),
    PlayerClass(
      race: _valrath,
      className: 'Sunkeeper',
      classCode: _sunkeeper,
      classIconUrl: 'sunkeeper.svg',
      classColor: '0xfff3c338',
    ),
    PlayerClass(
      race: _valrath,
      className: 'Quartermaster',
      classCode: _quartermaster,
      classIconUrl: 'quartermaster.svg',
      classColor: '0xffd98926',
    ),
    PlayerClass(
      race: _aesther,
      className: 'Summoner',
      classCode: _summoner,
      classIconUrl: 'summoner.svg',
      classColor: '0xffeb6ea3',
    ),
    PlayerClass(
      race: _aesther,
      className: 'Nightshroud',
      classCode: _nightshround,
      classIconUrl: 'nightshroud.svg',
      classColor: '0xff9f9fcf',
    ),
    PlayerClass(
      race: _harrower,
      className: 'Plagueherald',
      classCode: _plagueherald,
      classIconUrl: 'plagueherald.svg',
      classColor: '0xff74c7bb',
    ),
    PlayerClass(
      race: _inox,
      className: 'Berserker',
      classCode: _berserker,
      classIconUrl: 'berserker.svg',
      classColor: '0xffd14e4e',
    ),
    PlayerClass(
      race: _quatryl,
      className: 'Soothsinger',
      classCode: _soothsinger,
      classIconUrl: 'soothsinger.svg',
      classColor: '0xffdf7e7a',
    ),
    PlayerClass(
      race: _orchid,
      className: 'Doomstalker',
      classCode: _doomstalker,
      classIconUrl: 'doomstalker.svg',
      classColor: '0xff38c3f1',
    ),
    PlayerClass(
      race: _human,
      className: 'Sawbones',
      classCode: _sawbones,
      classIconUrl: 'sawbones.svg',
      classColor: '0xffdfddcb',
    ),
    PlayerClass(
      race: _savvas,
      className: 'Elementalist',
      classCode: _elementalist,
      classIconUrl: 'elementalist.svg',
      classColor: '0xff9e9d9d',
    ),
    PlayerClass(
      race: _vermling,
      className: 'Beast Tyrant',
      classCode: _beastTyrant,
      classIconUrl: 'beast_tyrant.svg',
      classColor: '0xffad745c',
    ),
    // ENVELOPE X
    PlayerClass(
      race: _harrower,
      className: 'Bladeswarm',
      classCode: _bladeswarm,
      classIconUrl: 'bladeswarm.svg',
      locked: false,
      classColor: '0xffae5a4d',
    ),
    // FORGOTTEN CIRCLES
    PlayerClass(
      race: _aesther,
      className: 'Diviner',
      classCode: _diviner,
      classIconUrl: 'diviner.svg',
      classCategory: ClassCategory.gloomhaven,
      locked: false,
      classColor: '0xff8bc5d3',
    ),
    // JAWS OF THE LION
    PlayerClass(
      race: _quatryl,
      className: 'Demolitionist',
      classCode: _demolitionist,
      classIconUrl: 'demolitionist.svg',
      classCategory: ClassCategory.jawsOfTheLion,
      locked: false,
      classColor: '0xffe65c18',
    ),
    PlayerClass(
      race: _inox,
      className: 'Hatchet',
      classCode: _hatchet,
      classIconUrl: 'hatchet.svg',
      classCategory: ClassCategory.jawsOfTheLion,
      locked: false,
      classColor: '0xff78a1ad',
    ),
    PlayerClass(
      race: _valrath,
      className: 'Red Guard',
      classCode: _redGuard,
      classIconUrl: 'red_guard.svg',
      classCategory: ClassCategory.jawsOfTheLion,
      locked: false,
      classColor: '0xffe3393b',
    ),
    PlayerClass(
      race: _human,
      className: 'Voidwarden',
      classCode: _voidwarden,
      classIconUrl: 'voidwarden.svg',
      classCategory: ClassCategory.jawsOfTheLion,
      locked: false,
      classColor: '0xffd9d9d9',
    ),
    // FROSTHAVEN
    PlayerClass(
      race: _inox,
      className: 'Drifter',
      classCode: 'drifter',
      classIconUrl: 'drifter.svg',
      classCategory: ClassCategory.frosthaven,
      locked: false,
      classColor: '0xff92887f',
    ),
    PlayerClass(
      race: _quatryl,
      className: 'Blink Blade',
      classCode: 'blinkblade',
      classIconUrl: 'blink_blade.svg',
      classCategory: ClassCategory.frosthaven,
      locked: false,
      classColor: '0xff00a8cf',
    ),
    PlayerClass(
      race: _human,
      className: 'Banner Spear',
      classCode: 'bannerspear',
      classIconUrl: 'banner_spear.svg',
      classCategory: ClassCategory.frosthaven,
      locked: false,
      classColor: '0xfffdd072',
    ),
    PlayerClass(
      race: _valrath,
      className: 'Deathwalker',
      classCode: 'deathwalker',
      classIconUrl: 'deathwalker.svg',
      classCategory: ClassCategory.frosthaven,
      locked: false,
      classColor: '0xffacc8ed',
    ),
    PlayerClass(
      race: _aesther,
      className: 'Boneshaper',
      classCode: 'boneshaper',
      classIconUrl: 'boneshaper.svg',
      classCategory: ClassCategory.frosthaven,
      locked: false,
      classColor: '0xff6cbe4c',
    ),
    PlayerClass(
      race: _harrower,
      className: 'Geminate',
      classCode: 'geminate',
      classIconUrl: 'geminate.svg',
      classCategory: ClassCategory.frosthaven,
      locked: false,
      classColor: '0xffab1c54',
    ),
    PlayerClass(
      race: _orchid,
      className: 'Infuser',
      classCode: 'infuser',
      classIconUrl: 'infuser.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xff7bc144',
    ),
    PlayerClass(
      race: _savvas,
      className: 'Pyroclast',
      classCode: 'pyroclast',
      classIconUrl: 'pyroclast.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xffff4a1d',
    ),
    PlayerClass(
      race: _savvas,
      className: 'Shattersong',
      classCode: 'shattersong',
      classIconUrl: 'shattersong.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xffc2c5c9',
    ),
    PlayerClass(
      race: _vermling,
      className: 'Trapper',
      classCode: 'trapper',
      classIconUrl: 'trapper.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xffd1b38d',
    ),
    PlayerClass(
      race: _aesther,
      className: 'Pain Conduit',
      classCode: 'painconduit',
      classIconUrl: 'pain_conduit.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xffbec5e4',
    ),
    PlayerClass(
      race: _algox,
      className: 'Snowdancer',
      classCode: 'snowdancer',
      classIconUrl: 'snowdancer.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xff7cd1e7',
    ),
    PlayerClass(
      race: _algox,
      className: 'Frozen Fist',
      classCode: 'frozenfist',
      classIconUrl: 'frozen_fist.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xff88bee7',
    ),
    PlayerClass(
      race: _unfettered,
      className: 'HIVE',
      classCode: 'hive',
      classIconUrl: 'hive.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xffecb633',
    ),
    PlayerClass(
      race: _unfettered,
      className: 'Metal Mosaic',
      classCode: 'metalmosaic',
      classIconUrl: 'metal_mosaic.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xffddb586',
    ),
    PlayerClass(
      race: _lurker,
      className: 'Deepwraith',
      classCode: 'deepwraith',
      classIconUrl: 'deepwraith.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xffac427d',
    ),
    PlayerClass(
      race: _lurker,
      className: 'Crashing Tide',
      classCode: 'crashingtide',
      classIconUrl: 'crashing_tide.svg',
      classCategory: ClassCategory.frosthaven,
      locked: true,
      classColor: '0xff59c0a1',
    ),
    // CRIMSON SCALES
    PlayerClass(
      race: _quatryl,
      className: 'Bombard',
      classCode: 'bb',
      classIconUrl: 'bombard.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xff948572',
    ),
    PlayerClass(
      race: _human,
      className: 'Brightspark',
      classCode: 'bp',
      classIconUrl: 'brightspark.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xffcaad2e',
    ),
    PlayerClass(
      race: _inox,
      className: 'Chainguard',
      classCode: 'cg',
      classIconUrl: 'chainguard.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xffce6d30',
    ),
    PlayerClass(
      race: _orchid,
      className: 'Chieftain',
      classCode: 'ct',
      classIconUrl: 'chieftain.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xff76c6c3',
    ),
    PlayerClass(
      race: _valrath,
      className: 'Fire Knight',
      classCode: 'fk',
      classIconUrl: 'fire_knight.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xffd52229',
    ),
    PlayerClass(
      race: _human,
      className: 'Hierophant',
      classCode: 'hf',
      classIconUrl: 'hierophant.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xffddde8a',
    ),
    PlayerClass(
      race: _savvas,
      className: 'Hollowpact',
      classCode: 'hp',
      classIconUrl: 'hollowpact.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xffa765a9',
    ),
    PlayerClass(
      race: _lurker,
      className: 'Luminary',
      classCode: 'ln',
      classIconUrl: 'luminary.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xffb28abf',
    ),
    PlayerClass(
      race: _quatryl,
      className: 'Mirefoot',
      classCode: 'mf',
      classIconUrl: 'mirefoot.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xffef6b26',
    ),
    PlayerClass(
      race: _vermling,
      className: 'Spirit Caller',
      classCode: 'scr',
      classIconUrl: 'spirit_caller.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xff63bd57',
    ),
    PlayerClass(
      race: _aesther,
      className: 'Starslinger',
      classCode: 'ssl',
      classIconUrl: 'starslinger.svg',
      classCategory: ClassCategory.crimsonScales,
      classColor: '0xff4f57a6',
    ),
    //CUSTOM
    PlayerClass(
      race: _harrower,
      className: 'Amber Aegis',
      classCode: 'aa',
      classIconUrl: 'amber_aegis.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xfff6831f',
    ),
    PlayerClass(
      race: _quatryl,
      className: 'Artificer',
      classCode: 'af',
      classIconUrl: 'artificer.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xff317da7',
    ),
    PlayerClass(
      race: _orchid,
      className: 'Brewmaster',
      classCode: 'bm',
      classIconUrl: 'brewmaster.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xffe2c22b',
    ),
    PlayerClass(
      race: _orchid,
      className: 'Frostborn',
      classCode: 'fb',
      classIconUrl: 'frostborn.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xffb0e0ea',
    ),
    PlayerClass(
      race: _human,
      className: 'Rootwhisperer',
      classCode: 'rw',
      classIconUrl: 'rootwhisperer.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xff7bd071',
    ),
    PlayerClass(
      race: _vermling,
      className: 'Ruinmaw',
      classCode: 'rm',
      classIconUrl: 'ruinmaw.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xffdb332d',
    ),
    PlayerClass(
      race: _orchid,
      className: 'Thornreaper',
      classCode: 'thornreaper',
      classIconUrl: 'thornreaper.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xffc3d678',
    ),
    PlayerClass(
      race: _inox,
      className: 'Incarnate',
      classCode: 'incarnate',
      classIconUrl: 'incarnate.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xffcb4a77',
    ),
    PlayerClass(
      race: _savvas,
      className: 'Rimehearth',
      classCode: 'rimehearth',
      classIconUrl: 'rimehearth.svg',
      classCategory: ClassCategory.custom,
      classColor: '0xff61d4e8',
    ),
  ];

  static PlayerClass playerClassByClassCode(String classCode) =>
      playerClasses.firstWhere(
        (playerClass) => playerClass.classCode == classCode,
      );

  static final Map<int, int> levelXp = {
    1: 0,
    2: 45,
    3: 95,
    4: 150,
    5: 210,
    6: 275,
    7: 345,
    8: 420,
    9: 500
  };

  static final List<Perk> perks = [
    // BRUTE
    Perk(_brute, 1, '$_remove $_two -1 $_cards'),
    Perk(_brute, 1, '$_remove $_one -1 $_card and $_addL $_one +1 $_card'),
    Perk(_brute, 2, '$_add $_two +1 $_cards'),
    Perk(_brute, 1, '$_add $_one +3 $_card'),
    Perk(_brute, 2, '$_add $_three $_rolling PUSH 1 $_cards'),
    Perk(_brute, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    Perk(_brute, 2, '$_add $_one $_rolling STUN $_card'),
    Perk(_brute, 1,
        '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
    Perk(_brute, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    Perk(_brute, 1, '$_add $_one +1 "SHIELD 1, Self" $_card'),
    Perk(_brute, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    // TINKERER
    Perk(_tinkerer, 2, '$_remove $_two -1 $_cards'),
    Perk(_tinkerer, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk(_tinkerer, 1, '$_add $_two +1 $_cards'),
    Perk(_tinkerer, 1, '$_add $_one +3 $_card'),
    Perk(_tinkerer, 1, '$_add $_two $_rolling FIRE $_cards'),
    Perk(_tinkerer, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    Perk(_tinkerer, 2, '$_add $_one +1 WOUND $_card'),
    Perk(_tinkerer, 2, '$_add $_one +1 IMMOBILIZE $_card'),
    Perk(_tinkerer, 2, '$_add $_one +1 HEAL 2 $_card'),
    Perk(_tinkerer, 1, '$_add $_one +0 ADD TARGET $_card'),
    Perk(_tinkerer, 1, 'Ignore $_negative $_scenario $_effects'),
    // SPELLWEAVER
    Perk(_spellweaver, 1, '$_remove four +0 $_cards'),
    Perk(_spellweaver, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_spellweaver, 2, '$_add $_two +1 $_cards'),
    Perk(_spellweaver, 1, '$_add $_one +0 STUN $_card'),
    Perk(_spellweaver, 1, '$_add $_one +1 WOUND $_card'),
    Perk(_spellweaver, 1, '$_add $_one +1 IMMOBILIZE $_card'),
    Perk(_spellweaver, 1, '$_add $_one +1 CURSE $_card'),
    Perk(_spellweaver, 2, '$_add $_one +2 FIRE $_card'),
    Perk(_spellweaver, 2, '$_add $_one +2 ICE $_card'),
    Perk(_spellweaver, 1,
        '$_add $_one $_rolling EARTH and $_one $_rolling AIR $_card'),
    Perk(_spellweaver, 1,
        '$_add $_one $_rolling LIGHT and $_one $_rolling DARK $_card'),
    // SCOUNDREL
    Perk(_scoundrel, 2, '$_remove $_two -1 $_cards'),
    Perk(_scoundrel, 1, '$_remove four +0 $_cards'),
    Perk(_scoundrel, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk(_scoundrel, 1, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_scoundrel, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk(_scoundrel, 2, '$_add $_two $_rolling +1 $_cards'),
    Perk(_scoundrel, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    Perk(_scoundrel, 2, '$_add $_two $_rolling POISON $_cards'),
    Perk(_scoundrel, 1, '$_add $_two $_rolling MUDDLE $_cards'),
    Perk(_scoundrel, 1, '$_add $_one $_rolling INVISIBLE $_card'),
    Perk(_scoundrel, 1, 'Ignore $_negative $_scenario $_effects'),
    // CRAGHEART
    Perk(_cragheart, 1, '$_remove four +0 $_cards'),
    Perk(_cragheart, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_cragheart, 1, '$_add $_one -2 $_card and $_two +2 $_cards'),
    Perk(_cragheart, 2, '$_add $_one +1 IMMOBILIZE $_card'),
    Perk(_cragheart, 2, '$_add $_one +2 MUDDLE $_card'),
    Perk(_cragheart, 1, '$_add $_two $_rolling PUSH 2 $_cards'),
    Perk(_cragheart, 2, '$_add $_two $_rolling EARTH $_cards'),
    Perk(_cragheart, 1, '$_add $_two $_rolling AIR $_cards'),
    Perk(_cragheart, 1, 'Ignore $_negative item $_effects'),
    Perk(_cragheart, 1, 'Ignore $_negative $_scenario $_effects'),
    // MINDTHIEF
    Perk(_mindthief, 2, '$_remove $_two -1 $_cards'),
    Perk(_mindthief, 1, '$_remove four +0 $_cards'),
    Perk(_mindthief, 1, '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    Perk(_mindthief, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk(_mindthief, 2, '$_add $_one +2 ICE $_card'),
    Perk(_mindthief, 2, '$_add $_two $_rolling +1 $_cards'),
    Perk(_mindthief, 1, '$_add $_three $_rolling PULL 1 $_cards'),
    Perk(_mindthief, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    Perk(_mindthief, 1, '$_add $_two $_rolling IMMOBILIZE $_cards'),
    Perk(_mindthief, 1, '$_add $_one $_rolling STUN $_card'),
    Perk(_mindthief, 1,
        '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
    Perk(_mindthief, 1, 'Ignore $_negative $_scenario $_effects'),
    // SUNKEEPER
    Perk(
      _sunkeeper,
      2,
      '$_remove $_two -1 $_cards',
    ),
    Perk(
      _sunkeeper,
      1,
      '$_remove four +0 $_cards',
    ),
    Perk(
      _sunkeeper,
      1,
      '$_replace $_one -2 $_card with $_one +0 $_card',
    ),
    Perk(
      _sunkeeper,
      1,
      '$_replace $_one +0 $_card with $_one +2 $_card',
    ),
    Perk(
      _sunkeeper,
      2,
      '$_add $_two $_rolling +1 $_cards',
    ),
    Perk(
      _sunkeeper,
      2,
      '$_add $_two $_rolling HEAL 1 $_cards',
    ),
    Perk(
      _sunkeeper,
      1,
      '$_add $_one $_rolling STUN $_card',
    ),
    Perk(
      _sunkeeper,
      2,
      '$_add $_two $_rolling LIGHT $_cards',
    ),
    Perk(
      _sunkeeper,
      1,
      '$_add $_two $_rolling "SHIELD 1, Self" $_cards',
    ),
    Perk(
      _sunkeeper,
      1,
      'Ignore $_negative item $_effects and $_addL $_two +1 $_cards',
    ),
    Perk(
      _sunkeeper,
      1,
      'Ignore $_negative $_scenario $_effects',
    ),
    // QUARTERMASTER
    Perk(_quartermaster, 2, '$_remove $_two -1 $_cards'),
    Perk(_quartermaster, 1, '$_remove four +0 $_cards'),
    Perk(_quartermaster, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk(_quartermaster, 2, '$_add $_two $_rolling +1 $_cards'),
    Perk(_quartermaster, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    Perk(_quartermaster, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    Perk(_quartermaster, 1, '$_add $_one $_rolling STUN $_card'),
    Perk(_quartermaster, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    Perk(_quartermaster, 3, '$_add $_one +0 "REFRESH an item" $_card'),
    Perk(_quartermaster, 1,
        'Ignore $_negative item $_effects and $_addL $_two +1 $_cards'),
    // SUMMONER
    Perk(_summoner, 1, '$_remove $_two -1 $_cards'),
    Perk(_summoner, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk(_summoner, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_summoner, 2, '$_add $_one +2 $_card'),
    Perk(_summoner, 1, '$_add $_two $_rolling WOUND $_cards'),
    Perk(_summoner, 1, '$_add $_two $_rolling POISON $_cards'),
    Perk(_summoner, 3, '$_add $_two $_rolling HEAL 1 $_cards'),
    Perk(_summoner, 1,
        '$_add $_one $_rolling FIRE and $_one $_rolling AIR $_card'),
    Perk(_summoner, 1,
        '$_add $_one $_rolling DARK and $_one $_rolling EARTH $_card'),
    Perk(_summoner, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // NIGHTSHROUD
    Perk(_nightshround, 2, '$_remove $_two -1 $_cards'),
    Perk(_nightshround, 1, '$_remove four +0 $_cards'),
    Perk(_nightshround, 2, '$_add $_one -1 DARK $_card'),
    Perk(_nightshround, 2,
        '$_replace $_one -1 DARK $_card with $_one +1 DARK $_card'),
    Perk(_nightshround, 2, '$_add $_one +1 INVISIBLE $_card'),
    Perk(_nightshround, 2, '$_add $_three $_rolling MUDDLE $_cards'),
    Perk(_nightshround, 1, '$_add $_two $_rolling HEAL 1 $_cards'),
    Perk(_nightshround, 1, '$_add $_two $_rolling CURSE $_cards'),
    Perk(_nightshround, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    Perk(_nightshround, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // PLAGUEHERALD
    Perk(_plagueherald, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk(_plagueherald, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_plagueherald, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk(_plagueherald, 1, '$_add $_two +1 $_cards'),
    Perk(_plagueherald, 3, '$_add $_one +1 AIR $_card'),
    Perk(_plagueherald, 1, '$_add $_three $_rolling POISON $_cards'),
    Perk(_plagueherald, 1, '$_add $_two $_rolling CURSE $_cards'),
    Perk(_plagueherald, 1, '$_add $_two $_rolling IMMOBILIZE $_cards'),
    Perk(_plagueherald, 2, '$_add $_one $_rolling STUN $_card'),
    Perk(_plagueherald, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // BERSERKER
    Perk(_berserker, 1, '$_remove $_two -1 $_cards'),
    Perk(_berserker, 1, '$_remove four +0 $_cards'),
    Perk(_berserker, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_berserker, 2,
        '$_replace $_one +0 $_card with $_one $_rolling +2 $_card'),
    Perk(_berserker, 2, '$_add $_two $_rolling WOUND $_cards'),
    Perk(_berserker, 2, '$_add $_one $_rolling STUN $_card'),
    Perk(_berserker, 1, '$_add $_one $_rolling +1 DISARM $_card'),
    Perk(_berserker, 1, '$_add $_two $_rolling HEAL 1 $_cards'),
    Perk(_berserker, 2, '$_add $_one +2 FIRE $_card'),
    Perk(_berserker, 1, 'Ignore $_negative item $_effects'),
    //SOOTHSAYER
    Perk(_soothsinger, 2, '$_remove $_two -1 $_cards'),
    Perk(_soothsinger, 1, '$_remove $_one -2 $_card'),
    Perk(_soothsinger, 2, '$_replace $_two +1 $_cards with $_one +4 $_card'),
    Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +1 IMMOBILIZE $_card'),
    Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +1 DISARM $_card'),
    Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 WOUND $_card'),
    Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 POISON $_card'),
    Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
    Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
    Perk(
        _soothsinger, 1, '$_replace $_one -1 $_card with $_one +0 STUN $_card'),
    Perk(_soothsinger, 1, '$_add $_three $_rolling +1 $_cards'),
    Perk(_soothsinger, 2, '$_add $_two $_rolling CURSE $_cards'),
    // DOOMSTALKER
    Perk(_doomstalker, 2, '$_remove $_two -1 $_cards'),
    Perk(_doomstalker, 3, '$_replace $_two +0 $_cards with $_two +1 $_cards'),
    Perk(_doomstalker, 2, '$_add $_two $_rolling +1 $_cards'),
    Perk(_doomstalker, 1, '$_add $_one +2 MUDDLE $_card'),
    Perk(_doomstalker, 1, '$_add $_one +1 POISON $_card'),
    Perk(_doomstalker, 1, '$_add $_one +1 WOUND $_card'),
    Perk(_doomstalker, 1, '$_add $_one +1 IMMOBILIZE $_card'),
    Perk(_doomstalker, 1, '$_add $_one +0 STUN $_card'),
    Perk(_doomstalker, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    Perk(_doomstalker, 1, 'Ignore $_negative $_scenario $_effects'),
    // SAWBONES
    Perk(_sawbones, 2, '$_remove $_two -1 $_cards'),
    Perk(_sawbones, 1, '$_remove four +0 $_cards'),
    Perk(_sawbones, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk(_sawbones, 2, '$_add $_one $_rolling +2 $_card'),
    Perk(_sawbones, 2, '$_add $_one +1 IMMOBILIZE $_card'),
    Perk(_sawbones, 2, '$_add $_two $_rolling WOUND $_cards'),
    Perk(_sawbones, 1, '$_add $_one $_rolling STUN $_card'),
    Perk(_sawbones, 2, '$_add $_one $_rolling HEAL 3 $_card'),
    Perk(_sawbones, 1, '$_add $_one +0 "REFRESH an item" $_card'),
    // ELEMENTALIST
    Perk(_elementalist, 2, '$_remove $_two -1 $_cards'),
    Perk(_elementalist, 1, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_elementalist, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk(_elementalist, 1, '$_add $_three +0 FIRE $_cards'),
    Perk(_elementalist, 1, '$_add $_three +0 ICE $_cards'),
    Perk(_elementalist, 1, '$_add $_three +0 AIR $_cards'),
    Perk(_elementalist, 1, '$_add $_three +0 EARTH $_cards'),
    Perk(_elementalist, 1,
        '$_replace $_two +0 $_cards with $_one +0 FIRE $_card and $_one +0 EARTH $_card'),
    Perk(_elementalist, 1,
        '$_replace $_two +0 $_cards with $_one +0 ICE $_card and $_one +0 AIR $_card'),
    Perk(_elementalist, 1, '$_add $_two +1 PUSH 1 $_cards'),
    Perk(_elementalist, 1, '$_add $_one +1 WOUND $_card'),
    Perk(_elementalist, 1, '$_add $_one +0 STUN $_card'),
    Perk(_elementalist, 1, '$_add $_one +0 ADD TARGET $_card'),
    // BEAST TYRANT
    Perk(_beastTyrant, 1, '$_remove $_two -1 $_cards'),
    Perk(_beastTyrant, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_beastTyrant, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk(_beastTyrant, 2, '$_add $_one +1 WOUND $_card'),
    Perk(_beastTyrant, 2, '$_add $_one +1 IMMOBILIZE $_card'),
    Perk(_beastTyrant, 3, '$_add $_two $_rolling HEAL 1 $_cards'),
    Perk(_beastTyrant, 1, '$_add $_two $_rolling EARTH $_cards'),
    Perk(_beastTyrant, 1, 'Ignore $_negative $_scenario $_effects'),
    // BLADESWARM
    Perk(_bladeswarm, 1, '$_remove $_one -2 $_card'),
    Perk(_bladeswarm, 1, '$_remove four +0 $_cards'),
    Perk(_bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 AIR $_card'),
    Perk(
        _bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 EARTH $_card'),
    Perk(
        _bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 LIGHT $_card'),
    Perk(_bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 DARK $_card'),
    Perk(_bladeswarm, 2, '$_add $_two $_rolling HEAL 1 $_cards'),
    Perk(_bladeswarm, 2, '$_add $_one +1 WOUND $_card'),
    Perk(_bladeswarm, 2, '$_add $_one +1 POISON $_card'),
    Perk(_bladeswarm, 1, '$_add $_one +2 MUDDLE $_card'),
    Perk(_bladeswarm, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    Perk(_bladeswarm, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // DIVINER
    Perk(_diviner, 2, '$_remove $_two -1 $_cards'),
    Perk(_diviner, 1, '$_remove $_one -2 $_card'),
    Perk(_diviner, 2,
        '$_replace $_two +1 $_cards with $_one +3 "SHIELD 1, Self" $_card'),
    Perk(_diviner, 1,
        '$_replace $_one +0 $_card with $_one +1 "SHIELD 1, Affect any Ally" $_card'),
    Perk(_diviner, 1, '$_replace $_one +0 $_card with $_one +2 DARK $_card'),
    Perk(_diviner, 1, '$_replace $_one +0 $_card with $_one +2 LIGHT $_card'),
    Perk(_diviner, 1, '$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
    Perk(_diviner, 1, '$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
    Perk(_diviner, 1,
        '$_replace $_one +0 $_card with $_one +2 "REGENERATE, Self" $_card'),
    Perk(_diviner, 1,
        '$_replace $_one -1 $_card with $_one +1 "HEAL 2, Affect any Ally" $_card'),
    Perk(_diviner, 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    Perk(_diviner, 1, '$_add $_two $_rolling CURSE $_cards'),
    Perk(_diviner, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // DEMOLITIONIST
    Perk(_demolitionist, 1, '$_remove four +0 $_cards'),
    Perk(_demolitionist, 2, '$_remove $_two -1 $_cards'),
    Perk(_demolitionist, 1, '$_remove $_one -2 $_card and $_one +1 $_card'),
    Perk(_demolitionist, 2,
        '$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
    Perk(_demolitionist, 1,
        '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    Perk(_demolitionist, 2, '$_add $_one +2 $_card'),
    Perk(_demolitionist, 2,
        '$_replace $_one +1 $_card with $_one +2 EARTH $_card'),
    Perk(_demolitionist, 2,
        '$_replace $_one +1 $_card with $_one +2 FIRE $_card'),
    Perk(_demolitionist, 2,
        '$_add $_one +0 "All adjacent enemies suffer 1 DAMAGE" $_card'),
    // HATCHET
    Perk(_hatchet, 2, '$_remove $_two -1 $_cards'),
    Perk(_hatchet, 1, '$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
    Perk(_hatchet, 1, '$_replace $_one +0 $_card with $_one +1 POISON $_card'),
    Perk(_hatchet, 1, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    Perk(_hatchet, 1,
        '$_replace $_one +0 $_card with $_one +1 IMMOBILIZE $_card'),
    Perk(_hatchet, 1, '$_replace $_one +0 $_card with $_one +1 PUSH 2 $_card'),
    Perk(_hatchet, 1, '$_replace $_one +0 $_card with $_one +0 STUN $_card'),
    Perk(_hatchet, 1, '$_replace $_one +1 $_card with $_one +1 STUN $_card'),
    Perk(_hatchet, 3, '$_add $_one +2 AIR $_card'),
    Perk(_hatchet, 3, '$_replace $_one +1 $_card with $_one +3 $_card'),
    // RED GUARD
    Perk(_redGuard, 1, '$_remove four +0 $_cards'),
    Perk(_redGuard, 1, '$_remove $_two -1 $_cards'),
    Perk(_redGuard, 1, '$_remove $_one -2 $_card and $_one +1 $_card'),
    Perk(_redGuard, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk(_redGuard, 2, '$_replace $_one +1 $_card with $_one +2 FIRE $_card'),
    Perk(_redGuard, 2, '$_replace $_one +1 $_card with $_one +2 LIGHT $_card'),
    Perk(_redGuard, 2, '$_add $_one +1 FIRE&LIGHT $_card'),
    Perk(_redGuard, 2, '$_add $_one +1 SHIELD 1 $_card'),
    Perk(_redGuard, 1,
        '$_replace $_one +0 $_card with $_one +1 IMMOBILIZE $_card'),
    Perk(_redGuard, 1, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    // VOIDWARDEN
    Perk(_voidwarden, 1, '$_remove $_two -1 $_cards'),
    Perk(_voidwarden, 1, '$_remove $_one -2 $_card'),
    Perk(_voidwarden, 2, '$_replace $_one +0 $_card with $_one +1 DARK $_card'),
    Perk(_voidwarden, 2, '$_replace $_one +0 $_card with $_one +1 ICE $_card'),
    Perk(_voidwarden, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Ally" $_card'),
    Perk(_voidwarden, 3, '$_add $_one +1 "HEAL 1, Ally" $_card'),
    Perk(_voidwarden, 1, '$_add $_one +1 POISON $_card'),
    Perk(_voidwarden, 1, '$_add $_one +3 $_card'),
    Perk(_voidwarden, 2, '$_add $_one +1 CURSE $_card'),
    // AMBER AEGIS
    Perk('aa', 1,
        '$_replace $_one -2 $_card with $_one -1 "Place $_one Colony token of your choice on any empty hex within RANGE 2" $_card'),
    Perk('aa', 1, '$_remove $_two -1 $_cards'),
    Perk('aa', 1, '$_remove four +0 $_cards'),
    Perk('aa', 1, '$_replace $_one -1 $_card with $_one +2 MUDDLE $_card'),
    Perk('aa', 1, '$_replace $_one -1 $_card with $_one +1 POISON $_card'),
    Perk('aa', 1, '$_replace $_one -1 $_card with $_one +1 WOUND $_card'),
    Perk('aa', 2, '$_add $_two $_rolling +1 IMMOBILIZE $_cards'),
    Perk('aa', 2,
        '$_add $_one $_rolling "HEAL 1, Self" $_card and $_one $_rolling "SHIELD 1, Self" $_card'),
    Perk('aa', 2, '$_add $_one $_rolling "RETALIATE 1, RANGE 3, Self" $_card'),
    Perk('aa', 1, '$_add $_one +2 EARTH/FIRE $_card'),
    Perk(
        'aa', 1, 'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    Perk('aa', 1,
        'Ignore $_scenario $_effects and $_addL $_one $_rolling BRITTLE $_card'),
    // ARTIFICER
    Perk('af', 1, '$_replace $_one -2 $_card with $_one -1 Any_Element $_card'),
    Perk('af', 1, '$_replace $_one -1 $_card with $_one +1 DISARM $_card'),
    Perk('af', 2, '$_replace $_one -1 $_card with $_one +1 PUSH 1 $_card'),
    Perk('af', 2, '$_replace $_one -1 $_card with $_one +1 PULL 1 $_card'),
    Perk('af', 2,
        '$_replace $_one +0 $_card with $_one +0 "REFRESH a spent item" $_card'),
    Perk('af', 2,
        '$_replace $_one +0 $_card with $_one +1 "SHIELD 1, Self" $_card'),
    Perk('af', 2, '$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
    Perk('af', 1,
        '$_replace $_one +2 $_card with $_one +3 "HEAL 2, Self" $_card'),
    Perk('af', 1,
        '$_replace $_two +1 $_cards with $_two $_rolling +1 POISON $_cards'),
    Perk('af', 1,
        '$_replace $_two +1 $_cards with $_two $_rolling +1 WOUND $_cards'),
    // BOMBARD
    Perk('bb', 1, '$_remove $_two -1 $_cards'),
    Perk('bb', 1,
        '$_replace $_two +0 $_cards with $_two $_rolling PIERCE 3 $_cards'),
    Perk('bb', 2,
        '$_replace $_one -1 $_card with $_one +0 "+3 if Projectile" $_card'),
    Perk('bb', 2, '$_add $_one +2 IMMOBILIZE $_card'),
    Perk('bb', 1,
        '$_replace $_one +1 $_card with $_two +1 "RETALIATE 1, RANGE 3" $_cards'),
    Perk('bb', 1, '$_add $_two +1 "PULL 3, Self, toward the target" $_cards'),
    Perk('bb', 1, '$_add $_one +0 "STRENGTHEN, Self" $_card'),
    Perk('bb', 1, '$_add $_one +0 STUN $_card'),
    Perk('bb', 1, '$_add $_one +1 WOUND $_card'),
    Perk('bb', 1, '$_add $_two $_rolling "SHIELD 1, Self" $_cards'),
    Perk('bb', 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    Perk('bb', 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    Perk('bb', 1,
        'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
    // BREWMASTER
    Perk('bm', 1, '$_replace $_one -2 $_card with $_one -1 STUN $_card'),
    Perk('bm', 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk('bm', 2,
        '$_replace $_one -1 $_card with $_two $_rolling MUDDLE $_cards'),
    Perk('bm', 1,
        '$_replace $_two +0 $_cards with $_two +0 "HEAL 1, Self" $_cards'),
    Perk('bm', 2,
        '$_replace $_one +0 $_card with $_one +0 "Give yourself or an adjacent Ally a \'Liquid Rage\' item $_card" $_card'),
    Perk('bm', 2, '$_add $_one +2 PROVOKE $_card'),
    Perk('bm', 2, '$_add four $_rolling Shrug_Off 1 $_cards'),
    Perk('bm', 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    Perk('bm', 2, 'Each time you long rest, perform Shrug_Off 1'),
    // BRIGHTSPARK
    Perk('bp', 3,
        '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element to $_addL +2 ATTACK" $_card'),
    Perk('bp', 1,
        '$_replace $_one -2 $_card with $_one -2 "Recover $_one random $_card from your discard pile" $_card'),
    Perk('bp', 2,
        '$_replace $_two +0 $_cards with $_one +1 "HEAL 1, Affect $_one Ally within RANGE 2" $_card'),
    Perk('bp', 1,
        '$_replace $_two +0 $_cards with $_one +1 "SHIELD 1, Affect $_one Ally within RANGE 2" $_card'),
    Perk('bp', 2, '$_replace $_one +1 $_card with $_one +2 Any_Element $_card'),
    Perk('bp', 2,
        '$_add $_one +1 "STRENGTHEN, Affect $_one Ally within RANGE 2" $_card'),
    Perk('bp', 1,
        '$_add $_one $_rolling "PUSH 1 or PULL 1, AIR" $_card and $_one $_rolling "IMMOBILIZE, ICE" $_card'),
    Perk('bp', 1,
        '$_add $_one $_rolling "HEAL 1, RANGE 3, LIGHT" $_card and $_one $_rolling "PIERCE 2, FIRE" $_card'),
    Perk('bp', 1,
        '$_add $_three $_rolling "Consume_Any_Element : Any_Element" $_cards'),
    Perk('bp', 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
    // CHIEFTAIN
    Perk('ct', 1, '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    Perk('ct', 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Chieftain" $_card'),
    Perk('ct', 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Affect all summoned allies owned" $_card'),
    Perk('ct', 1,
        '$_replace $_one -2 $_card with $_one -2 "BLESS, Self" $_card'),
    Perk('ct', 1,
        '$_replace $_two +0 $_cards with $_one +0 "IMMOBILIZE and PUSH 1" $_card'),
    Perk('ct', 2,
        '$_replace $_one +0 $_card with $_one "+X, where X is the number of summoned allies you own" $_card'),
    Perk('ct', 1,
        '$_replace $_one +1 $_card with $_two +1 "$_rolling +1, if summon is attacking" $_cards'),
    Perk('ct', 1, '$_add $_one +0 WOUND, PIERCE 1 $_card'),
    Perk('ct', 2, '$_add $_one +1 EARTH $_card'),
    Perk('ct', 1,
        '$_add $_two $_rolling "PIERCE 2, ignore RETALIATE on the target" $_cards'),
    Perk('ct', 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // FIRE KNIGHT
    Perk('fk', 1, '$_remove $_two -1 $_cards'),
    Perk('fk', 2,
        '$_replace $_one -1 $_card with $_one +0 "STRENGTHEN, Ally" $_card'),
    Perk('fk', 2,
        '$_replace $_two +0 $_cards with $_two +0 "+2 if you are on Ladder" $_cards'),
    Perk('fk', 1, '$_replace $_one +0 $_card with $_one +1 FIRE $_card'),
    Perk('fk', 1, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    Perk('fk', 1, '$_replace $_two +1 $_cards with $_one +2 FIRE $_card'),
    Perk('fk', 1, '$_replace $_two +1 $_cards with $_one +2 WOUND $_card'),
    Perk('fk', 1, '$_add $_one +1 "STRENGTHEN, Ally" $_card'),
    Perk('fk', 2, '$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards'),
    Perk('fk', 1, '$_add $_two $_rolling WOUND $_cards'),
    Perk('fk', 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling FIRE $_card'),
    Perk('fk', 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one $_rolling FIRE $_card'),
    // FROSTBORN
    Perk('fb', 2, '$_remove $_two -1 $_cards'),
    Perk('fb', 1, '$_replace $_one -2 $_card with $_one +0 CHILL $_card'),
    Perk('fb', 2, '$_replace $_two +0 $_cards with $_two +1 PUSH 1 $_cards'),
    Perk('fb', 2, '$_replace $_one +0 $_card with $_one +1 ICE CHILL $_card'),
    Perk('fb', 1, '$_replace $_one +1 $_card with $_one +3 $_card'),
    Perk('fb', 1, '$_add $_one +0 STUN $_card'),
    Perk('fb', 2, '$_add $_one $_rolling ADD TARGET $_card'),
    Perk('fb', 1, '$_add $_three $_rolling CHILL $_cards'),
    Perk('fb', 1, '$_add $_three $_rolling PUSH 1 $_cards'),
    Perk('fb', 1, 'Ignore difficult and hazardous terrain during move actions'),
    Perk('fb', 1, 'Ignore $_scenario $_effects'),
    // HOLLOWPACT
    Perk('hp', 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 2, Self" $_card'),
    Perk('hp', 2, '$_replace $_two +0 $_cards with $_one +0 VOIDSIGHT $_card'),
    Perk('hp', 2, '$_add $_one -2 EARTH $_card and $_two +2 DARK $_cards'),
    Perk('hp', 1,
        '$_replace $_one -1 $_card with $_one -2 STUN $_card and $_one +0 VOIDSIGHT $_card'),
    Perk('hp', 1,
        '$_replace $_one -2 $_card with $_one +0 DISARM $_card and $_one -1 Any_Element $_card'),
    Perk('hp', 2,
        '$_replace $_one -1 $_card with $_one $_rolling +1 VOID $_card and $_one $_rolling -1 CURSE $_card'),
    Perk('hp', 2,
        '$_replace $_two +1 $_cards with $_one +3 "REGENERATE, Self" $_card'),
    Perk('hp', 2,
        '$_replace $_one +0 $_card with $_one +1 "Create a Void pit in an empty hex within RANGE 2" $_card'),
    Perk('hp', 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +0 "WARD, Self" $_card'),
    // MIREFOOT
    Perk('mf', 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk('mf', 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk('mf', 2,
        '$_replace $_two +0 $_cards with $_two "+X, where X is the POISON value of the target" $_cards'),
    Perk('mf', 1, '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    Perk('mf', 2,
        '$_replace $_one +0 $_card with $_two $_rolling "Create difficult terrain in the hex occupied by the target" $_cards'),
    Perk('mf', 2, '$_replace $_one +1 $_card with $_one +0 WOUND 2 $_card'),
    Perk('mf', 1,
        '$_add four $_rolling +0 "+1 if the target occupies difficult terrain" $_cards'),
    Perk('mf', 1,
        '$_add $_two $_rolling "INVISIBLE, Self, if you occupy difficult terrain" $_cards'),
    Perk('mf', 1,
        'Gain "Poison Dagger" (Item 011). You may carry $_one additional One_Hand item with "Dagger" in its name'),
    Perk('mf', 1,
        'Ignore damage, $_negative conditions, and modifiers from Events, and $_removeL $_one -1 $_card'),
    Perk('mf', 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
    // ROOTWHISPERER
    Perk('rw', 2, '$_remove $_two -1 $_cards'),
    Perk('rw', 1, '$_remove four +0 $_cards'),
    Perk('rw', 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk('rw', 2, '$_add $_one $_rolling +2 $_card'),
    Perk('rw', 2, '$_add $_one +1 IMMOBILIZE $_card'),
    Perk('rw', 2, '$_add $_two $_rolling POISON $_cards'),
    Perk('rw', 1, '$_add $_one $_rolling DISARM $_card'),
    Perk('rw', 2, '$_add $_one $_rolling HEAL 2 EARTH $_card'),
    Perk('rw', 1, 'Ignore $_negative $_scenario $_effects'),
    // CHAINGUARD
    Perk('cg', 2, '$_replace $_one -1 $_card with $_one +1 Shackle $_card'),
    Perk('cg', 2,
        '$_replace $_one -1 $_card with $_one +0 "+2 if the target is Shackled" $_card'),
    Perk('cg', 2,
        '$_replace $_two +0 $_cards with $_one $_rolling "SHIELD 1, Self" $_card'),
    Perk('cg', 1, '$_add $_two $_rolling "RETALIATE 1, Self" $_cards'),
    Perk('cg', 1, '$_add $_three $_rolling SWING 3 $_cards'),
    Perk('cg', 1, '$_replace $_one +1 $_card with $_one +2 WOUND $_card'),
    Perk('cg', 1, '$_add $_one +1 "DISARM if the target is Shackled" $_card'),
    Perk('cg', 1,
        '$_add $_one +1 "Create a 2 DAMAGE trap in an empty hex within RANGE 2" $_card'),
    Perk('cg', 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    Perk('cg', 2, '$_add $_one +2 Shackle $_card'),
    Perk('cg', 1,
        'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
    // HIEROPHANT
    Perk('hf', 1, '$_remove $_two -1 $_cards'),
    Perk('hf', 1,
        '$_replace $_two +0 $_cards with $_one $_rolling LIGHT $_card'),
    Perk('hf', 1,
        '$_replace $_two +0 $_cards with $_one $_rolling EARTH $_card'),
    Perk('hf', 2, '$_replace $_one -1 $_card with $_one +0 CURSE $_card'),
    Perk('hf', 1,
        '$_replace $_one +0 $_card with $_one +1 "SHIELD 1, Ally" $_card'),
    Perk('hf', 1,
        '$_replace $_one -2 $_card with $_one -1 "Give $_one Ally a \'Prayer\' ability $_card" and $_one +0 $_card'),
    Perk('hf', 2, '$_replace $_one +1 $_card with $_one +3 $_card'),
    Perk('hf', 2, '$_add $_two $_rolling "HEAL 1, Self or Ally" $_cards'),
    Perk('hf', 2, '$_add $_one +1 WOUND, MUDDLE $_card'),
    Perk(
        'hf', 1, 'At the start of your first turn each $_scenario, gain BLESS'),
    Perk('hf', 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // LUMINARY
    Perk('ln', 1, '$_remove four +0 $_cards'),
    Perk('ln', 1, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk('ln', 1, '$_replace $_one -1 $_card with $_one +0 ICE $_card'),
    Perk('ln', 1, '$_replace $_one -1 $_card with $_one +0 FIRE $_card'),
    Perk('ln', 1, '$_replace $_one -1 $_card with $_one +0 LIGHT $_card'),
    Perk('ln', 1, '$_replace $_one -1 $_card with $_one +0 DARK $_card'),
    Perk('ln', 1,
        '$_replace $_one -2 $_card with $_one -2 "Perform $_one Glow ability" $_card'),
    Perk('ln', 2, '$_add $_one +0 Any_Element $_card'),
    Perk('ln', 2, '$_add $_one $_rolling +1 "HEAL 1, Self" $_card'),
    Perk('ln', 2,
        '$_add $_one "POISON, target all enemies in the depicted HEX area" $_card'),
    Perk('ln', 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    Perk('ln', 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling "Consume_Any_Element : Any_Element" $_card'),
    // SPIRIT CALLER
    Perk('scr', 1,
        '$_replace $_one -2 $_card with $_one -1 $_card and $_one +1 $_card'),
    Perk('scr', 2,
        '$_replace $_one -1 $_card with $_one +0 "+2 if a Spirit performed the attack" $_card'),
    Perk('scr', 2,
        '$_replace $_one -1 $_card with $_one +0 $_card and $_one $_rolling POISON $_card'),
    Perk('scr', 2, '$_replace $_one +0 $_card with $_one +1 AIR $_card'),
    Perk('scr', 2, '$_replace $_one +0 $_card with $_one +1 DARK $_card'),
    Perk('scr', 1, '$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
    Perk('scr', 1, '$_add $_three $_rolling PIERCE 3 $_cards'),
    Perk('scr', 1, '$_add $_one +1 CURSE $_card'),
    Perk('scr', 1, '$_add $_one $_rolling ADD TARGET $_card'),
    Perk('scr', 1, '$_replace $_one +1 $_card with $_one +2 PUSH 2 $_card'),
    Perk('scr', 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // STARSLINGER
    Perk('ssl', 2,
        '$_replace $_two +0 $_cards with $_one $_rolling "HEAL 1, Self" $_card'),
    Perk('ssl', 1,
        '$_replace $_one -2 $_card with $_one -1 "INVISIBLE, Self" $_card'),
    Perk('ssl', 1, '$_replace $_two -1 $_cards with $_one +0 DARK $_card'),
    Perk('ssl', 2, '$_replace $_one -1 $_card with $_one +1 LIGHT $_card'),
    Perk('ssl', 1, '$_add $_one $_rolling Loot 1 $_card'),
    Perk('ssl', 2, '$_add $_one +1 "+3 if you are at full health" $_card'),
    Perk('ssl', 1, '$_add $_two $_rolling IMMOBILIZE $_cards'),
    Perk('ssl', 2, '$_add $_one +1 "HEAL 1, RANGE 3" $_card'),
    Perk('ssl', 1,
        '$_add $_two $_rolling "Force the target to perform a MOVE 1 ability" $_card'),
    Perk('ssl', 1, '$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards'),
    Perk('ssl', 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // RUINMAW
    Perk('rm', 1,
        '$_replace $_one -2 $_card with $_one -1 RUPTURE and WOUND $_card'),
    Perk('rm', 2, '$_replace $_one -1 $_card with $_one +0 WOUND $_card'),
    Perk('rm', 2, '$_replace $_one -1 $_card with $_one +0 RUPTURE $_card'),
    Perk('rm', 3,
        '$_replace $_one +0 $_card with $_one +1 "$_add +3 instead if the target has RUPTURE or WOUND" $_card'),
    Perk('rm', 3,
        '$_replace $_one +0 $_card with $_one $_rolling "HEAL 1, Self, EMPOWER" $_card'),
    Perk('rm', 1,
        'Once each $_scenario, become SATED after collecting your 5th loot token'),
    Perk('rm', 1,
        'Become SATED each time you lose a $_card to negate suffering DAMAGE'),
    Perk('rm', 1,
        'Whenever $_one of your abilities causes at least $_one enemy to gain RUPTURE, immediately after that ability perform "MOVE 1"'),
    Perk('rm', 1,
        'Ignore $_negative $_scenario $_effects, and $_removeL $_one -1 $_card'),
    // THORNREAPER
    Perk('thornreaper', 2,
        '$_replace $_one -1 $_card with $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card'),
    Perk('thornreaper', 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk('thornreaper', 1, '$_replace $_one +0 $_card with $_one +2 $_card'),
    Perk('thornreaper', 2,
        '$_add $_three $_rolling "+1 if LIGHT is Strong or Waning" $_cards'),
    Perk('thornreaper', 1, '$_add $_two $_rolling LIGHT $_cards'),
    Perk('thornreaper', 1,
        '$_add $_three $_rolling "EARTH if LIGHT is Strong or Waning" $_cards'),
    Perk('thornreaper', 2,
        '$_add $_one "Create hazardous terrain in $_one hex within RANGE 1" $_card'),
    Perk('thornreaper', 2,
        '$_add $_one $_rolling "RETALIATE 3, next attack from an adjacent enemy while you occupy hazardous terrain" $_card'),
    Perk('thornreaper', 2,
        '$_add $_one $_rolling "SHIELD 3, next damage from an attack while you occupy hazardous terrain" $_card'),
    Perk('thornreaper', 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card'),
    Perk('thornreaper', 2, 'Gain SHIELD 1 while you occupy hazardous terrain',
        perkIsGrouped: true),
    Perk('thornreaper', 1,
        'At the end of each of your long rests, generate LIGHT'),
    // INCARNATE
    Perk('incarnate', 1,
        '$_replace $_one -2 $_card with $_one RITUALIST / CONQUEROR / REAVER $_rolling $_card'),
    Perk('incarnate', 1,
        '$_replace $_one -1 $_card with $_one PIERCE 2 FIRE $_rolling $_card'),
    Perk('incarnate', 1,
        '$_replace $_one -1 $_card with $_one "SHIELD 1" EARTH $_rolling $_card'),
    Perk('incarnate', 1,
        '$_replace $_one -1 $_card with $_one PUSH 1 AIR $_rolling $_card'),
    Perk('incarnate', 2,
        '$_replace $_one +0 $_card with $_one +1 "RITUALIST : ENFEEBLE or CONQUEROR : EMPOWER, Self" $_card'),
    Perk('incarnate', 2,
        '$_replace $_one +0 $_card with $_one +1 "CONQUEROR : EMPOWER, Self or REAVER : RUPTURE" $_card'),
    Perk('incarnate', 2,
        '$_replace $_one +0 $_card with $_one +1 "RITUALIST : ENFEEBLE or REAVER : RUPTURE" $_card'),
    Perk('incarnate', 1,
        '$_replace $_four +1 $_cards with $_four +1 "RETALIATE 1" $_cards'),
    Perk('incarnate', 2, '$_add one +3 $_card'),
    Perk('incarnate', 1,
        '$_add $_one REFRESH $_one One_Hand or Two_Hand item $_rolling $_card'),
    Perk('incarnate', 1, 'Ignore item -1 effects and $_removeL one -1 $_card'),
    Perk('incarnate', 1,
        'Whenever you short rest, REFRESH one spent One_Hand item'),
    Perk('incarnate', 1,
        'Whenever you long rest, perform RITUALIST / CONQUEROR / REAVER'),
    Perk('incarnate', 1,
        'You may bring one additional One_Hand item into each scenario'),
    // RIMEHEARTH
    Perk(
      'rimehearth',
      2,
      '$_replace $_one -1 $_card with $_one $_rolling WOUND $_card',
    ),
    Perk(
      'rimehearth',
      1,
      '$_replace $_one +0 $_card with $_one $_rolling HEAL 3, WOUND, Self $_card',
    ),
    Perk(
      'rimehearth',
      1,
      '$_replace $_two +0 $_cards with $_two $_rolling FIRE $_cards',
    ),
    Perk(
      'rimehearth',
      1,
      '$_replace $_three +1 $_cards with $_one $_rolling +1 card, $_one +1 WOUND $_card, and $_one +1 HEAL 1, Self $_card',
    ),
    Perk(
      'rimehearth',
      2,
      '$_replace $_one +0 $_card with $_one +1 ICE $_card',
    ),
    Perk(
      'rimehearth',
      2,
      '$_replace $_one -1 $_card with $_one +0 CHILL $_card',
    ),
    Perk(
      'rimehearth',
      1,
      '$_replace $_one +2 $_card with $_one +3 CHILL $_card',
    ),
    Perk(
      'rimehearth',
      2,
      '$_add $_one +2 FIRE/ICE $_card',
    ),
    Perk(
      'rimehearth',
      1,
      '$_add $_one +0 BRITTLE $_card',
    ),
    Perk(
      'rimehearth',
      1,
      'At the start of each $_scenario you may either gain WOUND to generate FIRE or gain CHILL to generate ICE',
    ),
    Perk(
      'rimehearth',
      1,
      'Ignore negative item effects and $_add $_one $_rolling FIRE/ICE $_card',
    ),
    // DRIFTER
    Perk('drifter', 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk('drifter', 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk('drifter', 2,
        '$_replace $_one +1 $_card with $_two +0 "Move $_one character token back $_one space" $_cards'),
    Perk('drifter', 1,
        '$_replace $_two +0 $_cards with $_two $_rolling PIERCE 3 $_cards'),
    Perk('drifter', 1,
        '$_replace $_two +0 $_cards with $_two $_rolling PUSH 2 $_cards'),
    Perk('drifter', 1, '$_add $_one +3 $_card'),
    Perk('drifter', 2, '$_add $_one +2 IMMOBILIZE $_card'),
    Perk('drifter', 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    Perk('drifter', 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    Perk('drifter', 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    Perk('drifter', 2,
        'Whenever you long rest, you may move $_one of your character tokens back $_one space',
        perkIsGrouped: true),
    Perk('drifter', 1,
        'You may bring $_one additional One_Hand item into each $_scenario'),
    Perk('drifter', 1,
        'At the end of each $_scenario, you may discard up to $_two loot $_cards to draw that many new loot $_cards'),
    // BLINK BLADE
    Perk('blinkblade', 1, '$_remove $_one -2 $_card'),
    Perk('blinkblade', 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk('blinkblade', 2,
        '$_replace $_one -1 $_card with $_one +0 WOUND $_card'),
    Perk('blinkblade', 2,
        '$_replace $_one +0 $_card with $_one +1 IMMOBILIZE $_card'),
    Perk('blinkblade', 3,
        '$_replace $_one +0 $_card with $_one $_rolling "Place this $_card in your active area. On your next attack, discard this $_card to $_addL +2 ATTACK" $_card'),
    Perk('blinkblade', 1, '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    Perk('blinkblade', 2, '$_add $_one -1 "Gain $_one TIME_TOKEN" $_card'),
    Perk('blinkblade', 2, '$_add $_one $_rolling +2 "REGENERATE, Self" $_card'),
    Perk('blinkblade', 1,
        'Whenever you short rest, you may spend $_one item for no effect to Recover a different spent item'),
    Perk('blinkblade', 1,
        'At the start of your first turn each $_scenario, you may perform "MOVE 3"'),
    Perk('blinkblade', 1, 'When you gain IMMOBILIZE, prevent the condition'),
    // BANNER SPEAR
    Perk('bannerspear', 3,
        '$_replace $_one -1 $_card with $_one $_rolling "SHIELD 1" $_card'),
    Perk('bannerspear', 2,
        '$_replace $_one +0 $_card with $_one +0 "$_add +1 for each Ally adjacent to the target" $_card'),
    Perk('bannerspear', 2, '$_add $_one +1 DISARM $_card'),
    Perk('bannerspear', 2, '$_add $_one +2 PUSH 1 $_card'),
    Perk('bannerspear', 2, '$_add $_two $_rolling +1 $_cards'),
    Perk('bannerspear', 2, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    Perk('bannerspear', 1,
        'Ignore $_negative item $_effects and $_removeL $_one -1 $_card'),
    Perk('bannerspear', 1,
        'At the end of each of your long rests, $_one Ally withing RANGE 3 may perform "MOVE 2" with you controlling the MOVE abilities of any summons'),
    Perk('bannerspear', 1,
        'Whenever you open a door with a MOVE ability, $_addL +3 MOVE'),
    Perk('bannerspear', 2,
        'Once each $_scenario, during your turn, gain SHIELD 2 for the remainder of the round',
        perkIsGrouped: true),
    // DEATHWALKER
    Perk('deathwalker', 1, '$_remove $_two -1 $_cards'),
    Perk('deathwalker', 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk('deathwalker', 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    Perk('deathwalker', 3,
        '$_replace $_one +0 $_card with $_one +1 CURSE $_card'),
    Perk('deathwalker', 2, '$_add $_one +2 DARK $_card'),
    Perk('deathwalker', 2,
        '$_add $_one $_rolling DISARM and $_one $_rolling MUDDLE $_card'),
    Perk('deathwalker', 2, '$_add $_two $_rolling "HEAL 1, Ally" $_cards'),
    Perk('deathwalker', 1, 'Ignore $_negative $_scenario $_effects'),
    Perk('deathwalker', 1,
        'Whenever you long rest, you may move $_one SHADOW up to 3 hexes'),
    Perk('deathwalker', 1,
        'While you occupy a hex with a SHADOW, all attacks targeting you gain Disadvantage'),
    Perk('deathwalker', 1,
        'Whenever you short rest, you may consume_DARK to perform "CURSE, RANGE 2" as if you were occupying a hex with a SHADOW'),
    // BONESHAPER
    Perk('boneshaper', 2,
        '$_replace $_one -1 $_card with $_one +0 CURSE $_card'),
    Perk('boneshaper', 2,
        '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    Perk('boneshaper', 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk('boneshaper', 3,
        '$_replace $_one +0 $_card with $_one +1 "Kill the attacking summon to instead $_addL +4" $_card'),
    Perk('boneshaper', 2,
        '$_add $_three $_rolling "HEAL 1, Target Boneshaper" $_cards'),
    Perk('boneshaper', 3, '$_add $_one +2 EARTH/DARK $_card'),
    Perk('boneshaper', 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    Perk('boneshaper', 1,
        'Immediately before each of your rests, you may kill $_one of your summons to perform "BLESS, Self"'),
    Perk('boneshaper', 1,
        'Once each $_scenario, when any character ally would become exhausted by suffering DAMAGE, you may suffer DAMAGE 2 to reduce their hit point value to 1 instead'),
    Perk('boneshaper', 2,
        'At the start of each $_scenario, you may play a level 1 $_card from your hand to perform a summon action of the $_card',
        perkIsGrouped: true),
    // GEMINATE
    Perk('geminate', 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    Perk('geminate', 3,
        '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element : Any_Element" $_card'),
    Perk(
        'geminate', 2, '$_replace $_one +0 $_card with $_one +1 POISON $_card'),
    Perk('geminate', 2, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    Perk('geminate', 1,
        '$_replace $_two +0 $_cards with $_two $_rolling PIERCE 3 $_cards'),
    Perk('geminate', 1, '$_add $_two +1 PUSH 3 $_cards'),
    Perk('geminate', 1, '$_add $_one 2x "BRITTLE, Self" $_card'),
    Perk('geminate', 2, '$_add $_one $_rolling +1 "REGENERATE, Self" card'),
    Perk('geminate', 1, 'Ignore $_negative $_scenario $_effects'),
    Perk('geminate', 1,
        'Whenever you short rest, you may $_removeL $_one $_negative condition from $_one Ally within RANGE 3'),
    Perk('geminate', 1,
        'Once each $_scenario, when you give yourself a $_negative condition, prevent the condition'),
    Perk('geminate', 2,
        'Whenever you perform an action with a lost icon, you may discard $_one $_card to Recover $_one discard',
        perkIsGrouped: true),
  ];

  static final List<Mastery> masteries = [
    // GLOOMHAVEN
    Mastery(
      masteryClassCode: _brute,
      masteryDetails:
          'Cause enemies to suffer a total of 12 or more RETALIATE damage during attacks targeting you in a single round',
    ),
    Mastery(
      masteryClassCode: _brute,
      masteryDetails:
          'Across three consecutive rounds, play six different ability cards and cause enemies to suffer at least DAMAGE 6 on each of your turns',
    ),
    Mastery(
      masteryClassCode: _tinkerer,
      masteryDetails:
          'Heal an ally or apply a negative condition to an enemy each turn',
    ),
    Mastery(
      masteryClassCode: _tinkerer,
      masteryDetails:
          'Perform two actions with lost icons before your first rest and then only rest after having played at least two actions with lost icons since your previous rest',
    ),
    Mastery(
      masteryClassCode: _spellweaver,
      masteryDetails: 'Infuse and consume all six elements',
    ),
    Mastery(
      masteryClassCode: _spellweaver,
      masteryDetails: 'Perform four different loss actions twice each',
    ),
    Mastery(
      masteryClassCode: _scoundrel,
      masteryDetails:
          'Kill at least six enemies that are adjacent to at least one of your allies',
    ),
    Mastery(
      masteryClassCode: _scoundrel,
      masteryDetails:
          'Kill at least six enemies that are adjacent to none of your allies',
    ),
    Mastery(
      masteryClassCode: _cragheart,
      masteryDetails: 'Only attack enemies adjacent to obstacles or walls',
    ),
    Mastery(
      masteryClassCode: _cragheart,
      masteryDetails: 'Damage or heal at least one ally each round',
    ),
    Mastery(
      masteryClassCode: _mindthief,
      masteryDetails:
          'Trigger the on-attack effect of four different Augments thrice each',
    ),
    Mastery(
      masteryClassCode: _mindthief,
      masteryDetails: 'Never be targeted by an attack',
    ),
    Mastery(
      masteryClassCode: _sunkeeper,
      masteryDetails:
          'Reduce attacks targeting you by a total of 20 or more through Shield effects in a single round',
    ),
    Mastery(
      masteryClassCode: _sunkeeper,
      masteryDetails: 'LIGHT or consume_LIGHT during each of your turns',
    ),
    Mastery(
      masteryClassCode: _quartermaster,
      masteryDetails:
          "Spend, lose, or refresh one or more items on each of your turns without ever performing the top action of 'Reinforced Steel'",
    ),
    Mastery(
      masteryClassCode: _quartermaster,
      masteryDetails: 'Loot six or more loot tokens in a single turn',
    ),
    Mastery(
      masteryClassCode: _summoner,
      masteryDetails:
          'Summon the Lava Golem on your first turn and keep it alive for the entire scenario',
    ),
    Mastery(
      masteryClassCode: _summoner,
      masteryDetails:
          'Perform the summon action of five different ability cards',
    ),
    Mastery(
      masteryClassCode: _nightshround,
      masteryDetails:
          'Have INVISIBLE at the start or end of each of your turns',
    ),
    Mastery(
      masteryClassCode: _nightshround,
      masteryDetails: 'DARK or consume_DARK during each of your turns',
    ),
    Mastery(
      masteryClassCode: _plagueherald,
      masteryDetails: 'Kill at least five enemies with non-attack abilities',
    ),
    Mastery(
      masteryClassCode: _plagueherald,
      masteryDetails:
          'Perform three different attack abilities that target at least four enemies each',
    ),
    Mastery(
      masteryClassCode: _berserker,
      masteryDetails:
          "Lose at least one hit point during each of your turns, without ever performing the bottom action of 'Blood Pact'",
    ),
    Mastery(
      masteryClassCode: _berserker,
      masteryDetails:
          'Have exactly one hit point at the end of each of your turns',
    ),
    Mastery(
      masteryClassCode: _soothsinger,
      masteryDetails:
          'On your first turn of the scenario and the turn after each of your rests, perform one Song action that you have not yet performed this scenario',
    ),
    Mastery(
      masteryClassCode: _soothsinger,
      masteryDetails:
          'Have all 10 monster CURSE cards and all 10 BLESS cards in modifier decks at the same time',
    ),
    Mastery(
      masteryClassCode: _doomstalker,
      masteryDetails:
          'Never perform a Doom action that you have already performed in the scenario',
    ),
    Mastery(
      masteryClassCode: _doomstalker,
      masteryDetails: 'Kill three Doomed enemies during one of your turns',
    ),
    Mastery(
      masteryClassCode: _sawbones,
      masteryDetails:
          "On each of your turns, give an ally an ability card, target an ally with a HEAL ability, grant an ally SHIELD, or place an ability card in an ally's active area",
    ),
    Mastery(
      masteryClassCode: _sawbones,
      masteryDetails: 'Deal at least DAMAGE 20 with a single attack ability',
    ),
    Mastery(
      masteryClassCode: _elementalist,
      masteryDetails:
          "Consume at least two different elements with each of four different attack abilities without ever performing the bottom action of 'Formless Power' or 'Shaping the Ether'",
    ),
    Mastery(
      masteryClassCode: _elementalist,
      masteryDetails:
          'Infuse five or more elements during one of your turns, then consume five or more elements during your following turn',
    ),
    Mastery(
      masteryClassCode: _beastTyrant,
      masteryDetails:
          'Have your bear summon deal DAMAGE 10 or more in three consecutive rounds',
    ),
    Mastery(
      masteryClassCode: _beastTyrant,
      masteryDetails:
          'You or your summons must apply a negative condition to at least 10 different enemies',
    ),
    Mastery(
      masteryClassCode: _bladeswarm,
      masteryDetails:
          'Perform two different summon actions on your first turn and keep all summons from those actions alive for the entire scenario',
    ),
    Mastery(
      masteryClassCode: _bladeswarm,
      masteryDetails:
          'Perform three different non-summon persistent loss actions before your first rest',
    ),
    Mastery(
      masteryClassCode: _diviner,
      masteryDetails:
          'During one round, have at least four monsters move into four different Rifts that affect those monsters',
    ),
    Mastery(
      masteryClassCode: _diviner,
      masteryDetails:
          'Reveal at least one card from at least one ability card deck or attack modifier deck each round',
    ),
    // JAWS OF THE LION
    Mastery(
      masteryClassCode: _demolitionist,
      masteryDetails:
          'Deal DAMAGE 10 or more with each of three different attack actions',
    ),
    Mastery(
      masteryClassCode: _demolitionist,
      masteryDetails:
          'Destroy at least six obstacles. End the scenario with no obstacles on the map other than ones placed by allies',
    ),
    Mastery(
      masteryClassCode: _hatchet,
      masteryDetails: 'AIR or consume_AIR during each of your turns',
    ),
    Mastery(
      masteryClassCode: _hatchet,
      masteryDetails:
          'During each round in which there is at least one enemy on the map at the start of your turn, either place one of your tokens on an ability card of yours or on an enemy',
    ),
    Mastery(
      masteryClassCode: _redGuard,
      masteryDetails: 'Kill at least five enemies during their turns',
    ),
    Mastery(
      masteryClassCode: _redGuard,
      masteryDetails:
          'Force each enemy in the scenario to move at least one hex, forcing at least six enemies to move',
    ),
    Mastery(
      masteryClassCode: _voidwarden,
      masteryDetails:
          'Cause enemies to suffer DAMAGE 20 or more in a single turn with granted or commanded attacks',
    ),
    Mastery(
      masteryClassCode: _voidwarden,
      masteryDetails:
          'Give at least one ally or enemy POISON, STRENGTHEN, BLESS, or WARD each round',
    ),
    // FROSTHAVEN
    Mastery(
      masteryClassCode: 'drifter',
      masteryDetails:
          'End a scenario with your character tokens on the last use slots of four persistent abilities',
    ),
    Mastery(
      masteryClassCode: 'drifter',
      masteryDetails:
          'Never perform a move or attack ability with a value less than 4, and perform at least one move or attack ability every round',
    ),
    Mastery(
      masteryClassCode: 'blinkblade',
      masteryDetails: 'Declare Fast seven rounds in a row',
    ),
    Mastery(
      masteryClassCode: 'blinkblade',
      masteryDetails: 'Never be targeted by an attack',
    ),
    Mastery(
      masteryClassCode: 'bannerspear',
      masteryDetails:
          'Attack at least three targets with three different area of effect attacks',
    ),
    Mastery(
      masteryClassCode: 'bannerspear',
      masteryDetails:
          'Play a Banner summon ability on your first turn, always have it within RANGE 3 of you, and keep it alive for the entire scenario',
    ),
    Mastery(
      masteryClassCode: 'deathwalker',
      masteryDetails: 'Consume seven SHADOW in one round',
    ),
    Mastery(
      masteryClassCode: 'deathwalker',
      masteryDetails: 'Create or consume at least one SHADOW every round',
    ),
    Mastery(
      masteryClassCode: 'boneshaper',
      masteryDetails: 'Kill at least 15 of your summons',
    ),
    Mastery(
      masteryClassCode: 'boneshaper',
      masteryDetails:
          'Play a summon action on your first turn, have this summon kill at least 6 enemies, and keep it alive for the entire scenario',
    ),
    Mastery(
      masteryClassCode: 'geminate',
      masteryDetails: 'Switch forms every round',
    ),
    Mastery(
      masteryClassCode: 'geminate',
      masteryDetails: 'Lose at least one card every round',
    ),
    Mastery(
      masteryClassCode: 'geminate',
      masteryDetails: 'Switch forms every round',
    ),
    Mastery(
      masteryClassCode: 'geminate',
      masteryDetails: 'Lose at least one card every round',
    ),
    Mastery(
      masteryClassCode: 'infuser',
      masteryDetails: 'Have five active INFUSION bonuses',
    ),
    Mastery(
      masteryClassCode: 'infuser',
      masteryDetails: 'Kill at least four enemies, but never attack',
    ),
    Mastery(
      masteryClassCode: 'pyroclast',
      masteryDetails:
          'Create or destroy at least one obstacle or hazardous terrain tile each round',
    ),
    Mastery(
      masteryClassCode: 'pyroclast',
      masteryDetails:
          'Move enemies through six different hexes of hazardous terrain you created in one turn',
    ),
    Mastery(
      masteryClassCode: 'shattersong',
      // TODO: add this icon
      masteryDetails:
          'Always have 0 RESONANCE directly before you gain RESONANCE at the end of each of your turns',
    ),
    Mastery(
      masteryClassCode: 'shattersong',
      masteryDetails:
          'Spend 5 RESONANCE of each of five different wave abilities',
    ),
    Mastery(
      masteryClassCode: 'trapper',
      masteryDetails:
          'Have one HEAL trap on the map with a value of at least 20',
    ),
    Mastery(
      masteryClassCode: 'trapper',
      masteryDetails:
          'Move enemies through seven or more traps with one ability',
    ),
    Mastery(
      masteryClassCode: 'painconduit',
      masteryDetails:
          'Cause other figures to suffer a total of at least DAMAGE 40 in one round',
    ),
    Mastery(
      masteryClassCode: 'painconduit',
      masteryDetails:
          // TODO: get this BANE icon
          'Start a turn with WOUND, BRITTLE, BAIN, POISON, IMMOBILIZE, DISARM, STUN, and MUDDLE',
    ),
    Mastery(
      masteryClassCode: 'snowdancer',
      masteryDetails: 'Cause at least one ally or enemy to move each round',
    ),
    Mastery(
      masteryClassCode: 'snowdancer',
      masteryDetails:
          'Ensure the first ally to suffer DAMAGE each round, directly before suffering the DAMAGE, has at least one condition you applied',
    ),
    Mastery(
      masteryClassCode: 'fozenfist',
      masteryDetails:
          'Recover at least one card from your discard pile each round',
    ),
    Mastery(
      masteryClassCode: 'frozenfist',
      masteryDetails:
          'Enter at least ten different hexes with one move ability, then cause one enemy to suffer at least DAMAGE 10 with one attack ability in the same turn',
    ),
    Mastery(
      masteryClassCode: 'fozenfist',
      masteryDetails:
          'Recover at least one card from your discard pile each round',
    ),
    Mastery(
      masteryClassCode: 'frozenfist',
      masteryDetails:
          'Enter at least ten different hexes with one move ability, then cause one enemy to suffer at least DAMAGE 10 with one attack ability in the same turn',
    ),
    Mastery(
      masteryClassCode: 'hive',
      // TODO: get this icon and name
      masteryDetails: '_ICON_ each round',
    ),
    Mastery(
      masteryClassCode: 'hive',
      masteryDetails: '_ICON_ into four different summons in one round',
    ),
    Mastery(
      masteryClassCode: 'metalmosaic',
      masteryDetails: 'Never attack',
    ),
    Mastery(
      masteryClassCode: 'metalmosaic',
      masteryDetails:
          //TODO: get this icon
          'For four consecutive rounds, move the pressure gauge up or down three levels from where it started the round(LOW_PRESSURE to HIGH_PRESSURE, or vice versa)',
    ),
    Mastery(
      masteryClassCode: 'deepwraith',
      masteryDetails: 'Perform all your attacks with advantage',
    ),
    Mastery(
      masteryClassCode: 'deepwraith',
      masteryDetails: 'Infuse DARK each round',
    ),
    Mastery(
      masteryClassCode: 'crashingtide',
      masteryDetails:
          'Never suffer damage from attacks, and be targeted by at least five attacks',
    ),
    Mastery(
      masteryClassCode: 'crashingtide',
      // TODO: get this icon and confirm what it's called
      masteryDetails:
          'At the start of each of your rests, have more active TIDE than cards in your discard pile',
    ),
    // CUSTOM
    Mastery(
      masteryClassCode: 'incarnate',
      masteryDetails:
          'Never end your turn with the same spirit you started in that turn',
    ),
    Mastery(
      masteryClassCode: 'incarnate',
      masteryDetails:
          'Perform fifteen attacks using One_Hand or Two_Hand items',
    ),
  ];

  static final List<Resource> resources = [
    Resource(
      // 'hide',
      'Hide',
      'images/resources/hide.svg',
    ),
    Resource(
      // 'metal',
      'Metal',
      'images/resources/metal.svg',
    ),
    Resource(
      // 'lumber',
      'Lumber',
      'images/resources/lumber.svg',
    ),
    Resource(
      // 'arrowvine',
      'Arrowvine',
      'images/resources/arrow_vine.svg',
    ),
    Resource(
      // 'axenut',
      'Axenut',
      'images/resources/axe_nut.svg',
    ),
    Resource(
      // 'rockroot',
      'Rockroot',
      'images/resources/rock_root.svg',
    ),
    Resource(
      // 'flamefruit',
      'Flamefruit',
      'images/resources/flame_fruit.svg',
    ),
    Resource(
      // 'corpsecap',
      'Corpsecap',
      'images/resources/corpse_cap.svg',
    ),
    Resource(
      // 'snowthistle',
      'Snowthistle',
      'images/resources/snow_thistle.svg',
    ),
  ];

  static final List<PersonalGoal> personalGoals = [
    PersonalGoal(
      510,
      [
        SubGoal("Complete three 'Crypt' scenarios", 3),
        SubGoal("Complete 'Noxious Cellar' ($_scenario 52", 1),
      ],
      'Seeker of Xorn',
      _plagueherald,
    ),
  ];
}
