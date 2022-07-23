import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/models/character_mastery.dart';
import 'package:gloomhaven_enhancement_calc/models/mastery.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/masteries_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/resource_card.dart';
import '../../data/constants.dart';
import '../../data/strings.dart';
import '../dialogs/add_subtract_dialog.dart';
import '../widgets/perks_section.dart';
import '../../viewmodels/character_model.dart';
import '../dialogs/info_dialog.dart';
import '../../viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: smallPadding),
        child: Column(
          children: <Widget>[
            // RETIREMENTS and POCKET ITEMS
            const RetirementsAndPocketItemsSection(),
            // NAME and CLASS
            const Padding(
              padding: EdgeInsets.all(smallPadding),
              child: NameAndClassSection(),
            ),
            // STATS
            const Padding(
              padding: EdgeInsets.all(smallPadding),
              child: StatsSection(),
            ),
            // RESOURCES
            const ResourcesSection(),
            // NOTES
            context.read<CharacterModel>().character.notes.isEmpty &&
                    !context.read<CharactersModel>().isEditMode
                ? Container()
                : const Padding(
                    padding: EdgeInsets.all(smallPadding),
                    child: NotesSection(),
                  ),
            // BATTLE GOAL CHECKMARKS
            const BattleGoalCheckmarksSection(),

            // PERKS
            Padding(
              padding: const EdgeInsets.all(smallPadding),
              child: PerksSection(
                characterModel: context.watch<CharacterModel>(),
              ),
            ),
            MasteriesSection(
              characterModel: context.watch<CharacterModel>(),
            ),
            Container(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

class RetirementsAndPocketItemsSection extends StatelessWidget {
  const RetirementsAndPocketItemsSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.read<CharacterModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: context.watch<CharactersModel>().isEditMode
                  ? TextField(
                      enableInteractiveSelection: false,
                      onChanged: (String value) =>
                          characterModel.updateCharacter(
                        characterModel.character
                          ..previousRetirements =
                              value.isEmpty ? 0 : int.parse(value),
                      ),
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.center,
                      controller: characterModel.previousRetirementsController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp('[\\.|\\,|\\ |\\-]'))
                      ],
                      keyboardType: TextInputType.number,
                    )
                  : Text(
                      'Retirements: ${characterModel.character.previousRetirements}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
            ),
            IconButton(
              icon: const Icon(
                Icons.info_outline,
              ),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) {
                  return InfoDialog(
                    title: Strings.previousRetirementsInfoTitle,
                    message: Strings.previousRetirementsInfoBody(context),
                  );
                },
              ),
            ),
          ],
        ),
        Tooltip(
          message:
              '${characterModel.numOfPocketItems} Pocket Item${characterModel.numOfPocketItems > 1 ? 's' : ''} Allowed',
          child: Padding(
            padding: const EdgeInsets.only(
              right: smallPadding,
              top: smallPadding,
            ),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                SvgPicture.asset(
                  'images/equipment_slots/pocket.svg',
                  width: iconSize,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.5),
                  child: Text(
                    context.watch<CharacterModel>().numOfPocketItems.toString(),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
                const SizedBox(
                  width: smallPadding,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NameAndClassSection extends StatelessWidget {
  const NameAndClassSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.read<CharacterModel>();
    return Column(
      children: <Widget>[
        context.watch<CharactersModel>().isEditMode
            ? TextField(
                autocorrect: false,
                onChanged: (String value) {
                  characterModel.updateCharacter(
                    characterModel.character..name = value,
                  );
                },
                minLines: 1,
                maxLines: 2,
                controller: characterModel.nameController,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
              )
            : AutoSizeText(
                characterModel.character.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: const Alignment(0, 0.75),
              children: <Widget>[
                SvgPicture.asset(
                  'images/level.svg',
                  width: iconSize * 1.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                Text(
                  '${context.watch<CharacterModel>().currentLevel}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black87
                        : Colors.white,
                    fontSize: titleFontSize - 5,
                    fontFamily: pirataOne,
                  ),
                )
              ],
            ),
            const SizedBox(
              width: smallPadding,
            ),
            Flexible(
              child: AutoSizeText(
                '${characterModel.character.playerClass.race} ${characterModel.character.playerClass.className}',
                maxLines: 1,
                style: const TextStyle(fontSize: titleFontSize),
              ),
            ),
          ],
        ),
        if (characterModel.character.isRetired)
          const Text(
            '(retired)',
            style: TextStyle(fontSize: 20),
          ),
      ],
    );
  }
}

class StatsSection extends StatelessWidget {
  const StatsSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.read<CharacterModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Tooltip(
          message: 'XP',
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'images/xp.svg',
                width: iconSize + 5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              const SizedBox(
                width: smallPadding,
              ),
              context.watch<CharactersModel>().isEditMode
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: TextField(
                            enableInteractiveSelection: false,
                            onChanged: (String value) {
                              characterModel.updateCharacter(
                                characterModel.character
                                  ..xp = value == '' ? 0 : int.parse(value),
                              );
                            },
                            textAlignVertical: TextAlignVertical.center,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                            controller: characterModel.xpController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\.|\\,|\\ |\\-]'))
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.exposure),
                          onPressed: () async => await showDialog<int>(
                              context: context,
                              builder: (_) => AddSubtractDialog(
                                    characterModel.character.xp,
                                    'XP',
                                  )).then(
                            (value) {
                              if (value != null) {
                                characterModel.xpController.text =
                                    value.toString();
                                characterModel.updateCharacter(
                                  characterModel.character..xp = value,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : Text(
                      characterModel.character.xp.toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
              Text(
                ' / ${context.watch<CharacterModel>().nextLevelXp}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize:
                        Theme.of(context).textTheme.bodyText2.fontSize / 2),
              ),
            ],
          ),
        ),
        Tooltip(
          message: 'Gold',
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'images/gold.svg',
                width: iconSize + 5,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              const SizedBox(
                width: 5,
              ),
              context.watch<CharactersModel>().isEditMode
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: TextField(
                            enableInteractiveSelection: false,
                            onChanged: (String value) =>
                                characterModel.updateCharacter(
                              characterModel.character
                                ..gold = value == '' ? 0 : int.parse(value),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                            controller: characterModel.goldController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\.|\\,|\\ |\\-]'))
                            ],
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.exposure),
                          onPressed: () async => await showDialog<int>(
                              context: context,
                              builder: (_) => AddSubtractDialog(
                                    characterModel.character.gold,
                                    'Gold',
                                  )).then(
                            (value) {
                              if (value != null) {
                                characterModel.goldController.text =
                                    value.toString();
                                characterModel.updateCharacter(
                                  characterModel.character..gold = value,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  : Text(
                      ' ${characterModel.character.gold}',
                      style: Theme.of(context).textTheme.bodyText2,
                    )
            ],
          ),
        ),
        Tooltip(
          message: 'Battle Goal Checkmarks',
          child: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  'images/goal.svg',
                  width: iconSize,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 5,
                  child: Text(
                    characterModel.checkMarkProgress.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  '/3',
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ResourcesSection extends StatefulWidget {
  const ResourcesSection({
    Key key,
  }) : super(key: key);

  @override
  State<ResourcesSection> createState() => _ResourcesSectionState();
}

class _ResourcesSectionState extends State<ResourcesSection> {
  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white54
              : Colors.black54,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          maintainState: true,
          onExpansionChanged: (value) =>
              SharedPrefs().resourcesExpanded = value,
          initiallyExpanded: SharedPrefs().resourcesExpanded,
          title: const Text(
            'Resources',
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                bottom: smallPadding,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  runSpacing: smallPadding,
                  spacing: smallPadding,
                  alignment: WrapAlignment.spaceEvenly,
                  children: <ResourceCard>[
                    // ...CharacterData.resources.map(
                    //   ((resource) => ResourceCard(
                    //         resource: resource,
                    //         count: characterModel.character.resourceHide,
                    //         increaseCount: () => characterModel.updateCharacter(
                    //           characterModel.character
                    //             ..resourceHide =
                    //                 characterModel.character.resourceHide + 1,
                    //         ),
                    //         decreaseCount: () => characterModel.updateCharacter(
                    //           characterModel.character
                    //             ..resourceHide =
                    //                 characterModel.character.resourceHide - 1,
                    //         ),
                    //       )),
                    // )
                    ResourceCard(
                      resource: CharacterData.resources[0],
                      count: characterModel.character.resourceHide,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceHide =
                              characterModel.character.resourceHide + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceHide =
                              characterModel.character.resourceHide - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[1],
                      count: characterModel.character.resourceMetal,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceMetal =
                              characterModel.character.resourceMetal + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceMetal =
                              characterModel.character.resourceMetal - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[2],
                      count: characterModel.character.resourceLumber,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceLumber =
                              characterModel.character.resourceLumber + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceLumber =
                              characterModel.character.resourceLumber - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[3],
                      count: characterModel.character.resourceArrowVine,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceArrowVine =
                              characterModel.character.resourceArrowVine + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceArrowVine =
                              characterModel.character.resourceArrowVine - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[4],
                      count: characterModel.character.resourceAxeNut,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceAxeNut =
                              characterModel.character.resourceAxeNut + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceAxeNut =
                              characterModel.character.resourceAxeNut - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[5],
                      count: characterModel.character.resourceRockRoot,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceRockRoot =
                              characterModel.character.resourceRockRoot + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceRockRoot =
                              characterModel.character.resourceRockRoot - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[6],
                      count: characterModel.character.resourceFlameFruit,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceFlameFruit =
                              characterModel.character.resourceFlameFruit + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceFlameFruit =
                              characterModel.character.resourceFlameFruit - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[7],
                      count: characterModel.character.resourceCorpseCap,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceCorpseCap =
                              characterModel.character.resourceCorpseCap + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceCorpseCap =
                              characterModel.character.resourceCorpseCap - 1,
                      ),
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[8],
                      count: characterModel.character.resourceSnowThistle,
                      increaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceSnowThistle =
                              characterModel.character.resourceSnowThistle + 1,
                      ),
                      decreaseCount: () => characterModel.updateCharacter(
                        characterModel.character
                          ..resourceSnowThistle =
                              characterModel.character.resourceSnowThistle - 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesSection extends StatelessWidget {
  const NotesSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.read<CharacterModel>();
    CharactersModel charactersModel = context.watch<CharactersModel>();
    return Column(
      children: <Widget>[
        Text(
          'Notes',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: smallPadding,
        ),
        charactersModel.isEditMode
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (String value) {
                    characterModel.updateCharacter(
                        characterModel.character..notes = value);
                  },
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Notes',
                  ),
                  controller: characterModel.notesController,
                ),
              )
            : Text(
                characterModel.character.notes,
              ),
      ],
    );
  }
}

class BattleGoalCheckmarksSection extends StatelessWidget {
  const BattleGoalCheckmarksSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharacterModel characterModel = context.watch<CharacterModel>();
    return context.watch<CharactersModel>().isEditMode
        ? Padding(
            padding: const EdgeInsets.all(smallPadding),
            child: Column(
              children: <Widget>[
                const AutoSizeText(
                  'Battle Goal Checkmarks',
                  textAlign: TextAlign.center,
                  minFontSize: titleFontSize,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: characterModel.character.checkMarks > 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.secondary,
                        iconSize:
                            Theme.of(context).textTheme.bodyText2.fontSize,
                        icon: const Icon(
                          Icons.remove_circle,
                        ),
                        onPressed: characterModel.decreaseCheckmark,
                      ),
                    ),
                    Text(
                      '${characterModel.character.checkMarks} / 18',
                      style: const TextStyle(fontSize: titleFontSize),
                    ),
                    Visibility(
                      visible: characterModel.character.checkMarks < 18,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.secondary,
                        iconSize:
                            Theme.of(context).textTheme.bodyText2.fontSize,
                        icon: const Icon(
                          Icons.add_circle,
                        ),
                        onPressed: characterModel.increaseCheckmark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }
}
