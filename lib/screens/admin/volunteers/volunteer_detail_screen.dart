import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../widgets/status_badge.dart';
import 'package:shared/shared.dart';

class VolunteerDetailScreen extends StatefulWidget {
  final String volunteerId;

  const VolunteerDetailScreen({Key? key, required this.volunteerId}) : super(key: key);

  @override
  State<VolunteerDetailScreen> createState() => _VolunteerDetailScreenState();
}

class _VolunteerDetailScreenState extends State<VolunteerDetailScreen> {
  Volunteer? _volunteer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final vol = await ApiService().getVolunteerById(widget.volunteerId);
      if (mounted) setState(() { _volunteer = vol; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_volunteer == null) return const Center(child: Text('Volunteer not found'));

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 16),
              const Text('Volunteer Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFF7C3AED),
                    child: Text(_volunteer!.fullName[0].toUpperCase(), style: const TextStyle(fontSize: 36, color: Colors.white)),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(_volunteer!.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            StatusBadge(status: _volunteer!.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_volunteer!.email, style: const TextStyle(color: Colors.white70)),
                        Text(_volunteer!.phone, style: const TextStyle(color: Colors.white70)),
                        Text(_volunteer!.city, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: _volunteer!.skills.map((s) => Chip(
                            label: Text(s),
                            backgroundColor: const Color(0xFF1A1929),
                            side: const BorderSide(color: Color(0xFF7C3AED)),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _Stat(label: 'Tasks Completed', value: _volunteer!.tasksCompleted.toString()),
                      const SizedBox(height: 16),
                      _Stat(label: 'Attendance', value: '${_volunteer!.attendancePct.toStringAsFixed(1)}%'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Recent Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Expanded(
            child: Card(
              child: Center(
                child: Text('Attendance history coming soon', style: TextStyle(color: Colors.white60)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
        Text(label, style: const TextStyle(color: Colors.white60)),
      ],
    );
  }
}
