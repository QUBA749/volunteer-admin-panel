import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';
import '../../../widgets/status_badge.dart';
import 'package:shared/shared.dart';
import 'create_event_dialog.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final events = await ApiService().getEvents();
      if (mounted) setState(() { _events = events; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCreateDialog([Event? event]) {
    showDialog(
      context: context,
      builder: (_) => CreateEventDialog(event: event),
    ).then((_) => _loadData());
  }

  void _deleteEvent(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService().deleteEvent(id);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Events', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showCreateDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Create Event'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _events.isEmpty
                    ? const Center(child: Text('No events found'))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisExtent: 220,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          final e = _events[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(e.eventName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                      StatusBadge(status: e.status),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(e.description, style: const TextStyle(color: Colors.white70), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const Spacer(),
                                  Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.white60), const SizedBox(width: 4), Text(e.location, style: const TextStyle(color: Colors.white60))]),
                                  const SizedBox(height: 4),
                                  Row(children: [const Icon(Icons.access_time, size: 16, color: Colors.white60), const SizedBox(width: 4), Text(DateFormat('MMM dd, yyyy HH:mm').format(e.startTime), style: const TextStyle(color: Colors.white60))]),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showCreateDialog(e)),
                                      IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent), onPressed: () => _deleteEvent(e.id)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
