import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';
import '../../../widgets/summary_card.dart';
import '../../../widgets/status_badge.dart';
import 'package:shared/shared.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _summary;
  List<Event>? _upcomingEvents;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final api = ApiService();
    try {
      final summary = await api.getDashboardSummary();
      final events = await api.getUpcomingEvents();
      if (mounted) {
        setState(() {
          _summary = summary;
          _upcomingEvents = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
              ],
            ),
            const SizedBox(height: 32),
            LayoutBuilder(builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  SummaryCard(
                    title: 'Total Volunteers',
                    value: _summary?['totalVolunteers']?.toString() ?? '0',
                    subtitle: 'Registered users',
                    icon: Icons.people_rounded,
                    gradientColors: const [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  SummaryCard(
                    title: 'Total Events',
                    value: _summary?['totalEvents']?.toString() ?? '0',
                    subtitle: 'Organized events',
                    icon: Icons.event_rounded,
                    gradientColors: const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  ),
                  SummaryCard(
                    title: "Today's Attendance",
                    value: _summary?['todayAttendance']?.toString() ?? '0',
                    subtitle: 'Checked in today',
                    icon: Icons.bar_chart_rounded,
                    gradientColors: const [Color(0xFF10B981), Color(0xFF34D399)],
                  ),
                  const SummaryCard(
                    title: 'Active Tasks',
                    value: '0',
                    subtitle: 'Coming Soon',
                    icon: Icons.task_alt_rounded,
                    gradientColors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                  ),
                ],
              );
            }),
            const SizedBox(height: 48),
            const Text('Upcoming Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_upcomingEvents != null && _upcomingEvents!.isNotEmpty)
              ..._upcomingEvents!.take(5).map((e) => Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(e.eventName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.white60),
                              const SizedBox(width: 4),
                              Text(e.location, style: const TextStyle(color: Colors.white60)),
                              const SizedBox(width: 16),
                              const Icon(Icons.access_time, size: 16, color: Colors.white60),
                              const SizedBox(width: 4),
                              Text(DateFormat('MMM dd, yyyy HH:mm').format(e.startTime), style: const TextStyle(color: Colors.white60)),
                            ],
                          ),
                        ],
                      ),
                      trailing: StatusBadge(status: e.status),
                    ),
                  ))
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No upcoming events', style: TextStyle(color: Colors.white60)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
