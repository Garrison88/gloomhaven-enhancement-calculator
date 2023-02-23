import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/character_data.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/masteries_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/resource_card.dart';
import '../../data/constants.dart';
import '../../data/strings.dart';
import '../dialogs/add_subtract_dialog.dart';
import '../widgets/perks_section.dart';
import '../dialogs/info_dialog.dart';
import '../../viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({
    @required this.character,
    Key key,
  }) : super(
          key: key,
        );
  final Character character;
  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
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
            RetirementsAndPocketItemsSection(
              character: widget.character,
            ),
            // NAME and CLASS
            Padding(
              padding: const EdgeInsets.all(
                smallPadding,
              ),
              child: NameAndClassSection(
                character: widget.character,
              ),
            ),
            // STATS
            Padding(
              padding: const EdgeInsets.all(
                smallPadding,
              ),
              child: StatsSection(
                character: widget.character,
                // isEditMode: isEditMode,
              ),
            ),
            // RESOURCES
            ResourcesSection(
              character: widget.character,
            ),
            // NOTES
            Padding(
              padding: const EdgeInsets.all(smallPadding),
              child: NotesSection(
                character: widget.character,
              ),
            ),
            // BATTLE GOAL CHECKMARKS
            BattleGoalCheckmarksSection(
              character: widget.character,
            ),
            // PERKS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding),
              child: PerksSection(
                character: widget.character,
                // uuid: context.watch<CharactersModel>().currentCharacter.uuid,
                // charactersModel: context.watch<CharactersModel>(),
              ),
            ),
            const SizedBox(
              height: smallPadding,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: smallPadding - 3),
              child: MasteriesSection(
                character: widget.character,
                charactersModel: context.watch<CharactersModel>(),
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
    @required this.character,
    Key key,
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
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: context.watch<CharactersModel>().isEditMode
                  ? TextField(
                      enableInteractiveSelection: false,
                      onChanged: (String value) =>
                          charactersModel.updateCharacter(
                        charactersModel.currentCharacter
                          ..previousRetirements =
                              value.isEmpty ? 0 : int.parse(value),
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                      controller: charactersModel.previousRetirementsController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp('[\\.|\\,|\\ |\\-]'))
                      ],
                      keyboardType: TextInputType.number,
                    )
                  : Text(
                      'Retirements: ${character.previousRetirements}',
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
              '${(character.level() / 2).round()} Pocket Item${(character.level() / 2).round() > 1 ? 's' : ''} Allowed',
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
                  child: Consumer<CharactersModel>(
                    builder: (
                      _,
                      charactersModel,
                      __,
                    ) =>
                        Text(
                      '${(character.level() / 2).round()}',
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
  NameAndClassSection({
    @required this.character,
    Key key,
  }) : super(key: key);
  final Character character;
  final TextEditingController controller =
      TextEditingController(text: 'My First Guy');
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
    return Column(
      children: <Widget>[
        context.watch<CharactersModel>().isEditMode
            ? TextField(
                autocorrect: false,
                onChanged: (String value) {
                  charactersModel.updateCharacter(
                    charactersModel.currentCharacter..name = value,
                  );
                },
                minLines: 1,
                maxLines: 2,
                controller: charactersModel.nameController,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.words,
              )
            : AutoSizeText(
                character.name,
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
                Consumer<CharactersModel>(
                  builder: (
                    _,
                    charactersModel,
                    __,
                  ) =>
                      Text(
                    '${character.level()}',
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
                '${character.playerClass.race} ${character.playerClass.className}',
                maxLines: 1,
                style: const TextStyle(fontSize: titleFontSize),
              ),
            ),
          ],
        ),
        if (character.isRetired)
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
    @required this.character,
    Key key,
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
                              charactersModel.updateCharacter(
                                character
                                  ..xp = value == '' ? 0 : int.parse(value),
                              );
                            },
                            textAlignVertical: TextAlignVertical.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                            controller: charactersModel.xpController,
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
                                    charactersModel.currentCharacter.xp,
                                    'XP',
                                  )).then(
                            (value) {
                              if (value != null) {
                                charactersModel.updateCharacter(
                                  charactersModel.currentCharacter..xp = value,
                                );
                              }
                            },
                          ),
                        ),
                      ],
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
                  ' / ${character.nextLevelXp()}',
                  style: Theme.of(context).textTheme.bodyMedium.copyWith(
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium.fontSize / 2,
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
                                charactersModel.updateCharacter(
                              charactersModel.currentCharacter
                                ..gold = value == '' ? 0 : int.parse(value),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                            controller: charactersModel.goldController,
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
                                    charactersModel.currentCharacter.gold,
                                    'Gold',
                                  )).then(
                            (value) {
                              if (value != null) {
                                charactersModel.updateCharacter(
                                  charactersModel.currentCharacter
                                    ..gold = value,
                                );
                              }
                            },
                          ),
                        ),
                      ],
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
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
    this.character,
    Key key,
  }) : super(key: key);
  final Character character;
  @override
  State<ResourcesSection> createState() => _ResourcesSectionState();
}

class _ResourcesSectionState extends State<ResourcesSection> {
  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.read<CharactersModel>();
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
                    // TODO: uncomment this when including Resources
                    ResourceCard(
                      resource: CharacterData.resources[0],
                      count: widget.character.resourceHide,
                      increaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceHide = widget.character.resourceHide + 1,
                      ),
                      decreaseCount: () => charactersModel.updateCharacter(
                        widget.character
                          ..resourceHide = widget.character.resourceHide - 1,
                      ),
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
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[2],
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
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[5],
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
                    ),
                    ResourceCard(
                      resource: CharacterData.resources[7],
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
    @required this.character,
    Key key,
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
        context.watch<CharactersModel>().isEditMode
            ? TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onChanged: (String value) {
                  charactersModel.updateCharacter(
                    charactersModel.currentCharacter..notes = value,
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

class BattleGoalCheckmarksSection extends StatelessWidget {
  const BattleGoalCheckmarksSection({
    @required this.character,
    Key key,
  }) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.watch<CharactersModel>();
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
                      visible: character.checkMarks > 0,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(
                          Icons.remove_circle,
                        ),
                        onPressed: charactersModel.decreaseCheckmark,
                      ),
                    ),
                    Text(
                      '${character.checkMarks} / 18',
                      style: const TextStyle(fontSize: titleFontSize),
                    ),
                    Visibility(
                      visible: character.checkMarks < 18,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(
                          Icons.add_circle,
                        ),
                        onPressed: charactersModel.increaseCheckmark,
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
