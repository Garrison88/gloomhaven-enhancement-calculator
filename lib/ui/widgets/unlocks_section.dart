import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/party_achievement.dart';

class UnlocksSection extends StatelessWidget {
  final List<CampaignUnlock> unlocks;
  final Function(CampaignUnlock, int) onUpdateProgress;

  const UnlocksSection({
    super.key,
    required this.unlocks,
    required this.onUpdateProgress,
  });

  @override
  Widget build(BuildContext context) {
    final groupedUnlocks = _groupUnlocksByType(unlocks);

    return ListView(
      padding: const EdgeInsets.all(smallPadding),
      children: [
        ...groupedUnlocks.entries.map((entry) {
          return _buildUnlockGroup(
            context: context,
            type: entry.key,
            unlocks: entry.value,
          );
        }),
      ],
    );
  }

  Widget _buildUnlockGroup({
    required BuildContext context,
    required UnlockType type,
    required List<CampaignUnlock> unlocks,
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
                  _getIconForType(type),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getTypeTitle(type),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                _buildTypeProgress(unlocks),
              ],
            ),
          ),
          ...unlocks.map((unlock) => _buildUnlockTile(context, unlock)),
        ],
      ),
    );
  }

  Widget _buildUnlockTile(BuildContext context, CampaignUnlock unlock) {
    final isComplete = unlock.conditionMet;
    final progressPercentage = unlock.progressPercentage;

    return Container(
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.withOpacity(0.05) : null,
      ),
      child: ExpansionTile(
        leading: _buildProgressIndicator(context, unlock),
        title: Text(
          unlock.name,
          style: TextStyle(
            decoration: isComplete ? TextDecoration.lineThrough : null,
            fontWeight: isComplete ? FontWeight.bold : null,
          ),
        ),
        subtitle: Text(
          unlock.condition,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: isComplete
            ? const Icon(Icons.check_circle, color: Colors.green)
            : Text(
                '${unlock.progress}/${unlock.target}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
        children: [
          if (!isComplete && _isManuallyTrackable(unlock))
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: unlock.progress.toDouble(),
                          min: 0,
                          max: unlock.target.abs().toDouble(),
                          divisions:
                              unlock.target.abs() > 1 ? unlock.target.abs() : 1,
                          label: unlock.progress.toString(),
                          onChanged: (value) {
                            onUpdateProgress(unlock, value.toInt());
                          },
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          '${unlock.progress}/${unlock.target}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (unlock.type == UnlockType.envelope)
                    Text(
                      _getUnlockHint(unlock),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, CampaignUnlock unlock) {
    final progress = unlock.progressPercentage;

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              unlock.conditionMet
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          if (unlock.conditionMet)
            const Icon(Icons.lock_open, size: 20, color: Colors.green)
          else
            const Icon(Icons.lock_outline, size: 20),
        ],
      ),
    );
  }

  Widget _buildTypeProgress(List<CampaignUnlock> unlocks) {
    final completed = unlocks.where((u) => u.conditionMet).length;
    final total = unlocks.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: completed == total ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$completed/$total',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Map<UnlockType, List<CampaignUnlock>> _groupUnlocksByType(
    List<CampaignUnlock> unlocks,
  ) {
    final grouped = <UnlockType, List<CampaignUnlock>>{};

    for (final unlock in unlocks) {
      grouped.putIfAbsent(unlock.type, () => []).add(unlock);
    }

    // Sort so envelopes appear first
    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        if (a.key == UnlockType.envelope) return -1;
        if (b.key == UnlockType.envelope) return 1;
        return a.key.index.compareTo(b.key.index);
      });

    return Map.fromEntries(sortedEntries);
  }

  IconData _getIconForType(UnlockType type) {
    switch (type) {
      case UnlockType.envelope:
        return Icons.mail_outline;
      case UnlockType.characterClass:
        return Icons.person_add_outlined;
      case UnlockType.scenario:
        return Icons.map_outlined;
      case UnlockType.item:
        return Icons.shopping_bag_outlined;
      case UnlockType.achievement:
        return Icons.flag_outlined;
      case UnlockType.other:
        return Icons.star_outline;
    }
  }

  String _getTypeTitle(UnlockType type) {
    switch (type) {
      case UnlockType.envelope:
        return 'Envelopes';
      case UnlockType.characterClass:
        return 'Character Classes';
      case UnlockType.scenario:
        return 'Scenarios';
      case UnlockType.item:
        return 'Items';
      case UnlockType.achievement:
        return 'Achievements';
      case UnlockType.other:
        return 'Other Unlocks';
    }
  }

  bool _isManuallyTrackable(CampaignUnlock unlock) {
    // Some unlocks are automatically tracked (reputation-based)
    // Others need manual tracking
    if (unlock.type == UnlockType.envelope) {
      return unlock.name == 'Envelope B'; // Sanctuary donations are manual
    }
    return false;
  }

  String _getUnlockHint(CampaignUnlock unlock) {
    if (unlock.name == 'Envelope A') {
      return 'Automatically tracked from Ancient Technology achievements';
    } else if (unlock.name == 'Envelope B') {
      return 'Track sanctuary donations in the Overview tab';
    }
    return '';
  }
}
