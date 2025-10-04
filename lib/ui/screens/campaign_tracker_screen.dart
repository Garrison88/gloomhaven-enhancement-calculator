import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/campaign.dart';
import 'package:gloomhaven_enhancement_calc/ui/dialogs/create_campaign_dialog.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/campaign_overview_card.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/achievements_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/unlocks_section.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/events_section.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/campaign_model.dart';
import 'package:provider/provider.dart';

class CampaignTrackerScreen extends StatefulWidget {
  const CampaignTrackerScreen({super.key});

  @override
  State<CampaignTrackerScreen> createState() => _CampaignTrackerScreenState();
}

class _CampaignTrackerScreenState extends State<CampaignTrackerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initialize campaign data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CampaignModel>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignModel>(
      builder: (context, campaignModel, child) {
        final campaign = campaignModel.currentCampaign;

        if (campaign == null) {
          return _buildNoCampaignView(context, campaignModel);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(campaign.partyName),
            actions: [
              IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: () => _showCampaignSelector(context, campaignModel),
                tooltip: 'Switch Campaign',
              ),
              PopupMenuButton<String>(
                onSelected: (value) =>
                    _handleMenuAction(value, context, campaignModel),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Campaign'),
                  ),
                  const PopupMenuItem(
                    value: 'new',
                    child: Text('New Campaign'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Campaign'),
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Achievements'),
                Tab(text: 'Unlocks'),
                Tab(text: 'Events'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context, campaign, campaignModel),
              _buildAchievementsTab(context, campaign, campaignModel),
              _buildUnlocksTab(context, campaign, campaignModel),
              _buildEventsTab(context, campaign, campaignModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    Campaign campaign,
    CampaignModel model,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(smallPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CampaignOverviewCard(
            campaign: campaign,
            onReputationChanged: (change) => model.adjustReputation(change),
            onProsperityChanged: (marks) =>
                model.addProsperityCheckmarks(marks),
            onDonationAdded: (amount) => model.donatToSanctuary(amount),
            onLocationChanged: (location) {
              campaign.currentLocation = location;
              model.updateCampaign(campaign);
            },
            onNotesChanged: (notes) {
              campaign.notes = notes;
              model.updateCampaign(campaign);
            },
          ),
          const SizedBox(height: 16),
          _buildQuickStats(context, campaign, model),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    Campaign campaign,
    CampaignModel model,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: 'Shop Price Modifier',
              value:
                  '${campaign.shopPriceModifier >= 0 ? '+' : ''}${campaign.shopPriceModifier}g',
              color: campaign.shopPriceModifier < 0
                  ? Colors.green
                  : campaign.shopPriceModifier > 0
                      ? Colors.red
                      : null,
            ),
            _StatRow(
              label: 'Available Items',
              value: 'Items 1-${14 + (campaign.prosperityLevel - 1) * 7}',
            ),
            _StatRow(
              label: 'Starting Level',
              value: 'Level ${campaign.prosperityLevel}',
            ),
            _StatRow(
              label: 'Global Achievements',
              value: '${model.globalAchievements.length}',
            ),
            _StatRow(
              label: 'Party Achievements',
              value: '${model.partyAchievements.length}',
            ),
            _StatRow(
              label: 'Ancient Technology',
              value: '${model.ancientTechnologyCount}/5',
              color: model.ancientTechnologyCount >= 5 ? Colors.green : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsTab(
    BuildContext context,
    Campaign campaign,
    CampaignModel model,
  ) {
    return AchievementsSection(
      globalAchievements: model.globalAchievements,
      partyAchievements: model.partyAchievements,
      onAddGlobalAchievement: (name, type, details) {
        model.addGlobalAchievement(
          name: name,
          type: type,
          details: details,
          associatedCampaignUuid: campaign.uuid,
        );
      },
      onRemoveGlobalAchievement: model.removeGlobalAchievement,
      onAddPartyAchievement: (name, details) {
        model.addPartyAchievement(
          name: name,
          details: details,
        );
      },
      onRemovePartyAchievement: model.removePartyAchievement,
    );
  }

  Widget _buildUnlocksTab(
    BuildContext context,
    Campaign campaign,
    CampaignModel model,
  ) {
    return UnlocksSection(
      unlocks: model.campaignUnlocks,
      onUpdateProgress: (unlock, progress) {
        unlock.progress = progress;
        model.updateCampaign(campaign);
      },
    );
  }

  Widget _buildEventsTab(
    BuildContext context,
    Campaign campaign,
    CampaignModel model,
  ) {
    return EventsSection(
      cityEvents: model.cityEvents,
      roadEvents: model.roadEvents,
      onCompleteEvent: model.completeEvent,
      onAddEvent: model.addEvent,
      onRemoveEvent: model.removeEvent,
    );
  }

  void _createNewCampaign(BuildContext context, CampaignModel model) {
    showDialog(
      context: context,
      builder: (context) => CreateCampaignDialog(
        onCreateCampaign: (name, variant) {
          model.createCampaign(
            partyName: name,
            gameVariant: variant,
          );
        },
      ),
    );
  }

  void _showCampaignSelector(BuildContext context, CampaignModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Campaign'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: model.campaigns.length,
            itemBuilder: (context, index) {
              final campaign = model.campaigns[index];
              return ListTile(
                title: Text(campaign.partyName),
                subtitle: Text(
                    'Reputation: ${campaign.reputation}, Prosperity: ${campaign.prosperityLevel}'),
                selected: campaign.uuid == model.currentCampaign?.uuid,
                onTap: () {
                  model.switchCampaign(campaign);
                  Navigator.pop(context);
                },
              );
            },
          ),
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

  void _handleMenuAction(
      String action, BuildContext context, CampaignModel model) {
    switch (action) {
      case 'edit':
        // TODO: Implement edit campaign dialog
        break;
      case 'new':
        _createNewCampaign(context, model);
        break;
      case 'delete':
        _confirmDeleteCampaign(context, model);
        break;
    }
  }

  void _confirmDeleteCampaign(BuildContext context, CampaignModel model) {
    if (model.currentCampaign == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Campaign?'),
        content: Text(
            'Are you sure you want to delete "${model.currentCampaign!.partyName}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              model.deleteCampaign(model.currentCampaign!);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatRow({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
