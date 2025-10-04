import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/models/campaign/event.dart';

class EventsSection extends StatefulWidget {
  final List<CampaignEvent> cityEvents;
  final List<CampaignEvent> roadEvents;
  final Function(CampaignEvent, {bool returnToBottom}) onCompleteEvent;
  final Function(int, EventType) onAddEvent;
  final Function(CampaignEvent) onRemoveEvent;

  const EventsSection({
    super.key,
    required this.cityEvents,
    required this.roadEvents,
    required this.onCompleteEvent,
    required this.onAddEvent,
    required this.onRemoveEvent,
  });

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  EventStatus _filterStatus = EventStatus.available;

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
            Tab(text: 'City Events (${_getAvailableCount(widget.cityEvents)})'),
            Tab(text: 'Road Events (${_getAvailableCount(widget.roadEvents)})'),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text('Filter: '),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: EventStatus.values.map((status) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_getStatusLabel(status)),
                          selected: _filterStatus == status,
                          onSelected: (selected) {
                            setState(() {
                              _filterStatus = status;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEventList(EventType.city),
              _buildEventList(EventType.road),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventList(EventType type) {
    final events =
        type == EventType.city ? widget.cityEvents : widget.roadEvents;
    final filteredEvents = _filterEvents(events);

    return Scaffold(
      body: filteredEvents.isEmpty
          ? _buildEmptyState(type)
          : ListView.builder(
              padding: const EdgeInsets.all(smallPadding),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return _buildEventCard(filteredEvents[index]);
              },
            ),
      floatingActionButton: _filterStatus == EventStatus.available
          ? FloatingActionButton(
              onPressed: () => _showAddEventDialog(type),
              child: const Icon(Icons.add),
              tooltip: 'Add ${type == EventType.city ? 'City' : 'Road'} Event',
            )
          : null,
    );
  }

  Widget _buildEmptyState(EventType type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            type == EventType.city ? Icons.location_city : Icons.route,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${_getStatusLabel(_filterStatus).toLowerCase()} ${type == EventType.city ? 'city' : 'road'} events',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (_filterStatus == EventStatus.available) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showAddEventDialog(type),
              icon: const Icon(Icons.add),
              label:
                  Text('Add ${type == EventType.city ? 'City' : 'Road'} Event'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventCard(CampaignEvent event) {
    final isAvailable = event.status == EventStatus.available;
    final isCompleted = event.status == EventStatus.completed;
    final isRemoved = event.status == EventStatus.removed;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(event.status),
          child: Text(
            '${event.eventNumber}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          event.displayName,
          style: TextStyle(
            decoration: isRemoved ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${_getStatusLabel(event.status)}',
              style: TextStyle(
                color: _getStatusColor(event.status),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (event.notes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                event.notes,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        trailing: isAvailable
            ? PopupMenuButton<String>(
                onSelected: (value) => _handleEventAction(value, event),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'complete',
                    child: ListTile(
                      leading: Icon(Icons.check),
                      title: Text('Complete'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'bottom',
                    child: ListTile(
                      leading: Icon(Icons.vertical_align_bottom),
                      title: Text('Return to Bottom'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Remove from Game'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  List<CampaignEvent> _filterEvents(List<CampaignEvent> events) {
    return events.where((event) => event.status == _filterStatus).toList()
      ..sort((a, b) => a.eventNumber.compareTo(b.eventNumber));
  }

  int _getAvailableCount(List<CampaignEvent> events) {
    return events.where((e) => e.status == EventStatus.available).length;
  }

  String _getStatusLabel(EventStatus status) {
    switch (status) {
      case EventStatus.available:
        return 'Available';
      case EventStatus.completed:
        return 'Completed';
      case EventStatus.removed:
        return 'Removed';
      case EventStatus.bottomOfDeck:
        return 'Bottom of Deck';
    }
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.available:
        return Colors.blue;
      case EventStatus.completed:
        return Colors.green;
      case EventStatus.removed:
        return Colors.red;
      case EventStatus.bottomOfDeck:
        return Colors.orange;
    }
  }

  void _handleEventAction(String action, CampaignEvent event) {
    switch (action) {
      case 'complete':
        _showCompleteEventDialog(event);
        break;
      case 'bottom':
        widget.onCompleteEvent(event, returnToBottom: true);
        break;
      case 'remove':
        _confirmRemoveEvent(event);
        break;
    }
  }

  void _showCompleteEventDialog(CampaignEvent event) {
    final notesController = TextEditingController(text: event.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Complete ${event.displayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mark this event as completed?'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Choice made, outcome, etc.',
              ),
              maxLines: 3,
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
              event.notes = notesController.text;
              widget.onCompleteEvent(event, returnToBottom: false);
              Navigator.pop(context);
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveEvent(CampaignEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Event?'),
        content: Text(
          'Remove ${event.displayName} from the game? This event will no longer be available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.onRemoveEvent(event);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(EventType type) {
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${type == EventType.city ? 'City' : 'Road'} Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'Event Number',
                hintText: 'e.g., 75',
                prefixIcon: Icon(
                  type == EventType.city ? Icons.location_city : Icons.route,
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
            ),
            const SizedBox(height: 8),
            Text(
              'Add new ${type == EventType.city ? 'city' : 'road'} events when unlocked',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
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
              final number = int.tryParse(numberController.text);
              if (number != null && number > 0) {
                // Check if event already exists
                final events = type == EventType.city
                    ? widget.cityEvents
                    : widget.roadEvents;
                final exists = events.any((e) => e.eventNumber == number);

                if (exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Event $number already exists'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                } else {
                  widget.onAddEvent(number, type);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
