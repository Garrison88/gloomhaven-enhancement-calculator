import 'package:gloomhaven_enhancement_calc/models/goal.dart';
import 'package:gloomhaven_enhancement_calc/models/legacy_perk.dart' as legacy;
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/legacy_mastery.dart'
    as legacy;
import 'package:gloomhaven_enhancement_calc/models/perk.dart';
import 'package:gloomhaven_enhancement_calc/models/personal_goal.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/models/resource.dart';
import 'package:gloomhaven_enhancement_calc/data/character_constants.dart';

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
    legacy.Perk(ClassCodes.brute, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.brute, 1,
        '$_remove $_one -1 $_card and $_addL $_one +1 $_card'),
    legacy.Perk(ClassCodes.brute, 2, '$_add $_two +1 $_cards'),
    legacy.Perk(ClassCodes.brute, 1, '$_add $_one +3 $_card'),
    legacy.Perk(ClassCodes.brute, 2, '$_add $_three $_rolling PUSH 1 $_cards'),
    legacy.Perk(ClassCodes.brute, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(ClassCodes.brute, 2, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(ClassCodes.brute, 1,
        '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
    legacy.Perk(ClassCodes.brute, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(
        ClassCodes.brute, 1, '$_add $_one +1 "$_shield 1, Self" $_card'),
    legacy.Perk(ClassCodes.brute, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    // TINKERER
    legacy.Perk(ClassCodes.tinkerer, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.tinkerer, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.tinkerer, 1, '$_add $_two +1 $_cards'),
    legacy.Perk(ClassCodes.tinkerer, 1, '$_add $_one +3 $_card'),
    legacy.Perk(ClassCodes.tinkerer, 1, '$_add $_two $_rolling FIRE $_cards'),
    legacy.Perk(
        ClassCodes.tinkerer, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(ClassCodes.tinkerer, 2, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.tinkerer, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.tinkerer, 2, '$_add $_one +1 HEAL 2 $_card'),
    legacy.Perk(ClassCodes.tinkerer, 1, '$_add $_one +0 ADD TARGET $_card'),
    legacy.Perk(
        ClassCodes.tinkerer, 1, 'Ignore $_negative $_scenario $_effects'),
    // SPELLWEAVER
    legacy.Perk(ClassCodes.spellweaver, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.spellweaver, 2,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.spellweaver, 2, '$_add $_two +1 $_cards'),
    legacy.Perk(ClassCodes.spellweaver, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(ClassCodes.spellweaver, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(
        ClassCodes.spellweaver, 1, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.spellweaver, 1, '$_add $_one +1 CURSE $_card'),
    legacy.Perk(ClassCodes.spellweaver, 2, '$_add $_one +2 FIRE $_card'),
    legacy.Perk(ClassCodes.spellweaver, 2, '$_add $_one +2 ICE $_card'),
    legacy.Perk(ClassCodes.spellweaver, 1,
        '$_add $_one $_rolling EARTH and $_one $_rolling AIR $_card'),
    legacy.Perk(ClassCodes.spellweaver, 1,
        '$_add $_one $_rolling LIGHT and $_one $_rolling DARK $_card'),
    // SCOUNDREL
    legacy.Perk(ClassCodes.scoundrel, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.scoundrel, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.scoundrel, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.scoundrel, 1,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.scoundrel, 2,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.scoundrel, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(
        ClassCodes.scoundrel, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(
        ClassCodes.scoundrel, 2, '$_add $_two $_rolling POISON $_cards'),
    legacy.Perk(
        ClassCodes.scoundrel, 1, '$_add $_two $_rolling MUDDLE $_cards'),
    legacy.Perk(
        ClassCodes.scoundrel, 1, '$_add $_one $_rolling INVISIBLE $_card'),
    legacy.Perk(
        ClassCodes.scoundrel, 1, 'Ignore $_negative $_scenario $_effects'),
    // CRAGHEART
    legacy.Perk(ClassCodes.cragheart, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.cragheart, 3,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(
        ClassCodes.cragheart, 1, '$_add $_one -2 $_card and $_two +2 $_cards'),
    legacy.Perk(ClassCodes.cragheart, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.cragheart, 2, '$_add $_one +2 MUDDLE $_card'),
    legacy.Perk(
        ClassCodes.cragheart, 1, '$_add $_two $_rolling PUSH 2 $_cards'),
    legacy.Perk(ClassCodes.cragheart, 2, '$_add $_two $_rolling EARTH $_cards'),
    legacy.Perk(ClassCodes.cragheart, 1, '$_add $_two $_rolling AIR $_cards'),
    legacy.Perk(ClassCodes.cragheart, 1, 'Ignore $_negative item $_effects'),
    legacy.Perk(
        ClassCodes.cragheart, 1, 'Ignore $_negative $_scenario $_effects'),
    // MINDTHIEF
    legacy.Perk(ClassCodes.mindthief, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.mindthief, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.mindthief, 1,
        '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    legacy.Perk(ClassCodes.mindthief, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.mindthief, 2, '$_add $_one +2 ICE $_card'),
    legacy.Perk(ClassCodes.mindthief, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(
        ClassCodes.mindthief, 1, '$_add $_three $_rolling PULL 1 $_cards'),
    legacy.Perk(
        ClassCodes.mindthief, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(
        ClassCodes.mindthief, 1, '$_add $_two $_rolling $_immobilize $_cards'),
    legacy.Perk(ClassCodes.mindthief, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(ClassCodes.mindthief, 1,
        '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
    legacy.Perk(
        ClassCodes.mindthief, 1, 'Ignore $_negative $_scenario $_effects'),
    // SUNKEEPER
    legacy.Perk(ClassCodes.sunkeeper, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.sunkeeper, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.sunkeeper, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.sunkeeper, 1,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.sunkeeper, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(
        ClassCodes.sunkeeper, 2, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(ClassCodes.sunkeeper, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(ClassCodes.sunkeeper, 2, '$_add $_two $_rolling LIGHT $_cards'),
    legacy.Perk(ClassCodes.sunkeeper, 1,
        '$_add $_two $_rolling "$_shield 1, Self" $_cards'),
    legacy.Perk(ClassCodes.sunkeeper, 1,
        'Ignore $_negative item $_effects and $_addL $_two +1 $_cards'),
    legacy.Perk(
        ClassCodes.sunkeeper, 1, 'Ignore $_negative $_scenario $_effects'),
    // QUARTERMASTER
    legacy.Perk(ClassCodes.quartermaster, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.quartermaster, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.quartermaster, 2,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(
        ClassCodes.quartermaster, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(
        ClassCodes.quartermaster, 1, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(
        ClassCodes.quartermaster, 1, '$_add $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(
        ClassCodes.quartermaster, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(
        ClassCodes.quartermaster, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(
        ClassCodes.quartermaster, 3, '$_add $_one +0 "RECOVER an item" $_card'),
    legacy.Perk(ClassCodes.quartermaster, 1,
        'Ignore $_negative item $_effects and $_addL $_two +1 $_cards'),
    // SUMMONER
    legacy.Perk(ClassCodes.summoner, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.summoner, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.summoner, 3,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.summoner, 2, '$_add $_one +2 $_card'),
    legacy.Perk(ClassCodes.summoner, 1, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(ClassCodes.summoner, 1, '$_add $_two $_rolling POISON $_cards'),
    legacy.Perk(ClassCodes.summoner, 3, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(ClassCodes.summoner, 1,
        '$_add $_one $_rolling FIRE and $_one $_rolling AIR $_card'),
    legacy.Perk(ClassCodes.summoner, 1,
        '$_add $_one $_rolling DARK and $_one $_rolling EARTH $_card'),
    legacy.Perk(ClassCodes.summoner, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // NIGHTSHROUD
    legacy.Perk(ClassCodes.nightshroud, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.nightshroud, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.nightshroud, 2, '$_add $_one -1 DARK $_card'),
    legacy.Perk(ClassCodes.nightshroud, 2,
        '$_replace $_one -1 DARK $_card with $_one +1 DARK $_card'),
    legacy.Perk(ClassCodes.nightshroud, 2, '$_add $_one +1 INVISIBLE $_card'),
    legacy.Perk(
        ClassCodes.nightshroud, 2, '$_add $_three $_rolling MUDDLE $_cards'),
    legacy.Perk(
        ClassCodes.nightshroud, 1, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(
        ClassCodes.nightshroud, 1, '$_add $_two $_rolling CURSE $_cards'),
    legacy.Perk(
        ClassCodes.nightshroud, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(ClassCodes.nightshroud, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // PLAGUEHERALD
    legacy.Perk(ClassCodes.plagueherald, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.plagueherald, 2,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.plagueherald, 2,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.plagueherald, 1, '$_add $_two +1 $_cards'),
    legacy.Perk(ClassCodes.plagueherald, 3, '$_add $_one +1 AIR $_card'),
    legacy.Perk(
        ClassCodes.plagueherald, 1, '$_add $_three $_rolling POISON $_cards'),
    legacy.Perk(
        ClassCodes.plagueherald, 1, '$_add $_two $_rolling CURSE $_cards'),
    legacy.Perk(ClassCodes.plagueherald, 1,
        '$_add $_two $_rolling $_immobilize $_cards'),
    legacy.Perk(
        ClassCodes.plagueherald, 2, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(ClassCodes.plagueherald, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // BERSERKER
    legacy.Perk(ClassCodes.berserker, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.berserker, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.berserker, 2,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.berserker, 2,
        '$_replace $_one +0 $_card with $_one $_rolling +2 $_card'),
    legacy.Perk(ClassCodes.berserker, 2, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(ClassCodes.berserker, 2, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(
        ClassCodes.berserker, 1, '$_add $_one $_rolling +1 DISARM $_card'),
    legacy.Perk(
        ClassCodes.berserker, 1, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(ClassCodes.berserker, 2, '$_add $_one +2 FIRE $_card'),
    legacy.Perk(ClassCodes.berserker, 1, 'Ignore $_negative item $_effects'),
    //SOOTHSINGER
    legacy.Perk(ClassCodes.soothsinger, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.soothsinger, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(ClassCodes.soothsinger, 2,
        '$_replace $_two +1 $_cards with $_one +4 $_card'),
    legacy.Perk(ClassCodes.soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +1 DISARM $_card'),
    legacy.Perk(ClassCodes.soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 WOUND $_card'),
    legacy.Perk(ClassCodes.soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 POISON $_card'),
    legacy.Perk(ClassCodes.soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
    legacy.Perk(ClassCodes.soothsinger, 1,
        '$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
    legacy.Perk(ClassCodes.soothsinger, 1,
        '$_replace $_one -1 $_card with $_one +0 STUN $_card'),
    legacy.Perk(
        ClassCodes.soothsinger, 1, '$_add $_three $_rolling +1 $_cards'),
    legacy.Perk(
        ClassCodes.soothsinger, 2, '$_add $_two $_rolling CURSE $_cards'),
    // DOOMSTALKER
    legacy.Perk(ClassCodes.doomstalker, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.doomstalker, 3,
        '$_replace $_two +0 $_cards with $_two +1 $_cards'),
    legacy.Perk(ClassCodes.doomstalker, 2, '$_add $_two $_rolling +1 $_cards'),
    legacy.Perk(ClassCodes.doomstalker, 1, '$_add $_one +2 MUDDLE $_card'),
    legacy.Perk(ClassCodes.doomstalker, 1, '$_add $_one +1 POISON $_card'),
    legacy.Perk(ClassCodes.doomstalker, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(
        ClassCodes.doomstalker, 1, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.doomstalker, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(
        ClassCodes.doomstalker, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(
        ClassCodes.doomstalker, 1, 'Ignore $_negative $_scenario $_effects'),
    // SAWBONES
    legacy.Perk(ClassCodes.sawbones, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.sawbones, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.sawbones, 2,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.sawbones, 2, '$_add $_one $_rolling +2 $_card'),
    legacy.Perk(ClassCodes.sawbones, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.sawbones, 2, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(ClassCodes.sawbones, 1, '$_add $_one $_rolling STUN $_card'),
    legacy.Perk(ClassCodes.sawbones, 2, '$_add $_one $_rolling HEAL 3 $_card'),
    legacy.Perk(
        ClassCodes.sawbones, 1, '$_add $_one +0 "RECOVER an item" $_card'),
    // ELEMENTALIST
    legacy.Perk(ClassCodes.elementalist, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.elementalist, 1,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.elementalist, 2,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_three +0 FIRE $_cards'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_three +0 ICE $_cards'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_three +0 AIR $_cards'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_three +0 EARTH $_cards'),
    legacy.Perk(ClassCodes.elementalist, 1,
        '$_replace $_two +0 $_cards with $_one +0 FIRE $_card and $_one +0 EARTH $_card'),
    legacy.Perk(ClassCodes.elementalist, 1,
        '$_replace $_two +0 $_cards with $_one +0 ICE $_card and $_one +0 AIR $_card'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_two +1 PUSH 1 $_cards'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(ClassCodes.elementalist, 1, '$_add $_one +0 ADD TARGET $_card'),
    // BEAST TYRANT
    legacy.Perk(ClassCodes.beastTyrant, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.beastTyrant, 3,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.beastTyrant, 2,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.beastTyrant, 2, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(
        ClassCodes.beastTyrant, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(
        ClassCodes.beastTyrant, 3, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(
        ClassCodes.beastTyrant, 1, '$_add $_two $_rolling EARTH $_cards'),
    legacy.Perk(
        ClassCodes.beastTyrant, 1, 'Ignore $_negative $_scenario $_effects'),
    // BLADESWARM
    legacy.Perk(ClassCodes.bladeswarm, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.bladeswarm, 1,
        '$_replace $_one -1 $_card with $_one +1 AIR $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 1,
        '$_replace $_one -1 $_card with $_one +1 EARTH $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 1,
        '$_replace $_one -1 $_card with $_one +1 LIGHT $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 1,
        '$_replace $_one -1 $_card with $_one +1 DARK $_card'),
    legacy.Perk(
        ClassCodes.bladeswarm, 2, '$_add $_two $_rolling HEAL 1 $_cards'),
    legacy.Perk(ClassCodes.bladeswarm, 2, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 2, '$_add $_one +1 POISON $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 1, '$_add $_one +2 MUDDLE $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(ClassCodes.bladeswarm, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // DIVINER
    legacy.Perk(ClassCodes.diviner, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.diviner, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(ClassCodes.diviner, 2,
        '$_replace $_two +1 $_cards with $_one +3 "$_shield 1, Self" $_card'),
    legacy.Perk(ClassCodes.diviner, 1,
        '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Affect any Ally" $_card'),
    legacy.Perk(ClassCodes.diviner, 1,
        '$_replace $_one +0 $_card with $_one +2 DARK $_card'),
    legacy.Perk(ClassCodes.diviner, 1,
        '$_replace $_one +0 $_card with $_one +2 LIGHT $_card'),
    legacy.Perk(ClassCodes.diviner, 1,
        '$_replace $_one +0 $_card with $_one +3 MUDDLE $_card'),
    legacy.Perk(ClassCodes.diviner, 1,
        '$_replace $_one +0 $_card with $_one +2 CURSE $_card'),
    legacy.Perk(ClassCodes.diviner, 1,
        '$_replace $_one +0 $_card with $_one +2 "$_regenerate, Self" $_card'),
    legacy.Perk(ClassCodes.diviner, 1,
        '$_replace $_one -1 $_card with $_one +1 "HEAL 2, Affect any Ally" $_card'),
    legacy.Perk(
        ClassCodes.diviner, 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    legacy.Perk(ClassCodes.diviner, 1, '$_add $_two $_rolling CURSE $_cards'),
    legacy.Perk(ClassCodes.diviner, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
    // DEMOLITIONIST
    legacy.Perk(ClassCodes.demolitionist, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.demolitionist, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.demolitionist, 1,
        '$_remove $_one -2 $_card and $_one +1 $_card'),
    legacy.Perk(ClassCodes.demolitionist, 2,
        '$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
    legacy.Perk(ClassCodes.demolitionist, 1,
        '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    legacy.Perk(ClassCodes.demolitionist, 2, '$_add $_one +2 $_card'),
    legacy.Perk(ClassCodes.demolitionist, 2,
        '$_replace $_one +1 $_card with $_one +2 EARTH $_card'),
    legacy.Perk(ClassCodes.demolitionist, 2,
        '$_replace $_one +1 $_card with $_one +2 FIRE $_card'),
    legacy.Perk(ClassCodes.demolitionist, 2,
        '$_add $_one +0 "All adjacent enemies suffer 1 DAMAGE" $_card'),
    // HATCHET
    legacy.Perk(ClassCodes.hatchet, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.hatchet, 1,
        '$_replace $_one +0 $_card with $_one +2 MUDDLE $_card'),
    legacy.Perk(ClassCodes.hatchet, 1,
        '$_replace $_one +0 $_card with $_one +1 POISON $_card'),
    legacy.Perk(ClassCodes.hatchet, 1,
        '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.hatchet, 1,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.hatchet, 1,
        '$_replace $_one +0 $_card with $_one +1 PUSH 2 $_card'),
    legacy.Perk(ClassCodes.hatchet, 1,
        '$_replace $_one +0 $_card with $_one +0 STUN $_card'),
    legacy.Perk(ClassCodes.hatchet, 1,
        '$_replace $_one +1 $_card with $_one +1 STUN $_card'),
    legacy.Perk(ClassCodes.hatchet, 3, '$_add $_one +2 AIR $_card'),
    legacy.Perk(ClassCodes.hatchet, 3,
        '$_replace $_one +1 $_card with $_one +3 $_card'),
    // RED GUARD
    legacy.Perk(ClassCodes.redGuard, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.redGuard, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(
        ClassCodes.redGuard, 1, '$_remove $_one -2 $_card and $_one +1 $_card'),
    legacy.Perk(ClassCodes.redGuard, 2,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.redGuard, 2,
        '$_replace $_one +1 $_card with $_one +2 FIRE $_card'),
    legacy.Perk(ClassCodes.redGuard, 2,
        '$_replace $_one +1 $_card with $_one +2 LIGHT $_card'),
    legacy.Perk(ClassCodes.redGuard, 2, '$_add $_one +1 FIRE&LIGHT $_card'),
    legacy.Perk(ClassCodes.redGuard, 2, '$_add $_one +1 $_shield 1 $_card'),
    legacy.Perk(ClassCodes.redGuard, 1,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.redGuard, 1,
        '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    // VOIDWARDEN
    legacy.Perk(ClassCodes.voidwarden, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.voidwarden, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(ClassCodes.voidwarden, 2,
        '$_replace $_one +0 $_card with $_one +1 DARK $_card'),
    legacy.Perk(ClassCodes.voidwarden, 2,
        '$_replace $_one +0 $_card with $_one +1 ICE $_card'),
    legacy.Perk(ClassCodes.voidwarden, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Ally" $_card'),
    legacy.Perk(
        ClassCodes.voidwarden, 3, '$_add $_one +1 "HEAL 1, Ally" $_card'),
    legacy.Perk(ClassCodes.voidwarden, 1, '$_add $_one +1 POISON $_card'),
    legacy.Perk(ClassCodes.voidwarden, 1, '$_add $_one +3 $_card'),
    legacy.Perk(ClassCodes.voidwarden, 2, '$_add $_one +1 CURSE $_card'),
    // AMBER AEGIS
    legacy.Perk(ClassCodes.amberAegis, 1,
        '$_replace $_one -2 $_card with $_one -1 "Place $_one Colony token of your choice on any empty hex within RANGE 2" $_card'),
    legacy.Perk(ClassCodes.amberAegis, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.amberAegis, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.amberAegis, 1,
        '$_replace $_one -1 $_card with $_one +2 MUDDLE $_card'),
    legacy.Perk(ClassCodes.amberAegis, 1,
        '$_replace $_one -1 $_card with $_one +1 POISON $_card'),
    legacy.Perk(ClassCodes.amberAegis, 1,
        '$_replace $_one -1 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.amberAegis, 2,
        '$_add $_two $_rolling +1 $_immobilize $_cards'),
    legacy.Perk(ClassCodes.amberAegis, 2,
        '$_add $_one $_rolling "HEAL 1, Self" $_card and $_one $_rolling "$_shield 1, Self" $_card'),
    legacy.Perk(ClassCodes.amberAegis, 2,
        '$_add $_one $_rolling "$_retaliate 1, RANGE 3" $_card'),
    legacy.Perk(ClassCodes.amberAegis, 1, '$_add $_one +2 FIRE/EARTH $_card'),
    legacy.Perk(ClassCodes.amberAegis, 1,
        'Ignore $_negative item $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(ClassCodes.amberAegis, 1,
        'Ignore $_scenario $_effects and $_addL $_one "+X, where X is the number of active Cultivate actions" card'),
    // ARTIFICER
    legacy.Perk(ClassCodes.artificer, 1,
        '$_replace $_one -2 $_card with $_one -1 Any_Element $_card'),
    legacy.Perk(ClassCodes.artificer, 1,
        '$_replace $_one -1 $_card with $_one +1 DISARM $_card'),
    legacy.Perk(ClassCodes.artificer, 2,
        '$_replace $_one -1 $_card with $_one +1 PUSH 1 $_card'),
    legacy.Perk(ClassCodes.artificer, 2,
        '$_replace $_one -1 $_card with $_one +1 PULL 1 $_card'),
    legacy.Perk(ClassCodes.artificer, 2,
        '$_replace $_one +0 $_card with $_one +0 "RECOVER a spent item" $_card'),
    legacy.Perk(ClassCodes.artificer, 2,
        '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Self" $_card'),
    legacy.Perk(ClassCodes.artificer, 2,
        '$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
    legacy.Perk(ClassCodes.artificer, 1,
        '$_replace $_one +2 $_card with $_one +3 "HEAL 2, Self" $_card'),
    legacy.Perk(ClassCodes.artificer, 1,
        '$_replace $_two +1 $_cards with $_two $_rolling +1 POISON $_cards'),
    legacy.Perk(ClassCodes.artificer, 1,
        '$_replace $_two +1 $_cards with $_two $_rolling +1 WOUND $_cards'),
    // BOMBARD
    legacy.Perk(ClassCodes.bombard, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.bombard, 1,
        '$_replace $_two +0 $_cards with $_two $_rolling PIERCE 3 $_cards'),
    legacy.Perk(ClassCodes.bombard, 2,
        '$_replace $_one -1 $_card with $_one +0 "+3 if Projectile" $_card'),
    legacy.Perk(ClassCodes.bombard, 2, '$_add $_one +2 $_immobilize $_card'),
    legacy.Perk(ClassCodes.bombard, 1,
        '$_replace $_one +1 $_card with $_two +1 "$_retaliate 1, RANGE 3" $_cards'),
    legacy.Perk(ClassCodes.bombard, 1,
        '$_add $_two +1 "PULL 3, Self, toward the target" $_cards'),
    legacy.Perk(
        ClassCodes.bombard, 1, '$_add $_one +0 "STRENGTHEN, Self" $_card'),
    legacy.Perk(ClassCodes.bombard, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(ClassCodes.bombard, 1, '$_add $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.bombard, 1,
        '$_add $_two $_rolling "$_shield 1, Self" $_cards'),
    legacy.Perk(
        ClassCodes.bombard, 1, '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    legacy.Perk(ClassCodes.bombard, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    legacy.Perk(ClassCodes.bombard, 1,
        'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
    // BREWMASTER
    legacy.Perk(ClassCodes.brewmaster, 1,
        '$_replace $_one -2 $_card with $_one -1 STUN $_card'),
    legacy.Perk(ClassCodes.brewmaster, 2,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.brewmaster, 2,
        '$_replace $_one -1 $_card with $_two $_rolling MUDDLE $_cards'),
    legacy.Perk(ClassCodes.brewmaster, 1,
        '$_replace $_two +0 $_cards with $_two +0 "HEAL 1, Self" $_cards'),
    legacy.Perk(ClassCodes.brewmaster, 2,
        '$_replace $_one +0 $_card with $_one +0 "Give yourself or an adjacent Ally a \'Liquid Rage\' item $_card" $_card'),
    legacy.Perk(ClassCodes.brewmaster, 2, '$_add $_one +2 PROVOKE $_card'),
    legacy.Perk(
        ClassCodes.brewmaster, 2, '$_add four $_rolling Shrug_Off 1 $_cards'),
    legacy.Perk(ClassCodes.brewmaster, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(ClassCodes.brewmaster, 2,
        'Each time you long rest, perform Shrug_Off 1'),
    // BRIGHTSPARK
    legacy.Perk(ClassCodes.brightspark, 3,
        '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element to $_addL +2 ATTACK" $_card'),
    legacy.Perk(ClassCodes.brightspark, 1,
        '$_replace $_one -2 $_card with $_one -2 "RECOVER $_one random $_card from your discard pile" $_card'),
    legacy.Perk(ClassCodes.brightspark, 2,
        '$_replace $_two +0 $_cards with $_one +1 "HEAL 1, Affect $_one Ally within RANGE 2" $_card'),
    legacy.Perk(ClassCodes.brightspark, 1,
        '$_replace $_two +0 $_cards with $_one +1 "$_shield 1, Affect $_one Ally within RANGE 2" $_card'),
    legacy.Perk(ClassCodes.brightspark, 2,
        '$_replace $_one +1 $_card with $_one +2 Any_Element $_card'),
    legacy.Perk(ClassCodes.brightspark, 2,
        '$_add $_one +1 "STRENGTHEN, Affect $_one Ally within RANGE 2" $_card'),
    legacy.Perk(ClassCodes.brightspark, 1,
        '$_add $_one $_rolling "PUSH 1 or PULL 1, AIR" $_card and $_one $_rolling "$_immobilize, ICE" $_card'),
    legacy.Perk(ClassCodes.brightspark, 1,
        '$_add $_one $_rolling "HEAL 1, RANGE 3, LIGHT" $_card and $_one $_rolling "PIERCE 2, FIRE" $_card'),
    legacy.Perk(ClassCodes.brightspark, 1,
        '$_add $_three $_rolling "Consume_Any_Element : Any_Element" $_cards'),
    legacy.Perk(ClassCodes.brightspark, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
    // CHIEFTAIN
    legacy.Perk(ClassCodes.chieftain, 1,
        '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    legacy.Perk(ClassCodes.chieftain, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Chieftain" $_card'),
    legacy.Perk(ClassCodes.chieftain, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Affect all summoned allies owned" $_card'),
    legacy.Perk(ClassCodes.chieftain, 1,
        '$_replace $_one -2 $_card with $_one -2 "BLESS, Self" $_card'),
    legacy.Perk(ClassCodes.chieftain, 1,
        '$_replace $_two +0 $_cards with $_one +0 "$_immobilize and PUSH 1" $_card'),
    legacy.Perk(ClassCodes.chieftain, 2,
        '$_replace $_one +0 $_card with $_one "+X, where X is the number of summoned allies you own" $_card'),
    legacy.Perk(ClassCodes.chieftain, 1,
        '$_replace $_one +1 $_card with $_two +1 "$_rolling +1, if summon is attacking" $_cards'),
    legacy.Perk(
        ClassCodes.chieftain, 1, '$_add $_one +0 WOUND, PIERCE 1 $_card'),
    legacy.Perk(ClassCodes.chieftain, 2, '$_add $_one +1 EARTH $_card'),
    legacy.Perk(ClassCodes.chieftain, 1,
        '$_add $_two $_rolling "PIERCE 2, ignore $_retaliate on the target" $_cards'),
    legacy.Perk(ClassCodes.chieftain, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
    // FIRE KNIGHT
    legacy.Perk(ClassCodes.fireKnight, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.fireKnight, 2,
        '$_replace $_one -1 $_card with $_one +0 "STRENGTHEN, Ally" $_card'),
    legacy.Perk(ClassCodes.fireKnight, 2,
        '$_replace $_two +0 $_cards with $_two +0 "+2 if you are on Ladder" $_cards'),
    legacy.Perk(ClassCodes.fireKnight, 1,
        '$_replace $_one +0 $_card with $_one +1 FIRE $_card'),
    legacy.Perk(ClassCodes.fireKnight, 1,
        '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.fireKnight, 1,
        '$_replace $_two +1 $_cards with $_one +2 FIRE $_card'),
    legacy.Perk(ClassCodes.fireKnight, 1,
        '$_replace $_two +1 $_cards with $_one +2 WOUND $_card'),
    legacy.Perk(
        ClassCodes.fireKnight, 1, '$_add $_one +1 "STRENGTHEN, Ally" $_card'),
    legacy.Perk(ClassCodes.fireKnight, 2,
        '$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards'),
    legacy.Perk(
        ClassCodes.fireKnight, 1, '$_add $_two $_rolling WOUND $_cards'),
    legacy.Perk(ClassCodes.fireKnight, 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling FIRE $_card'),
    legacy.Perk(ClassCodes.fireKnight, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one $_rolling FIRE $_card'),
    // FROSTBORN
    legacy.Perk(ClassCodes.frostborn, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.frostborn, 1,
        '$_replace $_one -2 $_card with $_one +0 CHILL $_card'),
    legacy.Perk(ClassCodes.frostborn, 2,
        '$_replace $_two +0 $_cards with $_two +1 PUSH 1 $_cards'),
    legacy.Perk(ClassCodes.frostborn, 2,
        '$_replace $_one +0 $_card with $_one +1 ICE CHILL $_card'),
    legacy.Perk(ClassCodes.frostborn, 1,
        '$_replace $_one +1 $_card with $_one +3 $_card'),
    legacy.Perk(ClassCodes.frostborn, 1, '$_add $_one +0 STUN $_card'),
    legacy.Perk(
        ClassCodes.frostborn, 2, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(
        ClassCodes.frostborn, 1, '$_add $_three $_rolling CHILL $_cards'),
    legacy.Perk(
        ClassCodes.frostborn, 1, '$_add $_three $_rolling PUSH 1 $_cards'),
    legacy.Perk(ClassCodes.frostborn, 1,
        'Ignore difficult and hazardous terrain during move actions'),
    legacy.Perk(ClassCodes.frostborn, 1, 'Ignore $_scenario $_effects'),
    // HOLLOWPACT
    legacy.Perk(ClassCodes.hollowpact, 2,
        '$_replace $_one -1 $_card with $_one +0 "HEAL 2, Self" $_card'),
    legacy.Perk(ClassCodes.hollowpact, 2,
        '$_replace $_two +0 $_cards with $_one +0 VOIDSIGHT $_card'),
    legacy.Perk(ClassCodes.hollowpact, 2,
        '$_add $_one -2 EARTH $_card and $_two +2 DARK $_cards'),
    legacy.Perk(ClassCodes.hollowpact, 1,
        '$_replace $_one -1 $_card with $_one -2 STUN $_card and $_one +0 VOIDSIGHT $_card'),
    legacy.Perk(ClassCodes.hollowpact, 1,
        '$_replace $_one -2 $_card with $_one +0 DISARM $_card and $_one -1 Any_Element $_card'),
    legacy.Perk(ClassCodes.hollowpact, 2,
        '$_replace $_one -1 $_card with $_one $_rolling +1 VOID $_card and $_one $_rolling -1 CURSE $_card'),
    legacy.Perk(ClassCodes.hollowpact, 2,
        '$_replace $_two +1 $_cards with $_one +3 "$_regenerate, Self" $_card'),
    legacy.Perk(ClassCodes.hollowpact, 2,
        '$_replace $_one +0 $_card with $_one +1 "Create a Void pit in an empty hex within RANGE 2" $_card'),
    legacy.Perk(ClassCodes.hollowpact, 1,
        'Ignore $_negative $_scenario $_effects and $_addL $_one +0 "WARD, Self" $_card'),
    // MIREFOOT
    legacy.Perk(ClassCodes.mirefoot, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.mirefoot, 2,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.mirefoot, 2,
        '$_replace $_two +0 $_cards with $_two "+X, where X is the POISON value of the target" $_cards'),
    legacy.Perk(ClassCodes.mirefoot, 1,
        '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    legacy.Perk(ClassCodes.mirefoot, 2,
        '$_replace $_one +0 $_card with $_two $_rolling "Create difficult terrain in the hex occupied by the target" $_cards'),
    legacy.Perk(ClassCodes.mirefoot, 2,
        '$_replace $_one +1 $_card with $_one +0 WOUND 2 $_card'),
    legacy.Perk(ClassCodes.mirefoot, 1,
        '$_add four $_rolling +0 "+1 if the target occupies difficult terrain" $_cards'),
    legacy.Perk(ClassCodes.mirefoot, 1,
        '$_add $_two $_rolling "INVISIBLE, Self, if you occupy difficult terrain" $_cards'),
    legacy.Perk(ClassCodes.mirefoot, 1,
        'Gain "Poison Dagger" (Item 011). You may carry $_one additional One_Hand item with "Dagger" in its name'),
    legacy.Perk(ClassCodes.mirefoot, 1,
        'Ignore damage, $_negative conditions, and modifiers from Events, and $_removeL $_one -1 $_card'),
    legacy.Perk(ClassCodes.mirefoot, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one -1 $_card'),
    // ROOTWHISPERER
    // May be dead legacy.Perks if Rootwhisperer has a big overhaul - this is fine
    legacy.Perk(ClassCodes.rootwhisperer, 2, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.rootwhisperer, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.rootwhisperer, 2,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.rootwhisperer, 2, '$_add $_one $_rolling +2 $_card'),
    legacy.Perk(
        ClassCodes.rootwhisperer, 2, '$_add $_one +1 $_immobilize $_card'),
    legacy.Perk(
        ClassCodes.rootwhisperer, 2, '$_add $_two $_rolling POISON $_cards'),
    legacy.Perk(
        ClassCodes.rootwhisperer, 1, '$_add $_one $_rolling DISARM $_card'),
    legacy.Perk(ClassCodes.rootwhisperer, 2,
        '$_add $_one $_rolling HEAL 2 EARTH $_card'),
    legacy.Perk(
        ClassCodes.rootwhisperer, 1, 'Ignore $_negative $_scenario $_effects'),
    // CHAINGUARD
    legacy.Perk(ClassCodes.chainguard, 2,
        '$_replace $_one -1 $_card with $_one +1 Shackle $_card'),
    legacy.Perk(ClassCodes.chainguard, 2,
        '$_replace $_one -1 $_card with $_one +0 "+2 if the target is Shackled" $_card'),
    legacy.Perk(ClassCodes.chainguard, 2,
        '$_replace $_two +0 $_cards with $_one $_rolling "$_shield 1, Self" $_card'),
    legacy.Perk(ClassCodes.chainguard, 1,
        '$_add $_two $_rolling "$_retaliate 1, Self" $_cards'),
    legacy.Perk(
        ClassCodes.chainguard, 1, '$_add $_three $_rolling SWING 3 $_cards'),
    legacy.Perk(ClassCodes.chainguard, 1,
        '$_replace $_one +1 $_card with $_one +2 WOUND $_card'),
    legacy.Perk(ClassCodes.chainguard, 1,
        '$_add $_one +1 "DISARM if the target is Shackled" $_card'),
    legacy.Perk(ClassCodes.chainguard, 1,
        '$_add $_one +1 "Create a 2 DAMAGE trap in an empty hex within RANGE 2" $_card'),
    legacy.Perk(ClassCodes.chainguard, 1,
        '$_add $_two $_rolling "HEAL 1, Self" $_cards'),
    legacy.Perk(ClassCodes.chainguard, 2, '$_add $_one +2 Shackle $_card'),
    legacy.Perk(ClassCodes.chainguard, 1,
        'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
    // HIEROPHANT
    legacy.Perk(ClassCodes.hierophant, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.hierophant, 1,
        '$_replace $_two +0 $_cards with $_one $_rolling LIGHT $_card'),
    legacy.Perk(ClassCodes.hierophant, 1,
        '$_replace $_two +0 $_cards with $_one $_rolling EARTH $_card'),
    legacy.Perk(ClassCodes.hierophant, 2,
        '$_replace $_one -1 $_card with $_one +0 CURSE $_card'),
    legacy.Perk(ClassCodes.hierophant, 1,
        '$_replace $_one +0 $_card with $_one +1 "$_shield 1, Ally" $_card'),
    legacy.Perk(ClassCodes.hierophant, 1,
        '$_replace $_one -2 $_card with $_one -1 "Give $_one Ally a \'Prayer\' ability $_card" and $_one +0 $_card'),
    legacy.Perk(ClassCodes.hierophant, 2,
        '$_replace $_one +1 $_card with $_one +3 $_card'),
    legacy.Perk(ClassCodes.hierophant, 2,
        '$_add $_two $_rolling "HEAL 1, Self or Ally" $_cards'),
    legacy.Perk(
        ClassCodes.hierophant, 2, '$_add $_one +1 WOUND, MUDDLE $_card'),
    legacy.Perk(ClassCodes.hierophant, 1,
        'At the start of your first turn each $_scenario, gain BLESS'),
    legacy.Perk(ClassCodes.hierophant, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // LUMINARY
    legacy.Perk(ClassCodes.luminary, 1, '$_remove four +0 $_cards'),
    legacy.Perk(ClassCodes.luminary, 1,
        '$_replace $_one +0 $_card with $_one +2 $_card'),
    legacy.Perk(ClassCodes.luminary, 1,
        '$_replace $_one -1 $_card with $_one +0 ICE $_card'),
    legacy.Perk(ClassCodes.luminary, 1,
        '$_replace $_one -1 $_card with $_one +0 FIRE $_card'),
    legacy.Perk(ClassCodes.luminary, 1,
        '$_replace $_one -1 $_card with $_one +0 LIGHT $_card'),
    legacy.Perk(ClassCodes.luminary, 1,
        '$_replace $_one -1 $_card with $_one +0 DARK $_card'),
    legacy.Perk(ClassCodes.luminary, 1,
        '$_replace $_one -2 $_card with $_one -2 "Perform $_one Glow ability" $_card'),
    legacy.Perk(ClassCodes.luminary, 2, '$_add $_one +0 Any_Element $_card'),
    legacy.Perk(ClassCodes.luminary, 2,
        '$_add $_one $_rolling +1 "HEAL 1, Self" $_card'),
    legacy.Perk(ClassCodes.luminary, 2,
        '$_add $_one "POISON, target all enemies in the depicted LUMINARY_HEXES area" $_card'),
    legacy.Perk(ClassCodes.luminary, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    legacy.Perk(ClassCodes.luminary, 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling "Consume_Any_Element : Any_Element" $_card'),
    // SPIRIT CALLER
    legacy.Perk(ClassCodes.spiritCaller, 1,
        '$_replace $_one -2 $_card with $_one -1 $_card and $_one +1 $_card'),
    legacy.Perk(ClassCodes.spiritCaller, 2,
        '$_replace $_one -1 $_card with $_one +0 "+2 if a Spirit performed the attack" $_card'),
    legacy.Perk(ClassCodes.spiritCaller, 2,
        '$_replace $_one -1 $_card with $_one +0 $_card and $_one $_rolling POISON $_card'),
    legacy.Perk(ClassCodes.spiritCaller, 2,
        '$_replace $_one +0 $_card with $_one +1 AIR $_card'),
    legacy.Perk(ClassCodes.spiritCaller, 2,
        '$_replace $_one +0 $_card with $_one +1 DARK $_card'),
    legacy.Perk(ClassCodes.spiritCaller, 1,
        '$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
    legacy.Perk(
        ClassCodes.spiritCaller, 1, '$_add $_three $_rolling PIERCE 3 $_cards'),
    legacy.Perk(ClassCodes.spiritCaller, 1, '$_add $_one +1 CURSE $_card'),
    legacy.Perk(
        ClassCodes.spiritCaller, 1, '$_add $_one $_rolling ADD TARGET $_card'),
    legacy.Perk(ClassCodes.spiritCaller, 1,
        '$_replace $_one +1 $_card with $_one +2 PUSH 2 $_card'),
    legacy.Perk(ClassCodes.spiritCaller, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // STARSLINGER
    legacy.Perk(ClassCodes.starslinger, 2,
        '$_replace $_two +0 $_cards with $_one $_rolling "HEAL 1, Self" $_card'),
    legacy.Perk(ClassCodes.starslinger, 1,
        '$_replace $_one -2 $_card with $_one -1 "INVISIBLE, Self" $_card'),
    legacy.Perk(ClassCodes.starslinger, 1,
        '$_replace $_two -1 $_cards with $_one +0 DARK $_card'),
    legacy.Perk(ClassCodes.starslinger, 2,
        '$_replace $_one -1 $_card with $_one +1 LIGHT $_card'),
    legacy.Perk(
        ClassCodes.starslinger, 1, '$_add $_one $_rolling LOOT 1 $_card'),
    legacy.Perk(ClassCodes.starslinger, 2,
        '$_add $_one +1 "+3 if you are at full health" $_card'),
    legacy.Perk(ClassCodes.starslinger, 1,
        '$_add $_two $_rolling $_immobilize $_cards'),
    legacy.Perk(
        ClassCodes.starslinger, 2, '$_add $_one +1 "HEAL 1, RANGE 3" $_card'),
    legacy.Perk(ClassCodes.starslinger, 1,
        '$_add $_two $_rolling "Force the target to perform a \'MOVE 1\' ability" $_cards'),
    legacy.Perk(ClassCodes.starslinger, 1,
        '$_add $_two $_rolling "HEAL 1, RANGE 1" $_cards'),
    legacy.Perk(ClassCodes.starslinger, 1,
        'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
    // RUINMAW
    legacy.Perk(ClassCodes.ruinmaw, 1,
        '$_replace $_one -2 $_card with $_one -1 RUPTURE and WOUND $_card'),
    legacy.Perk(ClassCodes.ruinmaw, 2,
        '$_replace $_one -1 $_card with $_one +0 WOUND $_card'),
    legacy.Perk(ClassCodes.ruinmaw, 2,
        '$_replace $_one -1 $_card with $_one +0 RUPTURE $_card'),
    legacy.Perk(ClassCodes.ruinmaw, 3,
        '$_replace $_one +0 $_card with $_one +1 "$_add +3 instead if the target has RUPTURE or WOUND" $_card'),
    legacy.Perk(ClassCodes.ruinmaw, 3,
        '$_replace $_one +0 $_card with $_one $_rolling "HEAL 1, Self, EMPOWER" $_card'),
    legacy.Perk(ClassCodes.ruinmaw, 1,
        'Once each $_scenario, become SATED after collecting your 5th loot token'),
    legacy.Perk(ClassCodes.ruinmaw, 1,
        'Become SATED each time you lose a $_card to negate suffering damage'),
    legacy.Perk(ClassCodes.ruinmaw, 1,
        'Whenever $_one of your abilities causes at least $_one enemy to gain RUPTURE, immediately after that ability perform "MOVE 1"'),
    legacy.Perk(ClassCodes.ruinmaw, 1,
        'Ignore $_negative $_scenario $_effects, and $_removeL $_one -1 $_card'),
    // ************** ^^ THIS IS AS FAR AS RELEASE 3.7.0 GOES ^^ **************
    // DRIFTER
    legacy.Perk(ClassCodes.drifter, 3,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.drifter, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.drifter, 2,
        '$_replace $_one +1 $_card with $_two +0 "Move $_one of your character tokens backward $_one slot" $_cards'),
    legacy.Perk(ClassCodes.drifter, 1,
        '$_replace $_two +0 $_cards with $_two PIERCE 3 $_rolling $_cards'),
    legacy.Perk(ClassCodes.drifter, 1,
        '$_replace $_two +0 $_cards with $_two PUSH 2 $_rolling $_cards'),
    legacy.Perk(ClassCodes.drifter, 1, '$_add $_one +3 $_card'),
    legacy.Perk(ClassCodes.drifter, 2, '$_add $_one +2 $_immobilize $_card'),
    legacy.Perk(
        ClassCodes.drifter, 1, '$_add $_two "HEAL 1, self" $_rolling $_cards'),
    legacy.Perk(ClassCodes.drifter, 1,
        'Ignore $_scenario $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(ClassCodes.drifter, 1,
        'Ignore item item_minus_one $_effects and $_addL $_one +1 $_card'),
    legacy.Perk(ClassCodes.drifter, 2,
        '$_wheneverYouLongRest, you may move $_one of your character tokens backward $_one slot',
        perkIsGrouped: true),
    legacy.Perk(ClassCodes.drifter, 1,
        'You may bring $_one additional One_Hand item into each $_scenario'),
    legacy.Perk(ClassCodes.drifter, 1,
        "At the end of each $_scenario, you may discard up to $_two loot $_cards, except 'Random Item', to draw that many new loot $_cards"),
    // BLINK BLADE
    legacy.Perk(ClassCodes.blinkBlade, 1, '$_remove $_one -2 $_card'),
    legacy.Perk(ClassCodes.blinkBlade, 2,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.blinkBlade, 2,
        '$_replace $_one -1 $_card with $_one +0 WOUND $_card'),
    legacy.Perk(ClassCodes.blinkBlade, 2,
        '$_replace $_one +0 $_card with $_one +1 $_immobilize $_card'),
    legacy.Perk(ClassCodes.blinkBlade, 3,
        '$_replace $_one +0 $_card with $_one "Place this $_card in your active area. On your next attack, discard this $_card to $_addL plustwo ATTACK" $_rolling $_card'),
    legacy.Perk(ClassCodes.blinkBlade, 1,
        '$_replace $_two +1 $_cards with $_two +2 $_cards'),
    legacy.Perk(ClassCodes.blinkBlade, 2,
        '$_add $_one -1 "Gain $_one TIME_TOKEN" $_card'),
    legacy.Perk(ClassCodes.blinkBlade, 2,
        '$_add $_one +2 "$_regenerate, self" $_rolling $_card'),
    legacy.Perk(ClassCodes.blinkBlade, 1,
        '$_wheneverYouShortRest, you may spend $_one unspent SPENT item for no effect to RECOVER a different spent item'),
    legacy.Perk(ClassCodes.blinkBlade, 1,
        'At the start of your first turn each $_scenario, you may perform MOVE 3'),
    legacy.Perk(ClassCodes.blinkBlade, 1,
        'Whenever you would gain $_immobilize, prevent the condition'),
    // BANNER SPEAR
    legacy.Perk(ClassCodes.bannerSpear, 3,
        '$_replace $_one -1 $_card with $_one "$_shield 1" $_rolling $_card'),
    legacy.Perk(ClassCodes.bannerSpear, 2,
        '$_replace $_one +0 $_card with $_one +1 "$_add plusone ATTACK for each ally adjacent to the target" $_card'),
    legacy.Perk(ClassCodes.bannerSpear, 2, '$_add $_one +1 DISARM $_card'),
    legacy.Perk(ClassCodes.bannerSpear, 2, '$_add $_one +2 PUSH 1 $_card'),
    legacy.Perk(ClassCodes.bannerSpear, 2, '$_add $_two +1 $_rolling $_cards'),
    legacy.Perk(ClassCodes.bannerSpear, 2,
        '$_add $_two "HEAL 1, self" $_rolling $_cards'),
    legacy.Perk(ClassCodes.bannerSpear, 1,
        'Ignore item item_minus_one $_effects and $_removeL $_one -1 $_card'),
    legacy.Perk(ClassCodes.bannerSpear, 1,
        'At the end of each of your long rests, grant $_one ally within RANGE 3: MOVE 2'),
    legacy.Perk(ClassCodes.bannerSpear, 1,
        'Whenever you open a door with a move ability, $_addL +3 MOVE'),
    legacy.Perk(ClassCodes.bannerSpear, 2,
        'Once each $_scenario, during your turn, gain $_shield 2 for the round',
        perkIsGrouped: true),
    // DEATHWALKER
    legacy.Perk(ClassCodes.deathwalker, 1, '$_remove $_two -1 $_cards'),
    legacy.Perk(ClassCodes.deathwalker, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.deathwalker, 3,
        '$_replace $_one -1 $_card with $_one +1 $_card'),
    legacy.Perk(ClassCodes.deathwalker, 3,
        '$_replace $_one +0 $_card with $_one +1 CURSE $_card'),
    legacy.Perk(ClassCodes.deathwalker, 2, '$_add $_one +2 DARK $_card'),
    legacy.Perk(ClassCodes.deathwalker, 2,
        '$_add $_one DISARM $_rolling and $_one MUDDLE $_rolling $_card'),
    legacy.Perk(ClassCodes.deathwalker, 2,
        '$_add $_two "HEAL 1, Target 1 ally" $_rolling $_cards'),
    legacy.Perk(ClassCodes.deathwalker, 1, 'Ignore $_scenario $_effects'),
    legacy.Perk(ClassCodes.deathwalker, 1,
        '$_wheneverYouLongRest, you may move $_one SHADOW up to 3 hexes'),
    legacy.Perk(ClassCodes.deathwalker, 1,
        '$_wheneverYouShortRest, you may consume_DARK to perform MUDDLE, CURSE, RANGE 2 as if you were occupying a hex with a SHADOW'),
    legacy.Perk(ClassCodes.deathwalker, 1,
        'While you are occupying a hex with a SHADOW, all attacks targeting you gain disadvantage'),
    // BONESHAPER
    legacy.Perk(ClassCodes.boneshaper, 2,
        '$_replace $_one -1 $_card with $_one +0 CURSE $_card'),
    legacy.Perk(ClassCodes.boneshaper, 2,
        '$_replace $_one -1 $_card with $_one +0 POISON $_card'),
    legacy.Perk(ClassCodes.boneshaper, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.boneshaper, 3,
        '$_replace $_one +0 $_card with $_one +1 "Kill the attacking summon to instead $_addL +4" $_card'),
    legacy.Perk(ClassCodes.boneshaper, 2,
        '$_add $_three "HEAL 1, Target Boneshaper" $_rolling $_cards'),
    legacy.Perk(ClassCodes.boneshaper, 3, '$_add $_one +2 EARTH/DARK $_card'),
    legacy.Perk(ClassCodes.boneshaper, 1,
        'Ignore $_scenario $_effects and $_addL $_two +1 $_cards'),
    legacy.Perk(ClassCodes.boneshaper, 1,
        'Immediately before each of your rests, you may kill $_one of your summons to perform BLESS, self'),
    legacy.Perk(ClassCodes.boneshaper, 1,
        'Once each $_scenario, when any character ally would become exhausted by suffering DAMAGE, you may suffer DAMAGE 2 to reduce their hit point value to 1 instead'),
    legacy.Perk(ClassCodes.boneshaper, 2,
        'At the start of each $_scenario, you may play a level 1 $_card from your hand to perform a summon action of the $_card',
        perkIsGrouped: true),
    // GEMINATE
    legacy.Perk(ClassCodes.geminate, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.geminate, 3,
        '$_replace $_one -1 $_card with $_one +0 "Consume_Any_Element : Any_Element" $_card'),
    legacy.Perk(ClassCodes.geminate, 2,
        '$_replace $_one +0 $_card with $_one +1 POISON $_card'),
    legacy.Perk(ClassCodes.geminate, 2,
        '$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
    legacy.Perk(ClassCodes.geminate, 1,
        '$_replace $_two +0 $_cards with $_two PIERCE 3 $_rolling $_cards'),
    legacy.Perk(ClassCodes.geminate, 1, '$_add $_two +1 PUSH 3 $_cards'),
    legacy.Perk(
        ClassCodes.geminate, 1, '$_add $_one 2x "BRITTLE, self" $_card'),
    legacy.Perk(ClassCodes.geminate, 2,
        '$_add $_one +1 "$_regenerate, self" $_rolling card'),
    legacy.Perk(ClassCodes.geminate, 1, 'Ignore $_scenario $_effects'),
    legacy.Perk(ClassCodes.geminate, 1,
        '$_wheneverYouShortRest, you may $_removeL $_one $_negative condition from $_one ally within RANGE 3'),
    legacy.Perk(ClassCodes.geminate, 1,
        'Once each $_scenario, when you would give yourself a $_negative condition, prevent the condition'),
    legacy.Perk(ClassCodes.geminate, 2,
        'Whenever you perform an action with a lost icon, you may discard $_one $_card to RECOVER $_one card from your discard pile of equal or lower level',
        perkIsGrouped: true),
    // INFUSER
    legacy.Perk(ClassCodes.infuser, 1,
        'Replace one -2 card with one -1 and one -1 AIR EARTH DARK card'),
    legacy.Perk(ClassCodes.infuser, 2,
        'Replace one -1 card with one +0 AIR/EARTH card'),
    legacy.Perk(
        ClassCodes.infuser, 2, 'Replace one -1 card with one +0 AIR/DARK card'),
    legacy.Perk(ClassCodes.infuser, 2,
        'Replace one -1 card with one +0 EARTH/DARK card'),
    legacy.Perk(ClassCodes.infuser, 2, 'Replace one +0 card with one +2 card'),
    legacy.Perk(ClassCodes.infuser, 2,
        'Replace one +0 card with three "Move one waning element to strong" $_rolling cards'),
    legacy.Perk(ClassCodes.infuser, 2,
        'Add two "plusone ATTACK for each pair of active INFUSION" $_rolling cards'),
    legacy.Perk(ClassCodes.infuser, 1, 'Ignore $_scenario $_effects'),
    legacy.Perk(ClassCodes.infuser, 1,
        '$_ignoreItemMinusOneEffects. Whenever you become exhausted, keep all your active bonuses in play, with your summons acting on initiative 99 each round'),
    legacy.Perk(ClassCodes.infuser, 1,
        '$_wheneverYouShortRest, you may Consume_Any_Element to RECOVER one spent One_Hand or Two_Hand item'),
    legacy.Perk(ClassCodes.infuser, 1,
        'Once each scenario, during ordering of initiative, after all ability cards have been revealed, Any_Element'),
    // PYROCLAST
    legacy.Perk(ClassCodes.pyroclast, 1, 'Remove two -1 cards'),
    legacy.Perk(ClassCodes.pyroclast, 1, 'Remove one -2 card'),
    legacy.Perk(
        ClassCodes.pyroclast, 2, 'Replace one +0 card with one +1 WOUND card'),
    legacy.Perk(ClassCodes.pyroclast, 2,
        'Replace one -1 card with one +0 "Create one 1-hex hazardous terrain tile in a featureless hex adjacent to the target" card'),
    legacy.Perk(ClassCodes.pyroclast, 2,
        'Replace two +0 cards with two PUSH 2 $_rolling cards'),
    legacy.Perk(
        ClassCodes.pyroclast, 1, 'Replace two +1 cards with two +2 cards'),
    legacy.Perk(ClassCodes.pyroclast, 2, 'Add two +1 FIRE/EARTH cards'),
    legacy.Perk(ClassCodes.pyroclast, 1, 'Add two +1 MUDDLE $_rolling cards'),
    legacy.Perk(ClassCodes.pyroclast, 1, _ignoreScenarioEffects),
    legacy.Perk(ClassCodes.pyroclast, 1,
        '$_wheneverYouLongRest, you may destroy one adjacent obstacle to gain WARD'),
    legacy.Perk(ClassCodes.pyroclast, 1,
        '$_wheneverYouShortRest, you may consume_FIRE to perform WOUND, Target 1 enemy occupying or adjacent to hazardous terrain'),
    legacy.Perk(ClassCodes.pyroclast, 3,
        'You and all allies are unaffected by hazardous terrain you create',
        perkIsGrouped: true),
    // SHATTERSONG
    legacy.Perk(ClassCodes.shattersong, 1, 'Remove four +0 cards'),
    legacy.Perk(ClassCodes.shattersong, 2,
        'Replace two -1 cards with two +0 "Reveal the top card of the target\'s monster ability deck" cards'),
    legacy.Perk(
        ClassCodes.shattersong, 1, 'Replace one -2 card with one -1 STUN card'),
    legacy.Perk(ClassCodes.shattersong, 2,
        'Replace one +0 card with one +0 BRITTLE card'),
    legacy.Perk(ClassCodes.shattersong, 2,
        'Replace two +1 cards with two +2 AIR/LIGHT cards'),
    legacy.Perk(ClassCodes.shattersong, 2,
        'Add one "HEAL 2, BLESS, Target 1 ally" $_rolling card'),
    legacy.Perk(
        ClassCodes.shattersong, 3, 'Add one +1 "Gain 1 RESONANCE" card'),
    legacy.Perk(ClassCodes.shattersong, 1, _ignoreScenarioEffects),
    legacy.Perk(ClassCodes.shattersong, 2,
        '$_wheneverYouShortRest, you may consume_AIR to perform STRENGTHEN, RANGE 3 and consume_LIGHT to perform BLESS, RANGE 3',
        perkIsGrouped: true),
    legacy.Perk(ClassCodes.shattersong, 1,
        '$_atTheStartOfEachScenario, you may gain BRITTLE to gain 2 RESONANCE'),
    legacy.Perk(ClassCodes.shattersong, 1,
        'Whenever a new room is revealed, you may reveal the top card of both the monster attack modifier deck and all allies\' attack modifier decks'),
    // TRAPPER
    legacy.Perk(ClassCodes.trapper, 1, 'Remove one -2 card'),
    legacy.Perk(ClassCodes.trapper, 2,
        'Replace one -1 card with one +0 "Create one HEAL 2 trap in an empty hex adjacent to the target" card'),
    legacy.Perk(ClassCodes.trapper, 3,
        'Replace one -1 card with one +0 "Create one DAMAGE 1 trap in an empty hex adjacent to the target" card'),
    legacy.Perk(ClassCodes.trapper, 3,
        'Replace two +0 cards with two +0 "Add DAMAGE 2 or HEAL 2 to a trap within RANGE 2 of you" cards'),
    legacy.Perk(ClassCodes.trapper, 2,
        'Replace two +1 cards with two +2 $_immobilize cards'),
    legacy.Perk(ClassCodes.trapper, 3,
        'Add two "Add PUSH 2 or PULL 2" $_rolling cards'),
    legacy.Perk(ClassCodes.trapper, 1, _ignoreScenarioEffects),
    legacy.Perk(ClassCodes.trapper, 1,
        '$_wheneverYouLongRest, you may create one DAMAGE 1 trap in an adjacent empty hex'),
    legacy.Perk(ClassCodes.trapper, 1,
        'Whenever you enter a hex with a trap, you may choose to not spring the trap'),
    legacy.Perk(ClassCodes.trapper, 1,
        '$_atTheStartOfEachScenario, you may create one DAMAGE 2 trap in an adjacent empty hex'),
    // PAIN CONDUIT
    legacy.Perk(ClassCodes.painConduit, 2, 'Remove two -1 cards'),
    legacy.Perk(ClassCodes.painConduit, 1,
        'Replace one -2 card with one -2 CURSE CURSE card'),
    legacy.Perk(ClassCodes.painConduit, 1,
        'Replace one -1 card with one +0 DISARM card'),
    legacy.Perk(ClassCodes.painConduit, 3,
        'Replace one +0 card with one +1 FIRE/AIR card'),
    legacy.Perk(
        ClassCodes.painConduit, 1, 'Replace one +0 card with one +2 card'),
    legacy.Perk(ClassCodes.painConduit, 1,
        'Replace three +1 cards with three +1 CURSE cards'),
    legacy.Perk(
        ClassCodes.painConduit, 2, 'Add three "HEAL 1, self" $_rolling cards'),
    legacy.Perk(ClassCodes.painConduit, 2,
        'Add one +0 "Add plusone ATTACK for each negative condition you have" card'),
    legacy.Perk(ClassCodes.painConduit, 1,
        '$_ignoreScenarioEffects and add two +1 cards'),
    legacy.Perk(ClassCodes.painConduit, 1,
        'Each round in which you long rest, you may ignore all negative conditions you have. If you do, they cannot be removed that round'),
    legacy.Perk(ClassCodes.painConduit, 1,
        'Whenever you become exhausted, first perform CURSE, Target all, RANGE 3'),
    legacy.Perk(
        ClassCodes.painConduit, 2, 'Increase your maximum hit point value by 5',
        perkIsGrouped: true),
    // SNOWDANCER
    legacy.Perk(ClassCodes.snowdancer, 3,
        'Replace one -1 card with one +0 "HEAL 1, Target 1 ally" card'),
    legacy.Perk(ClassCodes.snowdancer, 2,
        'Replace one -1 card with one +0 $_immobilize card'),
    legacy.Perk(ClassCodes.snowdancer, 2, 'Add two +1 ICE/AIR cards'),
    legacy.Perk(ClassCodes.snowdancer, 2,
        'Replace two +0 cards with two "If this action forces the target to move, it suffers DAMAGE 1" $_rolling cards'),
    legacy.Perk(ClassCodes.snowdancer, 2,
        'Replace one +0 card with one +1 "STRENGTHEN, Target 1 ally" card'),
    legacy.Perk(ClassCodes.snowdancer, 2,
        'Add one "HEAL 1, WARD, Target 1 ally" $_rolling card'),
    legacy.Perk(
        ClassCodes.snowdancer, 1, '$_wheneverYouLongRest, you may ICE/AIR'),
    legacy.Perk(ClassCodes.snowdancer, 2,
        '$_wheneverYouShortRest, you may consume_ICE to perform $_regenerate, RANGE 3 and consume_AIR to perform WARD, RANGE 3',
        perkIsGrouped: true),
    legacy.Perk(ClassCodes.snowdancer, 2,
        '$_atTheStartOfEachScenario, all enemies gain MUDDLE. Whenever a new room is revealed, all enemies in the newly revealed room gain MUDDLE',
        perkIsGrouped: true),
    // FROZEN FIST
    legacy.Perk(ClassCodes.frozenFist, 2,
        'Replace one -1 card with one +0 DISARM card'),
    legacy.Perk(
        ClassCodes.frozenFist, 1, 'Replace one -1 card with one +1 card'),
    legacy.Perk(
        ClassCodes.frozenFist, 1, 'Replace one -2 card with one +0 card'),
    legacy.Perk(ClassCodes.frozenFist, 2,
        'Replace one +0 card with one +1 "$_shield 1" $_rolling card'),
    legacy.Perk(ClassCodes.frozenFist, 2,
        'Replace one +0 card with one +1 ICE/EARTH card'),
    legacy.Perk(ClassCodes.frozenFist, 2,
        'Replace one +0 card with one +2 "Create one 1-hex icy terrain tile in a featureless hex adjacent to the target" card'),
    legacy.Perk(ClassCodes.frozenFist, 1, 'Add one +3 card'),
    legacy.Perk(
        ClassCodes.frozenFist, 3, 'Add two "HEAL 1, self" $_rolling cards'),
    legacy.Perk(ClassCodes.frozenFist, 1,
        '$_ignoreItemMinusOneEffects, and, whenever you enter icy terrain with a move ability, you may ignore the effect to add plusone MOVE'),
    legacy.Perk(ClassCodes.frozenFist, 1,
        'Whenever you heal from a long rest, you may consume_ICE/EARTH to add plustwo HEAL'),
    legacy.Perk(ClassCodes.frozenFist, 2,
        'Once each scenario, when you would suffer DAMAGE, you may negate the DAMAGE',
        perkIsGrouped: true),
    // HIVE
    legacy.Perk(ClassCodes.hive, 1, 'Remove one -2 card and one +1 card'),
    legacy.Perk(ClassCodes.hive, 3,
        'Replace one -1 card with one +0 "After this attack ability, grant one of your summons: MOVE 2" card'),
    legacy.Perk(ClassCodes.hive, 3,
        'Replace one +0 card with one +1 "After this attack ability, TRANSFER" card'),
    legacy.Perk(ClassCodes.hive, 3, 'Add one +1 "HEAL 1, self" card'),
    legacy.Perk(ClassCodes.hive, 2, 'Add one +2 MUDDLE card'),
    legacy.Perk(ClassCodes.hive, 1, 'Add two POISON $_rolling cards'),
    legacy.Perk(ClassCodes.hive, 1, 'Add two WOUND $_rolling cards'),
    legacy.Perk(ClassCodes.hive, 2,
        '$_wheneverYouLongRest, you may do so on any initiative value, choosing your initiative after all ability cards have been revealed, and you decide how your summons perform their abilities for the round',
        perkIsGrouped: true),
    legacy.Perk(ClassCodes.hive, 1,
        'At the end of each of your short rests, you may TRANSFER'),
    legacy.Perk(ClassCodes.hive, 1,
        'Whenever you would gain WOUND, prevent the condition'),
    // METAL MOSAIC
    legacy.Perk(ClassCodes.metalMosaic, 3,
        'Replace one -1 card with one +0 "PRESSURE_GAIN or PRESSURE_LOSE" card'),
    legacy.Perk(ClassCodes.metalMosaic, 2,
        'Replace one -1 card with one "$_shield 1" $_rolling card'),
    legacy.Perk(ClassCodes.metalMosaic, 2,
        'Replace one +0 card with one +0 "The target and all enemies adjacent to it suffer DAMAGE 1" card'),
    legacy.Perk(ClassCodes.metalMosaic, 2,
        'Replace two +0 cards with one PIERCE 3 $_rolling and one "$_retaliate 2" $_rolling card'),
    legacy.Perk(ClassCodes.metalMosaic, 2, 'Add one +1 "HEAL 2, self" card'),
    legacy.Perk(ClassCodes.metalMosaic, 1, 'Add one +3 card'),
    legacy.Perk(ClassCodes.metalMosaic, 1,
        '$_ignoreItemMinusOneEffects and add two +1 cards'),
    legacy.Perk(ClassCodes.metalMosaic, 1,
        '$_wheneverYouLongRest, you may PRESSURE_GAIN or PRESSURE_LOSE'),
    legacy.Perk(ClassCodes.metalMosaic, 1,
        'Whenever you would gain POISON, you may suffer DAMAGE 1 to prevent the condition'),
    legacy.Perk(ClassCodes.metalMosaic, 3,
        'Once each scenario, when you would become exhausted, instead gain STUN and INVISIBLE, lose all your cards, RECOVER four lost cards, and then discard the recovered cards',
        perkIsGrouped: true),
    // DEEPWRAITH
    legacy.Perk(ClassCodes.deepwraith, 1, 'Remove two -1 cards'),
    legacy.Perk(ClassCodes.deepwraith, 2,
        'Replace one -1 card with one +0 DISARM card'),
    legacy.Perk(
        ClassCodes.deepwraith, 1, 'Replace one -2 card with one -1 STUN card'),
    legacy.Perk(ClassCodes.deepwraith, 2,
        'Replace one +0 card with one +0 "INVISIBLE, self" card'),
    legacy.Perk(ClassCodes.deepwraith, 1,
        'Replace two +0 cards with two PIERCE 3 $_rolling cards'),
    legacy.Perk(
        ClassCodes.deepwraith, 1, 'Replace two +1 cards with two +2 cards'),
    legacy.Perk(ClassCodes.deepwraith, 1,
        'Replace three +1 cards with three +1 CURSE cards'),
    legacy.Perk(ClassCodes.deepwraith, 3, 'Add two +1 "Gain 1 TROPHY" cards'),
    legacy.Perk(ClassCodes.deepwraith, 1,
        '$_ignoreScenarioEffects and remove two +0 cards'),
    legacy.Perk(ClassCodes.deepwraith, 1,
        '$_wheneverYouLongRest, you may LOOT one adjacent hex. If you gain any loot tokens, gain 1 TROPHY'),
    legacy.Perk(
        ClassCodes.deepwraith, 1, '$_atTheStartOfEachScenario, gain 2 TROPHY'),
    legacy.Perk(ClassCodes.deepwraith, 3,
        'While you have INVISIBLE, gain advantage on all your attacks',
        perkIsGrouped: true),
    // CRASHING TIDE
    legacy.Perk(ClassCodes.crashingTide, 2,
        'Replace one -1 card with two PIERCE 3 $_rolling cards'),
    legacy.Perk(ClassCodes.crashingTide, 2,
        'Replace one -1 card with one +0 "plusone Target" card'),
    legacy.Perk(ClassCodes.crashingTide, 2,
        'Replace one +0 card with one +1 "$_shield 1" $_rolling card'),
    legacy.Perk(ClassCodes.crashingTide, 2,
        'Add two +1 "If you performed a TIDE action this round, +2 instead" cards'),
    legacy.Perk(ClassCodes.crashingTide, 2, 'Add one +2 MUDDLE card'),
    legacy.Perk(ClassCodes.crashingTide, 1, 'Add one +1 DISARM card'),
    legacy.Perk(
        ClassCodes.crashingTide, 2, 'Add two "HEAL 1, self" $_rolling cards'),
    legacy.Perk(ClassCodes.crashingTide, 1,
        '$_ignoreItemMinusOneEffects, and, whenever you would gain IMPAIR, prevent the condition'),
    legacy.Perk(ClassCodes.crashingTide, 1,
        'Whenever you declare a long rest during card selection, gain $_shield 1 for the round'),
    legacy.Perk(ClassCodes.crashingTide, 3,
        'Gain advantage on all your attacks performed while occupying or targeting enemies occupying water hexes',
        perkIsGrouped: true),
    // THORNREAPER
    legacy.Perk(ClassCodes.thornreaper, 2,
        '$_replace $_one -1 $_card with $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card'),
    legacy.Perk(ClassCodes.thornreaper, 1,
        '$_replace $_one -2 $_card with $_one +0 $_card'),
    legacy.Perk(ClassCodes.thornreaper, 2,
        'Add three $_rolling "+1 if LIGHT is Strong or Waning" cards'),
    legacy.Perk(
        ClassCodes.thornreaper, 1, '$_add $_two $_rolling LIGHT $_cards'),
    legacy.Perk(ClassCodes.thornreaper, 1,
        '$_add $_three $_rolling "EARTH if LIGHT is Strong or Waning" $_cards'),
    legacy.Perk(ClassCodes.thornreaper, 1,
        '$_add $_one "Create hazardous terrain in $_one hex within RANGE 1" $_card'),
    legacy.Perk(ClassCodes.thornreaper, 2,
        'Add one $_rolling "On the next attack targeting you while occupying hazardous terrain, discard this card to gain $_retaliate 3" card'),
    legacy.Perk(ClassCodes.thornreaper, 2,
        'Add one $_rolling "On the next attack targeting you while occupying hazardous terrain, discard this card to gain $_shield 3" card'),
    legacy.Perk(ClassCodes.thornreaper, 1,
        'Ignore $_negative item $_effects and $_addL $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card'),
    legacy.Perk(ClassCodes.thornreaper, 2,
        'Gain $_shield 1 while you occupy hazardous terrain',
        perkIsGrouped: true),
    // INCARNATE
    legacy.Perk(ClassCodes.incarnate, 1,
        '$_replace $_one -2 $_card with $_one $_rolling ALL_STANCES $_card'),
    legacy.Perk(ClassCodes.incarnate, 1,
        '$_replace $_one -1 $_card with $_one $_rolling PIERCE 2, FIRE $_card'),
    legacy.Perk(ClassCodes.incarnate, 1,
        '$_replace $_one -1 $_card with $_one $_rolling "$_shield 1, Self, EARTH" $_card'),
    legacy.Perk(ClassCodes.incarnate, 1,
        '$_replace $_one -1 $_card with $_one $_rolling PUSH 1, AIR $_card'),
    legacy.Perk(ClassCodes.incarnate, 2,
        '$_replace $_one +0 $_card with $_one +1 "RITUALIST : ENFEEBLE / CONQUEROR : EMPOWER, Self" $_card'),
    legacy.Perk(ClassCodes.incarnate, 2,
        '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE / CONQUEROR : EMPOWER, Self" $_card'),
    legacy.Perk(ClassCodes.incarnate, 2,
        '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE / RITUALIST : ENFEEBLE" $_card'),
    legacy.Perk(ClassCodes.incarnate, 1,
        '$_add $_one $_rolling "RECOVER $_one One_Hand or Two_Hand item" $_card'),
    legacy.Perk(ClassCodes.incarnate, 1,
        'Each time you long rest, perform: ALL_STANCES'),
    legacy.Perk(ClassCodes.incarnate, 1,
        'You may bring one additional One_Hand item into each scenario'),
    legacy.Perk(ClassCodes.incarnate, 1,
        'Each time you short rest, RECOVER one spent One_Hand item'),
    legacy.Perk(ClassCodes.incarnate, 1,
        '$_ignoreNegativeItemEffects and $_removeL one -1 $_card'),
    // RIMEHEARTH
    legacy.Perk(ClassCodes.rimehearth, 2,
        '$_replace $_one -1 $_card with $_one $_rolling WOUND $_card'),
    legacy.Perk(ClassCodes.rimehearth, 1,
        '$_replace $_one +0 $_card with $_one $_rolling "HEAL 3, WOUND, Self" $_card'),
    legacy.Perk(ClassCodes.rimehearth, 1,
        '$_replace $_two +0 $_cards with $_two $_rolling FIRE $_cards'),
    legacy.Perk(ClassCodes.rimehearth, 1,
        '$_replace $_three +1 $_cards with $_one $_rolling +1 card, $_one +1 WOUND $_card, and $_one +1 "HEAL 1, Self" $_card'),
    legacy.Perk(ClassCodes.rimehearth, 2,
        '$_replace $_one +0 $_card with $_one +1 ICE $_card'),
    legacy.Perk(ClassCodes.rimehearth, 2,
        '$_replace $_one -1 $_card with $_one +0 CHILL $_card'),
    legacy.Perk(ClassCodes.rimehearth, 1,
        '$_replace $_one +2 $_card with $_one +3 CHILL $_card'),
    legacy.Perk(ClassCodes.rimehearth, 2, '$_add $_one +2 FIRE/ICE $_card'),
    legacy.Perk(ClassCodes.rimehearth, 1, '$_add $_one +0 BRITTLE $_card'),
    legacy.Perk(ClassCodes.rimehearth, 1,
        'At the start of each $_scenario, you may either gain WOUND to generate FIRE or gain CHILL to generate ICE'),
    legacy.Perk(ClassCodes.rimehearth, 1,
        '$_ignoreNegativeItemEffects and $_add $_one $_rolling FIRE/ICE $_card'),
    // SHARDRENDER
    legacy.Perk(ClassCodes.shardrender, 1, 'Remove one -2 card'),
    legacy.Perk(ClassCodes.shardrender, 2,
        '$_replace $_one -1 $_card with $_one +1 card'),
    legacy.Perk(ClassCodes.shardrender, 2,
        '$_replace -1 card with one $_rolling "Shield 1, Self" card'),
    legacy.Perk(ClassCodes.shardrender, 2,
        '$_replace two +0 cards with two +0 "Move one character token on a CRYSTALLIZE back one space" cards'),
    legacy.Perk(ClassCodes.shardrender, 2,
        'Replace one +0 card with one $_rolling +1 "+2 instead if the attack has PIERCE" card'),
    legacy.Perk(ClassCodes.shardrender, 1,
        'Add two +1 "+2 instead if you CRYSTALLIZE PERSIST one space" cards'),
    legacy.Perk(ClassCodes.shardrender, 1, 'Add one +0 BRITTLE card'),
    legacy.Perk(ClassCodes.shardrender, 2,
        '$_ignoreNegativeItemEffects and $_atTheStartOfEachScenario, you may play a level 1 card from your hand to perform a CRYSTALLIZE action of the card',
        perkIsGrouped: true),
    legacy.Perk(ClassCodes.shardrender, 1,
        'Once each scenario, when you would suffer damage from an attack, gain "$_shield 3" for that attack'),
    legacy.Perk(ClassCodes.shardrender, 1,
        'Each time you long rest, perform "$_regenerate, Self"'),
    // TEMPEST
    legacy.Perk(ClassCodes.tempest, 1,
        'Replace one -2 card with one -1 AIR/LIGHT card'),
    legacy.Perk(ClassCodes.tempest, 1,
        'Replace one -1 AIR/LIGHT card with one +1 AIR/LIGHT card'),
    legacy.Perk(
        ClassCodes.tempest, 2, 'Replace one -1 card with one +0 WOUND card'),
    legacy.Perk(ClassCodes.tempest, 2,
        '$_replace one -1 card with one $_rolling "$_regenerate, RANGE 1" card'),
    legacy.Perk(
        ClassCodes.tempest, 1, 'Replace one +0 card with one +2 MUDDLE card'),
    legacy.Perk(ClassCodes.tempest, 1,
        'Replace two +0 cards with one +1 $_immobilize card'),
    legacy.Perk(ClassCodes.tempest, 2, 'Add one +1 "DODGE, Self" card'),
    legacy.Perk(ClassCodes.tempest, 1, 'Add one +2 AIR/LIGHT card'),
    legacy.Perk(
        ClassCodes.tempest, 1, 'Whenever you dodge an attack, gain one SPARK'),
    legacy.Perk(
        ClassCodes.tempest, 2, '$_wheneverYouLongRest, you may gain DODGE',
        perkIsGrouped: true),
    legacy.Perk(ClassCodes.tempest, 1,
        '$_wheneverYouShortRest, you may consume_SPARK one Spark. If you do, one enemy within RANGE 2 suffers one damage'),
    // VANQUISHER
    legacy.Perk(ClassCodes.vanquisher, 1,
        'Replace two -1 cards with one +0 MUDDLE card'),
    legacy.Perk(ClassCodes.vanquisher, 1,
        'Replace two -1 cards with one -1 "HEAL 2, Self" card'),
    legacy.Perk(ClassCodes.vanquisher, 1,
        'Replace one -2 card with one -1 POISON WOUND card'),
    legacy.Perk(ClassCodes.vanquisher, 2,
        '$_replace one +0 card with one +1 "HEAL 1, Self" card'),
    legacy.Perk(ClassCodes.vanquisher, 1,
        'Replace two +0 cards with one +0 CURSE card and one +0 $_immobilize card'),
    legacy.Perk(ClassCodes.vanquisher, 2,
        'Replace one +1 card with one +2 FIRE/AIR card'),
    legacy.Perk(ClassCodes.vanquisher, 1,
        'Replace one +2 card with one $_rolling "Gain one RAGE" card'),
    legacy.Perk(ClassCodes.vanquisher, 2,
        'Add one +1 "$_retaliate 1, Self" card and one $_rolling PIERCE 3 card'),
    legacy.Perk(ClassCodes.vanquisher, 1, 'Add one +0 "BLESS, Self" card'),
    legacy.Perk(ClassCodes.vanquisher, 1,
        'Add two +1 "+2 instead if you suffer 1 damage" cards'),
    legacy.Perk(ClassCodes.vanquisher, 1,
        'Add one +2 "+3 instead if you suffer 1 damage" cards'),
    legacy.Perk(ClassCodes.vanquisher, 1,
        '$_ignoreNegativeItemEffects and remove one -1 card'),
    // INCARNATE V2
    // Perk(ClassCodes.incarnate, 1,
    //     '$_replace $_one -2 $_card with $_one +0 ALL_STANCES $_rolling $_card'),
    // Perk(ClassCodes.incarnate, 1,
    //     '$_replace $_one -1 $_card with $_one +0 PIERCE 2 FIRE $_rolling $_card'),
    // Perk(ClassCodes.incarnate, 1,
    //     '$_replace $_one -1 $_card with $_one +0 PUSH 1 AIR $_rolling $_card'),
    // Perk(ClassCodes.incarnate, 1,
    //     '$_replace $_one -1 $_card with $_one +0 "$_shield 1" EARTH $_rolling $_card'),
    // Perk(ClassCodes.incarnate, 2,
    //     '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE or RITUALIST : ENFEEBLE" $_card'),
    // Perk(ClassCodes.incarnate, 2,
    //     '$_replace $_one +0 $_card with $_one +1 "REAVER : RUPTURE or CONQUEROR : EMPOWER, self" $_card'),
    // Perk(ClassCodes.incarnate, 2,
    //     '$_replace $_one +0 $_card with $_one +1 "RITUALIST : ENFEEBLE or CONQUEROR : EMPOWER, self" $_card'),
    // Perk(ClassCodes.incarnate, 1,
    //     'Add one +0 "RECOVER one One_Hand or Two_Hand item" $_rolling card'),
    // Perk(ClassCodes.incarnate, 1,
    //     '$_ignoreItemMinusOneEffects and remove one -1 card'),
    // Perk(ClassCodes.incarnate, 1,
    //     '[Eyes of the Ritualist:] $_wheneverYouLongRest, perform ALL_STANCES'),
    // Perk(ClassCodes.incarnate, 1,
    //     '[Shoulders of the Conqueror:] You may bring one additional One_Hand item into each scenario'),
    // Perk(ClassCodes.incarnate, 1,
    //     '[Hands of the Reaver:] $_wheneverYouShortRest, RECOVER one spent One_Hand item'),
  ];

  static final List<legacy.Mastery> masteries = [
    // GLOOMHAVEN
    legacy.Mastery(
      masteryClassCode: ClassCodes.brute,
      masteryDetails:
          'Cause enemies to suffer a total of 12 or more $_retaliate damage during attacks targeting you in a single round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.brute,
      masteryDetails:
          'Across three consecutive rounds, play six different ability cards and cause enemies to suffer at least DAMAGE 6 on each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.tinkerer,
      masteryDetails:
          'Heal an ally or apply a negative condition to an enemy each turn',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.tinkerer,
      masteryDetails:
          'Perform two actions with lost icons before your first rest and then only rest after having played at least two actions with lost icons since your previous rest',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.spellweaver,
      masteryDetails: 'Infuse and consume all six elements',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.spellweaver,
      masteryDetails: 'Perform four different loss actions twice each',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.scoundrel,
      masteryDetails:
          'Kill at least six enemies that are adjacent to at least one of your allies',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.scoundrel,
      masteryDetails:
          'Kill at least six enemies that are adjacent to none of your allies',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.cragheart,
      masteryDetails: 'Only attack enemies adjacent to obstacles or walls',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.cragheart,
      masteryDetails: 'Damage or heal at least one ally each round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.mindthief,
      masteryDetails:
          'Trigger the on-attack effect of four different Augments thrice each',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.mindthief,
      masteryDetails: 'Never be targeted by an attack',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.sunkeeper,
      masteryDetails:
          'Reduce attacks targeting you by a total of 20 or more through Shield effects in a single round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.sunkeeper,
      masteryDetails: 'LIGHT or consume_LIGHT during each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.quartermaster,
      masteryDetails:
          "Spend, lose, or refresh one or more items on each of your turns without ever performing the top action of ~Reinforced ~Steel",
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.quartermaster,
      masteryDetails: 'LOOT six or more loot tokens in a single turn',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.summoner,
      masteryDetails:
          'Summon the Lava Golem on your first turn and keep it alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.summoner,
      masteryDetails:
          'Perform the summon action of five different ability cards',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.nightshroud,
      masteryDetails:
          'Have INVISIBLE at the start or end of each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.nightshroud,
      masteryDetails: 'DARK or consume_DARK during each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.plagueherald,
      masteryDetails: 'Kill at least five enemies with non-attack abilities',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.plagueherald,
      masteryDetails:
          'Perform three different attack abilities that target at least four enemies each',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.berserker,
      masteryDetails:
          "Lose at least one hit point during each of your turns, without ever performing the bottom action of ~Blood ~Pact",
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.berserker,
      masteryDetails:
          'Have exactly one hit point at the end of each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.soothsinger,
      masteryDetails:
          'On your first turn of the scenario and the turn after each of your rests, perform one Song action that you have not yet performed this scenario',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.soothsinger,
      masteryDetails:
          'Have all 10 monster CURSE cards and all 10 BLESS cards in modifier decks at the same time',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.doomstalker,
      masteryDetails:
          'Never perform a Doom action that you have already performed in the scenario',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.doomstalker,
      masteryDetails: 'Kill three Doomed enemies during one of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.sawbones,
      masteryDetails:
          "On each of your turns, give an ally an ability card, target an ally with a HEAL ability, grant an ally $_shield, or place an ability card in an ally's active area",
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.sawbones,
      masteryDetails: 'Deal at least DAMAGE 20 with a single attack ability',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.elementalist,
      masteryDetails:
          "Consume at least two different elements with each of four different attack abilities without ever performing the bottom action of ~Formless ~Power or ~Shaping ~the ~Ether",
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.elementalist,
      masteryDetails:
          'Infuse five or more elements during one of your turns, then consume five or more elements during your following turn',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.beastTyrant,
      masteryDetails:
          'Have your bear summon deal DAMAGE 10 or more in three consecutive rounds',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.beastTyrant,
      masteryDetails:
          'You or your summons must apply a negative condition to at least 10 different enemies',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.bladeswarm,
      masteryDetails:
          'Perform two different summon actions on your first turn and keep all summons from those actions alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.bladeswarm,
      masteryDetails:
          'Perform three different non-summon persistent loss actions before your first rest',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.diviner,
      masteryDetails:
          'During one round, have at least four monsters move into four different Rifts that affect those monsters',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.diviner,
      masteryDetails:
          'Reveal at least one card from at least one ability card deck or attack modifier deck each round',
    ),
    // JAWS OF THE LION
    legacy.Mastery(
      masteryClassCode: ClassCodes.demolitionist,
      masteryDetails:
          'Deal DAMAGE 10 or more with each of three different attack actions',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.demolitionist,
      masteryDetails:
          'Destroy at least six obstacles. End the scenario with no obstacles on the map other than ones placed by allies',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.hatchet,
      masteryDetails: 'AIR or consume_AIR during each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.hatchet,
      masteryDetails:
          'During each round in which there is at least one enemy on the map at the start of your turn, either place one of your tokens on an ability card of yours or on an enemy',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.redGuard,
      masteryDetails: 'Kill at least five enemies during their turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.redGuard,
      masteryDetails:
          'Force each enemy in the scenario to move at least one hex, forcing at least six enemies to move',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.voidwarden,
      masteryDetails:
          'Cause enemies to suffer DAMAGE 20 or more in a single turn with granted or commanded attacks',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.voidwarden,
      masteryDetails:
          'Give at least one ally or enemy POISON, STRENGTHEN, BLESS, or WARD each round',
    ),
    // FROSTHAVEN
    legacy.Mastery(
      masteryClassCode: ClassCodes.drifter,
      masteryDetails:
          'End a scenario with your character tokens on the last use slots of four persistent abilities',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.drifter,
      masteryDetails:
          'Never perform a move or attack ability with a value less than 4, and perform at least one move or attack ability every round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.blinkBlade,
      masteryDetails: 'Declare Fast seven rounds in a row',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.blinkBlade,
      masteryDetails: 'Never be targeted by an attack',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.bannerSpear,
      masteryDetails:
          'Attack at least three targets with three different area of effect attacks',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.bannerSpear,
      masteryDetails:
          'Play a Banner summon ability on your first turn, always have it within RANGE 3 of you, and keep it alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.deathwalker,
      masteryDetails: 'Consume seven SHADOW in one round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.deathwalker,
      masteryDetails: 'Create or consume at least one SHADOW every round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.boneshaper,
      masteryDetails: 'Kill at least 15 of your summons',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.boneshaper,
      masteryDetails:
          'Play a summon action on your first turn, have this summon kill at least 6 enemies, and keep it alive for the entire scenario',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.geminate,
      masteryDetails: 'Switch forms every round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.geminate,
      masteryDetails: 'Lose at least one card every round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.infuser,
      masteryDetails: 'Have five active INFUSION bonuses',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.infuser,
      masteryDetails: 'Kill at least four enemies, but never attack',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.pyroclast,
      masteryDetails:
          'Create or destroy at least one obstacle or hazardous terrain tile each round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.pyroclast,
      masteryDetails:
          'Move enemies through six different hexes of hazardous terrain you created in one turn',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.shattersong,
      masteryDetails:
          'Always have 0 RESONANCE directly before you gain RESONANCE at the end of each of your turns',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.shattersong,
      masteryDetails:
          'Spend 5 RESONANCE on each of five different Wave abilities',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.trapper,
      masteryDetails:
          'Have one HEAL trap on the map with a value of at least 20',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.trapper,
      masteryDetails:
          'Move enemies through seven or more traps with one ability',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.painConduit,
      masteryDetails:
          'Cause other figures to suffer a total of at least DAMAGE 40 in one round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.painConduit,
      masteryDetails:
          'Start a turn with WOUND, BRITTLE, BANE, POISON, $_immobilize, DISARM, STUN, and MUDDLE',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.snowdancer,
      masteryDetails: 'Cause at least one ally or enemy to move each round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.snowdancer,
      masteryDetails:
          'Ensure the first ally to suffer DAMAGE each round, directly before suffering the DAMAGE, has at least one condition you applied',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.frozenFist,
      masteryDetails:
          'RECOVER at least one card from your discard pile each round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.frozenFist,
      masteryDetails:
          'Enter at least ten different hexes with one move ability, then cause one enemy to suffer at least DAMAGE 10 with one attack ability in the same turn',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.hive,
      masteryDetails: 'TRANSFER each round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.hive,
      masteryDetails: 'TRANSFER into four different summons in one round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.metalMosaic,
      masteryDetails: 'Never attack',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.metalMosaic,
      masteryDetails:
          'For four consecutive rounds, move the pressure gauge up or down three levels from where it started the round (PRESSURE_LOW to PRESSURE_HIGH, or vice versa)',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.deepwraith,
      masteryDetails: 'Perform all your attacks with advantage',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.deepwraith,
      masteryDetails: 'Infuse DARK each round',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.crashingTide,
      masteryDetails:
          'Never suffer damage from attacks, and be targeted by at least five attacks',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.crashingTide,
      masteryDetails:
          'At the start of each of your rests, have more active TIDE than cards in your discard pile',
    ),
    // CUSTOM
    legacy.Mastery(
      masteryClassCode: ClassCodes.incarnate,
      masteryDetails:
          'Never end your turn with the same spirit you started in that turn',
    ),
    legacy.Mastery(
      masteryClassCode: ClassCodes.incarnate,
      masteryDetails:
          'Perform fifteen attacks using One_Hand or Two_Hand items',
    ),
  ];

  static final Map<String, List<Masteries>> masteriesMap = {
    ClassCodes.brute: [
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
    ClassCodes.tinkerer: [
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
    ClassCodes.spellweaver: [
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
    ClassCodes.scoundrel: [
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
    ClassCodes.cragheart: [
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
    ClassCodes.mindthief: [
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
    ClassCodes.sunkeeper: [
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
    ClassCodes.quartermaster: [
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
    ClassCodes.summoner: [
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
    ClassCodes.nightshroud: [
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
    ClassCodes.plagueherald: [
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
    ClassCodes.berserker: [
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
    ClassCodes.soothsinger: [
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
    ClassCodes.doomstalker: [
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
    ClassCodes.sawbones: [
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
    ClassCodes.elementalist: [
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
    ClassCodes.beastTyrant: [
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
    ClassCodes.bladeswarm: [
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
    ClassCodes.diviner: [
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
    ClassCodes.demolitionist: [
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
    ClassCodes.hatchet: [
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
    ClassCodes.redGuard: [
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
    ClassCodes.voidwarden: [
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
    ClassCodes.drifter: [
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
    ClassCodes.blinkBlade: [
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
    ClassCodes.bannerSpear: [
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
    ClassCodes.deathwalker: [
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
    ClassCodes.boneshaper: [
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
    ClassCodes.geminate: [
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
    ClassCodes.infuser: [
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
    ClassCodes.pyroclast: [
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
    ClassCodes.shattersong: [
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
    ClassCodes.trapper: [
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
    ClassCodes.painConduit: [
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
    ClassCodes.snowdancer: [
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
    ClassCodes.frozenFist: [
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
    ClassCodes.hive: [
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
    ClassCodes.metalMosaic: [
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
    ClassCodes.deepwraith: [
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
    ClassCodes.crashingTide: [
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
    ClassCodes.vimthreader: [
      Masteries(
        [
          Mastery(
            masteryDetails:
                'For an entire scenario, perform a heal ability and cause a figure to suffer DAMAGE each round',
          ),
          Mastery(
            masteryDetails: 'Gain the attributes of 12 different monster types',
          ),
        ],
      )
    ],
    // ClassCodes.incarnate: [
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
    ClassCodes.brute: [
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
        variant: Variant.base,
      ),
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
            '[Rejuvenating Vapor:] $_wheneverYouLongRest, you may perform "HEAL 2, RANGE 3"',
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
          Perk('$_add $_two $_rolling PIERCE 3 $_cards'),
          Perk(
            '$_add $_two $_rolling POISON $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling MUDDLE $_cards'),
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
        variant: Variant.base,
      ),
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
          Perk('$_add $_three $_rolling MUDDLE $_cards'),
          Perk('$_add $_two $_rolling $_immobilize $_cards'),
          Perk('$_add $_one $_rolling STUN $_card'),
          Perk(
              '$_add $_one $_rolling DISARM $_card and $_one $_rolling MUDDLE $_card'),
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
        variant: Variant.base,
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
        variant: Variant.base,
      ),
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
            '$_add $_three $_rolling MUDDLE $_cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling HEAL 1 $_cards'),
          Perk('$_add $_two $_rolling CURSE $_cards'),
          Perk('$_add $_one $_rolling ADD TARGET $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addL $_two +1 $_cards'),
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
          Perk('$_add $_two $_rolling CURSE $_cards'),
          Perk('$_add $_two $_rolling IMMOBILIZE $_cards'),
          Perk(
            '$_add $_one $_rolling STUN $_card',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_addL $_one +1 $_card'),
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
              '[Rapid Recovery:] Whenever you heal from a long rest, add plusone HEAL'),
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
        variant: Variant.base,
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
          Perk('$_replace $_one +0 $_card with $_one +0 STUN $_card'),
          Perk('$_replace $_one +0 $_card with $_one +1 WOUND $_card'),
          Perk('$_replace $_two +1 $_cards with $_two +2 $_cards'),
          Perk('$_add $_four +0 FIRE $_cards'),
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
    ClassCodes.bladeswarm: [
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
        variant: Variant.base,
      ),
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
    ClassCodes.hatchet: [
      Perks(
        [
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
        ],
        variant: Variant.base,
      ),
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
    ClassCodes.vimthreader: [
      Perks(
        [
          Perk(
              '$_replace $_one -2 $_card with $_one -1 "If the target has an attribute, $_addL +2, WOUND, POISON, MUDDLE" $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 ENFEEBLE $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "EMPOWER, RANGE 2" $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 "HEAL 1, TARGET 1 ally" $_card',
            quantity: 3,
          ),
          Perk('$_replace $_one +2 $_card with $_four +1 $_rolling $_cards'),
          Perk('$_add $_two PIERCE 2 POISON $_rolling $_cards'),
          Perk(
            '$_add $_three "HEAL 1, RANGE 1" $_rolling $_cards',
            quantity: 2,
          ),
          Perk('$_ignoreScenarioEffects and $_removeL $_one +0 $_card'),
          // here
          Perk('$_ignoreItemMinusOneEffects and $_removeL $_one +0 $_card'),
          Perk(
              '$_wheneverYouShortRest, $_one adjacent enemy suffers DAMAGE 1, and you perform "HEAL 1, self"'),
          Perk(
            '$_atTheStartOfEachScenario, you may suffer DAMAGE 1 to grant all allies and self MOVE 3',
            quantity: 2,
            grouped: true,
          ),
          Perk(
              'Once each $_scenario, $_removeL all $_negative conditions you have. One adjacent enemy suffers DAMAGE equal to the number of conditions removed'),
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
        ],
        variant: Variant.base,
      ),
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
    ClassCodes.amberAegis: [
      Perks(
        [
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
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.artificer: [
      Perks(
        [
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
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.bombard: [
      Perks(
        [
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
          Perk(
              'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.brewmaster: [
      Perks(
        [
          Perk('$_replace $_one -2 $_card with $_one -1 STUN $_card'),
          Perk(
            '$_replace $_one -1 $_card with $_one +1 $_card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_two $_rolling MUDDLE $_cards',
            quantity: 2,
          ),
          Perk(
              '$_replace $_two +0 $_cards with $_two +0 "HEAL 1, Self" $_cards'),
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
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.brightspark: [
      Perks(
        [
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
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.chieftain: [
      Perks(
        [
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
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.hollowpact: [
      Perks(
        [
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
          Perk('$_replace $_one +1 $_card with $_one +2 WOUND $_card'),
          Perk('$_add $_one +1 "DISARM if the target is Shackled" $_card'),
          Perk(
              '$_add $_one +1 "Create a 2 DAMAGE trap in an empty hex within RANGE 2" $_card'),
          Perk('$_add $_two $_rolling "HEAL 1, Self" $_cards'),
          Perk(
            '$_add $_one +2 Shackle $_card',
            quantity: 2,
          ),
          Perk(
              'Ignore $_negative item $_effects and $_removeL $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.hierophant: [
      Perks(
        [
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
          Perk('$_replace $_one +0 $_card with $_one +1 PIERCE 2 $_card'),
          Perk('$_add $_three $_rolling PIERCE 3 $_cards'),
          Perk('$_add $_one +1 CURSE $_card'),
          Perk('$_add $_one $_rolling ADD TARGET $_card'),
          Perk('$_replace $_one +1 $_card with $_one +2 PUSH 2 $_card'),
          Perk(
              'Ignore $_negative $_scenario $_effects and $_removeL $_one +0 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.starslinger: [
      Perks(
        [
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
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.ruinmaw: [
      Perks(
        [
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
              '$_replace $_two +0 $_cards with $_two PIERCE 3 $_rolling $_cards'),
          Perk(
              '$_replace $_two +0 $_cards with $_two PUSH 2 $_rolling $_cards'),
          Perk('$_add $_one +3 $_card'),
          Perk(
            '$_add $_one +2 $_immobilize $_card',
            quantity: 2,
          ),
          Perk('$_add $_two "HEAL 1, self" $_rolling $_cards'),
          Perk('$_ignoreScenarioEffects and $_addL $_one +1 $_card'),
          Perk('$_ignoreItemMinusOneEffects and $_addL $_one +1 $_card'),
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
          Perk(
              '$_wheneverYouLongRest, you may move $_one SHADOW up to 3 hexes'),
          Perk(
              '$_wheneverYouShortRest, you may consume_DARK to perform MUDDLE, CURSE, RANGE 2 as if you were occupying a hex with a SHADOW'),
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
              '$_wheneverYouShortRest, you may $_removeL $_one $_negative condition from $_one ally within RANGE 3'),
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
            'Replace one +0 card with one +1 WOUND card',
            quantity: 2,
          ),
          Perk(
            'Replace one -1 card with one +0 "Create one 1-hex hazardous terrain tile in a featureless hex adjacent to the target" card',
            quantity: 2,
          ),
          Perk(
            'Replace two +0 cards with two PUSH 2 $_rolling cards',
            quantity: 2,
          ),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk(
            'Add two +1 FIRE/EARTH cards',
            quantity: 2,
          ),
          Perk('Add two +1 MUDDLE $_rolling cards'),
          Perk(_ignoreScenarioEffects),
          Perk(
              '$_wheneverYouLongRest, you may destroy one adjacent obstacle to gain WARD'),
          Perk(
              '$_wheneverYouShortRest, you may consume_FIRE to perform WOUND, Target 1 enemy occupying or adjacent to hazardous terrain'),
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
          Perk('Replace one -2 card with one -1 STUN card'),
          Perk(
            'Replace one +0 card with one +0 BRITTLE card',
            quantity: 2,
          ),
          Perk(
            'Replace two +1 cards with two +2 AIR/LIGHT cards',
            quantity: 2,
          ),
          Perk(
            'Add one "HEAL 2, BLESS, Target 1 ally" $_rolling card',
            quantity: 2,
          ),
          Perk(
            'Add one +1 "Gain 1 RESONANCE" card',
            quantity: 3,
          ),
          Perk(_ignoreScenarioEffects),
          Perk(
            '$_wheneverYouShortRest, you may consume_AIR to perform STRENGTHEN, RANGE 3 and consume_LIGHT to perform BLESS, RANGE 3',
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
            '$_replace $_one -1 $_card with $_one +0 "Create $_one HEAL 2 trap in an empty hex adjacent to the target" card',
            quantity: 2,
          ),
          Perk(
            '$_replace $_one -1 $_card with $_one +0 "Create $_one DAMAGE 1 trap in an empty hex adjacent to the target" card',
            quantity: 3,
          ),
          Perk(
            '$_replace $_two +0 $_cards with $_two +0 "Add DAMAGE 2 or HEAL 2 to a trap within RANGE 2 of you" $_cards',
            quantity: 3,
          ),
          Perk(
            '$_replace $_two +1 $_cards with $_two +2 $_immobilize $_cards',
            quantity: 2,
          ),
          Perk(
            '$_add $_two "Add PUSH 2 or PULL 2" $_rolling $_cards',
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
          Perk('$_replace $_one -2 $_card with $_one -2 CURSE CURSE $_card'),
          Perk('$_replace $_one -1 $_card with $_one +0 DISARM $_card'),
          Perk(
            '$_replace $_one +0 $_card with $_one +1 FIRE/AIR $_card',
            quantity: 3,
          ),
          Perk('$_replace $_one +0 $_card with $_one +2 $_card'),
          Perk('$_replace $_three +1 $_cards with $_three +1 CURSE $_cards'),
          Perk(
            '$_add $_three "HEAL 1, self" $_rolling $_cards',
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
              'Whenever you become exhausted, first perform CURSE, Target all, RANGE 3'),
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
            '$_replace $_one -1 $_card with $_one +0 "HEAL 1, Target 1 ally" $_card',
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
            '$_add $_one "HEAL 1, WARD, Target 1 ally" $_rolling $_card',
            quantity: 2,
          ),
          Perk('$_wheneverYouLongRest, you may ICE/AIR'),
          Perk(
            '$_wheneverYouShortRest, you may consume_ICE to perform $_regenerate, RANGE 3 and consume_AIR to perform WARD, RANGE 3',
            quantity: 2,
            grouped: true,
          ),
          Perk(
            '$_atTheStartOfEachScenario, all enemies gain MUDDLE. Whenever a new room is revealed, all enemies in the newly revealed room gain MUDDLE',
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
            '$_replace $_one -1 $_card with $_one +0 DISARM $_card',
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
            '$_add $_two "HEAL 1, self" $_rolling $_cards',
            quantity: 3,
          ),
          Perk(
              '$_ignoreItemMinusOneEffects, and, whenever you enter icy terrain with a move ability, you may ignore the effect to add plusone MOVE'),
          Perk(
              'Whenever you heal from a long rest, you may consume_ICE/EARTH to add plustwo HEAL'),
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
            '$_add $_one +1 "HEAL 1, self" $_card',
            quantity: 3,
          ),
          Perk(
            '$_add $_one +2 MUDDLE $_card',
            quantity: 2,
          ),
          Perk('$_add $_two POISON $_rolling $_cards'),
          Perk('$_add $_two WOUND $_rolling $_cards'),
          Perk(
            '$_wheneverYouLongRest, you may do so on any initiative value, choosing your initiative after all ability cards have been revealed, and you decide how your summons perform their abilities for the round',
            quantity: 2,
            grouped: true,
          ),
          Perk('At the end of each of your short rests, you may TRANSFER'),
          Perk('Whenever you would gain WOUND, prevent the condition'),
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
            '$_replace $_two +0 $_cards with $_one PIERCE 3 $_rolling and $_one "$_retaliate 2" $_rolling $_card',
            quantity: 2,
          ),
          Perk(
            '$_add $_one +1 "HEAL 2, self" $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +3 $_card'),
          Perk('$_ignoreItemMinusOneEffects and add two +1 $_cards'),
          Perk('$_wheneverYouLongRest, you may PRESSURE_GAIN or PRESSURE_LOSE'),
          Perk(
              'Whenever you would gain POISON, you may suffer DAMAGE 1 to prevent the condition'),
          Perk(
            'Once each scenario, when you would become exhausted, instead gain STUN and INVISIBLE, lose all your cards, RECOVER four lost cards, and then discard the recovered cards',
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
            '$_replace $_one -1 card with one +0 DISARM card',
            quantity: 2,
          ),
          Perk('Replace one -2 card with one -1 STUN card'),
          Perk(
            'Replace one +0 card with one +0 "INVISIBLE, self" card',
            quantity: 2,
          ),
          Perk('Replace two +0 cards with two PIERCE 3 $_rolling cards'),
          Perk('Replace two +1 cards with two +2 cards'),
          Perk('Replace three +1 cards with three +1 CURSE cards'),
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
            'Replace one -1 card with two PIERCE 3 $_rolling cards',
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
            'Add one +2 MUDDLE card',
            quantity: 2,
          ),
          Perk('Add one +1 DISARM card'),
          Perk(
            'Add two "HEAL 1, self" $_rolling cards',
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
            '$_replace $_one -1 $_card with $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card',
            quantity: 2,
          ),
          Perk('$_replace $_one -2 $_card with $_one +0 $_card'),
          Perk(
            'Add three $_rolling "+1 if LIGHT is Strong or Waning" cards',
            quantity: 2,
          ),
          Perk('$_add $_two $_rolling LIGHT $_cards'),
          Perk(
            '$_add $_three $_rolling "EARTH if LIGHT is Strong or Waning" $_cards',
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
            'Ignore $_negative item $_effects and $_addL $_one $_rolling "+1 if LIGHT is Strong or Waning" $_card',
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
              '$_replace $_one -1 $_card with $_one $_rolling PIERCE 2, FIRE $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one $_rolling "$_shield 1, Self, EARTH" $_card'),
          Perk(
              '$_replace $_one -1 $_card with $_one $_rolling PUSH 1, AIR $_card'),
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
          Perk('$_ignoreNegativeItemEffects and $_removeL one -1 $_card'),
        ],
        variant: Variant.base,
      ),
    ],
    ClassCodes.rimehearth: [
      Perks(
        [
          Perk(
            '$_replace $_one -1 $_card with $_one $_rolling WOUND $_card',
            quantity: 2,
          ),
          Perk(
              '$_replace $_one +0 $_card with $_one $_rolling "HEAL 3, WOUND, Self" $_card'),
          Perk('$_replace $_two +0 $_cards with $_two $_rolling FIRE $_cards'),
          Perk(
              '$_replace $_three +1 $_cards with $_one $_rolling +1 card, $_one +1 WOUND $_card, and $_one +1 "HEAL 1, Self" $_card'),
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
            '$_add $_one +2 FIRE/ICE $_card',
            quantity: 2,
          ),
          Perk('$_add $_one +0 BRITTLE $_card'),
          Perk(
              'At the start of each $_scenario, you may either gain WOUND to generate FIRE or gain CHILL to generate ICE'),
          Perk(
              '$_ignoreNegativeItemEffects and $_add $_one $_rolling FIRE/ICE $_card'),
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
            'Replace one +0 card with one $_rolling +1 "+2 instead if the attack has PIERCE" card',
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
          Perk('Replace one -2 card with one -1 AIR/LIGHT card'),
          Perk('Replace one -1 AIR/LIGHT card with one +1 AIR/LIGHT card'),
          Perk(
            'Replace one -1 card with one +0 WOUND card',
            quantity: 2,
          ),
          Perk(
            '$_replace one -1 card with one $_rolling "$_regenerate, RANGE 1" card',
            quantity: 2,
          ),
          Perk('Replace one +0 card with one +2 MUDDLE card'),
          Perk('Replace two +0 cards with one +1 $_immobilize card'),
          Perk(
            'Add one +1 "DODGE, Self" card',
            quantity: 2,
          ),
          Perk('Add one +2 AIR/LIGHT card'),
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
          Perk('Replace two -1 cards with one +0 MUDDLE card'),
          Perk('Replace two -1 cards with one -1 "HEAL 2, Self" card'),
          Perk('Replace one -2 card with one -1 POISON WOUND card'),
          Perk(
            '$_replace one +0 card with one +1 "HEAL 1, Self" card',
            quantity: 2,
          ),
          Perk(
              'Replace two +0 cards with one +0 CURSE card and one +0 $_immobilize card'),
          Perk(
            'Replace one +1 card with one +2 FIRE/AIR card',
            quantity: 2,
          ),
          Perk('Replace one +2 card with one $_rolling "Gain one RAGE" card'),
          Perk(
            'Add one +1 "$_retaliate 1, Self" card and one $_rolling PIERCE 3 card',
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

  static final List<PersonalGoal> personalGoals = [
    PersonalGoal(
      510,
      [
        SubGoal("Complete three 'Crypt' scenarios", 3),
        SubGoal("Complete 'Noxious Cellar' ($_scenario 52", 1),
      ],
      'Seeker of Xorn',
      ClassCodes.plagueherald,
    ),
  ];

  static final List<PlayerClass> playerClasses = [
    // GLOOMHAVEN
    PlayerClass(
        race: CharacterRaces.inox,
        name: 'Brute',
        classCode: ClassCodes.brute,
        icon: 'brute.svg',
        category: ClassCategory.gloomhaven,
        locked: false,
        primaryColor: 0xff4e7ec1,
        traits: [
          CharacterTraits.armored,
          CharacterTraits.intimidating,
          CharacterTraits.strong,
        ]),
    PlayerClass(
      race: CharacterRaces.quatryl,
      name: 'Tinkerer',
      classCode: ClassCodes.tinkerer,
      icon: 'tinkerer.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffc5b58d,
      traits: [
        CharacterTraits.educated,
        CharacterTraits.nimble,
        CharacterTraits.resourceful,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Spellweaver',
      classCode: ClassCodes.spellweaver,
      icon: 'spellweaver.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffb578b3,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.educated,
        CharacterTraits.resourceful,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.human,
      name: 'Scoundrel',
      classCode: ClassCodes.scoundrel,
      icon: 'scoundrel.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffa5d166,
      traits: [
        CharacterTraits.chaotic,
        CharacterTraits.nimble,
        CharacterTraits.resourceful,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.savvas,
      name: 'Cragheart',
      classCode: ClassCodes.cragheart,
      icon: 'cragheart.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xff899538,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.outcast,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.vermling,
      name: 'Mindthief',
      classCode: ClassCodes.mindthief,
      icon: 'mindthief.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xff647c9d,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.outcast,
        CharacterTraits.persuasive,
      ],
    ),
    PlayerClass(
        race: CharacterRaces.valrath,
        name: 'Sunkeeper',
        classCode: ClassCodes.sunkeeper,
        icon: 'sunkeeper.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xfff3c338,
        traits: [
          CharacterTraits.armored,
          CharacterTraits.nimble,
          CharacterTraits.persuasive,
        ]),
    PlayerClass(
        race: CharacterRaces.valrath,
        name: 'Quartermaster',
        classCode: ClassCodes.quartermaster,
        icon: 'quartermaster.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xffd98926,
        traits: [
          CharacterTraits.armored,
          CharacterTraits.resourceful,
          CharacterTraits.strong,
        ]),
    PlayerClass(
        race: CharacterRaces.aesther,
        name: 'Summoner',
        classCode: ClassCodes.summoner,
        icon: 'summoner.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xffeb6ea3,
        traits: [
          CharacterTraits.arcane,
          CharacterTraits.chaotic,
          CharacterTraits.resourceful,
        ]),
    PlayerClass(
        race: CharacterRaces.aesther,
        name: 'Nightshroud',
        classCode: ClassCodes.nightshroud,
        icon: 'nightshroud.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xff9f9fcf,
        traits: [
          CharacterTraits.chaotic,
          CharacterTraits.intimidating,
          CharacterTraits.nimble,
        ]),
    PlayerClass(
      race: CharacterRaces.harrower,
      name: 'Plagueherald',
      classCode: ClassCodes.plagueherald,
      icon: 'plagueherald.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xff74c7bb,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.intimidating,
        CharacterTraits.outcast,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.inox,
      name: 'Berserker',
      classCode: ClassCodes.berserker,
      icon: 'berserker.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xffd14e4e,
      traits: [
        CharacterTraits.chaotic,
        CharacterTraits.intimidating,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.quatryl,
      name: 'Soothsinger',
      classCode: ClassCodes.soothsinger,
      icon: 'soothsinger.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xffdf7e7a,
      traits: [
        CharacterTraits.educated,
        CharacterTraits.nimble,
        CharacterTraits.persuasive,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Doomstalker',
      classCode: ClassCodes.doomstalker,
      icon: 'doomstalker.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xff38c3f1,
      traits: [
        CharacterTraits.chaotic,
        CharacterTraits.intimidating,
        CharacterTraits.nimble,
      ],
    ),
    PlayerClass(
        race: CharacterRaces.human,
        name: 'Sawbones',
        classCode: ClassCodes.sawbones,
        icon: 'sawbones.svg',
        category: ClassCategory.gloomhaven,
        primaryColor: 0xffdfddcb,
        traits: [
          CharacterTraits.educated,
          CharacterTraits.persuasive,
          CharacterTraits.resourceful,
        ]),
    PlayerClass(
      race: CharacterRaces.savvas,
      name: 'Elementalist',
      classCode: ClassCodes.elementalist,
      icon: 'elementalist.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xff9e9d9d,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.educated,
        CharacterTraits.intimidating,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.vermling,
      name: 'Beast Tyrant',
      classCode: ClassCodes.beastTyrant,
      icon: 'beast_tyrant.svg',
      category: ClassCategory.gloomhaven,
      primaryColor: 0xffad745c,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.outcast,
        CharacterTraits.strong,
      ],
    ),
    // ENVELOPE X
    PlayerClass(
      race: CharacterRaces.harrower,
      name: 'Bladeswarm',
      classCode: ClassCodes.bladeswarm,
      icon: 'bladeswarm.svg',
      category: ClassCategory.gloomhaven,
      locked: false,
      primaryColor: 0xffae5a4d,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.intimidating,
        CharacterTraits.nimble,
      ],
    ),
    // FORGOTTEN CIRCLES
    PlayerClass(
        race: CharacterRaces.aesther,
        name: 'Diviner',
        classCode: ClassCodes.diviner,
        icon: 'diviner.svg',
        category: ClassCategory.gloomhaven,
        locked: false,
        primaryColor: 0xff8bc5d3,
        traits: [
          CharacterTraits.arcane,
          CharacterTraits.outcast,
          CharacterTraits.resourceful,
        ]),
    // JAWS OF THE LION
    PlayerClass(
      race: CharacterRaces.quatryl,
      name: 'Demolitionist',
      classCode: ClassCodes.demolitionist,
      icon: 'demolitionist.svg',
      category: ClassCategory.jawsOfTheLion,
      locked: false,
      primaryColor: 0xffe65c18,
      traits: [
        CharacterTraits.chaotic,
        CharacterTraits.nimble,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.inox,
      name: 'Hatchet',
      classCode: ClassCodes.hatchet,
      icon: 'hatchet.svg',
      category: ClassCategory.jawsOfTheLion,
      locked: false,
      primaryColor: 0xff78a1ad,
      traits: [
        CharacterTraits.intimidating,
        CharacterTraits.resourceful,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.valrath,
      name: 'Red Guard',
      classCode: ClassCodes.redGuard,
      icon: 'red_guard.svg',
      category: ClassCategory.jawsOfTheLion,
      locked: false,
      primaryColor: 0xffe3393b,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.outcast,
        CharacterTraits.persuasive,
      ],
    ),
    PlayerClass(
        race: CharacterRaces.human,
        name: 'Voidwarden',
        classCode: ClassCodes.voidwarden,
        icon: 'voidwarden.svg',
        category: ClassCategory.jawsOfTheLion,
        locked: false,
        primaryColor: 0xffd9d9d9,
        traits: [
          CharacterTraits.arcane,
          CharacterTraits.educated,
          CharacterTraits.outcast,
        ]),
    // FROSTHAVEN
    PlayerClass(
      race: CharacterRaces.inox,
      name: 'Drifter',
      classCode: ClassCodes.drifter,
      icon: 'drifter.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xff92887f,
      traits: [
        CharacterTraits.outcast,
        CharacterTraits.resourceful,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.quatryl,
      name: 'Blink Blade',
      classCode: ClassCodes.blinkBlade,
      icon: 'blink_blade.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xff00a8cf,
      traits: [
        CharacterTraits.educated,
        CharacterTraits.nimble,
        CharacterTraits.resourceful,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.human,
      name: 'Banner Spear',
      classCode: ClassCodes.bannerSpear,
      icon: 'banner_spear.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xfffdd072,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.persuasive,
        CharacterTraits.resourceful,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.valrath,
      name: 'Deathwalker',
      classCode: ClassCodes.deathwalker,
      icon: 'deathwalker.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xffacc8ed,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.outcast,
        CharacterTraits.persuasive,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.aesther,
      name: 'Boneshaper',
      classCode: ClassCodes.boneshaper,
      icon: 'boneshaper.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xff6cbe4c,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.educated,
        CharacterTraits.intimidating,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.harrower,
      name: 'Geminate',
      classCode: ClassCodes.geminate,
      icon: 'geminate.svg',
      category: ClassCategory.frosthaven,
      locked: false,
      primaryColor: 0xffab1c54,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.chaotic,
        CharacterTraits.nimble,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Infuser',
      classCode: ClassCodes.infuser,
      icon: 'infuser.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff7bc144,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.educated,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.savvas,
      name: 'Pyroclast',
      classCode: ClassCodes.pyroclast,
      icon: 'pyroclast.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffff4a1d,
      traits: [
        CharacterTraits.arcane,
        CharacterTraits.chaotic,
        CharacterTraits.intimidating,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.savvas,
      name: 'Shattersong',
      classCode: ClassCodes.shattersong,
      icon: 'shattersong.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffc2c5c9,
      traits: [
        CharacterTraits.educated,
        CharacterTraits.outcast,
        CharacterTraits.persuasive,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.vermling,
      name: 'Trapper',
      classCode: ClassCodes.trapper,
      icon: 'trapper.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffd1b38d,
      traits: [
        CharacterTraits.nimble,
        CharacterTraits.outcast,
        CharacterTraits.resourceful,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.aesther,
      name: 'Pain Conduit',
      classCode: ClassCodes.painConduit,
      icon: 'pain_conduit.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffbec5e4,
      traits: [
        CharacterTraits.chaotic,
        CharacterTraits.intimidating,
        CharacterTraits.outcast,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.algox,
      name: 'Snowdancer',
      classCode: ClassCodes.snowdancer,
      icon: 'snowdancer.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff7cd1e7,
      traits: [
        CharacterTraits.chaotic,
        CharacterTraits.nimble,
        CharacterTraits.persuasive,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.algox,
      name: 'Frozen Fist',
      classCode: ClassCodes.frozenFist,
      icon: 'frozen_fist.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff88bee7,
      traits: [
        CharacterTraits.intimidating,
        CharacterTraits.persuasive,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.unfettered,
      name: 'HIVE',
      classCode: ClassCodes.hive,
      icon: 'hive.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffecb633,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.educated,
        CharacterTraits.resourceful,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.unfettered,
      name: 'Metal Mosaic',
      classCode: ClassCodes.metalMosaic,
      icon: 'metal_mosaic.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffddb586,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.resourceful,
        CharacterTraits.strong,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.lurker,
      name: 'Deepwraith',
      classCode: ClassCodes.deepwraith,
      icon: 'deepwraith.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xffac427d,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.intimidating,
        CharacterTraits.nimble,
      ],
    ),
    PlayerClass(
      race: CharacterRaces.lurker,
      name: 'Crashing Tide',
      classCode: ClassCodes.crashingTide,
      icon: 'crashing_tide.svg',
      category: ClassCategory.frosthaven,
      locked: true,
      primaryColor: 0xff59c0a1,
      traits: [
        CharacterTraits.armored,
        CharacterTraits.chaotic,
        CharacterTraits.strong,
      ],
    ),
    // CRIMSON SCALES
    PlayerClass(
      race: CharacterRaces.harrower,
      name: 'Amber Aegis',
      classCode: ClassCodes.amberAegis,
      icon: 'amber_aegis.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffeb880d,
      secondaryColor: 0xfffff600,
    ),
    PlayerClass(
      race: CharacterRaces.quatryl,
      name: 'Artificer',
      classCode: ClassCodes.artificer,
      icon: 'artificer.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff477ca6,
      secondaryColor: 0xff8ccee5,
    ),
    PlayerClass(
      race: CharacterRaces.quatryl,
      name: 'Bombard',
      classCode: ClassCodes.bombard,
      icon: 'bombard.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff948572,
      secondaryColor: 0xff8c683b,
    ),
    PlayerClass(
      race: CharacterRaces.human,
      name: 'Brightspark',
      classCode: ClassCodes.brightspark,
      icon: 'brightspark.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffcaad2e,
      secondaryColor: 0xffc49a3d,
    ),
    PlayerClass(
      race: CharacterRaces.inox,
      name: 'Chainguard',
      classCode: ClassCodes.chainguard,
      icon: 'chainguard.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffce6d30,
      secondaryColor: 0xff1e1d1d,
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Chieftain',
      classCode: ClassCodes.chieftain,
      icon: 'chieftain.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff76c6c3,
      secondaryColor: 0xff5e7574,
    ),
    PlayerClass(
      race: CharacterRaces.valrath,
      name: 'Fire Knight',
      classCode: ClassCodes.fireKnight,
      icon: 'fire_knight.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffd52229,
      secondaryColor: 0xfff25424,
    ),
    PlayerClass(
      race: CharacterRaces.human,
      name: 'Hierophant',
      classCode: ClassCodes.hierophant,
      icon: 'hierophant.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffddde8a,
      secondaryColor: 0xffa9a5ad,
    ),
    PlayerClass(
      race: CharacterRaces.savvas,
      name: 'Hollowpact',
      classCode: ClassCodes.hollowpact,
      icon: 'hollowpact.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffa765a9,
      secondaryColor: 0xff310f33,
    ),
    PlayerClass(
      race: CharacterRaces.inox,
      name: 'Incarnate',
      classCode: ClassCodes.incarnate,
      icon: 'incarnate.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffc63072,
      secondaryColor: 0xff70d686,
      // traits: [
      //   CharacterTraits.strong,
      //   CharacterTraits.arcane,
      //   CharacterTraits.persuasive,
      // ],
    ),
    PlayerClass(
      race: CharacterRaces.lurker,
      name: 'Luminary',
      classCode: ClassCodes.luminary,
      icon: 'luminary.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffb28abf,
      secondaryColor: 0xffa43287,
    ),
    PlayerClass(
      race: CharacterRaces.quatryl,
      name: 'Mirefoot',
      classCode: ClassCodes.mirefoot,
      icon: 'mirefoot.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffef6b26,
      secondaryColor: 0xff4b732e,
    ),
    PlayerClass(
      race: CharacterRaces.savvas,
      name: 'Rimehearth',
      classCode: ClassCodes.rimehearth,
      icon: 'rimehearth.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff61d4e8,
      secondaryColor: 0xffd62d2a,
    ),
    PlayerClass(
      race: CharacterRaces.vermling,
      name: 'Ruinmaw',
      classCode: ClassCodes.ruinmaw,
      icon: 'ruinmaw.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffdb332d,
      secondaryColor: 0xffdb332d,
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Shardrender',
      classCode: ClassCodes.shardrender,
      icon: 'shardrender.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xffffd04f,
      secondaryColor: 0xffffaa23,
    ),
    PlayerClass(
      race: CharacterRaces.vermling,
      name: 'Spirit Caller',
      classCode: ClassCodes.spiritCaller,
      icon: 'spirit_caller.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff63bd57,
      secondaryColor: 0xffa6ce39,
    ),
    PlayerClass(
      race: CharacterRaces.aesther,
      name: 'Starslinger',
      classCode: ClassCodes.starslinger,
      icon: 'starslinger.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff4f57a6,
      secondaryColor: 0xffa3aacc,
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Tempest',
      classCode: ClassCodes.tempest,
      icon: 'tempest.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xff66c9fc,
      secondaryColor: 0xff109de0,
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Thornreaper',
      classCode: ClassCodes.thornreaper,
      icon: 'thornreaper.svg',
      category: ClassCategory.crimsonScales,
      primaryColor: 0xfffbff96,
      secondaryColor: 0xff80995a,
    ),
    PlayerClass(
      race: CharacterRaces.valrath,
      name: 'Vanquisher',
      classCode: ClassCodes.vanquisher,
      icon: 'vanquisher.svg',
      category: ClassCategory.crimsonScales,
      locked: false,
      primaryColor: 0xffd3423e,
      secondaryColor: 0xffbdbdbd,
    ),
    //CUSTOM
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Brewmaster',
      classCode: ClassCodes.brewmaster,
      icon: 'brewmaster.svg',
      category: ClassCategory.custom,
      primaryColor: 0xffe2c22b,
    ),
    PlayerClass(
      race: CharacterRaces.orchid,
      name: 'Frostborn',
      classCode: ClassCodes.frostborn,
      icon: 'frostborn.svg',
      category: ClassCategory.custom,
      primaryColor: 0xffb0e0ea,
    ),
    // This class is still in beta. Its perks are in version 3.7.0
    // TODO: when bringing it back, show it in Search Delegate
    PlayerClass(
      race: CharacterRaces.human,
      name: 'Rootwhisperer',
      classCode: ClassCodes.rootwhisperer,
      icon: 'rootwhisperer.svg',
      category: ClassCategory.custom,
      primaryColor: 0xff7bd071,
    ),
    PlayerClass(
      race: CharacterRaces.harrower,
      name: 'Vimthreader',
      classCode: ClassCodes.vimthreader,
      icon: 'vimthreader.svg',
      category: ClassCategory.custom,
      primaryColor: 0xffc26969,
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
  static const _atTheStartOfEachScenario = 'At the start of each scenario';
  static const _card = 'card';
  static const _cards = 'cards';
  static const _effects = 'effects';
  static const _four = 'four';
  static const _ignoreItemMinusOneEffects =
      'Ignore item item_minus_one effects';
  static const _ignoreNegativeItemEffects = 'Ignore negative item effects';
  static const _ignoreScenarioEffects = 'Ignore scenario effects';
  static const _immobilize = 'IMMOBILIZE';

  static const _negative = 'negative';
  static const _one = 'one';
  static const _regenerate = 'REGENERATE';
  static const _remove = 'Remove';
  static const _removeL = 'remove';
  static const _replace = 'Replace';
  static const _retaliate = 'RETALIATE';
  static const _rolling = 'Rolling';
  static const _scenario = 'scenario';
  static const _shield = 'SHIELD';
  static const _three = 'three';
  static const _two = 'two';
  static const _wheneverYouLongRest = 'Whenever you long rest';
  static const _wheneverYouShortRest = 'Whenever you short rest';

  static PlayerClass playerClassByClassCode(String classCode) {
    return playerClasses.firstWhere(
      (playerClass) => playerClass.classCode == classCode,
    );
  }

  static int xpByLevel(int level) => LevelConstants.levelXp.entries
      .lastWhere((entry) => entry.key == level)
      .value;

  static int nextXpByLevel(int level) => LevelConstants.levelXp.entries
      .firstWhere(
        (entry) => entry.key > level,
        orElse: () => LevelConstants.levelXp.entries.last,
      )
      .value;

  static int levelByXp(int xp) => LevelConstants.levelXp.entries
      .lastWhere(
        (entry) => entry.value <= xp,
      )
      .key;
}
