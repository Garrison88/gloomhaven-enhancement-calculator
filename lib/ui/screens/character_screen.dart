import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/player_classes/resources_repository.dart';
import 'package:gloomhaven_enhancement_calc/models/resource_field.dart';
import 'package:provider/provider.dart';

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
    super.key,
  });
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
  });
  final Character character;
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: TextField(
            textAlign: charactersModel.isEditMode && !character.isRetired
                ? TextAlign.center
                : TextAlign.start,
            enableInteractiveSelection: false,
            onChanged: (String value) => charactersModel.updateCharacter(
              character
                ..previousRetirements = value.isEmpty ? 0 : int.parse(value),
            ),
            enabled: charactersModel.isEditMode && !character.isRetired,
            decoration: InputDecoration(
              labelText: 'Previous retirements',
              border: charactersModel.isEditMode && !character.isRetired
                  ? const OutlineInputBorder()
                  : InputBorder.none,
            ),
            controller: charactersModel.previousRetirementsController,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp('[\\.|\\,|\\ |\\-]'))
            ],
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(
          width: 75,
        ),
        Tooltip(
          message:
              '${(Character.level(character.xp) / 2).round()} pocket item${(Character.level(character.xp) / 2).round() > 1 ? 's' : ''} allowed',
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
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.5),
                  child: Text(
                    '${(Character.level(character.xp) / 2).round()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.surface,
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
  });
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
                decoration: const InputDecoration(
                  label: Text('Name'),
                  border: OutlineInputBorder(),
                ),
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
              alignment: const Alignment(0, 0.3),
              children: <Widget>[
                SvgPicture.asset(
                  'images/level.svg',
                  width: iconSize * 1.5,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),
                Text(
                  '${Character.level(character.xp)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: titleFontSize - 7,
                        color: Theme.of(context).colorScheme.surface,
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
        if (character.showTraits()) ...[
          const SizedBox(
            height: smallPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/trait.svg',
                width: iconSize,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
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
  });
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
                width: iconSize,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
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
                            decoration: const InputDecoration(
                              label: Text('XP'),
                              border: OutlineInputBorder(),
                            ),
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
                width: iconSize,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
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
                            decoration: const InputDecoration(
                              label: Text('Gold'),
                              border: OutlineInputBorder(),
                            ),
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
                    Theme.of(context).colorScheme.onSurface,
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
  });
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
          color: Theme.of(context).colorScheme.onSurface,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: widget.character.primaryClassColor(
            Theme.of(context).brightness,
          ),
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
              child: Wrap(
                runSpacing: smallPadding,
                spacing: smallPadding,
                alignment: WrapAlignment.spaceEvenly,
                children: _buildResourceCards(
                  context,
                  widget.character,
                  charactersModel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate resource cards
  List<Widget> _buildResourceCards(
    BuildContext context,
    Character character,
    CharactersModel charactersModel,
  ) {
    return resourceFields.entries.map((entry) {
      final ResourceFieldData fieldData = entry.value;
      return ResourceCard(
        resource: ResourcesRepository.resources[fieldData.resourceIndex],
        color: character
            .primaryClassColor(Theme.of(context).brightness)
            .withValues(alpha: 0.1),
        count: fieldData.getter(character),
        onIncrease: () {
          // Create a copy of the character and update it
          final updatedCharacter = character;
          fieldData.setter(
            updatedCharacter,
            fieldData.getter(character) + 1,
          );
          charactersModel.updateCharacter(updatedCharacter);
        },
        onDecrease: () {
          // Create a copy of the character and update it
          final updatedCharacter = character;
          fieldData.setter(
            updatedCharacter,
            fieldData.getter(character) - 1,
          );
          charactersModel.updateCharacter(updatedCharacter);
        },
        canEdit: charactersModel.isEditMode && !character.isRetired,
      );
    }).toList();
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection({
    required this.character,
  });
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
                  label: Text('Notes'),
                  border: OutlineInputBorder(),
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
  });
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
