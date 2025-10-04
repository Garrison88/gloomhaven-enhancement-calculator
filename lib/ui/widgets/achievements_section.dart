import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/global_achievement.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/party_achievement.dart';

class AchievementsSection extends StatefulWidget {
  final List<GlobalAchievement> globalAchievements;
  final List<PartyAchievement> partyAchievements;
  final Function(String name, String? type, String details)
      onAddGlobalAchievement;
  final Function(GlobalAchievement) onRemoveGlobalAchievement;
  final Function(String name, String details) onAddPartyAchievement;
  final Function(PartyAchievement) onRemovePartyAchievement;

  const AchievementsSection({
    super.key,
    required this.globalAchievements,
    required this.partyAchievements,
    required this.onAddGlobalAchievement,
    required this.onRemoveGlobalAchievement,
    required this.onAddPartyAchievement,
    required this.onRemovePartyAchievement,
  });

  @override
  State<AchievementsSection> createState() => _AchievementsSectionState();
}

class _AchievementsSectionState extends State<AchievementsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Global (${widget.globalAchievements.length})'),
            Tab(text: 'Party (${widget.partyAchievements.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGlobalAchievementsTab(),
              _buildPartyAchievementsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalAchievementsTab() {
    final groupedAchievements =
        _groupAchievementsByType(widget.globalAchievements);

    return Scaffold(
      body: widget.globalAchievements.isEmpty
          ? _buildEmptyState('No global achievements yet')
          : ListView(
              padding: const EdgeInsets.all(smallPadding),
              children: [
                ...groupedAchievements.entries.map((entry) {
                  return _buildAchievementGroup(
                    title: entry.key ?? 'Other',
                    achievements: entry.value,
                    isGlobal: true,
                  );
                }),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGlobalAchievementDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Add Global Achievement',
      ),
    );
  }

  Widget _buildPartyAchievementsTab() {
    return Scaffold(
      body: widget.partyAchievements.isEmpty
          ? _buildEmptyState('No party achievements yet')
          : ListView.builder(
              padding: const EdgeInsets.all(smallPadding),
              itemCount: widget.partyAchievements.length,
              itemBuilder: (context, index) {
                final achievement = widget.partyAchievements[index];
                return _buildPartyAchievementCard(achievement);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPartyAchievementDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Add Party Achievement',
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementGroup({
    required String title,
    required List<GlobalAchievement> achievements,
    required bool isGlobal,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getIconForType(title),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (title == AchievementTypes.ancientTechnology)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: achievements.length >= 5
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${achievements.length}/5',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ...achievements
              .map((achievement) => _buildGlobalAchievementTile(achievement)),
        ],
      ),
    );
  }

  Widget _buildGlobalAchievementTile(GlobalAchievement achievement) {
    return ListTile(
      title: Text(achievement.name),
      subtitle:
          achievement.details.isNotEmpty ? Text(achievement.details) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (achievement.unlockedAt != null)
            Text(
              _formatDate(achievement.unlockedAt!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () => _confirmRemoveAchievement(achievement, true),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyAchievementCard(PartyAchievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.flag_outlined),
        title: Text(achievement.name),
        subtitle:
            achievement.details.isNotEmpty ? Text(achievement.details) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (achievement.unlockedAt != null)
              Text(
                _formatDate(achievement.unlockedAt!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _confirmRemoveAchievement(achievement, false),
            ),
          ],
        ),
      ),
    );
  }

  Map<String?, List<GlobalAchievement>> _groupAchievementsByType(
    List<GlobalAchievement> achievements,
  ) {
    final grouped = <String?, List<GlobalAchievement>>{};

    for (final achievement in achievements) {
      final type = achievement.type;
      grouped.putIfAbsent(type, () => []).add(achievement);
    }

    return grouped;
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case AchievementTypes.cityRule:
        return Icons.account_balance;
      case AchievementTypes.ancientTechnology:
        return Icons.memory;
      case AchievementTypes.artifactRecovered:
        return Icons.shield_outlined;
      case 'Other':
        return Icons.emoji_events_outlined;
      default:
        return Icons.flag_outlined;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showAddGlobalAchievementDialog() {
    final nameController = TextEditingController();
    final detailsController = TextEditingController();
    String? selectedType;

    final commonTypes = [
      AchievementTypes.cityRule,
      AchievementTypes.ancientTechnology,
      AchievementTypes.artifactRecovered,
      'Custom',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Global Achievement'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Achievement Name',
                    hintText: 'e.g., The Voice Silenced',
                  ),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type (Optional)',
                  ),
                  items: commonTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details (Optional)',
                    hintText: 'Additional notes...',
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  widget.onAddGlobalAchievement(
                    nameController.text.trim(),
                    selectedType == 'Custom' ? null : selectedType,
                    detailsController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPartyAchievementDialog() {
    final nameController = TextEditingController();
    final detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Party Achievement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Achievement Name',
                hintText: 'e.g., First Steps',
              ),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(
                labelText: 'Details (Optional)',
                hintText: 'Additional notes...',
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                widget.onAddPartyAchievement(
                  nameController.text.trim(),
                  detailsController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveAchievement(dynamic achievement, bool isGlobal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Achievement?'),
        content: Text(
            'Remove "${achievement.name}" from ${isGlobal ? 'global' : 'party'} achievements?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isGlobal) {
                widget.onRemoveGlobalAchievement(
                    achievement as GlobalAchievement);
              } else {
                widget
                    .onRemovePartyAchievement(achievement as PartyAchievement);
              }
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
