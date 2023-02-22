import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
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
  }) : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: context.read<CharactersModel>().charScreenScrollController,
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
              child: StatsSection(
                  // isEditMode: isEditMode,
                  ),
            ),
            // RESOURCES
            // const ResourcesSection(),
            // NOTES
            // context.read<CharacterModel>().character.notes.isEmpty &&
            //         !context.read<CharactersModel>().isEditMode
            //     ? Container()
            // :
            const Padding(
              padding: EdgeInsets.all(smallPadding),
              child: NotesSection(),
            ),
            // BATTLE GOAL CHECKMARKS
            const BattleGoalCheckmarksSection(),

            // PERKS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              child: PerksSection(
                characterModel: context.watch<CharacterModel>(),
              ),
            ),
            const SizedBox(
              height: smallPadding,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding - 3),
              child: MasteriesSection(
                characterModel: context.watch<CharacterModel>(),
              ),
            ),
            Container(
              height: MediaQuery.of(context).padding.bottom + 72,
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
                      style: Theme.of(context).textTheme.titleSmall,
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
                      style: Theme.of(context).textTheme.titleSmall,
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
                  child: Consumer<CharacterModel>(
                    builder: (
                      _,
                      characterModel,
                      __,
                    ) =>
                        Text(
                      characterModel.numOfPocketItems.toString(),
                      style: Theme.of(context).textTheme.bodyMedium.copyWith(
                            fontSize: 15,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                          ),
                    ),
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
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
              )
            : AutoSizeText(
                characterModel.character.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.displaySmall,
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
                Consumer<CharacterModel>(
                  builder: (
                    _,
                    characterModel,
                    __,
                  ) =>
                      Text(
                    characterModel.currentLevel.toString(),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black87
                          : Colors.white,
                      fontSize: titleFontSize - 7,
                      fontFamily: pirataOne,
                    ),
                  ),
                ),
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
                            style: Theme.of(context).textTheme.bodyMedium,
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
                          onPressed: () => showDialog<int>(
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              Consumer<CharacterModel>(
                builder: (
                  _,
                  characterModel,
                  __,
                ) =>
                    Text(
                  ' / ${characterModel.nextLevelXp}',
                  style: Theme.of(context).textTheme.bodyMedium.copyWith(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium.fontSize / 2),
                ),
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
                            style: Theme.of(context).textTheme.bodyMedium,
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
            ],
          ),
        ),
        Tooltip(
          message: 'Battle Goal Checkmarks',
          child: SizedBox(
            width: 90,
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
                SizedBox(
                  width: 5,
                  child: Text(
                    characterModel.checkMarkProgress.toString(),
                  ),
                ),
                Text(
                  '/3',
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      .copyWith(letterSpacing: 4),
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
          // maintainState: true,
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
                    // TODO: uncomment this when including Resources
                    // ResourceCard(
                    //   resource: CharacterData.resources[0],
                    //   count: characterModel.character.resourceHide,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceHide =
                    //           characterModel.character.resourceHide + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceHide =
                    //           characterModel.character.resourceHide - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[1],
                    //   count: characterModel.character.resourceMetal,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceMetal =
                    //           characterModel.character.resourceMetal + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceMetal =
                    //           characterModel.character.resourceMetal - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[2],
                    //   count: characterModel.character.resourceLumber,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceLumber =
                    //           characterModel.character.resourceLumber + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceLumber =
                    //           characterModel.character.resourceLumber - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[3],
                    //   count: characterModel.character.resourceArrowvine,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceArrowvine =
                    //           characterModel.character.resourceArrowvine + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceArrowvine =
                    //           characterModel.character.resourceArrowvine - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[4],
                    //   count: characterModel.character.resourceAxenut,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceAxenut =
                    //           characterModel.character.resourceAxenut + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceAxenut =
                    //           characterModel.character.resourceAxenut - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[5],
                    //   count: characterModel.character.resourceRockroot,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceRockroot =
                    //           characterModel.character.resourceRockroot + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceRockroot =
                    //           characterModel.character.resourceRockroot - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[6],
                    //   count: characterModel.character.resourceFlamefruit,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceFlamefruit =
                    //           characterModel.character.resourceFlamefruit + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceFlamefruit =
                    //           characterModel.character.resourceFlamefruit - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[7],
                    //   count: characterModel.character.resourceCorpsecap,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceCorpsecap =
                    //           characterModel.character.resourceCorpsecap + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceCorpsecap =
                    //           characterModel.character.resourceCorpsecap - 1,
                    //   ),
                    // ),
                    // ResourceCard(
                    //   resource: CharacterData.resources[8],
                    //   count: characterModel.character.resourceSnowthistle,
                    //   increaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceSnowthistle =
                    //           characterModel.character.resourceSnowthistle + 1,
                    //   ),
                    //   decreaseCount: () => characterModel.updateCharacter(
                    //     characterModel.character
                    //       ..resourceSnowthistle =
                    //           characterModel.character.resourceSnowthistle - 1,
                    //   ),
                    // ),
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
    return Column(
      children: <Widget>[
        Text(
          'Notes',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: smallPadding,
        ),
        context.watch<CharactersModel>().isEditMode
            ? TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (String value) {
                  characterModel.updateCharacter(
                    characterModel.character..notes = value,
                  );
                },
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Notes',
                ),
                controller: characterModel.notesController,
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
                        color: Theme.of(context).colorScheme.primary,
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
                        color: Theme.of(context).colorScheme.primary,
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
