import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/add_subtract_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/masteries_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/perks_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/resource_card.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({
    required this.character,
    Key? key,
  }) : super(
          key: key,
        );
  final Character character;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: context.read<CharactersModel>().charScreenScrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: smallPadding,
        ),
        child: Column(
          children: <Widget>[
            // RETIREMENTS and POCKET ITEMS
            Padding(
              padding: const EdgeInsets.all(
                smallPadding,
              ),
              child: _RetirementsAndPocketItemsSection(
                character: character,
              ),
            ),
            // NAME and CLASS
            Container(
              constraints: const BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.all(
                  smallPadding,
                ),
                child: _NameAndClassSection(
                  character: character,
                ),
              ),
            ),
            // STATS
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(
                  smallPadding,
                ),
                child: _StatsSection(
                  character: character,
                ),
              ),
            ),
            // RESOURCES
            Padding(
              padding: const EdgeInsets.all(
                smallPadding,
              ),
              child: _ResourcesSection(
                character: character,
              ),
            ),
            // NOTES
            Container(
              constraints: const BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.all(
                  smallPadding,
                ),
                child: character.notes.isNotEmpty ||
                        context.read<CharactersModel>().isEditMode
                    ? _NotesSection(
                        character: character,
                      )
                    : const SizedBox(),
              ),
            ),
            // BATTLE GOAL CHECKMARKS
            if (context.read<CharactersModel>().isEditMode &&
                !character.isRetired)
              _BattleGoalCheckmarksSection(
                character: character,
              ),
            // PERKS
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: smallPadding,
              ),
              child: PerksSection(
                character: character,
              ),
            ),
            const SizedBox(
              height: smallPadding,
            ),
            // MASTERIES
            if (character.characterMasteries.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: smallPadding - 3,
                ),
                child: MasteriesSection(
                  character: character,
                  charactersModel: context.watch<CharactersModel>(),
                ),
              ),
            // PADDING FOR FAB
            const SizedBox(
              height: 82,
            ),
          ],
        ),
      ),
    );
  }
}

