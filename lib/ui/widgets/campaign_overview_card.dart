import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';

class CampaignOverviewCard extends StatelessWidget {
  final Campaign campaign;
  final Function(int) onReputationChanged;
  final Function(int) onProsperityChanged;
  final Function(int) onDonationAdded;
  final Function(String) onLocationChanged;
  final Function(String) onNotesChanged;

  const CampaignOverviewCard({
    super.key,
    required this.campaign,
    required this.onReputationChanged,
    required this.onProsperityChanged,
    required this.onDonationAdded,
    required this.onLocationChanged,
    required this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campaign Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Reputation
            _buildReputationRow(context),
            const SizedBox(height: 12),

            // Prosperity
            _buildProsperityRow(context),
            const SizedBox(height: 12),

            // Sanctuary Donations
            _buildSanctuaryRow(context),
            const SizedBox(height: 12),

            // Current Location
            _buildLocationRow(context),
            const SizedBox(height: 12),

            // Notes
            _buildNotesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReputationRow(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.thumb_up_outlined, size: 20),
        const SizedBox(width: 8),
        const Text('Reputation:'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed:
              campaign.reputation > -20 ? () => onReputationChanged(-1) : null,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getReputationColor(campaign.reputation).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _getReputationColor(campaign.reputation),
            ),
          ),
          child: Text(
            '${campaign.reputation}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getReputationColor(campaign.reputation),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed:
              campaign.reputation < 20 ? () => onReputationChanged(1) : null,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildProsperityRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.trending_up, size: 20),
            const SizedBox(width: 8),
            Text('Prosperity Level ${campaign.prosperityLevel}'),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Checkmark'),
              onPressed: () => _showProsperityDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _getProsperityProgress(),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 4),
        Text(
          '${campaign.prosperityCheckmarks} / ${_getNextProsperityThreshold()} checkmarks',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSanctuaryRow(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.church_outlined, size: 20),
        const SizedBox(width: 8),
        const Text('Sanctuary Donations:'),
        const Spacer(),
        Text(
          '${campaign.sanctuaryDonations}g',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showDonationDialog(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_outlined, size: 20),
        const SizedBox(width: 8),
        const Text('Location:'),
        const Spacer(),
        InkWell(
          onTap: () => _showLocationDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  campaign.currentLocation,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.edit, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.notes_outlined, size: 20),
            const SizedBox(width: 8),
            const Text('Notes:'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              onPressed: () => _showNotesDialog(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        if (campaign.notes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              campaign.notes,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ],
    );
  }

  Color _getReputationColor(int reputation) {
    if (reputation >= 10) return Colors.blue;
    if (reputation >= 3) return Colors.green;
    if (reputation <= -10) return Colors.purple;
    if (reputation <= -3) return Colors.orange;
    return Colors.grey;
  }

  double _getProsperityProgress() {
    int current = campaign.prosperityCheckmarks;
    int next = _getNextProsperityThreshold();
    int previous = _getPreviousProsperityThreshold();

    if (next == previous) return 1.0;
    return (current - previous) / (next - previous);
  }

  int _getNextProsperityThreshold() {
    if (campaign.prosperityLevel >= 9) return 64;
    const thresholds = [0, 4, 9, 15, 22, 30, 39, 50, 64];
    return thresholds[campaign.prosperityLevel];
  }

  int _getPreviousProsperityThreshold() {
    if (campaign.prosperityLevel <= 1) return 0;
    const thresholds = [0, 4, 9, 15, 22, 30, 39, 50, 64];
    return thresholds[campaign.prosperityLevel - 1];
  }

  void _showProsperityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Prosperity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How many prosperity checkmarks to add?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3, 4, 5].map((count) {
                return ElevatedButton(
                  onPressed: () {
                    onProsperityChanged(count);
                    Navigator.pop(context);
                  },
                  child: Text('+$count'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showDonationDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Donate to Sanctuary'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Gold Amount',
            prefixText: '💰 ',
            suffixText: 'gold',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                onDonationAdded(amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Donate'),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    final controller = TextEditingController(text: campaign.currentLocation);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Current Location',
            hintText: 'e.g., Gloomhaven, Black Barrow',
          ),
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onLocationChanged(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showNotesDialog(BuildContext context) {
    final controller = TextEditingController(text: campaign.notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Notes'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Campaign Notes',
            hintText: 'Add any notes about your campaign...',
          ),
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onNotesChanged(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
