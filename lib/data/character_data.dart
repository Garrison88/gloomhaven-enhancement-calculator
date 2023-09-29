import 'package:gloomhaven_enhancement_calc/models/goal.dart';
import 'package:gloomhaven_enhancement_calc/models/legacy_perk.dart' as legacy;
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/legacy_mastery.dart'
    as legacy;
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/models/personal_goal.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/models/resource.dart';

abstract class CharacterData {
  static Map<Variant, String> classVariants = {
    Variant.base: 'Base',
    Variant.frosthavenCrossover: 'Frosthaven Crossover',
    Variant.v2: 'Version II',
    Variant.v3: 'Version III',
  };

  // Keep this to allow for a database migration
  static final List<legacy.Perk> legacyPerks = [
    // BRUTE
    legacy.Perk(_brute, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _brute, 1, '$_remove $_one -1 $_card and $_addL $_one +1 $_card'),
    legacy.Perk(_brute, 2, '$_add $_two +1 $_cards'),
    legacy.Perk(_brute, 1, '$_add $_one +3 $_card'),
    legacy.Perk(_brute, 2, '$_add $_three $_rolling PUSH 1 $_cards'),
    legacy.Perk(_brute, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(_brute, 2, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(_brute, 1,
        '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
    legacy.Perk(_brute, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(_brute, 1, '$_add $_one +1 "$_shield 1, Self" $_card'),
    legacy.Perk(_brute, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    // TINKERER
    legacy.Perk(_tinkerer, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_tinkerer, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_tinkerer, 1, '$_add $_two +1 $_cards'),
    legacy.Perk(_tinkerer, 1, '$_add $_one +3 $_card'),
    legacy.Perk(_tinkerer, 1, '$_add $_two $_rolling FIRE $_cards'),
    legacy.Perk(_tinkerer, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(_tinkerer, 2, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(_tinkerer, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(_tinkerer, 2, '$_add $_one +1 HEAL 2 $_card'),
    legacy.Perk(_tinkerer, 1, '$_add $_one +0 ADD TARGET $_card'),
    legacy.Perk(_tinkerer, 1, 'Ignore $_negative $_scenario $_effects'),
    // SPELLWEAVER
    legacy.Perk(_spellweaver, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _spellweaver, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_spellweaver, 2, '$_add $_two +1 $_cards'),
    legacy.Perk(_spellweaver, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(_spellweaver, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(_spellweaver, 1, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(_spellweaver, 1, '$_add $_one +1 CURSE $_card'),
    legacy.Perk(_spellweaver, 2, '$_add $_one +2 FIRE $_card'),
    legacy.Perk(_spellweaver, 2, '$_add $_one +2 ICE $_card'),
    legacy.Perk(_spellweaver, 1,
        '$_add $_one $_rolling EARTH and $_one $_rolling AIR $_card'),
    legacy.Perk(_spellweaver, 1,
        '$_add $_one $_rolling LIGHT and $_one $_rolling DARK $_card'),
    // SCOUNDREL
    legacy.Perk(_scoundrel, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_scoundrel, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _scoundrel, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(
        _scoundrel, 1, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(
        _scoundrel, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_scoundrel, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(_scoundrel, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(_scoundrel, 2, '$_add $_two $_rolling POISON $_cards'),
    legacy.Perk(_scoundrel, 1, '$_add $_two $_rolling MUDDLE $_cards'),
    legacy.Perk(_scoundrel, 1, '$_add $_one $_rolling INVISIBLE $_card'),
    legacy.Perk(_scoundrel, 1, 'Ignore $_negative $_scenario $_effects'),
    // CRAGHEART
    legacy.Perk(_cragheart, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _cragheart, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_cragheart, 1, '$_add $_one -2 $_card and $_two +2 $_cards'),
    legacy.Perk(_cragheart, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(_cragheart, 2, '$_add $_one +2 MUDDLE $_card'),
    legacy.Perk(_cragheart, 1, '$_add $_two $_rolling PUSH 2 $_cards'),
    legacy.Perk(_cragheart, 2, '$_add $_two $_rolling EARTH $_cards'),
    legacy.Perk(_cragheart, 1, '$_add $_two $_rolling AIR $_cards'),
    legacy.Perk(_cragheart, 1, 'Ignore $_negative item $_effects'),
    legacy.Perk(_cragheart, 1, 'Ignore $_negative $_scenario $_effects'),
    // MINDTHIEF
    legacy.Perk(_mindthief, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_mindthief, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _mindthief, 1, '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    legacy.Perk(
        _mindthief, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_mindthief, 2, '$_add $_one +2 ICE $_card'),
    legacy.Perk(_mindthief, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(_mindthief, 1, '$_add $_three $_rolling PULL 1 $_cards'),
    legacy.Perk(_mindthief, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(_mindthief, 1, '$_add $_two $_rolling $_immobilize $_cards'),
    legacy.Perk(_mindthief, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(_mindthief, 1,
        '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
    legacy.Perk(_mindthief, 1, 'Ignore $_negative $_scenario $_effects'),
    // SUNKEEPER
    legacy.Perk(_sunkeeper, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_sunkeeper, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _sunkeeper, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(
        _sunkeeper, 1, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_sunkeeper, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(_sunkeeper, 2, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(_sunkeeper, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(_sunkeeper, 2, '$_add $_two $_rolling LIGHT $_cards'),
    legacy.Perk(
        _sunkeeper, 1, '$_add $_two $_rolling "$_shield 1, Self" $_cards'),
    legacy.Perk(_sunkeeper, 1,
        'Ignore $_negative item $_effects and $_addL $_two +1 $_cards'),
    legacy.Perk(_sunkeeper, 1, 'Ignore $_negative $_scenario $_effects'),
    // QUARTERMASTER
    legacy.Perk(_quartermaster, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_quartermaster, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _quartermaster, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_quartermaster, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(_quartermaster, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(_quartermaster, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(_quartermaster, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(_quartermaster, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(_quartermaster, 3, '$_add $_one +0 "RECOVER an item" $_card'),
    legacy.Perk(_quartermaster, 1,
        'Ignore $_negative item $_effects and $_addL $_two +1 $_cards'),
    // SUMMONER
    legacy.Perk(_summoner, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_summoner, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_summoner, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_summoner, 2, '$_add $_one +2 $_card'),
    legacy.Perk(_summoner, 1, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(_summoner, 1, '$_add $_two $_rolling POISON $_cards'),
    legacy.Perk(_summoner, 3, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(_summoner, 1,
        '$_add $_one $_rolling FIRE and $_one $_rolling AIR $_card'),
    legacy.Perk(_summoner, 1,
        '$_add $_one $_rolling DARK and $_one $_rolling EARTH $_card'),
    legacy.Perk(_summoner, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // NIGHTSHROUD
    legacy.Perk(_nightshroud, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_nightshroud, 1, '$_remove four +0 $_cards'),
    legacy.Perk(_nightshroud, 2, '$_add $_one -1 DARK $_card'),
    legacy.Perk(_nightshroud, 2,
        '$_replace $_one -1 DARK $_card with $_one +1 DARK $_card'),
    legacy.Perk(_nightshroud, 2, '$_add $_one +1 INVISIBLE $_card'),
    legacy.Perk(_nightshroud, 2, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(_nightshroud, 1, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(_nightshroud, 1, '$_add $_two $_rolling CURSE $_cards'),
    legacy.Perk(_nightshroud, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(_nightshroud, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // PLAGUEHERALD
    legacy.Perk(
        _plagueherald, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(
        _plagueherald, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(
        _plagueherald, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_plagueherald, 1, '$_add $_two +1 $_cards'),
    legacy.Perk(_plagueherald, 3, '$_add $_one +1 AIR $_card'),
    legacy.Perk(_plagueherald, 1, '$_add $_three $_rolling POISON $_cards'),
    legacy.Perk(_plagueherald, 1, '$_add $_two $_rolling CURSE $_cards'),
    legacy.Perk(_plagueherald, 1, '$_add $_two $_rolling $_immobilize $_cards'),
    legacy.Perk(_plagueherald, 2, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(_plagueherald, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // BERSERKER
    legacy.Perk(_berserker, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_berserker, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _berserker, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_berserker, 2,
        '$_replace $_one +0 $_card with $_one $_rolling +2 $_card'),
    legacy.Perk(_berserker, 2, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(_berserker, 2, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(_berserker, 1, '$_add $_one $_rolling +1 DISARM $_card'),
    legacy.Perk(_berserker, 1, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(_berserker, 2, '$_add $_one +2 FIRE $_card'),
    legacy.Perk(_berserker, 1, 'Ignore $_negative item $_effects'),
    //SOOTHSINGER
    legacy.Perk(_soothsinger, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_soothsinger, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(
        _soothsinger, 2, '$_replace $_two +1 $_cards with $_one +4 $_card'),
    legacy.Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +1 DISARM $_card'),
    legacy.Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 WOUND $_card'),
    legacy.Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 POISON $_card'),
    legacy.Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
    legacy.Perk(_soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
    legacy.Perk(
        _soothsinger, 1, '$_replace $_one -1 $_card with $_one +0 STUN $_card'),
    legacy.Perk(_soothsinger, 1, '$_add $_three $_rolling +1 $_cards'),
    legacy.Perk(_soothsinger, 2, '$_add $_two $_rolling CURSE $_cards'),
    // DOOMSTALKER
    legacy.Perk(_doomstalker, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _doomstalker, 3, '$_replace $_two +0 $_cards with $_two +1 $_cards'),
    legacy.Perk(_doomstalker, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(_doomstalker, 1, '$_add $_one +2 MUDDLE $_card'),
    legacy.Perk(_doomstalker, 1, '$_add $_one +1 POISON $_card'),
    legacy.Perk(_doomstalker, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(_doomstalker, 1, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(_doomstalker, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(_doomstalker, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(_doomstalker, 1, 'Ignore $_negative $_scenario $_effects'),
    // SAWBONES
    legacy.Perk(_sawbones, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_sawbones, 1, '$_remove four +0 $_cards'),
    legacy.Perk(_sawbones, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_sawbones, 2, '$_add $_one $_rolling +2 $_card'),
    legacy.Perk(_sawbones, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(_sawbones, 2, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(_sawbones, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(_sawbones, 2, '$_add $_one $_rolling HEAL 3 $_card'),
    legacy.Perk(_sawbones, 1, '$_add $_one +0 "RECOVER an item" $_card'),
    // ELEMENTALIST
    legacy.Perk(_elementalist, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _elementalist, 1, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(
        _elementalist, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_elementalist, 1, '$_add $_three +0 FIRE $_cards'),
    legacy.Perk(_elementalist, 1, '$_add $_three +0 ICE $_cards'),
    legacy.Perk(_elementalist, 1, '$_add $_three +0 AIR $_cards'),
    legacy.Perk(_elementalist, 1, '$_add $_three +0 EARTH $_cards'),
    legacy.Perk(_elementalist, 1,
        '$_replace $_two +0 $_cards with $_one +0 FIRE $_card and $_one +0 EARTH $_card'),
    legacy.Perk(_elementalist, 1,
        '$_replace $_two +0 $_cards with $_one +0 ICE $_card and $_one +0 AIR $_card'),
    legacy.Perk(_elementalist, 1, '$_add $_two +1 PUSH 1 $_cards'),
    legacy.Perk(_elementalist, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(_elementalist, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(_elementalist, 1, '$_add $_one +0 ADD TARGET $_card'),
    // BEAST TYRANT
    legacy.Perk(_beastTyrant, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _beastTyrant, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(
        _beastTyrant, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_beastTyrant, 2, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(_beastTyrant, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(_beastTyrant, 3, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(_beastTyrant, 1, '$_add $_two $_rolling EARTH $_cards'),
    legacy.Perk(_beastTyrant, 1, 'Ignore $_negative $_scenario $_effects'),
    // BLADESWARM
    legacy.Perk(_bladeswarm, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(_bladeswarm, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 AIR $_card'),
    legacy.Perk(
        _bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 EARTH $_card'),
    legacy.Perk(
        _bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 LIGHT $_card'),
    legacy.Perk(
        _bladeswarm, 1, '$_replace $_one -1 $_card with $_one +1 DARK $_card'),
    legacy.Perk(_bladeswarm, 2, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(_bladeswarm, 2, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(_bladeswarm, 2, '$_add $_one +1 POISON $_card'),
    legacy.Perk(_bladeswarm, 1, '$_add $_one +2 MUDDLE $_card'),
    legacy.Perk(_bladeswarm, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(_bladeswarm, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // DIVINER
    legacy.Perk(_diviner, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_diviner, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(_diviner, 2,
        '$_replace $_two +1 $_cards with $_one +3 "$_shield 1, Self" $_card'),
    legacy.Perk(_diviner, 1,
        '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Affect any Ally" $_card'),
    legacy.Perk(
        _diviner, 1, '$_replace $_one +0 $_card with $_one +2 DARK $_card'),
    legacy.Perk(
        _diviner, 1, '$_replace $_one +0 $_card with $_one +2 LIGHT $_card'),
    legacy.Perk(
        _diviner, 1, '$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
    legacy.Perk(
        _diviner, 1, '$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
    legacy.Perk(_diviner, 1,
        '$_replace $_one +0 $_card with $_one +2 "$_regenerate, Self" $_card'),
    legacy.Perk(_diviner, 1,
        '$_replace $_one -1 $_card with $_one +1 "HEAL 2, Affect any Ally" $_card'),
    legacy.Perk(_diviner, 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    legacy.Perk(_diviner, 1, '$_add $_two $_rolling CURSE $_cards'),
    legacy.Perk(_diviner, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // DEMOLITIONIST
    legacy.Perk(_demolitionist, 1, '$_remove four +0 $_cards'),
    legacy.Perk(_demolitionist, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _demolitionist, 1, '$_remove $_one -2 $_card and $_one +1 $_card'),
    legacy.Perk(_demolitionist, 2,
        '$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
    legacy.Perk(_demolitionist, 1,
        '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    legacy.Perk(_demolitionist, 2, '$_add $_one +2 $_card'),
    legacy.Perk(_demolitionist, 2,
        '$_replace $_one +1 $_card with $_one +2 EARTH $_card'),
    legacy.Perk(_demolitionist, 2,
        '$_replace $_one +1 $_card with $_one +2 FIRE $_card'),
    legacy.Perk(_demolitionist, 2,
        '$_add $_one +0 "All adjacent enemies suffer 1 DAMAGE" $_card'),
    // HATCHET
    legacy.Perk(_hatchet, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _hatchet, 1, '$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
    legacy.Perk(
        _hatchet, 1, '$_replace $_one +0 $_card with $_one +1 POISON $_card'),
    legacy.Perk(
        _hatchet, 1, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(_hatchet, 1,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(
        _hatchet, 1, '$_replace $_one +0 $_card with $_one +1 PUSH 2 $_card'),
    legacy.Perk(
        _hatchet, 1, '$_replace $_one +0 $_card with $_one +0 STUN $_card'),
    legacy.Perk(
        _hatchet, 1, '$_replace $_one +1 $_card with $_one +1 STUN $_card'),
    legacy.Perk(_hatchet, 3, '$_add $_one +2 AIR $_card'),
    legacy.Perk(_hatchet, 3, '$_replace $_one +1 $_card with $_one +3 $_card'),
    // RED GUARD
    legacy.Perk(_redGuard, 1, '$_remove four +0 $_cards'),
    legacy.Perk(_redGuard, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_redGuard, 1, '$_remove $_one -2 $_card and $_one +1 $_card'),
    legacy.Perk(_redGuard, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(
        _redGuard, 2, '$_replace $_one +1 $_card with $_one +2 FIRE $_card'),
    legacy.Perk(
        _redGuard, 2, '$_replace $_one +1 $_card with $_one +2 LIGHT $_card'),
    legacy.Perk(_redGuard, 2, '$_add $_one +1 FIRE&LIGHT $_card'),
    legacy.Perk(_redGuard, 2, '$_add $_one +1 $_shield 1 $_card'),
    legacy.Perk(_redGuard, 1,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(
        _redGuard, 1, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    // VOIDWARDEN
    legacy.Perk(_voidwarden, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_voidwarden, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(
        _voidwarden, 2, '$_replace $_one +0 $_card with $_one +1 DARK $_card'),
    legacy.Perk(
        _voidwarden, 2, '$_replace $_one +0 $_card with $_one +1 ICE $_card'),
    legacy.Perk(_voidwarden, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Ally" $_card'),
    legacy.Perk(_voidwarden, 3, '$_add $_one +1 "HEAL 1, Ally" $_card'),
    legacy.Perk(_voidwarden, 1, '$_add $_one +1 POISON $_card'),
    legacy.Perk(_voidwarden, 1, '$_add $_one +3 $_card'),
    legacy.Perk(_voidwarden, 2, '$_add $_one +1 CURSE $_card'),
    // AMBER AEGIS
    legacy.Perk(_amberAegis, 1,
        '$_replace $_one -2 $_card with $_one -1 "Place $_one Colony token of your choice on any empty hex within RANGE 2" $_card'),
    legacy.Perk(_amberAegis, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_amberAegis, 1, '$_remove four +0 $_cards'),
    legacy.Perk(_amberAegis, 1,
        '$_replace $_one -1 $_card with $_one +2 MUDDLE $_card'),
    legacy.Perk(_amberAegis, 1,
        '$_replace $_one -1 $_card with $_one +1 POISON $_card'),
    legacy.Perk(
        _amberAegis, 1, '$_replace $_one -1 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(
        _amberAegis, 2, '$_add $_two $_rolling +1 $_immobilize $_cards'),
    legacy.Perk(_amberAegis, 2,
        '$_add $_one $_rolling "HEAL 1, Self" $_card and $_one $_rolling "$_shield 1, Self" $_card'),
    legacy.Perk(_amberAegis, 2,
        '$_add $_one $_rolling "$_retaliate 1, RANGE 3" $_card'),
    legacy.Perk(_amberAegis, 1, '$_add $_one +2 FIRE/EARTH $_card'),
    legacy.Perk(_amberAegis, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(_amberAegis, 1,
        'Ignore $_scenario $_effects and $_addL $_one "+X, where X is the number of active Cultivate actions" card'),
    // ARTIFICER
    legacy.Perk(_artificer, 1,
        '$_replace $_one -2 $_card with $_one -1 Any_Element $_card'),
    legacy.Perk(
        _artificer, 1, '$_replace $_one -1 $_card with $_one +1 DISARM $_card'),
    legacy.Perk(
        _artificer, 2, '$_replace $_one -1 $_card with $_one +1 PUSH 1 $_card'),
    legacy.Perk(
        _artificer, 2, '$_replace $_one -1 $_card with $_one +1 PULL 1 $_card'),
    legacy.Perk(_artificer, 2,
        '$_replace $_one +0 $_card with $_one +0 "RECOVER a spent item" $_card'),
    legacy.Perk(_artificer, 2,
        '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Self" $_card'),
    legacy.Perk(_artificer, 2,
        '$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
    legacy.Perk(_artificer, 1,
        '$_replace $_one +2 $_card with $_one +3 "HEAL 2, Self" $_card'),
    legacy.Perk(_artificer, 1,
        '$_replace $_two +1 $_cards with $_two $_rolling +1 POISON $_cards'),
    legacy.Perk(_artificer, 1,
        '$_replace $_two +1 $_cards with $_two $_rolling +1 WOUND $_cards'),
    // BOMBARD
    legacy.Perk(_bombard, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_bombard, 1,
        '$_replace $_two +0 $_cards with $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(_bombard, 2,
        '$_replace $_one -1 $_card with $_one +0 "+3 if Projectile" $_card'),
    legacy.Perk(_bombard, 2, '$_add $_one +2 $_immobilize $_card'),
    legacy.Perk(_bombard, 1,
        '$_replace $_one +1 $_card with $_two +1 "$_retaliate 1, RANGE 3" $_cards'),
    legacy.Perk(_bombard, 1,
        '$_add $_two +1 "PULL 3, Self, toward the target" $_cards'),
    legacy.Perk(_bombard, 1, '$_add $_one +0 "STRENGTHEN, Self" $_card'),
    legacy.Perk(_bombard, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(_bombard, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(
        _bombard, 1, '$_add $_two $_rolling "$_shield 1, Self" $_cards'),
    legacy.Perk(_bombard, 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    legacy.Perk(_bombard, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    legacy.Perk(_bombard, 1,
        'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
    // BREWMASTER
    legacy.Perk(
        _brewmaster, 1, '$_replace $_one -2 $_card with $_one -1 STUN $_card'),
    legacy.Perk(
        _brewmaster, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_brewmaster, 2,
        '$_replace $_one -1 $_card with $_two $_rolling MUDDLE $_cards'),
    legacy.Perk(_brewmaster, 1,
        '$_replace $_two +0 $_cards with $_two +0 "HEAL 1, Self" $_cards'),
    legacy.Perk(_brewmaster, 2,
        '$_replace $_one +0 $_card with $_one +0 "Give yourself or an adjacent Ally a \'Liquid Rage\' item $_card" $_card'),
    legacy.Perk(_brewmaster, 2, '$_add $_one +2 PROVOKE $_card'),
    legacy.Perk(_brewmaster, 2, '$_add four $_rolling Shrug_Off 1 $_cards'),
    legacy.Perk(_brewmaster, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(_brewmaster, 2, 'Each time you long rest, perform Shrug_Off 1'),
    // BRIGHTSPARK
    legacy.Perk(_brightspark, 3,
        '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element to $_addL +2 ATTACK" $_card'),
    legacy.Perk(_brightspark, 1,
        '$_replace $_one -2 $_card with $_one -2 "RECOVER $_one random $_card from your discard pile" $_card'),
    legacy.Perk(_brightspark, 2,
        '$_replace $_two +0 $_cards with $_one +1 "HEAL 1, Affect $_one Ally within RANGE 2" $_card'),
    legacy.Perk(_brightspark, 1,
        '$_replace $_two +0 $_cards with $_one +1 "$_shield 1, Affect $_one Ally within RANGE 2" $_card'),
    legacy.Perk(_brightspark, 2,
        '$_replace $_one +1 $_card with $_one +2 Any_Element $_card'),
    legacy.Perk(_brightspark, 2,
        '$_add $_one +1 "STRENGTHEN, Affect $_one Ally within RANGE 2" $_card'),
    legacy.Perk(_brightspark, 1,
        '$_add $_one $_rolling "PUSH 1 or PULL 1, AIR" $_card and $_one $_rolling "$_immobilize, ICE" $_card'),
    legacy.Perk(_brightspark, 1,
        '$_add $_one $_rolling "HEAL 1, RANGE 3, LIGHT" $_card and $_one $_rolling "PIERCE 2, FIRE" $_card'),
    legacy.Perk(_brightspark, 1,
        '$_add $_three $_rolling "Consume_Any_Element : Any_Element" $_cards'),
    legacy.Perk(_brightspark, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
    // CHIEFTAIN
    legacy.Perk(
        _chieftain, 1, '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    legacy.Perk(_chieftain, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Chieftain" $_card'),
    legacy.Perk(_chieftain, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Affect all summoned allies owned" $_card'),
    legacy.Perk(_chieftain, 1,
        '$_replace $_one -2 $_card with $_one -2 "BLESS, Self" $_card'),
    legacy.Perk(_chieftain, 1,
        '$_replace $_two +0 $_cards with $_one +0 "$_immobilize and PUSH 1" $_card'),
    legacy.Perk(_chieftain, 2,
        '$_replace $_one +0 $_card with $_one "+X, where X is the number of summoned allies you own" $_card'),
    legacy.Perk(_chieftain, 1,
        '$_replace $_one +1 $_card with $_two +1 "$_rolling +1, if summon is attacking" $_cards'),
    legacy.Perk(_chieftain, 1, '$_add $_one +0 WOUND, PIERCE 1 $_card'),
    legacy.Perk(_chieftain, 2, '$_add $_one +1 EARTH $_card'),
    legacy.Perk(_chieftain, 1,
        '$_add $_two $_rolling "PIERCE 2, ignore $_retaliate on the target" $_cards'),
    legacy.Perk(_chieftain, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // FIRE KNIGHT
    legacy.Perk(_fireKnight, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_fireKnight, 2,
        '$_replace $_one -1 $_card with $_one +0 "STRENGTHEN, Ally" $_card'),
    legacy.Perk(_fireKnight, 2,
        '$_replace $_two +0 $_cards with $_two +0 "+2 if you are on Ladder" $_cards'),
    legacy.Perk(
        _fireKnight, 1, '$_replace $_one +0 $_card with $_one +1 FIRE $_card'),
    legacy.Perk(
        _fireKnight, 1, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(
        _fireKnight, 1, '$_replace $_two +1 $_cards with $_one +2 FIRE $_card'),
    legacy.Perk(_fireKnight, 1,
        '$_replace $_two +1 $_cards with $_one +2 WOUND $_card'),
    legacy.Perk(_fireKnight, 1, '$_add $_one +1 "STRENGTHEN, Ally" $_card'),
    legacy.Perk(
        _fireKnight, 2, '$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards'),
    legacy.Perk(_fireKnight, 1, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(_fireKnight, 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling FIRE $_card'),
    legacy.Perk(_fireKnight, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one $_rolling FIRE $_card'),
    // FROSTBORN
    legacy.Perk(_frostborn, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _frostborn, 1, '$_replace $_one -2 $_card with $_one +0 CHILL $_card'),
    legacy.Perk(_frostborn, 2,
        '$_replace $_two +0 $_cards with $_two +1 PUSH 1 $_cards'),
    legacy.Perk(_frostborn, 2,
        '$_replace $_one +0 $_card with $_one +1 ICE CHILL $_card'),
    legacy.Perk(
        _frostborn, 1, '$_replace $_one +1 $_card with $_one +3 $_card'),
    legacy.Perk(_frostborn, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(_frostborn, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(_frostborn, 1, '$_add $_three $_rolling CHILL $_cards'),
    legacy.Perk(_frostborn, 1, '$_add $_three $_rolling PUSH 1 $_cards'),
    legacy.Perk(_frostborn, 1,
        'Ignore difficult and hazardous terrain during move actions'),
    legacy.Perk(_frostborn, 1, 'Ignore $_scenario $_effects'),
    // HOLLOWPACT
    legacy.Perk(_hollowpact, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 2, Self" $_card'),
    legacy.Perk(_hollowpact, 2,
        '$_replace $_two +0 $_cards with $_one +0 VOIDSIGHT $_card'),
    legacy.Perk(_hollowpact, 2,
        '$_add $_one -2 EARTH $_card and $_two +2 DARK $_cards'),
    legacy.Perk(_hollowpact, 1,
        '$_replace $_one -1 $_card with $_one -2 STUN $_card and $_one +0 VOIDSIGHT $_card'),
    legacy.Perk(_hollowpact, 1,
        '$_replace $_one -2 $_card with $_one +0 DISARM $_card and $_one -1 Any_Element $_card'),
    legacy.Perk(_hollowpact, 2,
        '$_replace $_one -1 $_card with $_one $_rolling +1 VOID $_card and $_one $_rolling -1 CURSE $_card'),
    legacy.Perk(_hollowpact, 2,
        '$_replace $_two +1 $_cards with $_one +3 "$_regenerate, Self" $_card'),
    legacy.Perk(_hollowpact, 2,
        '$_replace $_one +0 $_card with $_one +1 "Create a Void pit in an empty hex within RANGE 2" $_card'),
    legacy.Perk(_hollowpact, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +0 "WARD, Self" $_card'),
    // MIREFOOT
    legacy.Perk(_mirefoot, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_mirefoot, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_mirefoot, 2,
        '$_replace $_two +0 $_cards with $_two "+X, where X is the POISON value of the target" $_cards'),
    legacy.Perk(
        _mirefoot, 1, '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    legacy.Perk(_mirefoot, 2,
        '$_replace $_one +0 $_card with $_two $_rolling "Create difficult terrain in the hex occupied by the target" $_cards'),
    legacy.Perk(
        _mirefoot, 2, '$_replace $_one +1 $_card with $_one +0 WOUND 2 $_card'),
    legacy.Perk(_mirefoot, 1,
        '$_add four $_rolling +0 "+1 if the target occupies difficult terrain" $_cards'),
    legacy.Perk(_mirefoot, 1,
        '$_add $_two $_rolling "INVISIBLE, Self, if you occupy difficult terrain" $_cards'),
    legacy.Perk(_mirefoot, 1,
        'Gain "Poison Dagger" (Item 011). You may carry $_one additional One_Hand item with "Dagger" in its name'),
    legacy.Perk(_mirefoot, 1,
        'Ignore damage, $_negative conditions, and modifiers from Events, and $_removeL $_one -1 $_card'),
    legacy.Perk(_mirefoot, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
    // ROOTWHISPERER
    // May be dead legacy.Perks if Rootwhisperer has a big overhaul - this is fine
    legacy.Perk(_rootwhisperer, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(_rootwhisperer, 1, '$_remove four +0 $_cards'),
    legacy.Perk(
        _rootwhisperer, 2, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(_rootwhisperer, 2, '$_add $_one $_rolling +2 $_card'),
    legacy.Perk(_rootwhisperer, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(_rootwhisperer, 2, '$_add $_two $_rolling POISON $_cards'),
    legacy.Perk(_rootwhisperer, 1, '$_add $_one $_rolling DISARM $_card'),
    legacy.Perk(_rootwhisperer, 2, '$_add $_one $_rolling HEAL 2 EARTH $_card'),
    legacy.Perk(_rootwhisperer, 1, 'Ignore $_negative $_scenario $_effects'),
    // CHAINGUARD
    legacy.Perk(_chainguard, 2,
        '$_replace $_one -1 $_card with $_one +1 Shackle $_card'),
    legacy.Perk(_chainguard, 2,
        '$_replace $_one -1 $_card with $_one +0 "+2 if the target is Shackled" $_card'),
    legacy.Perk(_chainguard, 2,
        '$_replace $_two +0 $_cards with $_one $_rolling "$_shield 1, Self" $_card'),
    legacy.Perk(
        _chainguard, 1, '$_add $_two $_rolling "$_retaliate 1, Self" $_cards'),
    legacy.Perk(_chainguard, 1, '$_add $_three $_rolling SWING 3 $_cards'),
    legacy.Perk(
        _chainguard, 1, '$_replace $_one +1 $_card with $_one +2 WOUND $_card'),
    legacy.Perk(_chainguard, 1,
        '$_add $_one +1 "DISARM if the target is Shackled" $_card'),
    legacy.Perk(_chainguard, 1,
        '$_add $_one +1 "Create a 2 DAMAGE trap in an empty hex within RANGE 2" $_card'),
    legacy.Perk(_chainguard, 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    legacy.Perk(_chainguard, 2, '$_add $_one +2 Shackle $_card'),
    legacy.Perk(_chainguard, 1,
        'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
    // HIEROPHANT
    legacy.Perk(_hierophant, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(_hierophant, 1,
        '$_replace $_two +0 $_cards with $_one $_rolling LIGHT $_card'),
    legacy.Perk(_hierophant, 1,
        '$_replace $_two +0 $_cards with $_one $_rolling EARTH $_card'),
    legacy.Perk(
        _hierophant, 2, '$_replace $_one -1 $_card with $_one +0 CURSE $_card'),
    legacy.Perk(_hierophant, 1,
        '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Ally" $_card'),
    legacy.Perk(_hierophant, 1,
        '$_replace $_one -2 $_card with $_one -1 "Give $_one Ally a \'Prayer\' ability $_card" and $_one +0 $_card'),
    legacy.Perk(
        _hierophant, 2, '$_replace $_one +1 $_card with $_one +3 $_card'),
    legacy.Perk(
        _hierophant, 2, '$_add $_two $_rolling "HEAL 1, Self or Ally" $_cards'),
    legacy.Perk(_hierophant, 2, '$_add $_one +1 WOUND, MUDDLE $_card'),
    legacy.Perk(_hierophant, 1,
        'At the start of your first turn each $_scenario, gain BLESS'),
    legacy.Perk(_hierophant, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // LUMINARY
    legacy.Perk(_luminary, 1, '$_remove four +0 $_cards'),
    legacy.Perk(_luminary, 1, '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(
        _luminary, 1, '$_replace $_one -1 $_card with $_one +0 ICE $_card'),
    legacy.Perk(
        _luminary, 1, '$_replace $_one -1 $_card with $_one +0 FIRE $_card'),
    legacy.Perk(
        _luminary, 1, '$_replace $_one -1 $_card with $_one +0 LIGHT $_card'),
    legacy.Perk(
        _luminary, 1, '$_replace $_one -1 $_card with $_one +0 DARK $_card'),
    legacy.Perk(_luminary, 1,
        '$_replace $_one -2 $_card with $_one -2 "Perform $_one Glow ability" $_card'),
    legacy.Perk(_luminary, 2, '$_add $_one +0 Any_Element $_card'),
    legacy.Perk(_luminary, 2, '$_add $_one $_rolling +1 "HEAL 1, Self" $_card'),
    legacy.Perk(_luminary, 2,
        '$_add $_one "POISON, target all enemies in the depicted LUMINARY_HEXES area" $_card'),
    legacy.Perk(_luminary, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    legacy.Perk(_luminary, 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling "Consume_Any_Element : Any_Element" $_card'),
    // SPIRIT CALLER
    legacy.Perk(_spiritCaller, 1,
        '$_replace $_one -2 $_card with $_one -1 $_card and $_one +1 $_card'),
    legacy.Perk(_spiritCaller, 2,
        '$_replace $_one -1 $_card with $_one +0 "+2 if a Spirit performed the attack" $_card'),
    legacy.Perk(_spiritCaller, 2,
        '$_replace $_one -1 $_card with $_one +0 $_card and $_one $_rolling POISON $_card'),
    legacy.Perk(
        _spiritCaller, 2, '$_replace $_one +0 $_card with $_one +1 AIR $_card'),
    legacy.Perk(_spiritCaller, 2,
        '$_replace $_one +0 $_card with $_one +1 DARK $_card'),
    legacy.Perk(_spiritCaller, 1,
        '$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
    legacy.Perk(_spiritCaller, 1, '$_add $_three $_rolling PIERCE 3 $_cards'),
    legacy.Perk(_spiritCaller, 1, '$_add $_one +1 CURSE $_card'),
    legacy.Perk(_spiritCaller, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(_spiritCaller, 1,
        '$_replace $_one +1 $_card with $_one +2 PUSH 2 $_card'),
    legacy.Perk(_spiritCaller, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // STARSLINGER
    legacy.Perk(_starslinger, 2,
        '$_replace $_two +0 $_cards with $_one $_rolling "HEAL 1, Self" $_card'),
    legacy.Perk(_starslinger, 1,
        '$_replace $_one -2 $_card with $_one -1 "INVISIBLE, Self" $_card'),
    legacy.Perk(_starslinger, 1,
        '$_replace $_two -1 $_cards with $_one +0 DARK $_card'),
    legacy.Perk(_starslinger, 2,
        '$_replace $_one -1 $_card with $_one +1 LIGHT $_card'),
    legacy.Perk(_starslinger, 1, '$_add $_one $_rolling LOOT 1 $_card'),
    legacy.Perk(_starslinger, 2,
        '$_add $_one +1 "+3 if you are at full health" $_card'),
    legacy.Perk(_starslinger, 1, '$_add $_two $_rolling $_immobilize $_cards'),
    legacy.Perk(_starslinger, 2, '$_add $_one +1 "HEAL 1, RANGE 3" $_card'),
    legacy.Perk(_starslinger, 1,
        '$_add $_two $_rolling "Force the target to perform a \'MOVE 1\' ability" $_cards'),
    legacy.Perk(
        _starslinger, 1, '$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards'),
    legacy.Perk(_starslinger, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // RUINMAW
    legacy.Perk(_ruinmaw, 1,
        '$_replace $_one -2 $_card with $_one -1 RUPTURE and WOUND $_card'),
    legacy.Perk(
        _ruinmaw, 2, '$_replace $_one -1 $_card with $_one +0 WOUND $_card'),
    legacy.Perk(
        _ruinmaw, 2, '$_replace $_one -1 $_card with $_one +0 RUPTURE $_card'),
    legacy.Perk(_ruinmaw, 3,
        '$_replace $_one +0 $_card with $_one +1 "$_add +3 instead if the target has RUPTURE or WOUND" $_card'),
    legacy.Perk(_ruinmaw, 3,
        '$_replace $_one +0 $_card with $_one $_rolling "HEAL 1, Self, EMPOWER" $_card'),
    legacy.Perk(_ruinmaw, 1,
        'Once each $_scenario, become SATED after collecting your 5th loot token'),
    legacy.Perk(_ruinmaw, 1,
        'Become SATED each time you lose a $_card to negate suffering damage'),
    legacy.Perk(_ruinmaw, 1,
        'Whenever $_one of your abilities causes at least $_one enemy to gain RUPTURE, immediately after that ability perform "MOVE 1"'),
    legacy.Perk(_ruinmaw, 1,
        'Ignore $_negative $_scenario $_effects, and $_removeL $_one -1 $_card'),
    // ************** ^^ THIS IS AS FAR AS RELEASE 3.7.0 GOES ^^ **************
    // DRIFTER
    legacy.Perk(_drifter, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_drifter, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_drifter, 2,
        '$_replace $_one +1 $_card with $_two +0 "Move $_one of your character tokens backward $_one slot" $_cards'),
    legacy.Perk(_drifter, 1,
        '$_replace $_two +0 $_cards with $_two PIERCE 3 $_rolling $_cards'),
    legacy.Perk(_drifter, 1,
        '$_replace $_two +0 $_cards with $_two PUSH 2 $_rolling $_cards'),
    legacy.Perk(_drifter, 1, '$_add $_one +3 $_card'),
    legacy.Perk(_drifter, 2, '$_add $_one +2 $_immobilize $_card'),
    legacy.Perk(_drifter, 1, '$_add $_two "HEAL 1, self" $_rolling $_cards'),
    legacy.Perk(
        _drifter, 1, 'Ignore $_scenario $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(_drifter, 1,
        'Ignore item item_minus_one $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(_drifter, 2,
        'Whenever you long rest, you may move $_one of your character tokens backward $_one slot',
        perkIsGrouped: true),
    legacy.Perk(_drifter, 1,
        'You may bring $_one additional One_Hand item into each $_scenario'),
    legacy.Perk(_drifter, 1,
        "At the end of each $_scenario, you may discard up to $_two loot $_cards, except 'Random Item', to draw that many new loot $_cards"),
    // BLINK BLADE
    legacy.Perk(_blinkBlade, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(
        _blinkBlade, 2, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(
        _blinkBlade, 2, '$_replace $_one -1 $_card with $_one +0 WOUND $_card'),
    legacy.Perk(_blinkBlade, 2,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(_blinkBlade, 3,
        '$_replace $_one +0 $_card with $_one "Place this $_card in your active area. On your next attack, discard this $_card to $_addL plustwo ATTACK" $_rolling $_card'),
    legacy.Perk(
        _blinkBlade, 1, '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    legacy.Perk(
        _blinkBlade, 2, '$_add $_one -1 "Gain $_one TIME_TOKEN" $_card'),
    legacy.Perk(
        _blinkBlade, 2, '$_add $_one +2 "$_regenerate, self" $_rolling $_card'),
    legacy.Perk(_blinkBlade, 1,
        'Whenever you short rest, you may spend $_one unspent SPENT item for no effect to RECOVER a different spent item'),
    legacy.Perk(_blinkBlade, 1,
        'At the start of your first turn each $_scenario, you may perform MOVE 3'),
    legacy.Perk(_blinkBlade, 1,
        'Whenever you would gain $_immobilize, prevent the condition'),
    // BANNER SPEAR
    legacy.Perk(_bannerSpear, 3,
        '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card'),
    legacy.Perk(_bannerSpear, 2,
        '$_replace $_one +0 $_card with $_one +1 "$_add plusone ATTACK for each ally adjacent to the target" $_card'),
    legacy.Perk(_bannerSpear, 2, '$_add $_one +1 DISARM $_card'),
    legacy.Perk(_bannerSpear, 2, '$_add $_one +2 PUSH 1 $_card'),
    legacy.Perk(_bannerSpear, 2, '$_add $_two +1 $_rolling $_cards'),
    legacy.Perk(
        _bannerSpear, 2, '$_add $_two "HEAL 1, self" $_rolling $_cards'),
    legacy.Perk(_bannerSpear, 1,
        'Ignore item item_minus_one $_effects and $_removeL $_one -1 $_card'),
    legacy.Perk(_bannerSpear, 1,
        'At the end of each of your long rests, grant $_one ally within RANGE 3: MOVE 2'),
    legacy.Perk(_bannerSpear, 1,
        'Whenever you open a door with a move ability, $_addL +3 MOVE'),
    legacy.Perk(_bannerSpear, 2,
        'Once each $_scenario, during your turn, gain $_shield 2 for the round',
        perkIsGrouped: true),
    // DEATHWALKER
    legacy.Perk(_deathwalker, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        _deathwalker, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(
        _deathwalker, 3, '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(_deathwalker, 3,
        '$_replace $_one +0 $_card with $_one +1 CURSE $_card'),
    legacy.Perk(_deathwalker, 2, '$_add $_one +2 DARK $_card'),
    legacy.Perk(_deathwalker, 2,
        '$_add $_one DISARM $_rolling and $_one MUDDLE $_rolling $_card'),
    legacy.Perk(_deathwalker, 2,
        '$_add $_two "HEAL 1, Target 1 ally" $_rolling $_cards'),
    legacy.Perk(_deathwalker, 1, 'Ignore $_scenario $_effects'),
    legacy.Perk(_deathwalker, 1,
        'Whenever you long rest, you may move $_one SHADOW up to 3 hexes'),
    legacy.Perk(_deathwalker, 1,
        'Whenever you short rest, you may consume_DARK to perform MUDDLE, CURSE, RANGE 2 as if you were occupying a hex with a SHADOW'),
    legacy.Perk(_deathwalker, 1,
        'While you are occupying a hex with a SHADOW, all attacks targeting you gain disadvantage'),
    // BONESHAPER
    legacy.Perk(
        _boneshaper, 2, '$_replace $_one -1 $_card with $_one +0 CURSE $_card'),
    legacy.Perk(_boneshaper, 2,
        '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    legacy.Perk(
        _boneshaper, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_boneshaper, 3,
        '$_replace $_one +0 $_card with $_one +1 "Kill the attacking summon to instead $_addL +4" $_card'),
    legacy.Perk(_boneshaper, 2,
        '$_add $_three "HEAL 1, Target Boneshaper" $_rolling $_cards'),
    legacy.Perk(_boneshaper, 3, '$_add $_one +2 EARTH/DARK $_card'),
    legacy.Perk(_boneshaper, 1,
        'Ignore $_scenario $_effects and $_addL $_two +1 $_cards'),
    legacy.Perk(_boneshaper, 1,
        'Immediately before each of your rests, you may kill $_one of your summons to perform BLESS, self'),
    legacy.Perk(_boneshaper, 1,
        'Once each $_scenario, when any character ally would become exhausted by suffering DAMAGE, you may suffer DAMAGE 2 to reduce their hit point value to 1 instead'),
    legacy.Perk(_boneshaper, 2,
        'At the start of each $_scenario, you may play a level 1 $_card from your hand to perform a summon action of the $_card',
        perkIsGrouped: true),
    // GEMINATE
    legacy.Perk(_geminate, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_geminate, 3,
        '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element : Any_Element" $_card'),
    legacy.Perk(
        _geminate, 2, '$_replace $_one +0 $_card with $_one +1 POISON $_card'),
    legacy.Perk(
        _geminate, 2, '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(_geminate, 1,
        '$_replace $_two +0 $_cards with $_two PIERCE 3 $_rolling $_cards'),
    legacy.Perk(_geminate, 1, '$_add $_two +1 PUSH 3 $_cards'),
    legacy.Perk(_geminate, 1, '$_add $_one 2x "BRITTLE, self" $_card'),
    legacy.Perk(
        _geminate, 2, '$_add $_one +1 "$_regenerate, self" $_rolling card'),
    legacy.Perk(_geminate, 1, 'Ignore $_scenario $_effects'),
    legacy.Perk(_geminate, 1,
        'Whenever you short rest, you may $_removeL $_one $_negative condition from $_one ally within RANGE 3'),
    legacy.Perk(_geminate, 1,
        'Once each $_scenario, when you would give yourself a $_negative condition, prevent the condition'),
    legacy.Perk(_geminate, 2,
        'Whenever you perform an action with a lost icon, you may discard $_one $_card to RECOVER $_one card from your discard pile of equal or lower level',
        perkIsGrouped: true),
    // INFUSER
    legacy.Perk(_infuser, 1,
        'Replace one -2 card with one -1 and one -1 AIR EARTH DARK card'),
    legacy.Perk(_infuser, 2, 'Replace one -1 card with one +0 AIR/EARTH card'),
    legacy.Perk(_infuser, 2, 'Replace one -1 card with one +0 AIR/DARK card'),
    legacy.Perk(_infuser, 2, 'Replace one -1 card with one +0 EARTH/DARK card'),
    legacy.Perk(_infuser, 2, 'Replace one +0 card with one +2 card'),
    legacy.Perk(_infuser, 2,
        'Replace one +0 card with three "Move one waning element to strong" $_rolling cards'),
    legacy.Perk(_infuser, 2,
        'Add two "plusone ATTACK for each pair of active INFUSION" $_rolling cards'),
    legacy.Perk(_infuser, 1, 'Ignore $_scenario $_effects'),
    legacy.Perk(_infuser, 1,
        '$_ignoreItemMinusOneEffects. Whenever you become exhausted, keep all your active bonuses in play, with your summons acting on initiative 99 each round'),
    legacy.Perk(_infuser, 1,
        'Whenever you short rest, you may Consume_Any_Element to RECOVER one spent One_Hand or Two_Hand item'),
    legacy.Perk(_infuser, 1,
        'Once each scenario, during ordering of initiative, after all ability cards have been revealed, Any_Element'),
    // PYROCLAST
    legacy.Perk(_pyroclast, 1, 'Remove two -1 cards'),
    legacy.Perk(_pyroclast, 1, 'Remove one -2 card'),
    legacy.Perk(_pyroclast, 2, 'Replace one +0 card with one +1 WOUND card'),
    legacy.Perk(_pyroclast, 2,
        'Replace one -1 card with one +0 "Create one 1-hex hazardous terrain tile in a featureless hex adjacent to the target" card'),
    legacy.Perk(
        _pyroclast, 2, 'Replace two +0 cards with two PUSH 2 $_rolling cards'),
    legacy.Perk(_pyroclast, 1, 'Replace two +1 cards with two +2 cards'),
    legacy.Perk(_pyroclast, 2, 'Add two +1 FIRE/EARTH cards'),
    legacy.Perk(_pyroclast, 1, 'Add two +1 MUDDLE $_rolling cards'),
    legacy.Perk(_pyroclast, 1, _ignoreScenarioEffects),
    legacy.Perk(_pyroclast, 1,
        'Whenever you long rest, you may destroy one adjacent obstacle to gain WARD'),
    legacy.Perk(_pyroclast, 1,
        'Whenever you short rest, you may consume_FIRE to perform WOUND, Target 1 enemy occupying or adjacent to hazardous terrain'),
    legacy.Perk(_pyroclast, 3,
        'You and all allies are unaffected by hazardous terrain you create',
        perkIsGrouped: true),
    // SHATTERSONG
    legacy.Perk(_shattersong, 1, 'Remove four +0 cards'),
    legacy.Perk(_shattersong, 2,
        'Replace two -1 cards with two +0 "Reveal the top card of the target\'s monster ability deck" cards'),
    legacy.Perk(_shattersong, 1, 'Replace one -2 card with one -1 STUN card'),
    legacy.Perk(
        _shattersong, 2, 'Replace one +0 card with one +0 BRITTLE card'),
    legacy.Perk(
        _shattersong, 2, 'Replace two +1 cards with two +2 AIR/LIGHT cards'),
    legacy.Perk(_shattersong, 2,
        'Add one "HEAL 2, BLESS, Target 1 ally" $_rolling card'),
    legacy.Perk(_shattersong, 3, 'Add one +1 "Gain 1 RESONANCE" card'),
    legacy.Perk(_shattersong, 1, _ignoreScenarioEffects),
    legacy.Perk(_shattersong, 2,
        'Whenever you short rest, you may consume_AIR to perform STRENGTHEN, RANGE 3 and consume_LIGHT to perform BLESS, RANGE 3',
        perkIsGrouped: true),
    legacy.Perk(_shattersong, 1,
        'At the start of each scenario, you may gain BRITTLE to gain 2 RESONANCE'),
    legacy.Perk(_shattersong, 1,
        'Whenever a new room is revealed, you may reveal the top card of both the monster attack modifier deck and all allies\' attack modifier decks'),
    // TRAPPER
    legacy.Perk(_trapper, 1, 'Remove one -2 card'),
    legacy.Perk(_trapper, 2,
        'Replace one -1 card with one +0 "Create one HEAL 2 trap in an empty hex adjacent to the target" card'),
    legacy.Perk(_trapper, 3,
        'Replace one -1 card with one +0 "Create one DAMAGE 1 trap in an empty hex adjacent to the target" card'),
    legacy.Perk(_trapper, 3,
        'Replace two +0 cards with two +0 "Add DAMAGE 2 or HEAL 2 to a trap within RANGE 2 of you" cards'),
    legacy.Perk(
        _trapper, 2, 'Replace two +1 cards with two +2 $_immobilize cards'),
    legacy.Perk(_trapper, 3, 'Add two "Add PUSH 2 or PULL 2" $_rolling cards'),
    legacy.Perk(_trapper, 1, _ignoreScenarioEffects),
    legacy.Perk(_trapper, 1,
        'Whenever you long rest, you may create one DAMAGE 1 trap in an adjacent empty hex'),
    legacy.Perk(_trapper, 1,
        'Whenever you enter a hex with a trap, you may choose to not spring the trap'),
    legacy.Perk(_trapper, 1,
        'At the start of each scenario, you may create one DAMAGE 2 trap in an adjacent empty hex'),
    // PAIN CONDUIT
    legacy.Perk(_painConduit, 2, 'Remove two -1 cards'),
    legacy.Perk(
        _painConduit, 1, 'Replace one -2 card with one -2 CURSE CURSE card'),
    legacy.Perk(_painConduit, 1, 'Replace one -1 card with one +0 DISARM card'),
    legacy.Perk(
        _painConduit, 3, 'Replace one +0 card with one +1 FIRE/AIR card'),
    legacy.Perk(_painConduit, 1, 'Replace one +0 card with one +2 card'),
    legacy.Perk(
        _painConduit, 1, 'Replace three +1 cards with three +1 CURSE cards'),
    legacy.Perk(_painConduit, 2, 'Add three "HEAL 1, self" $_rolling cards'),
    legacy.Perk(_painConduit, 2,
        'Add one +0 "Add plusone ATTACK for each negative condition you have" card'),
    legacy.Perk(
        _painConduit, 1, '$_ignoreScenarioEffects and add two +1 cards'),
    legacy.Perk(_painConduit, 1,
        'Each round in which you long rest, you may ignore all negative conditions you have. If you do, they cannot be removed that round'),
    legacy.Perk(_painConduit, 1,
        'Whenever you become exhausted, first perform CURSE, Target all, RANGE 3'),
    legacy.Perk(_painConduit, 2, 'Increase your maximum hit point value by 5',
        perkIsGrouped: true),
    // SNOWDANCER
    legacy.Perk(_snowdancer, 3,
        'Replace one -1 card with one +0 "HEAL 1, Target 1 ally" card'),
    legacy.Perk(
        _snowdancer, 2, 'Replace one -1 card with one +0 $_immobilize card'),
    legacy.Perk(_snowdancer, 2, 'Add two +1 ICE/AIR cards'),
    legacy.Perk(_snowdancer, 2,
        'Replace two +0 cards with two "If this action forces the target to move, it suffers DAMAGE 1" $_rolling cards'),
    legacy.Perk(_snowdancer, 2,
        'Replace one +0 card with one +1 "STRENGTHEN, Target 1 ally" card'),
    legacy.Perk(
        _snowdancer, 2, 'Add one "HEAL 1, WARD, Target 1 ally" $_rolling card'),
    legacy.Perk(_snowdancer, 1, 'Whenever you long rest, you may ICE/AIR'),
    legacy.Perk(_snowdancer, 2,
        'Whenever you short rest, you may consume_ICE to perform $_regenerate, RANGE 3 and consume_AIR to perform WARD, RANGE 3',
        perkIsGrouped: true),
    legacy.Perk(_snowdancer, 2,
        'At the start of each scenario, all enemies gain MUDDLE. Whenever a new room is revealed, all enemies in the newly revealed room gain MUDDLE',
        perkIsGrouped: true),
    // FROZEN FIST
    legacy.Perk(_frozenFist, 2, 'Replace one -1 card with one +0 DISARM card'),
    legacy.Perk(_frozenFist, 1, 'Replace one -1 card with one +1 card'),
    legacy.Perk(_frozenFist, 1, 'Replace one -2 card with one +0 card'),
    legacy.Perk(_frozenFist, 2,
        'Replace one +0 card with one +1 "$_shield 1" $_rolling card'),
    legacy.Perk(
        _frozenFist, 2, 'Replace one +0 card with one +1 ICE/EARTH card'),
    legacy.Perk(_frozenFist, 2,
        'Replace one +0 card with one +2 "Create one 1-hex icy terrain tile in a featureless hex adjacent to the target" card'),
    legacy.Perk(_frozenFist, 1, 'Add one +3 card'),
    legacy.Perk(_frozenFist, 3, 'Add two "HEAL 1, self" $_rolling cards'),
    legacy.Perk(_frozenFist, 1,
        '$_ignoreItemMinusOneEffects, and, whenever you enter icy terrain with a move ability, you may ignore the effect to add plusone MOVE'),
    legacy.Perk(_frozenFist, 1,
        'Whenever you heal from a long rest, you may consume_ICE/EARTH to add plustwo HEAL'),
    legacy.Perk(_frozenFist, 2,
        'Once each scenario, when you would suffer DAMAGE, you may negate the DAMAGE',
        perkIsGrouped: true),
    // HIVE
    legacy.Perk(_hive, 1, 'Remove one -2 card and one +1 card'),
    legacy.Perk(_hive, 3,
        'Replace one -1 card with one +0 "After this attack ability, grant one of your summons: MOVE 2" card'),
    legacy.Perk(_hive, 3,
        'Replace one +0 card with one +1 "After this attack ability, TRANSFER" card'),
    legacy.Perk(_hive, 3, 'Add one +1 "HEAL 1, self" card'),
    legacy.Perk(_hive, 2, 'Add one +2 MUDDLE card'),
    legacy.Perk(_hive, 1, 'Add two POISON $_rolling cards'),
    legacy.Perk(_hive, 1, 'Add two WOUND $_rolling cards'),
    legacy.Perk(_hive, 2,
        'Whenever you long rest, you may do so on any initiative value, choosing your initiative after all ability cards have been revealed, and you decide how your summons perform their abilities for the round',
        perkIsGrouped: true),
    legacy.Perk(
        _hive, 1, 'At the end of each of your short rests, you may TRANSFER'),
    legacy.Perk(
        _hive, 1, 'Whenever you would gain WOUND, prevent the condition'),
    // METAL MOSAIC
    legacy.Perk(_metalMosaic, 3,
        'Replace one -1 card with one +0 "PRESSURE_GAIN or PRESSURE_LOSE" card'),
    legacy.Perk(_metalMosaic, 2,
        'Replace one -1 card with one "$_shield 1" $_rolling card'),
    legacy.Perk(_metalMosaic, 2,
        'Replace one +0 card with one +0 "The target and all enemies adjacent to it suffer DAMAGE 1" card'),
    legacy.Perk(_metalMosaic, 2,
        'Replace two +0 cards with one PIERCE 3 $_rolling and one "$_retaliate 2" $_rolling card'),
    legacy.Perk(_metalMosaic, 2, 'Add one +1 "HEAL 2, self" card'),
    legacy.Perk(_metalMosaic, 1, 'Add one +3 card'),
    legacy.Perk(
        _metalMosaic, 1, '$_ignoreItemMinusOneEffects and add two +1 cards'),
    legacy.Perk(_metalMosaic, 1,
        'Whenever you long rest, you may PRESSURE_GAIN or PRESSURE_LOSE'),
    legacy.Perk(_metalMosaic, 1,
        'Whenever you would gain POISON, you may suffer DAMAGE 1 to prevent the condition'),
    legacy.Perk(_metalMosaic, 3,
        'Once each scenario, when you would become exhausted, instead gain STUN and INVISIBLE, lose all your cards, RECOVER four lost cards, and then discard the recovered cards',
        perkIsGrouped: true),
    // DEEPWRAITH
    legacy.Perk(_deepwraith, 1, 'Remove two -1 cards'),
    legacy.Perk(_deepwraith, 2, 'Replace one -1 card with one +0 DISARM card'),
    legacy.Perk(_deepwraith, 1, 'Replace one -2 card with one -1 STUN card'),
    legacy.Perk(_deepwraith, 2,
        'Replace one +0 card with one +0 "INVISIBLE, self" card'),
    legacy.Perk(_deepwraith, 1,
        'Replace two +0 cards with two PIERCE 3 $_rolling cards'),
    legacy.Perk(_deepwraith, 1, 'Replace two +1 cards with two +2 cards'),
    legacy.Perk(
        _deepwraith, 1, 'Replace three +1 cards with three +1 CURSE cards'),
    legacy.Perk(_deepwraith, 3, 'Add two +1 "Gain 1 TROPHY" cards'),
    legacy.Perk(
        _deepwraith, 1, '$_ignoreScenarioEffects and remove two +0 cards'),
    legacy.Perk(_deepwraith, 1,
        'Whenever you long rest, you may LOOT one adjacent hex. If you gain any loot tokens, gain 1 TROPHY'),
    legacy.Perk(_deepwraith, 1, 'At the start of each scenario, gain 2 TROPHY'),
    legacy.Perk(_deepwraith, 3,
        'While you have INVISIBLE, gain advantage on all your attacks',
        perkIsGrouped: true),
    // CRASHING TIDE
    legacy.Perk(_crashingTide, 2,
        'Replace one -1 card with two PIERCE 3 $_rolling cards'),
    legacy.Perk(_crashingTide, 2,
        'Replace one -1 card with one +0 "plusone Target" card'),
    legacy.Perk(_crashingTide, 2,
        'Replace one +0 card with one +1 "$_shield 1" $_rolling card'),
    legacy.Perk(_crashingTide, 2,
        'Add two +1 "If you performed a TIDE action this round, +2 instead" cards'),
    legacy.Perk(_crashingTide, 2, 'Add one +2 MUDDLE card'),
    legacy.Perk(_crashingTide, 1, 'Add one +1 DISARM card'),
    legacy.Perk(_crashingTide, 2, 'Add two "HEAL 1, self" $_rolling cards'),
    legacy.Perk(_crashingTide, 1,
        '$_ignoreItemMinusOneEffects, and, whenever you would gain IMPAIR, prevent the condition'),
    legacy.Perk(_crashingTide, 1,
        'Whenever you declare a long rest during card selection, gain $_shield 1 for the round'),
    legacy.Perk(_crashingTide, 3,
        'Gain advantage on all your attacks performed while occupying or targeting enemies occupying water hexes',
        perkIsGrouped: true),
    // THORNREAPER
    legacy.Perk(_thornreaper, 2,
        '$_replace $_one -1 $_card with $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card'),
    legacy.Perk(
        _thornreaper, 1, '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(_thornreaper, 2,
        'Add three $_rolling "+1 if LIGHT is Strong or Waning" cards'),
    legacy.Perk(_thornreaper, 1, '$_add $_two $_rolling LIGHT $_cards'),
    legacy.Perk(_thornreaper, 1,
        '$_add $_three $_rolling "EARTH if LIGHT is Strong or Waning" $_cards'),
    legacy.Perk(_thornreaper, 1,
        '$_add $_one "Create hazardous terrain in $_one hex within RANGE 1" $_card'),
    legacy.Perk(_thornreaper, 2,
        'Add one $_rolling "On the next attack targeting you while occupying hazardous terrain, discard this card to gain $_retaliate 3" card'),
    legacy.Perk(_thornreaper, 2,
        'Add one $_rolling "On the next attack targeting you while occupying hazardous terrain, discard this card to gain $_shield 3" card'),
    legacy.Perk(_thornreaper, 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card'),
    legacy.Perk(
        _thornreaper, 2, 'Gain $_shield 1 while you occupy hazardous terrain',
        perkIsGrouped: true),
    // INCARNATE
    legacy.Perk(_incarnate, 1,
        '$_replace $_one -2 $_card with $_one $_rolling ALL_STANCES $_card'),
    legacy.Perk(_incarnate, 1,
        '$_replace $_one -1 $_card with $_one $_rolling PIERCE 2, FIRE $_card'),
    legacy.Perk(_incarnate, 1,
        '$_replace $_one -1 $_card with $_one $_rolling "$_shield 1, Self, EARTH" $_card'),
    legacy.Perk(_incarnate, 1,
        '$_replace $_one -1 $_card with $_one $_rolling PUSH 1, AIR $_card'),
    legacy.Perk(_incarnate, 2,
        '$_replace $_one +0 $_card with $_one +1 "RITUALIST : ENFEEBLE / CONQUEROR : EMPOWER, Self" $_card'),
    legacy.Perk(_incarnate, 2,
        '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE / CONQUEROR : EMPOWER, Self" $_card'),
    legacy.Perk(_incarnate, 2,
        '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE / RITUALIST : ENFEEBLE" $_card'),
    legacy.Perk(_incarnate, 1,
        '$_add $_one $_rolling "RECOVER $_one One_Hand or Two_Hand item" $_card'),
    legacy.Perk(_incarnate, 1, 'Each time you long rest, perform: ALL_STANCES'),
    legacy.Perk(_incarnate, 1,
        'You may bring one additional One_Hand item into each scenario'),
    legacy.Perk(_incarnate, 1,
        'Each time you short rest, RECOVER one spent One_Hand item'),
    legacy.Perk(_incarnate, 1,
        '$_ignoreNegativeItemEffects and $_removeL one -1 $_card'),
    // RIMEHEARTH
    legacy.Perk(_rimehearth, 2,
        '$_replace $_one -1 $_card with $_one $_rolling WOUND $_card'),
    legacy.Perk(_rimehearth, 1,
        '$_replace $_one +0 $_card with $_one $_rolling "HEAL 3, WOUND, Self" $_card'),
    legacy.Perk(_rimehearth, 1,
        '$_replace $_two +0 $_cards with $_two $_rolling FIRE $_cards'),
    legacy.Perk(_rimehearth, 1,
        '$_replace $_three +1 $_cards with $_one $_rolling +1 card, $_one +1 WOUND $_card, and $_one +1 "HEAL 1, Self" $_card'),
    legacy.Perk(
        _rimehearth, 2, '$_replace $_one +0 $_card with $_one +1 ICE $_card'),
    legacy.Perk(
        _rimehearth, 2, '$_replace $_one -1 $_card with $_one +0 CHILL $_card'),
    legacy.Perk(
        _rimehearth, 1, '$_replace $_one +2 $_card with $_one +3 CHILL $_card'),
    legacy.Perk(_rimehearth, 2, '$_add $_one +2 FIRE/ICE $_card'),
    legacy.Perk(_rimehearth, 1, '$_add $_one +0 BRITTLE $_card'),
    legacy.Perk(_rimehearth, 1,
        'At the start of each $_scenario, you may either gain WOUND to generate FIRE or gain CHILL to generate ICE'),
    legacy.Perk(_rimehearth, 1,
        '$_ignoreNegativeItemEffects and $_add $_one $_rolling FIRE/ICE $_card'),
    // SHARDRENDER
    legacy.Perk(_shardrender, 1, 'Remove one -2 card'),
    legacy.Perk(
        _shardrender, 2, '$_replace $_one -1 $_card with $_one +1 card'),
    legacy.Perk(_shardrender, 2,
        '$_replace -1 card with one $_rolling "Shield 1, Self" card'),
    legacy.Perk(_shardrender, 2,
        '$_replace two +0 cards with two +0 "Move one character token on a CRYSTALLIZE back one space" cards'),
    legacy.Perk(_shardrender, 2,
        'Replace one +0 card with one $_rolling +1 "+2 instead if the attack has PIERCE" card'),
    legacy.Perk(_shardrender, 1,
        'Add two +1 "+2 instead if you CRYSTALLIZE PERSIST one space" cards'),
    legacy.Perk(_shardrender, 1, 'Add one +0 BRITTLE card'),
    legacy.Perk(_shardrender, 2,
        '$_ignoreNegativeItemEffects and at the start of each scenario, you may play a level 1 card from your hand to perform a CRYSTALLIZE action of the card',
        perkIsGrouped: true),
    legacy.Perk(_shardrender, 1,
        'Once each scenario, when you would suffer damage from an attack, gain "$_shield 3" for that attack'),
    legacy.Perk(_shardrender, 1,
        'Each time you long rest, perform "$_regenerate, Self"'),
    // TEMPEST
    legacy.Perk(_tempest, 1, 'Replace one -2 card with one -1 AIR/LIGHT card'),
    legacy.Perk(_tempest, 1,
        'Replace one -1 AIR/LIGHT card with one +1 AIR/LIGHT card'),
    legacy.Perk(_tempest, 2, 'Replace one -1 card with one +0 WOUND card'),
    legacy.Perk(_tempest, 2,
        '$_replace one -1 card with one $_rolling "$_regenerate, RANGE 1" card'),
    legacy.Perk(_tempest, 1, 'Replace one +0 card with one +2 MUDDLE card'),
    legacy.Perk(
        _tempest, 1, 'Replace two +0 cards with one +1 $_immobilize card'),
    legacy.Perk(_tempest, 2, 'Add one +1 "DODGE, Self" card'),
    legacy.Perk(_tempest, 1, 'Add one +2 AIR/LIGHT card'),
    legacy.Perk(_tempest, 1, 'Whenever you dodge an attack, gain one SPARK'),
    legacy.Perk(_tempest, 2, 'Whenever you long rest, you may gain DODGE',
        perkIsGrouped: true),
    legacy.Perk(_tempest, 1,
        'Whenever you short rest, you may consume_SPARK one Spark. If you do, one enemy within RANGE 2 suffers one damage'),
    // VANQUISHER
    legacy.Perk(_vanquisher, 1, 'Replace two -1 cards with one +0 MUDDLE card'),
    legacy.Perk(
        _vanquisher, 1, 'Replace two -1 cards with one -1 "HEAL 2, Self" card'),
    legacy.Perk(
        _vanquisher, 1, 'Replace one -2 card with one -1 POISON WOUND card'),
    legacy.Perk(_vanquisher, 2,
        '$_replace one +0 card with one +1 "HEAL 1, Self" card'),
    legacy.Perk(_vanquisher, 1,
        'Replace two +0 cards with one +0 CURSE card and one +0 $_immobilize card'),
    legacy.Perk(
        _vanquisher, 2, 'Replace one +1 card with one +2 FIRE/AIR card'),
    legacy.Perk(_vanquisher, 1,
        'Replace one +2 card with one $_rolling "Gain one RAGE" card'),
    legacy.Perk(_vanquisher, 2,
        'Add one +1 "$_retaliate 1, Self" card and one $_rolling PIERCE 3 card'),
    legacy.Perk(_vanquisher, 1, 'Add one +0 "BLESS, Self" card'),
    legacy.Perk(
        _vanquisher, 1, 'Add two +1 "+2 instead if you suffer 1 damage" cards'),
    legacy.Perk(
        _vanquisher, 1, 'Add one +2 "+3 instead if you suffer 1 damage" cards'),
    legacy.Perk(
        _vanquisher, 1, '$_ignoreNegativeItemEffects and remove one -1 card'),
    // INCARNATE V2
    // Perk(_incarnate, 1,
    //     '$_replace $_one -2 $_card with $_one +0 ALL_STANCES $_rolling $_card'),
    // Perk(_incarnate, 1,
    //     '$_replace $_one -1 $_card with $_one +0 PIERCE 2 FIRE $_rolling $_card'),
    // Perk(_incarnate, 1,
    //     '$_replace $_one -1 $_card with $_one +0 PUSH 1 AIR $_rolling $_card'),
    // Perk(_incarnate, 1,
    //     '$_replace $_one -1 $_card with $_one +0 "$_shield 1" EARTH $_rolling $_card'),
    // Perk(_incarnate, 2,
    //     '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE or RITUALIST : ENFEEBLE" $_card'),
    // Perk(_incarnate, 2,
    //     '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE or CONQUEROR : EMPOWER, self" $_card'),
    // Perk(_incarnate, 2,
    //     '$_replace $_one +0 $_card with $_one +1 "RITUALIST : ENFEEBLE or CONQUEROR : EMPOWER, self" $_card'),
    // Perk(_incarnate, 1,
    //     'Add one +0 "RECOVER one One_Hand or Two_Hand item" $_rolling card'),
    // Perk(_incarnate, 1,
    //     '$_ignoreItemMinusOneEffects and remove one -1 card'),
    // Perk(_incarnate, 1,
    //     '[Eyes of the Ritualist:] Whenever you long rest, perform ALL_STANCES'),
    // Perk(_incarnate, 1,
    //     '[Shoulders of the Conqueror:] You may bring one additional One_Hand item into each scenario'),
    // Perk(_incarnate, 1,
    //     '[Hands of the Reaver:] Whenever you short rest, RECOVER one spent One_Hand item'),
  ];

  static final List<legacy.Mastery> masteries = [
    // GLOOMHAVEN
    legacy.Mastery(
      masteryClassCode: _brute,
      masteryDetails:
          'Cause enemies to suffer a total of 12 or more $_retaliate damage during attacks targeting you in a single round',
    ),
    legacy.Mastery(
      masteryClassCode: _brute,
      masteryDetails:
          'Across three consecutive rounds, play six different ability cards and cause enemies to suffer at least DAMAGE 6 on each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _tinkerer,
      masteryDetails:
          'Heal an ally or apply a negative condition to an enemy each turn',
    ),
    legacy.Mastery(
      masteryClassCode: _tinkerer,
      masteryDetails:
          'Perform two actions with lost icons before your first rest and then only rest after having played at least two actions with lost icons since your previous rest',
    ),
    legacy.Mastery(
      masteryClassCode: _spellweaver,
      masteryDetails: 'Infuse and consume all six elements',
    ),
    legacy.Mastery(
      masteryClassCode: _spellweaver,
      masteryDetails: 'Perform four different loss actions twice each',
    ),
    legacy.Mastery(
      masteryClassCode: _scoundrel,
      masteryDetails:
          'Kill at least six enemies that are adjacent to at least one of your allies',
    ),
    legacy.Mastery(
      masteryClassCode: _scoundrel,
      masteryDetails:
          'Kill at least six enemies that are adjacent to none of your allies',
    ),
    legacy.Mastery(
      masteryClassCode: _cragheart,
      masteryDetails: 'Only attack enemies adjacent to obstacles or walls',
    ),
    legacy.Mastery(
      masteryClassCode: _cragheart,
      masteryDetails: 'Damage or heal at least one ally each round',
    ),
    legacy.Mastery(
      masteryClassCode: _mindthief,
      masteryDetails:
          'Trigger the on-attack effect of four different Augments thrice each',
    ),
    legacy.Mastery(
      masteryClassCode: _mindthief,
      masteryDetails: 'Never be targeted by an attack',
    ),
    legacy.Mastery(
      masteryClassCode: _sunkeeper,
      masteryDetails:
          'Reduce attacks targeting you by a total of 20 or more through Shield effects in a single round',
    ),
    legacy.Mastery(
      masteryClassCode: _sunkeeper,
      masteryDetails: 'LIGHT or consume_LIGHT during each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _quartermaster,
      masteryDetails:
          "Spend, lose, or refresh one or more items on each of your turns without ever performing the top action of ~Reinforced ~Steel",
    ),
    legacy.Mastery(
      masteryClassCode: _quartermaster,
      masteryDetails: 'LOOT six or more loot tokens in a single turn',
    ),
    legacy.Mastery(
      masteryClassCode: _summoner,
      masteryDetails:
          'Summon the Lava Golem on your first turn and keep it alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: _summoner,
      masteryDetails:
          'Perform the summon action of five different ability cards',
    ),
    legacy.Mastery(
      masteryClassCode: _nightshroud,
      masteryDetails:
          'Have INVISIBLE at the start or end of each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _nightshroud,
      masteryDetails: 'DARK or consume_DARK during each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _plagueherald,
      masteryDetails: 'Kill at least five enemies with non-attack abilities',
    ),
    legacy.Mastery(
      masteryClassCode: _plagueherald,
      masteryDetails:
          'Perform three different attack abilities that target at least four enemies each',
    ),
    legacy.Mastery(
      masteryClassCode: _berserker,
      masteryDetails:
          "Lose at least one hit point during each of your turns, without ever performing the bottom action of ~Blood ~Pact",
    ),
    legacy.Mastery(
      masteryClassCode: _berserker,
      masteryDetails:
          'Have exactly one hit point at the end of each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _soothsinger,
      masteryDetails:
          'On your first turn of the scenario and the turn after each of your rests, perform one Song action that you have not yet performed this scenario',
    ),
    legacy.Mastery(
      masteryClassCode: _soothsinger,
      masteryDetails:
          'Have all 10 monster CURSE cards and all 10 BLESS cards in modifier decks at the same time',
    ),
    legacy.Mastery(
      masteryClassCode: _doomstalker,
      masteryDetails:
          'Never perform a Doom action that you have already performed in the scenario',
    ),
    legacy.Mastery(
      masteryClassCode: _doomstalker,
      masteryDetails: 'Kill three Doomed enemies during one of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _sawbones,
      masteryDetails:
          "On each of your turns, give an ally an ability card, target an ally with a HEAL ability, grant an ally $_shield, or place an ability card in an ally's active area",
    ),
    legacy.Mastery(
      masteryClassCode: _sawbones,
      masteryDetails: 'Deal at least DAMAGE 20 with a single attack ability',
    ),
    legacy.Mastery(
      masteryClassCode: _elementalist,
      masteryDetails:
          "Consume at least two different elements with each of four different attack abilities without ever performing the bottom action of ~Formless ~Power or ~Shaping ~the ~Ether",
    ),
    legacy.Mastery(
      masteryClassCode: _elementalist,
      masteryDetails:
          'Infuse five or more elements during one of your turns, then consume five or more elements during your following turn',
    ),
    legacy.Mastery(
      masteryClassCode: _beastTyrant,
      masteryDetails:
          'Have your bear summon deal DAMAGE 10 or more in three consecutive rounds',
    ),
    legacy.Mastery(
      masteryClassCode: _beastTyrant,
      masteryDetails:
          'You or your summons must apply a negative condition to at least 10 different enemies',
    ),
    legacy.Mastery(
      masteryClassCode: _bladeswarm,
      masteryDetails:
          'Perform two different summon actions on your first turn and keep all summons from those actions alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: _bladeswarm,
      masteryDetails:
          'Perform three different non-summon persistent loss actions before your first rest',
    ),
    legacy.Mastery(
      masteryClassCode: _diviner,
      masteryDetails:
          'During one round, have at least four monsters move into four different Rifts that affect those monsters',
    ),
    legacy.Mastery(
      masteryClassCode: _diviner,
      masteryDetails:
          'Reveal at least one card from at least one ability card deck or attack modifier deck each round',
    ),
    // JAWS OF THE LION
    legacy.Mastery(
      masteryClassCode: _demolitionist,
      masteryDetails:
          'Deal DAMAGE 10 or more with each of three different attack actions',
    ),
    legacy.Mastery(
      masteryClassCode: _demolitionist,
      masteryDetails:
          'Destroy at least six obstacles. End the scenario with no obstacles on the map other than ones placed by allies',
    ),
    legacy.Mastery(
      masteryClassCode: _hatchet,
      masteryDetails: 'AIR or consume_AIR during each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _hatchet,
      masteryDetails:
          'During each round in which there is at least one enemy on the map at the start of your turn, either place one of your tokens on an ability card of yours or on an enemy',
    ),
    legacy.Mastery(
      masteryClassCode: _redGuard,
      masteryDetails: 'Kill at least five enemies during their turns',
    ),
    legacy.Mastery(
      masteryClassCode: _redGuard,
      masteryDetails:
          'Force each enemy in the scenario to move at least one hex, forcing at least six enemies to move',
    ),
    legacy.Mastery(
      masteryClassCode: _voidwarden,
      masteryDetails:
          'Cause enemies to suffer DAMAGE 20 or more in a single turn with granted or commanded attacks',
    ),
    legacy.Mastery(
      masteryClassCode: _voidwarden,
      masteryDetails:
          'Give at least one ally or enemy POISON, STRENGTHEN, BLESS, or WARD each round',
    ),
    // FROSTHAVEN
    legacy.Mastery(
      masteryClassCode: _drifter,
      masteryDetails:
          'End a scenario with your character tokens on the last use slots of four persistent abilities',
    ),
    legacy.Mastery(
      masteryClassCode: _drifter,
      masteryDetails:
          'Never perform a move or attack ability with a value less than 4, and perform at least one move or attack ability every round',
    ),
    legacy.Mastery(
      masteryClassCode: _blinkBlade,
      masteryDetails: 'Declare Fast seven rounds in a row',
    ),
    legacy.Mastery(
      masteryClassCode: _blinkBlade,
      masteryDetails: 'Never be targeted by an attack',
    ),
    legacy.Mastery(
      masteryClassCode: _bannerSpear,
      masteryDetails:
          'Attack at least three targets with three different area of effect attacks',
    ),
    legacy.Mastery(
      masteryClassCode: _bannerSpear,
      masteryDetails:
          'Play a Banner summon ability on your first turn, always have it within RANGE 3 of you, and keep it alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: _deathwalker,
      masteryDetails: 'Consume seven SHADOW in one round',
    ),
    legacy.Mastery(
      masteryClassCode: _deathwalker,
      masteryDetails: 'Create or consume at least one SHADOW every round',
    ),
    legacy.Mastery(
      masteryClassCode: _boneshaper,
      masteryDetails: 'Kill at least 15 of your summons',
    ),
    legacy.Mastery(
      masteryClassCode: _boneshaper,
      masteryDetails:
          'Play a summon action on your first turn, have this summon kill at least 6 enemies, and keep it alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: _geminate,
      masteryDetails: 'Switch forms every round',
    ),
    legacy.Mastery(
      masteryClassCode: _geminate,
      masteryDetails: 'Lose at least one card every round',
    ),
    legacy.Mastery(
      masteryClassCode: _infuser,
      masteryDetails: 'Have five active INFUSION bonuses',
    ),
    legacy.Mastery(
      masteryClassCode: _infuser,
      masteryDetails: 'Kill at least four enemies, but never attack',
    ),
    legacy.Mastery(
      masteryClassCode: _pyroclast,
      masteryDetails:
          'Create or destroy at least one obstacle or hazardous terrain tile each round',
    ),
    legacy.Mastery(
      masteryClassCode: _pyroclast,
      masteryDetails:
          'Move enemies through six different hexes of hazardous terrain you created in one turn',
    ),
    legacy.Mastery(
      masteryClassCode: _shattersong,
      masteryDetails:
          'Always have 0 RESONANCE directly before you gain RESONANCE at the end of each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: _shattersong,
      masteryDetails:
          'Spend 5 RESONANCE on each of five different Wave abilities',
    ),
    legacy.Mastery(
      masteryClassCode: _trapper,
      masteryDetails:
          'Have one HEAL trap on the map with a value of at least 20',
    ),
    legacy.Mastery(
      masteryClassCode: _trapper,
      masteryDetails:
          'Move enemies through seven or more traps with one ability',
    ),
    legacy.Mastery(
      masteryClassCode: _painConduit,
      masteryDetails:
          'Cause other figures to suffer a total of at least DAMAGE 40 in one round',
    ),
    legacy.Mastery(
      masteryClassCode: _painConduit,
      masteryDetails:
          'Start a turn with WOUND, BRITTLE, BANE, POISON, $_immobilize, DISARM, STUN, and MUDDLE',
    ),
    legacy.Mastery(
      masteryClassCode: _snowdancer,
      masteryDetails: 'Cause at least one ally or enemy to move each round',
    ),
    legacy.Mastery(
      masteryClassCode: _snowdancer,
      masteryDetails:
          'Ensure the first ally to suffer DAMAGE each round, directly before suffering the DAMAGE, has at least one condition you applied',
    ),
    legacy.Mastery(
      masteryClassCode: _frozenFist,
      masteryDetails:
          'RECOVER at least one card from your discard pile each round',
    ),
    legacy.Mastery(
      masteryClassCode: _frozenFist,
      masteryDetails:
          'Enter at least ten different hexes with one move ability, then cause one enemy to suffer at least DAMAGE 10 with one attack ability in the same turn',
    ),
    legacy.Mastery(
      masteryClassCode: _hive,
      masteryDetails: 'TRANSFER each round',
    ),
    legacy.Mastery(
      masteryClassCode: _hive,
      masteryDetails: 'TRANSFER into four different summons in one round',
    ),
    legacy.Mastery(
      masteryClassCode: _metalMosaic,
      masteryDetails: 'Never attack',
    ),
    legacy.Mastery(
      masteryClassCode: _metalMosaic,
      masteryDetails:
          'For four consecutive rounds, move the pressure gauge up or down three levels from where it started the round (PRESSURE_LOW to PRESSURE_HIGH, or vice versa)',
    ),
    legacy.Mastery(
      masteryClassCode: _deepwraith,
      masteryDetails: 'Perform all your attacks with advantage',
    ),
    legacy.Mastery(
      masteryClassCode: _deepwraith,
      masteryDetails: 'Infuse DARK each round',
    ),
    legacy.Mastery(
      masteryClassCode: _crashingTide,
      masteryDetails:
          'Never suffer damage from attacks, and be targeted by at least five attacks',
    ),
    legacy.Mastery(
      masteryClassCode: _crashingTide,
      masteryDetails:
          'At the start of each of your rests, have more active TIDE than cards in your discard pile',
    ),
    // CUSTOM
    legacy.Mastery(
      masteryClassCode: _incarnate,
      masteryDetails:
          'Never end your turn with the same spirit you started in that turn',
    ),
    legacy.Mastery(
      masteryClassCode: _incarnate,
      masteryDetails:
          'Perform fifteen attacks using One_Hand or Two_Hand items',
    ),
  ];

  static final Map<String, List<Masteries>> masteriesMap = {
    _brute: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Cause enemies to suffer a total of 12 or more $_retaliate damage during attacks targeting you in a single round',
          ),
          Mastery(
            masteryDetails:
                'Across three consecutive rounds, play six different ability cards and cause enemies to suffer at least DAMAGE 6 on each of your turns',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _tinkerer: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Heal an ally or apply a negative condition to an enemy each turn',
          ),
          Mastery(
            masteryDetails:
                'Perform two actions with lost icons before your first rest and then only rest after having played at least two actions with lost icons since your previous rest',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _spellweaver: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Infuse and consume all six elements',
          ),
          Mastery(
            masteryDetails: 'Perform four different loss actions twice each',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _scoundrel: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Kill at least six enemies that are adjacent to at least one of your allies',
          ),
          Mastery(
            masteryDetails:
                'Kill at least six enemies that are adjacent to none of your allies',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _cragheart: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Only attack enemies adjacent to obstacles or walls',
          ),
          Mastery(
            masteryDetails: 'Damage or heal at least one ally each round',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _mindthief: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Trigger the on-attack effect of four different Augments thrice each',
          ),
          Mastery(
            masteryDetails: 'Never be targeted by an attack',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _sunkeeper: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Reduce attacks targeting you by a total of 20 or more through Shield effects in a single round',
          ),
          Mastery(
            masteryDetails: 'LIGHT or consume_LIGHT during each of your turns',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _quartermaster: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                "Spend, lose, or refresh one or more items on each of your turns without ever performing the top action of ~Reinforced ~Steel",
          ),
          Mastery(
            masteryDetails: 'LOOT six or more loot tokens in a single turn',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _summoner: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Summon the Lava Golem on your first turn and keep it alive for the entire scenario',
          ),
          Mastery(
            masteryDetails:
                'Perform the summon action of five different ability cards',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _nightshroud: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Have INVISIBLE at the start or end of each of your turns',
          ),
          Mastery(
            masteryDetails: 'DARK or consume_DARK during each of your turns',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _plagueherald: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Kill at least five enemies with non-attack abilities',
          ),
          Mastery(
            masteryDetails:
                'Perform three different attack abilities that target at least four enemies each',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _berserker: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Lose at least one hit point during each of your turns, without ever performing the bottom action of ~Blood ~Pact',
          ),
          Mastery(
            masteryDetails:
                'Have exactly one hit point at the end of each of your turns',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _soothsinger: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'On your first turn of the scenario and the turn after each of your rests, perform one Song action that you have not yet performed this scenario',
          ),
          Mastery(
            masteryDetails:
                'Have all 10 monster CURSE cards and all 10 BLESS cards in modifier decks at the same time',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _doomstalker: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Never perform a Doom action that you have already performed in the scenario',
          ),
          Mastery(
            masteryDetails:
                'Kill three Doomed enemies during one of your turns',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _sawbones: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'On each of your turns, give an ally an ability card, target an ally with a HEAL ability, grant an ally $_shield, or place an ability card in an ally\'s active area',
          ),
          Mastery(
            masteryDetails:
                'Deal at least DAMAGE 20 with a single attack ability',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _elementalist: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Consume at least two different elements with each of four different attack abilities without ever performing the bottom action of ~Formless ~Power or ~Shaping ~the ~Ether',
          ),
          Mastery(
            masteryDetails:
                'Infuse five or more elements during one of your turns, then consume five or more elements during your following turn',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _beastTyrant: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Have your bear summon deal DAMAGE 10 or more in three consecutive rounds',
          ),
          Mastery(
            masteryDetails:
                'You or your summons must apply a negative condition to at least 10 different enemies',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _bladeswarm: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Perform two different summon actions on your first turn and keep all summons from those actions alive for the entire scenario',
          ),
          Mastery(
            masteryDetails:
                'Perform three different non-summon persistent loss actions before your first rest',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _diviner: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'During one round, have at least four monsters move into four different Rifts that affect those monsters',
          ),
          Mastery(
            masteryDetails:
                'Reveal at least one card from at least one ability card deck or attack modifier deck each round',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    // Jaws of the Lion
    _demolitionist: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Deal DAMAGE 10 or more with each of three different attack actions',
          ),
          Mastery(
            masteryDetails:
                'Destroy at least six obstacles. End the scenario with no obstacles on the map other than ones placed by allies',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _hatchet: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'AIR or consume_AIR during each of your turns',
          ),
          Mastery(
            masteryDetails:
                'During each round in which there is at least one enemy on the map at the start of your turn, either place one of your tokens on an ability card of yours or on an enemy',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _redGuard: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Kill at least five enemies during their turns',
          ),
          Mastery(
            masteryDetails:
                'Force each enemy in the scenario to move at least one hex, forcing at least six enemies to move',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _voidwarden: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Cause enemies to suffer DAMAGE 20 or more in a single turn with granted or commanded attacks',
          ),
          Mastery(
            masteryDetails:
                'Give at least one ally or enemy POISON, STRENGTHEN, BLESS, or WARD each round',
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    // Frosthaven
    _drifter: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'End a scenario with your character tokens on the last use slots of four persistent abilities',
          ),
          Mastery(
            masteryDetails:
                'Never perform a move or attack ability with a value less than 4, and perform at least one move or attack ability every round',
          ),
        ],
      ),
    ],
    _blinkBlade: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Declare Fast seven rounds in a row',
          ),
          Mastery(
            masteryDetails: 'Never be targeted by an attack',
          ),
        ],
      ),
    ],
    _bannerSpear: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Attack at least three targets with three different area of effect attacks',
          ),
          Mastery(
            masteryDetails:
                'Play a Banner summon ability on your first turn, always have it within RANGE 3 of you, and keep it alive for the entire scenario',
          ),
        ],
      ),
    ],
    _deathwalker: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Consume seven SHADOW in one round',
          ),
          Mastery(
            masteryDetails: 'Create or consume at least one SHADOW every round',
          ),
        ],
      ),
    ],
    _boneshaper: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Kill at least 15 of your summons',
          ),
          Mastery(
            masteryDetails:
                'Play a summon action on your first turn, have this summon kill at least 6 enemies, and keep it alive for the entire scenario',
          ),
        ],
      ),
    ],
    _geminate: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Switch forms every round',
          ),
          Mastery(
            masteryDetails: 'Lose at least one card every round',
          ),
        ],
      ),
    ],
    _infuser: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Have five active INFUSION bonuses',
          ),
          Mastery(
            masteryDetails: 'Kill at least four enemies, but never attack',
          ),
        ],
      ),
    ],
    _pyroclast: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Create or destroy at least one obstacle or hazardous terrain tile each round',
          ),
          Mastery(
            masteryDetails:
                'Move enemies through six different hexes of hazardous terrain you created in one turn',
          ),
        ],
      ),
    ],
    _shattersong: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Always have 0 RESONANCE directly before you gain RESONANCE at the end of each of your turns',
          ),
          Mastery(
            masteryDetails:
                'Spend 5 RESONANCE on each of five different Wave abilities',
          ),
        ],
      ),
    ],
    _trapper: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Have one HEAL trap on the map with a value of at least 20',
          ),
          Mastery(
            masteryDetails:
                'Move enemies through seven or more traps with one ability',
          ),
        ],
      ),
    ],
    _painConduit: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Cause other figures to suffer a total of at least DAMAGE 40 in one round',
          ),
          Mastery(
            masteryDetails:
                'Start a turn with WOUND, BRITTLE, BANE, POISON, $_immobilize, DISARM, STUN, and MUDDLE',
          ),
        ],
      ),
    ],
    _snowdancer: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Cause at least one ally or enemy to move each round',
          ),
          Mastery(
            masteryDetails:
                'Ensure the first ally to suffer DAMAGE each round, directly before suffering the DAMAGE, has at least one condition you applied',
          ),
        ],
      ),
    ],
    _frozenFist: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'RECOVER at least one card from your discard pile each round',
          ),
          Mastery(
            masteryDetails:
                'Enter at least ten different hexes with one move ability, then cause one enemy to suffer at least DAMAGE 10 with one attack ability in the same turn',
          ),
        ],
      ),
    ],
    _hive: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'TRANSFER each round',
          ),
          Mastery(
            masteryDetails: 'TRANSFER into four different summons in one round',
          ),
        ],
      ),
    ],
    _metalMosaic: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Never attack',
          ),
          Mastery(
            masteryDetails:
                'For four consecutive rounds, move the pressure gauge up or down three levels from where it started the round (PRESSURE_LOW to PRESSURE_HIGH, or vice versa)',
          ),
        ],
      ),
    ],
    _deepwraith: [
      Masteries(
        [
          Mastery(
            masteryDetails: 'Perform all your attacks with advantage',
          ),
          Mastery(
            masteryDetails: 'Infuse DARK each round',
          ),
        ],
      ),
    ],
    _crashingTide: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'Never suffer damage from attacks, and be targeted by at least five attacks',
          ),
          Mastery(
            masteryDetails:
                'At the start of each of your rests, have more active TIDE than cards in your discard pile',
          ),
        ],
      ),
    ],
    // Custom
    // _incarnate: [
    //   Masteries(
    //     [
    //       Mastery(
    //         masteryDetails:
    //             'Never end your turn with the same spirit you started in that turn',
    //       ),
    //       Mastery(
    //         masteryDetails:
    //             'Perform fifteen attacks using One_Hand or Two_Hand items',
    //       ),
    //     ],
    //   ),
    // ],
  };

  static final Map<String, List<Perks>> perksMap = {
    // BRUTE
    _brute: [
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove $_one -1 $_card and $_addL $_one +1 $_card'),
          Perk(
            '$_add $_two +1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one +3 $_card'),
          Perk(
            '$_add $_three $_rolling PUSH 1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling PIERCE 3 $_cards'),
          Perk(
            '$_add $_one $_rolling STUN $_card',
            quantity: 2,
          ),
          Perk(
              '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
          Perk(
            '$_add $_one $_rolling ADD TARGET $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +1 "$_shield  Self" $_card'),
          Perk('Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
        ],
      ),
      // Crosschecked and confirmed
      Perks(
        [
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 2,
          ),
          Perk(
            'Replace one -1 card with three +0 PUSH 1 $_rolling cards',
            quantity: 2,
          ),
          Perk('$_replace two +0 cards with two +0 PIERCE 3 $_rolling cards'),
          Perk(
            '$_replace one +0 card with two +1 cards',
            quantity: 2,
          ),
          Perk(
            '$_replace one +0 card with one +0 "plusone Target" $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add one +0 STUN $_rolling card',
            quantity: 2,
          ),
          Perk(
              'Add one +0 DISARM $_rolling card and one +0 MUDDLE $_rolling card'),
          Perk('$_add $_one +3 card'),
          Perk(
              '$_ignoreItemMinusOneEffects and $_addL $_one +1 "$_shield 1" card'),
          Perk(
              '[Rested and Ready:] Whenever you long rest, add +1 MOVE to your first move ability the following round'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _tinkerer: [
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
            '$_add $_two $_rolling FIRE $_cards',
          ),
          Perk(
            '$_add $_three $_rolling MUDDLE $_cards',
          ),
          Perk(
            '$_add $_one +1 WOUND $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 $_immobilize $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 HEAL 2 $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +0 ADD TARGET $_card',
          ),
          Perk(
            'Ignore $_negative $_scenario $_effects',
          ),
        ],
      ),
      // Crosschecked and confirmed
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
            'Replace one +0 card with one +1 WOUND card',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with one +1 $_immobilize card',
            quantity: 2,
          ),
          Perk('Replace two +0 cards with three +0 MUDDLE $_rolling cards'),
          Perk('Add one +3 card'),
          Perk('Add two +1 "HEAL 2, self" cards'),
          Perk('$_ignoreScenarioEffects and add two +0 FIRE $_rolling cards'),
          Perk(
            '[Rejuvenating Vapor:] Whenever you long rest, you may perform "HEAL 2, RANGE 3"',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _spellweaver: [
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
          Perk('$_add $_one +0 STUN $_card'),
          Perk('$_add $_one +1 WOUND $_card'),
          Perk('$_add $_one +1 $_immobilize $_card'),
          Perk('$_add $_one +1 CURSE $_card'),
          Perk(
            '$_add $_one +2 FIRE $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +2 ICE $_card',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling EARTH and $_one $_rolling AIR $_card'),
          Perk('$_add $_one $_rolling LIGHT and $_one $_rolling DARK $_card'),
        ],
      ),
      // Crosschecked and confirmed
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
              'Replace one -1 card with one +0 LIGHT $_rolling card and one +0 DARK $_rolling card'),
          Perk('Replace one +0 card with one +1 WOUND card'),
          Perk('Replace one +0 card with one +1 $_immobilize card'),
          Perk('Replace one +0 card with one +1 STUN card'),
          Perk('Replace one +0 card with one +1 CURSE card'),
          Perk(
            'Add one +2 FIRE card',
            quantity: 2,
          ),
          Perk(
            'Add one +2 ICE card',
            quantity: 2,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
              '[Etheric Bond:] Whenever you short rest, if ~Reviving ~Ether is in your discard pile, first return it to your hand'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _scoundrel: [
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
          Perk('$_add $_two $_rolling PIERCE 3 $_cards'),
          Perk(
            '$_add $_two $_rolling POISON $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling MUDDLE $_cards'),
          Perk('$_add $_one $_rolling INVISIBLE $_card'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
      ),
      // Crosschecked and confirmed - typo found in official sheet at third last perk
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
            'Replace two +0 cards with one +0 MUDDLE $_rolling card and one +0 PIERCE 3 $_rolling card',
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
    _cragheart: [
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
            '$_add $_one +2 MUDDLE $_card',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling PUSH 2 $_cards'),
          Perk(
            '$_add $_two $_rolling EARTH $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling AIR $_cards'),
          Perk('Ignore $_negative item $_effects'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
      ),
      // Crosschecked and confirmed
      Perks(
        [
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 3,
          ),
          Perk('Replace one +0 card with two +0 PUSH 2 $_rolling cards'),
          Perk(
            'Replace one +0 card with one +1 $_immobilize card',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with one +2 card',
            quantity: 2,
          ),
          Perk(
            'Add one +2 MUDDLE card and one +0 AIR $_rolling card',
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
    _mindthief: [
      Perks([
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
        Perk('$_add $_three $_rolling MUDDLE $_cards'),
        Perk('$_add $_two $_rolling $_immobilize $_cards'),
        Perk('$_add $_one $_rolling STUN $_card'),
        Perk(
            '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
        Perk('Ignore $_negative $_scenario $_effects'),
      ]),
      // Crosschecked and confirmed
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk(
            'Replace one -1 card with one +0 $_immobilize $_rolling card',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one +0 card'),
          Perk('Replace two +0 cards with three +0 PUSH 1 $_rolling cards'),
          Perk('Replace two +0 cards with three +0 MUDDLE $_rolling cards'),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk(
            'Add one +2 ICE card',
            quantity: 2,
          ),
          Perk(
            'Add two +1 $_rolling cards',
            quantity: 2,
          ),
          Perk('Add one +0 STUN $_rolling card'),
          Perk(
              'Add one +0 DISARM $_rolling card and one +0 MUDDLE $_rolling card'),
          Perk(_ignoreScenarioEffects),
          Perk(
              '[Lying Low:] You are considered to be last in initiative order when determining monster focus'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _sunkeeper: [
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
            '$_add $_two $_rolling HEAL 1 $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling STUN $_card'),
          Perk(
            '$_add $_two $_rolling LIGHT $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling "$_shield 1, Self" $_cards'),
          Perk('Ignore $_negative item $_effects and $_addL $_two +1 $_cards'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
      ),
      Perks(
        [
          Perk('Remove four +0 cards'),
          Perk(
            'Replace one -1 card with two +0 LIGHT $_rolling cards',
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
          Perk('Add one +0 STUN $_rolling card'),
          Perk(
            'Add two +0 "HEAL 1, self" $_rolling cards',
            quantity: 2,
          ),
          Perk('$_ignoreItemMinusOneEffects, and add two +1 cards'),
          Perk(_ignoreScenarioEffects),
          Perk(
            '[Shielding Light:] Whenever one of your heals would cause an ally\'s current hit point value to increase beyond their maximum hit point value, that ally gains WARD',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _quartermaster: [
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
          Perk('$_add $_three $_rolling MUDDLE $_cards'),
          Perk('$_add $_two $_rolling PIERCE 3 $_cards'),
          Perk('$_add $_one $_rolling STUN $_card'),
          Perk('$_add $_one $_rolling ADD TARGET $_card'),
          Perk(
            '$_add $_one +0 "RECOVER an item" $_card',
            quantity: 3,
          ),
          Perk('Ignore $_negative item $_effects and $_addL $_two +1 $_cards'),
        ],
      ),
      // Crosschecked and confirmed
      Perks(
        [
          Perk(
            'Remove two -1 cards',
            quantity: 2,
          ),
          Perk('Replace two +0 cards with two +0 PIERCE 3 $_rolling cards'),
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
          Perk('Add one +0 STUN $_rolling card'),
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
    _summoner: [
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
          Perk('$_add $_two $_rolling WOUND $_cards'),
          Perk('$_add $_two $_rolling POISON $_cards'),
          Perk(
            '$_add $_two $_rolling HEAL 1 $_cards',
            quantity: 3,
          ),
          Perk('$_add $_one $_rolling FIRE and $_one $_rolling AIR $_card'),
          Perk('$_add $_one $_rolling DARK and $_one $_rolling EARTH $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
        ],
      ),
      // Crosschecked and confirmed
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 3,
          ),
          Perk('Replace one -2 card with one +0 card'),
          Perk(
              'Replace two +0 cards with one +0 FIRE $_rolling card and one +0 EARTH $_rolling card'),
          Perk(
              'Replace two +0 cards with one +0 AIR $_rolling card and one +0 DARK $_rolling card'),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk('Add two +0 WOUND $_rolling cards'),
          Perk('Add two +0 POISON $_rolling cards'),
          Perk(
            'Add three +0 "HEAL 1, self" $_rolling cards',
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
    _nightshroud: [
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
            '$_add $_three $_rolling MUDDLE $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling HEAL 1 $_cards'),
          Perk('$_add $_two $_rolling CURSE $_cards'),
          Perk('$_add $_one $_rolling ADD TARGET $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
        ],
      ),
      // Crosschecked and confirmed
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
            'Replace two +0 cards with three +0 MUDDLE $_rolling cards',
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
          Perk('Add two +0 CURSE $_rolling cards'),
          Perk('Add two +0 "HEAL 1, self" $_rolling cards'),
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
    _plagueherald: [
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
          Perk('$_add $_two $_rolling CURSE $_cards'),
          Perk('$_add $_two $_rolling IMMOBILIZE $_cards'),
          Perk(
            '$_add $_one $_rolling STUN $_card',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
        ],
      ),
      // Crosschecked and confirmed
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
            'Add one +0 STUN $_rolling card',
            quantity: 2,
          ),
          Perk('Add two +0 CURSE $_rolling cards'),
          Perk('$_ignoreScenarioEffects and add one +1 card'),
          Perk(
            '[Xorn\'s Boon:] Once each scenario, during your turn, cause each enemy that has POISON to suffer DAMAGE 1 and gain MUDDLE and each ally who has POISON to suffer DAMAGE 1 and gain STRENGTHEN',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      )
    ],
    _berserker: [
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
            '$_add $_two $_rolling WOUND $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one $_rolling STUN $_card',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling +1 DISARM $_card'),
          Perk('$_add $_two $_rolling HEAL 1 $_cards'),
          Perk(
            '$_add $_one +2 FIRE $_card',
            quantity: 2,
          ),
          Perk('Ignore $_negative item $_effects'),
        ],
      ),
      // Crosschecked and confirmed
      Perks(
        [
          Perk('Remove two -1 cards'),
          Perk(
            'Replace one -1 card with one +1 card',
            quantity: 2,
          ),
          Perk(
            'Replace one +0 card with two +0 WOUND $_rolling cards',
            quantity: 2,
          ),
          Perk(
            'Replace one +1 card with one +2 $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add one +2 FIRE card',
            quantity: 2,
          ),
          Perk(
            'Add one +0 STUN $_rolling card',
            quantity: 2,
          ),
          Perk('Add one +1 DISARM $_rolling card'),
          Perk('Add two +0 "HEAL 1, self" $_rolling cards'),
          Perk(_ignoreItemMinusOneEffects),
          Perk(
              '[Rapid Recovery:] Whenever you heal from a long rest, add +1 HEAL'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _soothsinger: [
      Perks([
        Perk(
          '$_remove $_two -1 $_cards',
          quantity: 2,
        ),
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_two +1 $_cards with $_one +4 $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +1 IMMOBILIZE $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 DISARM $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 WOUND $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 POISON $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
        Perk('$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 STUN $_card'),
        Perk('$_add $_three $_rolling +1 $_cards'),
        Perk(
          '$_add $_two $_rolling CURSE $_cards',
          quantity: 2,
        ),
      ]),
      // Crosschecked and confirmed
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 STUN $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 DISARM $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 WOUND $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
          Perk('$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
          Perk(
            '$_replace $_two +1 $_cards with $_one +4 $_card',
            quantity: 2,
          ),
          Perk('$_add $_three +1 $_rolling $_cards'),
          Perk('$_add $_three +0 CURSE $_rolling $_cards'),
          Perk(
              '[Storyteller:] At the end of each scenario, each character in that scenario gains 8 experience if you successfully completed your battle goal'),
        ],
        variant: Variant.frosthavenCrossover,
      )
    ],
    _doomstalker: [
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
          Perk('$_add $_one +2 MUDDLE $_card'),
          Perk('$_add $_one +1 POISON $_card'),
          Perk('$_add $_one +1 WOUND $_card'),
          Perk('$_add $_one +1 IMMOBILIZE $_card'),
          Perk('$_add $_one +0 STUN $_card'),
          Perk(
            '$_add $_one $_rolling ADD TARGET $_card',
            quantity: 2,
          ),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
      ),
      // Crosschecked and confirmed
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
          Perk('$_replace $_one +0 $_card with $_one +0 STUN $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
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
    _sawbones: [
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
          Perk('$_add $_one +1 IMMOBILIZE $_card'),
          Perk(
            '$_add $_two $_rolling WOUND $_cards',
            quantity: 2,
          ),
          Perk('$_add $_one $_rolling STUN $_card'),
          Perk(
            '$_add $_one $_rolling HEAL 3 $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +0 "RECOVER an item" $_card'),
        ],
      ),
      Perks(
        [
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 WOUND $_rolling $_card',
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
          Perk('$_add $_one +0 STUN $_rolling $_card'),
          Perk(
            '$_add $_one +0 "HEAL 3, self" $_rolling $_card',
            quantity: 2,
          ),
          Perk(
              '[Revitalizing Medicine:] Whenever an ally performs the Heal ability of ~Medical ~Pack or ~Large ~Medical ~Pack, that character may first remove one negative condition'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],

    _elementalist: [
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
          Perk('$_add $_three +0 FIRE $_cards'),
          Perk('$_add $_three +0 ICE $_cards'),
          Perk('$_add $_three +0 AIR $_cards'),
          Perk('$_add $_three +0 EARTH $_cards'),
          Perk(
              '$_replace $_two +0 $_cards with $_one +0 FIRE $_card and $_one +0 EARTH $_card'),
          Perk(
              '$_replace $_two +0 $_cards with $_one +0 ICE $_card and $_one +0 AIR $_card'),
          Perk('$_add $_two +1 PUSH 1 $_cards'),
          Perk('$_add $_one +1 WOUND $_card'),
          Perk('$_add $_one +0 STUN $_card'),
          Perk('$_add $_one +0 ADD TARGET $_card'),
        ],
      ),
      // Crosschecked and confirmed
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
          Perk('$_replace $_one +0 $_card with $_one +0 STUN $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
          Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
          Perk('$_add $_four +0 FIRE $_cards'),
          Perk('$_add $_four +0 ICE $_cards'),
          Perk('$_add $_four +0 AIR $_cards'),
          Perk('$_add $_four +0 EARTH $_cards'),
          Perk(_ignoreScenarioEffects),
          Perk(
            '[Elemental Proficiency:] At the start of each scenario and whenever you long rest, Any_Element',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],

    _beastTyrant: [
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
            '$_add $_one +1 WOUND $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 IMMOBILIZE $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two $_rolling HEAL 1 $_cards',
            quantity: 3,
          ),
          Perk('$_add $_two $_rolling EARTH $_cards'),
          Perk('Ignore $_negative $_scenario $_effects'),
        ],
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
            '$_replace $_one +0 $_card with $_one +1 WOUND $_card',
            quantity: 2,
          ),
          Perk('$_add $_two +1 $_immobilize $_cards'),
          Perk(
            '$_add $_two +0 "HEAL 1, self" $_rolling $_cards',
            quantity: 3,
          ),
          Perk(
              '$_ignoreScenarioEffects and $_addL $_two +0 EARTH $_rolling $_cards'),
          Perk(
            '[Bear Treat:] During each round in which you long rest, at initiative 99, you may skip the bear\'s normal turn to Command: "MOVE 3; LOOT 1; If the loot ability was performed: HEAL 3, self"',
            quantity: 2,
            grouped: true,
          ),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _bladeswarm: [
      Perks(
        [
          Perk('$_remove $_one -2 $_card'),
          Perk('$_remove four +0 $_cards'),
          Perk('$_replace $_one -1 $_card with $_one +1 AIR $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 EARTH $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 LIGHT $_card'),
          Perk('$_replace $_one -1 $_card with $_one +1 DARK $_card'),
          Perk(
            '$_add $_two $_rolling HEAL 1 $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 WOUND $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 POISON $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +2 MUDDLE $_card'),
          Perk('Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
        ],
      ),
      // Crosschecked and confirmed
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 WOUND $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 POISON $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 AIR $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 EARTH $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 LIGHT $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 DARK $_card'),
          Perk(
            '$_add $_one +2 MUDDLE $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_two HEAL 1 $_rolling $_cards',
            quantity: 2,
          ),
          Perk('$_ignoreNegativeItemEffects and $_addL $_one +1 $_card'),
          Perk('$_ignoreScenarioEffects and $_addL $_one +1 $_card'),
          Perk(
              '[Spinning Up:] At the start of your first turn each scenario, you may play one card from your hand to perform a persistent loss action of that card'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _diviner: [
      Perks([
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
        Perk('$_replace $_one +0 $_card with $_one +2 LIGHT $_card'),
        Perk('$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
        Perk('$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
        Perk(
            '$_replace $_one +0 $_card with $_one +2 "$_regenerate, Self" $_card'),
        Perk(
            '$_replace $_one -1 $_card with $_one +1 "HEAL 2, Affect any Ally" $_card'),
        Perk('$_add $_two $_rolling "HEAL 1, Self" $_cards'),
        Perk('$_add $_two $_rolling CURSE $_cards'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
      ]),
      // Crosschecked and confirmed
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
          Perk('$_replace $_one +0 $_card with $_one +2 LIGHT $_card'),
          Perk('$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
          Perk(
              '$_replace $_one +0 $_card with $_one +2 "$_regenerate, self" $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one +1 "HEAL 2, Target 1 ally" $_card'),
          Perk('$_add $_two +0 CURSE $_rolling $_cards'),
          Perk('$_ignoreScenarioEffects and add $_two +1 $_cards'),
          Perk(
              '[Tip the Scales:] Whenever you rest, you may look at the top card of one attack modifier deck, then you may consume_LIGHT/DARK to place one card on the bottom of the deck'),
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _demolitionist: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk(
          '$_remove $_two -1 $_cards',
          quantity: 2,
        ),
        Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +2 MUDDLE $_card',
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
          '$_replace $_one +1 $_card with $_one +2 FIRE $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +0 "All adjacent enemies suffer 1 DAMAGE" $_card',
          quantity: 2,
        ),
      ]),
      // Crosschecked and confirmed
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_four +0 $_cards'),
          Perk('$_replace $_one -2 $_card with $_one +0 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 MUDDLE $_card',
              quantity: 2),
          Perk('$_replace $_one +1 $_card with $_two +2 $_cards'),
          Perk('$_replace $_one +1 $_card with $_one +2 FIRE $_card',
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
    _hatchet: [
      Perks([
        Perk(
          '$_remove $_two -1 $_cards',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 IMMOBILIZE $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 PUSH 2 $_card'),
        Perk('$_replace $_one +0 $_card with $_one +0 STUN $_card'),
        Perk('$_replace $_one +1 $_card with $_one +1 STUN $_card'),
        Perk(
          '$_add $_one +2 AIR $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +3 $_card',
          quantity: 3,
        ),
      ]),
      // Crosschecked and confirmed
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_replace $_one +0 $_card with $_one +0 STUN $_card'),
          Perk('$_replace $_one +1 $_card with $_one +1 STUN $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk('$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
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
    _redGuard: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove $_one -2 $_card and $_one +1 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 FIRE $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +1 $_card with $_one +2 LIGHT $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +1 FIRE&LIGHT $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +1 $_shield 1 $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +1 IMMOBILIZE $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
      ]),
      Perks(
        [
          Perk(
            '$_remove $_two -1 $_cards',
            quantity: 2,
          ),
          Perk('$_remove $_one -2 $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
          Perk(
              '$_replace $_one +0 $_card and $_one +1 $_card with $_two +1 "$_shield 1" $_cards'),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 FIRE $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +1 $_card with $_one +2 LIGHT $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 FIRE/LIGHT $_card',
            quantity: 2,
          ),
          Perk('$_ignoreItemMinusOneEffects and $_addL $_two +1 $_cards'),
          Perk(
            '[Brilliant Aegis:] Whenever you are attacked, you may consume_LIGHT to gain $_shield 1 for the attack and have the attacker gain disadvantage for the attack',
            quantity: 2,
            grouped: true,
          )
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _voidwarden: [
      Perks([
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
          '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Ally" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +1 "HEAL 1, Ally" $_card',
          quantity: 3,
        ),
        Perk('$_add $_one +1 POISON $_card'),
        Perk('$_add $_one +3 $_card'),
        Perk(
          '$_add $_one +1 CURSE $_card',
          quantity: 2,
        ),
      ]),
      Perks(
        [
          Perk('$_remove $_two -1 $_cards'),
          Perk('$_remove $_one -2 $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Target 1 ally" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "HEAL 1, Target 1 ally" $_card',
            quantity: 3,
          ),
          Perk('$_replace $_one +0 $_card with $_one +1 POISON $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 CURSE $_card',
            quantity: 2,
          ),
          Perk('$_add $_two +1 ICE $_cards'),
          Perk('$_add $_two +1 DARK $_cards'),
          Perk('$_add $_one +3 $_card'),
          Perk(_ignoreScenarioEffects),
          Perk(
              '[Grave Defense:] Whenever you rest, you may consume_ICE/DARK to give WARD to one ally who has POISON')
        ],
        variant: Variant.frosthavenCrossover,
      ),
    ],
    _amberAegis: [
      Perks([
        Perk(
            '$_replace $_one -2 $_card with $_one -1 "Place $_one Colony token of your choice on any empty hex within RANGE 2" $_card'),
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one -1 $_card with $_one +2 MUDDLE $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 POISON $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 WOUND $_card'),
        Perk(
          '$_add $_two $_rolling +1 IMMOBILIZE $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_one $_rolling "HEAL 1, Self" $_card and $_one $_rolling "$_shield 1, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one $_rolling "$_retaliate 1, RANGE 3" $_card',
          quantity: 2,
        ),
        Perk('$_add $_one +2 FIRE/EARTH $_card'),
        Perk('Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
        Perk(
            'Ignore $_scenario $_effects and $_addL $_one "+X, where X is the number of active Cultivate actions" card'),
      ]),
    ],
    _artificer: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one -1 Any_Element $_card'),
        Perk('$_replace $_one -1 $_card with $_one +1 DISARM $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 PUSH 1 $_card',
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
          '$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +2 $_card with $_one +3 "HEAL 2, Self" $_card'),
        Perk(
            '$_replace $_two +1 $_cards with $_two $_rolling +1 POISON $_cards'),
        Perk(
            '$_replace $_two +1 $_cards with $_two $_rolling +1 WOUND $_cards'),
      ]),
    ],
    _bombard: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk(
            '$_replace $_two +0 $_cards with $_two $_rolling PIERCE 3 $_cards'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "+3 if Projectile" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +2 IMMOBILIZE $_card',
          quantity: 2,
        ),
        Perk(
            '$_replace $_one +1 $_card with $_two +1 "$_retaliate 1, RANGE 3" $_cards'),
        Perk('$_add $_two +1 "PULL 3, Self, toward the target" $_cards'),
        Perk('$_add $_one +0 "STRENGTHEN, Self" $_card'),
        Perk('$_add $_one +0 STUN $_card'),
        Perk('$_add $_one +1 WOUND $_card'),
        Perk('$_add $_two $_rolling "$_shield 1, Self" $_cards'),
        Perk('$_add $_two $_rolling "HEAL 1, Self" $_cards'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
        Perk('Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
      ]),
    ],
    _brewmaster: [
      Perks([
        Perk('$_replace $_one -2 $_card with $_one -1 STUN $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_two $_rolling MUDDLE $_cards',
          quantity: 2,
        ),
        Perk('$_replace $_two +0 $_cards with $_two +0 "HEAL 1, Self" $_cards'),
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
            'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
        Perk(
          'Each time you long rest, perform Shrug_Off 1',
          quantity: 2,
        ),
      ]),
    ],
    _brightspark: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element to $_addL +2 ATTACK" $_card',
          quantity: 3,
        ),
        Perk(
            '$_replace $_one -2 $_card with $_one -2 "RECOVER $_one random $_card from your discard pile" $_card'),
        Perk(
          '$_replace $_two +0 $_cards with $_one +1 "HEAL 1, Affect $_one Ally within RANGE 2" $_card',
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
            '$_add $_one $_rolling "PUSH 1 or PULL 1, AIR" $_card and $_one $_rolling "IMMOBILIZE, ICE" $_card'),
        Perk(
            '$_add $_one $_rolling "HEAL 1, RANGE 3, LIGHT" $_card and $_one $_rolling "PIERCE 2, FIRE" $_card'),
        Perk(
            '$_add $_three $_rolling "Consume_Any_Element : Any_Element" $_cards'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
      ]),
    ],
    _chieftain: [
      Perks([
        Perk('$_replace $_one -1 $_card with $_one +0 POISON $_card'),
        Perk(
            '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Chieftain" $_card',
            quantity: 2),
        Perk(
            '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Affect all summoned allies owned" $_card',
            quantity: 2),
        Perk('$_replace $_one -2 $_card with $_one -2 "BLESS, Self" $_card'),
        Perk(
            '$_replace $_two +0 $_cards with $_one +0 "IMMOBILIZE and PUSH 1" $_card'),
        Perk(
            '$_replace $_one +0 $_card with $_one "+X, where X is the number of summoned allies you own" $_card',
            quantity: 2),
        Perk(
            '$_replace $_one +1 $_card with $_two +1 "$_rolling +1, if summon is attacking" $_cards'),
        Perk('$_add $_one +0 WOUND, PIERCE 1 $_card'),
        Perk('$_add $_one +1 EARTH $_card', quantity: 2),
        Perk(
            '$_add $_two $_rolling "PIERCE 2, ignore $_retaliate on the target" $_cards'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
      ])
    ],
    _fireKnight: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "STRENGTHEN, Ally" $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_two +0 $_cards with $_two +0 "+2 if you are on Ladder" $_cards',
          quantity: 2,
        ),
        Perk('$_replace $_one +0 $_card with $_one +1 FIRE $_card'),
        Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
        Perk('$_replace $_two +1 $_cards with $_one +2 FIRE $_card'),
        Perk('$_replace $_two +1 $_cards with $_one +2 WOUND $_card'),
        Perk('$_add $_one +1 "STRENGTHEN, Ally" $_card'),
        Perk(
          '$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards',
          quantity: 2,
        ),
        Perk('$_add $_two $_rolling WOUND $_cards'),
        Perk(
            'Ignore $_negative item $_effects and $_addL $_one $_rolling FIRE $_card'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_addL $_one $_rolling FIRE $_card'),
      ])
    ],

    _frostborn: [
      Perks([
        Perk(
          '$_remove $_two -1 $_cards',
          quantity: 2,
        ),
        Perk('$_replace $_one -2 $_card with $_one +0 CHILL $_card'),
        Perk(
          '$_replace $_two +0 $_cards with $_two +1 PUSH 1 $_cards',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 ICE CHILL $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one +1 $_card with $_one +3 $_card'),
        Perk('$_add $_one +0 STUN $_card'),
        Perk(
          '$_add $_one $_rolling ADD TARGET $_card',
          quantity: 2,
        ),
        Perk('$_add $_three $_rolling CHILL $_cards'),
        Perk('$_add $_three $_rolling PUSH 1 $_cards'),
        Perk('Ignore difficult and hazardous terrain during move actions'),
        Perk('Ignore $_scenario $_effects'),
      ]),
    ],
    _hollowpact: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 "HEAL 2, Self" $_card',
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
            '$_replace $_one -1 $_card with $_one -2 STUN $_card and $_one +0 VOIDSIGHT $_card'),
        Perk(
            '$_replace $_one -2 $_card with $_one +0 DISARM $_card and $_one -1 Any_Element $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one $_rolling +1 VOID $_card and $_one $_rolling -1 CURSE $_card',
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
            'Ignore $_negative $_scenario $_effects and $_addL $_one +0 "WARD, Self" $_card'),
      ]),
    ],
    _mirefoot: [
      Perks([
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
          '$_replace $_one +1 $_card with $_one +0 WOUND 2 $_card',
          quantity: 2,
        ),
        Perk(
            '$_add four $_rolling +0 "+1 if the target occupies difficult terrain" $_cards'),
        Perk(
            '$_add $_two $_rolling "INVISIBLE, Self, if you occupy difficult terrain" $_cards'),
        Perk(
            'Gain "Poison Dagger" (Item 011). You may carry $_one additional One_Hand item with "Dagger" in its name'),
        Perk(
            'Ignore damage, $_negative conditions, and modifiers from Events, and $_removeL $_one -1 $_card'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
      ]),
    ],
    // May be dead Perks if Rootwhisperer has a big overhaul - this is fine
    _rootwhisperer: [
      Perks([
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
          '$_add $_one +1 IMMOBILIZE $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_two $_rolling POISON $_cards',
          quantity: 2,
        ),
        Perk('$_add $_one $_rolling DISARM $_card'),
        Perk(
          '$_add $_one $_rolling HEAL 2 EARTH $_card',
          quantity: 2,
        ),
        Perk('Ignore $_negative $_scenario $_effects'),
      ]),
    ],
    // TODO: NEED TO CHECK ALL BELOW HERE vvvvvvvv *************
    _chainguard: [
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
        Perk('$_replace $_one +1 $_card with $_one +2 WOUND $_card'),
        Perk('$_add $_one +1 "DISARM if the target is Shackled" $_card'),
        Perk(
            '$_add $_one +1 "Create a 2 DAMAGE trap in an empty hex within RANGE 2" $_card'),
        Perk('$_add $_two $_rolling "HEAL 1, Self" $_cards'),
        Perk(
          '$_add $_one +2 Shackle $_card',
          quantity: 2,
        ),
        Perk('Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
      ]),
    ],
    _hierophant: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_two +0 $_cards with $_one $_rolling LIGHT $_card'),
        Perk('$_replace $_two +0 $_cards with $_one $_rolling EARTH $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 CURSE $_card',
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
          '$_add $_two $_rolling "HEAL 1, Self or Ally" $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +1 WOUND, MUDDLE $_card',
          quantity: 2,
        ),
        Perk('At the start of your first turn each $_scenario, gain BLESS'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
      ]),
    ],
    _luminary: [
      Perks([
        Perk('$_remove four +0 $_cards'),
        Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 ICE $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 FIRE $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 LIGHT $_card'),
        Perk('$_replace $_one -1 $_card with $_one +0 DARK $_card'),
        Perk(
            '$_replace $_one -2 $_card with $_one -2 "Perform $_one Glow ability" $_card'),
        Perk(
          '$_add $_one +0 Any_Element $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one $_rolling +1 "HEAL 1, Self" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one "POISON, target all enemies in the depicted LUMINARY_HEXES area" $_card',
          quantity: 2,
        ),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
        Perk(
            'Ignore $_negative item $_effects and $_addL $_one $_rolling "Consume_Any_Element : Any_Element" $_card'),
      ]),
    ],
    _spiritCaller: [
      Perks([
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
        Perk('$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
        Perk('$_add $_three $_rolling PIERCE 3 $_cards'),
        Perk('$_add $_one +1 CURSE $_card'),
        Perk('$_add $_one $_rolling ADD TARGET $_card'),
        Perk('$_replace $_one +1 $_card with $_one +2 PUSH 2 $_card'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
      ]),
    ],
    _starslinger: [
      Perks([
        Perk(
          '$_replace $_two +0 $_cards with $_one $_rolling "HEAL 1, Self" $_card',
          quantity: 2,
        ),
        Perk(
            '$_replace $_one -2 $_card with $_one -1 "INVISIBLE, Self" $_card'),
        Perk('$_replace $_two -1 $_cards with $_one +0 DARK $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 LIGHT $_card',
          quantity: 2,
        ),
        Perk('$_add $_one $_rolling LOOT 1 $_card'),
        Perk(
          '$_add $_one +1 "+3 if you are at full health" $_card',
          quantity: 2,
        ),
        Perk('$_add $_two $_rolling $_immobilize $_cards'),
        Perk(
          '$_add $_one +1 "HEAL 1, RANGE 3" $_card',
          quantity: 2,
        ),
        Perk(
            '$_add $_two $_rolling "Force the target to perform a \'MOVE 1\' ability" $_cards'),
        Perk('$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards'),
        Perk(
            'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
      ]),
    ],
    _ruinmaw: [
      Perks([
        Perk(
            '$_replace $_one -2 $_card with $_one -1 RUPTURE and WOUND $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 WOUND $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 RUPTURE $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_add +3 instead if the target has RUPTURE or WOUND" $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one $_rolling "HEAL 1, Self, EMPOWER" $_card',
          quantity: 3,
        ),
        Perk(
            'Once each $_scenario, become SATED after collecting your 5th loot token'),
        Perk(
            'Become SATED each time you lose a $_card to negate suffering damage'),
        Perk(
            'Whenever $_one of your abilities causes at least $_one enemy to gain RUPTURE, immediately after that ability perform "MOVE 1"'),
        Perk(
            'Ignore $_negative $_scenario $_effects, and $_removeL $_one -1 $_card'),
      ]),
    ],
    // Crosschecked and confirmed
    _drifter: [
      Perks([
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
            '$_replace $_two +0 $_cards with $_two PIERCE 3 $_rolling $_cards'),
        Perk('$_replace $_two +0 $_cards with $_two PUSH 2 $_rolling $_cards'),
        Perk('$_add $_one +3 $_card'),
        Perk(
          '$_add $_one +2 $_immobilize $_card',
          quantity: 2,
        ),
        Perk('$_add $_two "HEAL 1, self" $_rolling $_cards'),
        Perk('$_ignoreScenarioEffects and $_addL $_one +1 $_card'),
        Perk('$_ignoreItemMinusOneEffects and $_addL $_one +1 $_card'),
        Perk(
          'Whenever you long rest, you may move $_one of your character tokens backward $_one slot',
          quantity: 2,
          grouped: true,
        ),
        Perk(
            'You may bring $_one additional One_Hand item into each $_scenario'),
        Perk(
            'At the end of each $_scenario, you may discard up to $_two loot $_cards, except ~Random ~Item, to draw that many new loot $_cards'),
      ]),
    ],
    // Crosschecked and confirmed
    _blinkBlade: [
      Perks([
        Perk('$_remove $_one -2 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 WOUND $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one "Place this $_card in your active area. On your next attack, discard this $_card to $_addL plustwo ATTACK" $_rolling $_card',
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
            'Whenever you short rest, you may spend $_one unspent SPENT item for no effect to RECOVER a different spent item'),
        Perk(
            'At the start of your first turn each $_scenario, you may perform MOVE 3'),
        Perk('Whenever you would gain $_immobilize, prevent the condition'),
      ]),
    ],
    // Crosschecked and confirmed
    _bannerSpear: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "$_add plusone ATTACK for each ally adjacent to the target" $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +1 DISARM $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +2 PUSH 1 $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_two +1 $_rolling $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_two "HEAL 1, self" $_rolling $_cards',
          quantity: 2,
        ),
        Perk('$_ignoreItemMinusOneEffects and $_removeL $_one -1 $_card'),
        Perk(
            'At the end of each of your long rests, grant $_one ally within RANGE 3: MOVE 2'),
        Perk('Whenever you open a door with a move ability, $_addL +3 MOVE'),
        Perk(
          'Once each $_scenario, during your turn, gain $_shield 2 for the round',
          grouped: true,
          quantity: 2,
        ),
      ]),
    ],
    // Crosschecked and confirmed
    _deathwalker: [
      Perks([
        Perk('$_remove $_two -1 $_cards'),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one -1 $_card with $_one +1 $_card',
          quantity: 3,
        ),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 CURSE $_card',
          quantity: 3,
        ),
        Perk(
          '$_add $_one +2 DARK $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_one DISARM $_rolling and $_one MUDDLE $_rolling $_card',
          quantity: 2,
        ),
        Perk(
          '$_add $_two "HEAL 1, Target 1 ally" $_rolling $_cards',
          quantity: 2,
        ),
        Perk(_ignoreScenarioEffects),
        Perk('Whenever you long rest, you may move $_one SHADOW up to 3 hexes'),
        Perk(
            'Whenever you short rest, you may consume_DARK to perform MUDDLE, CURSE, RANGE 2 as if you were occupying a hex with a SHADOW'),
        Perk(
            'While you are occupying a hex with a SHADOW, all attacks targeting you gain disadvantage'),
      ]),
    ],
    // Crosschecked and confirmed
    _boneshaper: [
      Perks([
        Perk(
          '$_replace $_one -1 $_card with $_one +0 CURSE $_card',
          quantity: 2,
        ),
        Perk(
          '$_replace $_one -1 $_card with $_one +0 POISON $_card',
          quantity: 2,
        ),
        Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
        Perk(
          '$_replace $_one +0 $_card with $_one +1 "Kill the attacking summon to instead $_addL +4" $_card',
          quantity: 3,
        ),
        Perk(
          '$_add $_three "HEAL 1, Target Boneshaper" $_rolling $_cards',
          quantity: 2,
        ),
        Perk(
          '$_add $_one +2 EARTH/DARK $_card',
          quantity: 3,
        ),
        Perk('$_ignoreScenarioEffects and $_addL $_two +1 $_cards'),
        Perk(
            'Immediately before each of your rests, you may kill $_one of your summons to perform BLESS, self'),
        Perk(
            'Once each $_scenario, when any character ally would become exhausted by suffering DAMAGE, you may suffer DAMAGE 2 to reduce their hit point value to 1 instead'),
        Perk(
          'At the start of each $_scenario, you may play a level 1 $_card from your hand to perform a summon action of the $_card',
          quantity: 2,
          grouped: true,
        ),
      ]),
    ],
    // Crosschecked and confirmed
    _geminate: [
      Perks([
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
          '$_replace $_one +0 $_card with $_one +1 WOUND $_card',
          quantity: 2,
        ),
        Perk(
            '$_replace $_two +0 $_cards with $_two PIERCE 3 $_rolling $_cards'),
        Perk('$_add $_two +1 PUSH 3 $_cards'),
        Perk('$_add $_one 2x "BRITTLE, self" $_card'),
        Perk(
          '$_add $_one +1 "$_regenerate, self" $_rolling card',
          quantity: 2,
        ),
        Perk(_ignoreScenarioEffects),
        Perk(
            'Whenever you short rest, you may $_removeL $_one $_negative condition from $_one ally within RANGE 3'),
        Perk(
            'Once each $_scenario, when you would give yourself a $_negative condition, prevent the condition'),
        Perk(
          'Whenever you perform an action with a lost icon, you may discard $_one $_card to RECOVER $_one card from your discard pile of equal or lower level',
          quantity: 2,
          grouped: true,
        ),
      ]),
    ],
  };

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

  static final List<PlayerClass> playerClasses = [
    // GLOOMHAVEN
    PlayerClass(
        race: _inox,
        name: 'Brute',
        classCode: _brute,
        icon: 'brute.svg',
        category: ClassCategory.gloomhaven,
        locked: false,
        primaryColor: 0xff4e7ec1,
        traits: [
          _armored,
          _intimidating,
          _strong,
        ]),
    PlayerClass(
      race: _quatryl,
      name: 'Tinkerer',
      classCode: _tinkerer,
      icon: 'tinkerer.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffc5b58d,
      traits: [
        _educated,
        _nimble,
        _resourceful,
      ],
    ),
    PlayerClass(
      race: _orchid,
      name: 'Spellweaver',
      classCode: _spellweaver,
      icon: 'spellweaver.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffb578b3,
      traits: [
        _arcane,
        _educated,
        _resourceful,
      ],
    ),
    PlayerClass(
      race: _human,
      name: 'Scoundrel',
      classCode: _scoundrel,
      icon: 'scoundrel.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffa5d166,
      traits: [
        _chaotic,
        _nimble,
        _resourceful,
      ],
    ),
    PlayerClass(
      race: _savvas,
      name: 'Cragheart',
      classCode: _cragheart,
      icon: 'cragheart.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xff899538,
      traits: [
        _armored,
        _outcast,
        _strong,
      ],
    ),
    PlayerClass(
      race: _vermling,
      name: 'Mindthief',
      classCode: _mindthief,
      icon: 'mindthief.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xff647c9d,
      traits: [
        _arcane,
        _outcast,
        _persuasive,
      ],
    ),
    PlayerClass(
        race: _valrath,
        name: 'Sunkeeper',
        classCode: _sunkeeper,
        icon: 'sunkeeper.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xfff3c338,
        traits: [
          _armored,
          _nimble,
          _persuasive,
        ]),
    PlayerClass(
        race: _valrath,
        name: 'Quartermaster',
        classCode: _quartermaster,
        icon: 'quartermaster.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xffd98926,
        traits: [
          _armored,
          _resourceful,
          _strong,
        ]),
    PlayerClass(
        race: _aesther,
        name: 'Summoner',
        classCode: _summoner,
        icon: 'summoner.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xffeb6ea3,
        traits: [
          _arcane,
          _chaotic,
          _resourceful,
        ]),
    PlayerClass(
        race: _aesther,
        name: 'Nightshroud',
        classCode: _nightshroud,
        icon: 'nightshroud.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xff9f9fcf,
        traits: [
          _chaotic,
          _intimidating,
          _nimble,
        ]),
    PlayerClass(
      race: _harrower,
      name: 'Plagueherald',
      classCode: _plagueherald,
      icon: 'plagueherald.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xff74c7bb,
      traits: [
        _arcane,
        _intimidating,
        _outcast,
      ],
    ),
    PlayerClass(
      race: _inox,
      name: 'Berserker',
      classCode: _berserker,
      icon: 'berserker.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xffd14e4e,
      traits: [
        _chaotic,
        _intimidating,
        _strong,
      ],
    ),
    PlayerClass(
      race: _quatryl,
      name: 'Soothsinger',
      classCode: _soothsinger,
      icon: 'soothsinger.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xffdf7e7a,
      traits: [
        _educated,
        _nimble,
        _persuasive,
      ],
    ),
    PlayerClass(
      race: _orchid,
      name: 'Doomstalker',
      classCode: _doomstalker,
      icon: 'doomstalker.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xff38c3f1,
      traits: [
        _chaotic,
        _intimidating,
        _nimble,
      ],
    ),
    PlayerClass(
        race: _human,
        name: 'Sawbones',
        classCode: _sawbones,
        icon: 'sawbones.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xffdfddcb,
        traits: [
          _educated,
          _persuasive,
          _resourceful,
        ]),
    PlayerClass(
      race: _savvas,
      name: 'Elementalist',
      classCode: _elementalist,
      icon: 'elementalist.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xff9e9d9d,
      traits: [
        _arcane,
        _educated,
        _intimidating,
      ],
    ),
    PlayerClass(
      race: _vermling,
      name: 'Beast Tyrant',
      classCode: _beastTyrant,
      icon: 'beast_tyrant.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xffad745c,
      traits: [
        _armored,
        _outcast,
        _strong,
      ],
    ),
    // ENVELOPE X
    PlayerClass(
      race: _harrower,
      name: 'Bladeswarm',
      classCode: _bladeswarm,
      icon: 'bladeswarm.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffae5a4d,
      traits: [
        _armored,
        _intimidating,
        _nimble,
      ],
    ),
    // FORGOTTEN CIRCLES
    PlayerClass(
        race: _aesther,
        name: 'Diviner',
        classCode: _diviner,
        icon: 'diviner.svg',
        category: ClassCategory.gloomhaven,
        locked: false,
        primaryColor: 0xff8bc5d3,
        traits: [
          _arcane,
          _outcast,
          _resourceful,
        ]),
    // JAWS OF THE LION
    PlayerClass(
      race: _quatryl,
      name: 'Demolitionist',
      classCode: _demolitionist,
      icon: 'demolitionist.svg',
      category: ClassCategory.jawsOfTheLion,
      locked: false,
      primaryColor: 0xffe65c18,
      traits: [
        _chaotic,
        _nimble,
        _strong,
      ],
    ),
    PlayerClass(
      race: _inox,
      name: 'Hatchet',
      classCode: _hatchet,
      icon: 'hatchet.svg',
      category: ClassCategory.jawsOfTheLion,
      locked: false,
      primaryColor: 0xff78a1ad,
      traits: [
        _intimidating,
        _resourceful,
        _strong,
      ],
    ),
    PlayerClass(
      race: _valrath,
      name: 'Red Guard',
      classCode: _redGuard,
      icon: 'red_guard.svg',
      category: ClassCategory.jawsOfTheLion,
      locked: false,
      primaryColor: 0xffe3393b,
      traits: [
        _armored,
        _outcast,
        _persuasive,
      ],
    ),
    PlayerClass(
        race: _human,
        name: 'Voidwarden',
        classCode: _voidwarden,
        icon: 'voidwarden.svg',
        category: ClassCategory.jawsOfTheLion,
        locked: false,
        primaryColor: 0xffd9d9d9,
        traits: [
          _arcane,
          _educated,
          _outcast,
        ]),
    // FROSTHAVEN
    PlayerClass(
      race: _inox,
      name: 'Drifter',
      classCode: _drifter,
      icon: 'drifter.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xff92887f,
      traits: [
        _outcast,
        _resourceful,
        _strong,
      ],
    ),
    PlayerClass(
      race: _quatryl,
      name: 'Blink Blade',
      classCode: _blinkBlade,
      icon: 'blink_blade.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xff00a8cf,
      traits: [
        _educated,
        _nimble,
        _resourceful,
      ],
    ),
    PlayerClass(
      race: _human,
      name: 'Banner Spear',
      classCode: _bannerSpear,
      icon: 'banner_spear.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xfffdd072,
      traits: [
        _armored,
        _persuasive,
        _resourceful,
      ],
    ),
    PlayerClass(
      race: _valrath,
      name: 'Deathwalker',
      classCode: _deathwalker,
      icon: 'deathwalker.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xffacc8ed,
      traits: [
        _arcane,
        _outcast,
        _persuasive,
      ],
    ),
    PlayerClass(
      race: _aesther,
      name: 'Boneshaper',
      classCode: _boneshaper,
      icon: 'boneshaper.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xff6cbe4c,
      traits: [
        _arcane,
        _educated,
        _intimidating,
      ],
    ),
    PlayerClass(
      race: _harrower,
      name: 'Geminate',
      classCode: _geminate,
      icon: 'geminate.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xffab1c54,
      traits: [
        _arcane,
        _chaotic,
        _nimble,
      ],
    ),
    PlayerClass(
      race: _orchid,
      name: 'Infuser',
      classCode: _infuser,
      icon: 'infuser.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff7bc144,
      traits: [
        _arcane,
        _educated,
        _strong,
      ],
    ),
    PlayerClass(
      race: _savvas,
      name: 'Pyroclast',
      classCode: _pyroclast,
      icon: 'pyroclast.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffff4a1d,
      traits: [
        _arcane,
        _chaotic,
        _intimidating,
      ],
    ),
    PlayerClass(
      race: _savvas,
      name: 'Shattersong',
      classCode: _shattersong,
      icon: 'shattersong.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffc2c5c9,
      traits: [
        _educated,
        _outcast,
        _persuasive,
      ],
    ),
    PlayerClass(
      race: _vermling,
      name: 'Trapper',
      classCode: _trapper,
      icon: 'trapper.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffd1b38d,
      traits: [
        _nimble,
        _outcast,
        _resourceful,
      ],
    ),
    PlayerClass(
      race: _aesther,
      name: 'Pain Conduit',
      classCode: _painConduit,
      icon: 'pain_conduit.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffbec5e4,
      traits: [
        _chaotic,
        _intimidating,
        _outcast,
      ],
    ),
    PlayerClass(
      race: _algox,
      name: 'Snowdancer',
      classCode: _snowdancer,
      icon: 'snowdancer.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff7cd1e7,
      traits: [
        _chaotic,
        _nimble,
        _persuasive,
      ],
    ),
    PlayerClass(
      race: _algox,
      name: 'Frozen Fist',
      classCode: _frozenFist,
      icon: 'frozen_fist.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff88bee7,
      traits: [
        _intimidating,
        _persuasive,
        _strong,
      ],
    ),
    PlayerClass(
      race: _unfettered,
      name: 'HIVE',
      classCode: _hive,
      icon: 'hive.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffecb633,
      traits: [
        _armored,
        _educated,
        _resourceful,
      ],
    ),
    PlayerClass(
      race: _unfettered,
      name: 'Metal Mosaic',
      classCode: _metalMosaic,
      icon: 'metal_mosaic.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffddb586,
      traits: [
        _armored,
        _resourceful,
        _strong,
      ],
    ),
    PlayerClass(
      race: _lurker,
      name: 'Deepwraith',
      classCode: _deepwraith,
      icon: 'deepwraith.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffac427d,
      traits: [
        _armored,
        _intimidating,
        _nimble,
      ],
    ),
    PlayerClass(
      race: _lurker,
      name: 'Crashing Tide',
      classCode: _crashingTide,
      icon: 'crashing_tide.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff59c0a1,
      traits: [
        _armored,
        _chaotic,
        _strong,
      ],
    ),
    // CRIMSON SCALES
    PlayerClass(
      race: _harrower,
      name: 'Amber Aegis',
      classCode: _amberAegis,
      icon: 'amber_aegis.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffeb880d,
      secondaryColor: 0xfffff600,
    ),
    PlayerClass(
      race: _quatryl,
      name: 'Artificer',
      classCode: _artificer,
      icon: 'artificer.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff477ca6,
      secondaryColor: 0xff8ccee5,
    ),
    PlayerClass(
      race: _quatryl,
      name: 'Bombard',
      classCode: _bombard,
      icon: 'bombard.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff948572,
      secondaryColor: 0xff8c683b,
    ),
    PlayerClass(
      race: _human,
      name: 'Brightspark',
      classCode: _brightspark,
      icon: 'brightspark.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffcaad2e,
      secondaryColor: 0xffc49a3d,
    ),
    PlayerClass(
      race: _inox,
      name: 'Chainguard',
      classCode: _chainguard,
      icon: 'chainguard.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffce6d30,
      secondaryColor: 0xff1e1d1d,
    ),
    PlayerClass(
      race: _orchid,
      name: 'Chieftain',
      classCode: _chieftain,
      icon: 'chieftain.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff76c6c3,
      secondaryColor: 0xff5e7574,
    ),
    PlayerClass(
      race: _valrath,
      name: 'Fire Knight',
      classCode: _fireKnight,
      icon: 'fire_knight.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffd52229,
      secondaryColor: 0xfff25424,
    ),
    PlayerClass(
      race: _human,
      name: 'Hierophant',
      classCode: _hierophant,
      icon: 'hierophant.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffddde8a,
      secondaryColor: 0xffa9a5ad,
    ),
    PlayerClass(
      race: _savvas,
      name: 'Hollowpact',
      classCode: _hollowpact,
      icon: 'hollowpact.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffa765a9,
      secondaryColor: 0xff310f33,
    ),
    PlayerClass(
      race: _inox,
      name: 'Incarnate',
      classCode: _incarnate,
      icon: 'incarnate.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffc63072,
      secondaryColor: 0xff70d686,
      // traits: [
      //   _strong,
      //   _arcane,
      //   _persuasive,
      // ],
    ),
    PlayerClass(
      race: _lurker,
      name: 'Luminary',
      classCode: _luminary,
      icon: 'luminary.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffb28abf,
      secondaryColor: 0xffa43287,
    ),
    PlayerClass(
      race: _quatryl,
      name: 'Mirefoot',
      classCode: _mirefoot,
      icon: 'mirefoot.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffef6b26,
      secondaryColor: 0xff4b732e,
    ),
    PlayerClass(
      race: _savvas,
      name: 'Rimehearth',
      classCode: _rimehearth,
      icon: 'rimehearth.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff61d4e8,
      secondaryColor: 0xffd62d2a,
    ),
    PlayerClass(
      race: _vermling,
      name: 'Ruinmaw',
      classCode: _ruinmaw,
      icon: 'ruinmaw.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffdb332d,
      secondaryColor: 0xffdb332d,
    ),
    PlayerClass(
      race: _orchid,
      name: 'Shardrender',
      classCode: _shardrender,
      icon: 'shardrender.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffffd04f,
      secondaryColor: 0xffffaa23,
    ),
    PlayerClass(
      race: _vermling,
      name: 'Spirit Caller',
      classCode: _spiritCaller,
      icon: 'spirit_caller.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff63bd57,
      secondaryColor: 0xffa6ce39,
    ),
    PlayerClass(
      race: _aesther,
      name: 'Starslinger',
      classCode: _starslinger,
      icon: 'starslinger.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff4f57a6,
      secondaryColor: 0xffa3aacc,
    ),
    PlayerClass(
      race: _orchid,
      name: 'Tempest',
      classCode: _tempest,
      icon: 'tempest.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff66c9fc,
      secondaryColor: 0xff109de0,
    ),
    PlayerClass(
      race: _orchid,
      name: 'Thornreaper',
      classCode: _thornreaper,
      icon: 'thornreaper.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xfffbff96,
      secondaryColor: 0xff80995a,
    ),
    PlayerClass(
      race: _valrath,
      name: 'Vanquisher',
      classCode: _vanquisher,
      icon: 'vanquisher.svg',
      category: ClassCategory.crimsonScales,
      locked: false,
      primaryColor: 0xffd3423e,
      secondaryColor: 0xffbdbdbd,
    ),
    //CUSTOM
    PlayerClass(
      race: _orchid,
      name: 'Brewmaster',
      classCode: _brewmaster,
      icon: 'brewmaster.svg',
      category: ClassCategory.custom,
      primaryColor: 0xffe2c22b,
    ),
    PlayerClass(
      race: _orchid,
      name: 'Frostborn',
      classCode: _frostborn,
      icon: 'frostborn.svg',
      category: ClassCategory.custom,
      primaryColor: 0xffb0e0ea,
    ),
    // This class is still in beta. Its perks are in version 3.7.0
    // TODO: when bringing it back, show it in Search Delegate
    PlayerClass(
      race: _human,
      name: 'Rootwhisperer',
      classCode: _rootwhisperer,
      icon: 'rootwhisperer.svg',
      category: ClassCategory.custom,
      primaryColor: 0xff7bd071,
    ),
  ];

  static final List<Resource> resources = [
    Resource(
      'Lumber',
      'images/resources/lumber.svg',
    ),
    Resource(
      'Metal',
      'images/resources/metal.svg',
    ),
    Resource(
      'Hide',
      'images/resources/hide.svg',
    ),
    Resource(
      'Arrowvine',
      'images/resources/arrow_vine.svg',
    ),
    Resource(
      'Axenut',
      'images/resources/axe_nut.svg',
    ),
    Resource(
      'Corpsecap',
      'images/resources/corpse_cap.svg',
    ),
    Resource(
      'Flamefruit',
      'images/resources/flame_fruit.svg',
    ),
    Resource(
      'Rockroot',
      'images/resources/rock_root.svg',
    ),
    Resource(
      'Snowthistle',
      'images/resources/snow_thistle.svg',
    ),
  ];

  static const _add = 'Add';
  static const _addL = 'add';
  static const _aesther = 'Aesther';
  static const _algox = 'Algox';
  static const _amberAegis = 'aa';
  static const _arcane = 'Arcane';
  static const _armored = 'Armored';
  static const _artificer = 'af';
  static const _bannerSpear = 'bannerspear';
  static const _beastTyrant = 'bt';
  static const _berserker = 'be';
  static const _bladeswarm = 'bs';
  static const _blinkBlade = 'blinkblade';
  static const _bombard = 'bb';
  static const _boneshaper = 'boneshaper';
  static const _brewmaster = 'bm';
  static const _brightspark = 'bp';
  static const _brute = 'br';
  static const _card = 'card';
  static const _cards = 'cards';
  static const _chainguard = 'cg';
  static const _chaotic = 'Chaotic';
  static const _chieftain = 'ct';
  static const _cragheart = 'ch';
  static const _crashingTide = 'crashingtide';
  static const _deathwalker = 'deathwalker';
  static const _deepwraith = 'deepwraith';
  static const _demolitionist = 'dl';
  static const _diviner = 'dv';
  static const _doomstalker = 'ds';
  static const _drifter = 'drifter';
  static const _educated = 'Educated';
  static const _effects = 'effects';
  static const _elementalist = 'el';
  static const _fireKnight = 'fk';
  static const _four = 'four';
  static const _frostborn = 'fb';
  static const _frozenFist = 'frozenfist';
  static const _geminate = 'geminate';
  static const _harrower = 'Harrower';
  static const _hatchet = 'hc';
  static const _hierophant = 'hf';
  static const _hive = 'hive';
  static const _hollowpact = 'hp';
  static const _human = 'Human';
  static const _ignoreItemMinusOneEffects =
      'Ignore item item_minus_one effects';

  static const _ignoreNegativeItemEffects = 'Ignore negative item effects';
  static const _ignoreScenarioEffects = 'Ignore scenario effects';
  static const _immobilize = 'IMMOBILIZE';
  static const _incarnate = 'incarnate';
  static const _infuser = 'infuser';
  static const _inox = 'Inox';
  static const _intimidating = 'Intimidating';
  static final Map<int, int> _levelXp = {
    1: 0,
    2: 45,
    3: 95,
    4: 150,
    5: 210,
    6: 275,
    7: 345,
    8: 420,
    9: 500,
  };

  static const _luminary = 'ln';
  static const _lurker = 'Lurker';
  static const _metalMosaic = 'metalmosaic';
  static const _mindthief = 'mt';
  static const _mirefoot = 'mf';
  static const _negative = 'negative';
  static const _nightshroud = 'ns';
  static const _nimble = 'Nimble';
  static const _one = 'one';
  static const _orchid = 'Orchid';
  static const _outcast = 'Outcast';
  static const _painConduit = 'painconduit';
  static const _persuasive = 'Persuasive';
  static const _plagueherald = 'ph';
  static const _pyroclast = 'pyroclast';
  static const _quartermaster = 'qm';
  static const _quatryl = 'Quatryl';
  static const _redGuard = 'rg';
  static const _regenerate = 'REGENERATE';
  static const _remove = 'Remove';
  static const _removeL = 'remove';
  static const _replace = 'Replace';
  static const _resourceful = 'Resourceful';
  static const _retaliate = 'RETALIATE';
  static const _rimehearth = 'rimehearth';
  static const _rolling = 'Rolling';
  static const _rootwhisperer = 'rw';
  static const _ruinmaw = 'rm';
  static const _savvas = 'Savvas';
  static const _sawbones = 'sb';
  static const _scenario = 'scenario';
  static const _scoundrel = 'sc';
  static const _shardrender = 'shardrender';
  static const _shattersong = 'shattersong';
  static const _shield = 'SHIELD';
  static const _snowdancer = 'snowdancer';
  static const _soothsinger = 'ss';
  static const _spellweaver = 'sw';
  static const _spiritCaller = 'scr';
  static const _starslinger = 'ssl';
  static const _strong = 'Strong';
  static const _summoner = 'su';
  static const _sunkeeper = 'sk';
  static const _tempest = 'tempest';
  static const _thornreaper = 'thornreaper';
  static const _three = 'three';
  static const _tinkerer = 'ti';
  static const _trapper = 'trapper';
  static const _two = 'two';
  static const _unfettered = 'Unfettered';
  static const _valrath = 'Valrath';
  static const _vanquisher = 'vanquisher';
  static const _vermling = 'Vermling';
  static const _voidwarden = 'vw';

  static PlayerClass playerClassByClassCode(String classCode) {
    return playerClasses.firstWhere(
      (playerClass) => playerClass.classCode == classCode,
    );
  }

  static int xpByLevel(int level) =>
      _levelXp.entries.lastWhere((entry) => entry.key == level).value;

  static int nextXpByLevel(int level) => _levelXp.entries
      .firstWhere(
        (entry) => entry.key > level,
        orElse: () => _levelXp.entries.last,
      )
      .value;

  static int levelByXp(int xp) => _levelXp.entries
      .lastWhere(
        (entry) => entry.value <= xp,
      )
      .key;
}