class _RetirementsAndPocketItemsSection extends StatelessWidget {
  const _RetirementsAndPocketItemsSection({
    required this.character,
    Key? key,
  }) : super(key: key);
  final Character character;
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 190),
              child: TextField(
                textAlign: context.watch<CharactersModel>().isEditMode &&
                        !character.isRetired
                    ? TextAlign.center
                    : TextAlign.start,
                enableInteractiveSelection: false,
                onChanged: (String value) => charactersModel.updateCharacter(
                  character
                    ..previousRetirements =
                        value.isEmpty ? 0 : int.parse(value),
                ),
                enabled: context.watch<CharactersModel>().isEditMode &&
                    !character.isRetired,
                decoration: InputDecoration(
                  labelText: 'Previous Retirements',
                  border: context.watch<CharactersModel>().isEditMode &&
                          !character.isRetired
                      ? null
                      : InputBorder.none,
                ),
                controller: charactersModel.previousRetirementsController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp('[\\.|\\,|\\ |\\-]'))
                ],
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        Tooltip(
          message:
              '${(Character.level(character.xp) / 2).round()} Pocket Item${(Character.level(character.xp) / 2).round() > 1 ? 's' : ''} Allowed',
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
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onBackground,
                    BlendMode.srcIn,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.5),
                  child: Consumer<CharactersModel>(
                    builder: (
                      _,
                      charactersModel,
                      __,
                    ) =>
                        Text(
                      '${(Character.level(character.xp) / 2).round()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.background,
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

class _NameAndClassSection extends StatelessWidget {
  const _NameAndClassSection({
    required this.character,
    Key? key,
  }) : super(key: key);
  final Character character;
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
    return Column(
      children: <Widget>[
        context.watch<CharactersModel>().isEditMode && !character.isRetired
            ? TextField(
                autocorrect: false,
                onChanged: (String value) {
                  charactersModel.updateCharacter(
                    character..name = value,
                  );
                },
                minLines: 1,
                maxLines: 2,
                controller: charactersModel.nameController,
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
              )
            : AutoSizeText(
                character.name,
                maxLines: 2,
                style: Theme.of(context).textTheme.displayMedium,
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
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onBackground,
                    BlendMode.srcIn,
                  ),
                ),
                Consumer<CharactersModel>(
                  builder: (
                    _,
                    charactersModel,
                    __,
                  ) =>
                      Text(
                    '${Character.level(character.xp)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: titleFontSize - 7,
                          color: Theme.of(context).colorScheme.background,
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
                '${character.playerClass.race} ${character.playerClass.name}',
                maxLines: 1,
                style: const TextStyle(fontSize: titleFontSize),
              ),
            ),
          ],
        ),
        if (character.playerClass.traits.isNotEmpty) ...[
          const SizedBox(
            height: smallPadding,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Chip(
          //       label: Text(
          //         character.playerClass.traits[0],
          //       ),

          //     ),
          //     Chip(
          //       label: Text(
          //         character.playerClass.traits[1],
          //       ),
          //     ),
          //     Chip(
          //       label: Text(
          //         character.playerClass.traits[2],
          //       ),
          //     ),
          //   ],
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/trait.svg',
                width: iconSize,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onBackground,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: smallPadding,
              ),
              Flexible(
                child: AutoSizeText(
                  '${character.playerClass.traits[0]} · ${character.playerClass.traits[1]} · ${character.playerClass.traits[2]}',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
        if (character.isRetired)
          const Text(
            '(retired)',
            style: TextStyle(fontSize: 20),
          ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({
    required this.character,
    Key? key,
  }) : super(key: key);
  final Character character;
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
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
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onBackground,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: smallPadding,
              ),
              context.watch<CharactersModel>().isEditMode &&
                      !character.isRetired
                  ? Container(
                      constraints: const BoxConstraints(
                        maxWidth: 75,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            enableInteractiveSelection: false,
                            onChanged: (String value) {
                              charactersModel.updateCharacter(
                                character
                                  ..xp = value == '' ? 0 : int.parse(value),
                              );
                            },
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: charactersModel.xpController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\.|\\,|\\ |\\-]'))
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          IconButton(
                            icon: const Icon(Icons.exposure),
                            onPressed: () async {
                              int? value = await showDialog<int?>(
                                context: context,
                                builder: (_) => AddSubtractDialog(
                                  character.xp,
                                  'XP',
                                ),
                              );
                              if (value != null) {
                                if (value < 1) {
                                  charactersModel.updateCharacter(
                                    character..xp = 0,
                                  );
                                  charactersModel.xpController.clear();
                                } else {
                                  charactersModel.updateCharacter(
                                    character..xp = value,
                                  );
                                  charactersModel.xpController.text = '$value';
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : Text(
                      character.xp.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
              Consumer<CharactersModel>(
                builder: (
                  _,
                  charactersModel,
                  __,
                ) =>
                    Text(
                  ' / ${Character.xpForNextLevel(Character.level(character.xp))}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.fontSize !=
                                null
                            ? Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize! /
                                2
                            : Theme.of(context).textTheme.bodyMedium?.fontSize,
                      ),
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
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onBackground,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              context.watch<CharactersModel>().isEditMode &&
                      !character.isRetired
                  ? Container(
                      constraints: const BoxConstraints(
                        maxWidth: 75,
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            enableInteractiveSelection: false,
                            onChanged: (String value) =>
                                charactersModel.updateCharacter(
                              character
                                ..gold = value == '' ? 0 : int.parse(value),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.center,
                            controller: charactersModel.goldController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\.|\\,|\\ |\\-]'))
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          IconButton(
                            icon: const Icon(Icons.exposure),
                            onPressed: () async {
                              int? value = await showDialog<int?>(
                                context: context,
                                builder: (_) => AddSubtractDialog(
                                  character.gold,
                                  'Gold',
                                ),
                              );
                              if (value != null) {
                                charactersModel.updateCharacter(
                                  character..gold = value,
                                );
                                if (value == 0) {
                                  charactersModel.goldController.clear();
                                } else {
                                  charactersModel.goldController.text =
                                      '$value';
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : Text(
                      ' ${character.gold}',
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
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onBackground,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(
                  width: 5,
                  child: Text(
                    character.checkMarkProgress().toString(),
                  ),
                ),
                Text(
                  '/3',
                  softWrap: false,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(letterSpacing: 4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResourcesSection extends StatefulWidget {
  const _ResourcesSection({
    required this.character,
    Key? key,
  }) : super(key: key);
  final Character character;
  @override
  State<_ResourcesSection> createState() => _ResourcesSectionState();
}

class _ResourcesSectionState extends State<_ResourcesSection> {
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.onBackground,
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
                // width: MediaQuery.of(context).size.width,
                child: Wrap(
                  runSpacing: smallPadding,
                  spacing: smallPadding,
                  alignment: WrapAlignment.spaceEvenly,
                  children: <ResourceCard>[
                    // ...CharacterData.resources.map(
                    //   ((resource) => ResourceCard(
                    //         resource: resource,
                    //         count: widget.character.resourceHide,
                    //         increaseCount: () =>
                    //             charactersModel.updateCharacter(
                    //           widget.character
                    //             ..resourceHide =
                    //                 widget.character.resourceHide + 1,
                    //         ),
                    //         decreaseCount: () =>
                    //             charactersModel.updateCharacter(
                    //           widget.character
                    //             ..resourceHide =
                    //                 widget.character.resourceHide - 1,
                    //         ),
                    //       )),
                    // ),
                    ResourceCard(
                      resource: CharacterData.resources[0],
                      count: widget.character.resourceLumber,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceLumber =
                              widget.character.resourceLumber + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceLumber =
                              widget.character.resourceLumber - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[1],
                      count: widget.character.resourceMetal,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceMetal = widget.character.resourceMetal + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceMetal = widget.character.resourceMetal - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[2],
                      count: widget.character.resourceHide,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceHide = widget.character.resourceHide + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceHide = widget.character.resourceHide - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[3],
                      count: widget.character.resourceArrowvine,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceArrowvine =
                              widget.character.resourceArrowvine + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceArrowvine =
                              widget.character.resourceArrowvine - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[4],
                      count: widget.character.resourceAxenut,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceAxenut =
                              widget.character.resourceAxenut + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceAxenut =
                              widget.character.resourceAxenut - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[5],
                      count: widget.character.resourceCorpsecap,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceCorpsecap =
                              widget.character.resourceCorpsecap + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceCorpsecap =
                              widget.character.resourceCorpsecap - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[6],
                      count: widget.character.resourceFlamefruit,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceFlamefruit =
                              widget.character.resourceFlamefruit + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceFlamefruit =
                              widget.character.resourceFlamefruit - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[7],
                      count: widget.character.resourceRockroot,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceRockroot =
                              widget.character.resourceRockroot + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceRockroot =
                              widget.character.resourceRockroot - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[8],
                      count: widget.character.resourceSnowthistle,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceSnowthistle =
                              widget.character.resourceSnowthistle + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceSnowthistle =
                              widget.character.resourceSnowthistle - 1,
                      ),
                      canEdit: charactersModel.isEditMode &&
                          !widget.character.isRetired,
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

class _NotesSection extends StatelessWidget {
  const _NotesSection({
    required this.character,
    Key? key,
  }) : super(key: key);
  final Character character;
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
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
        context.watch<CharactersModel>().isEditMode && !character.isRetired
            ? TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (String value) {
                  charactersModel.updateCharacter(
                    character..notes = value,
                  );
                },
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Notes',
                ),
                controller: charactersModel.notesController,
              )
            : Text(
                character.notes,
              ),
      ],
    );
  }
}

class _BattleGoalCheckmarksSection extends StatelessWidget {
  const _BattleGoalCheckmarksSection({
    required this.character,
    Key? key,
  }) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.watch<CharactersModel>();
    return charactersModel.isEditMode
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
                      visible: character.checkMarks > 0 && !character.isRetired,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(
                          Icons.remove_circle,
                        ),
                        onPressed: () =>
                            charactersModel.decreaseCheckmark(character),
                      ),
                    ),
                    Text(
                      '${character.checkMarks} / 18',
                      style: const TextStyle(fontSize: titleFontSize),
                    ),
                    Visibility(
                      visible:
                          character.checkMarks < 18 && !character.isRetired,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(
                          Icons.add_circle,
                        ),
                        onPressed: () =>
                            charactersModel.increaseCheckmark(character),
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
