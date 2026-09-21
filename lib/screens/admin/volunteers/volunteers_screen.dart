import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../widgets/status_badge.dart';
import 'package:shared/shared.dart';

class VolunteersScreen extends StatefulWidget {
  const VolunteersScreen({Key? key}) : super(key: key);

  @override
  State<VolunteersScreen> createState() => _VolunteersScreenState();
}

class _VolunteersScreenState extends State<VolunteersScreen> {
  List<Volunteer> _volunteers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final vols = await ApiService().getVolunteers(status: _statusFilter, search: _searchQuery.isNotEmpty ? _searchQuery : null);
      if (mounted) {
        setState(() {
          _volunteers = vols;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Volunteers', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search volunteers...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => _searchQuery = v,
                  onSubmitted: (_) => _loadData(),
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String?>(
                value: _statusFilter,
                hint: const Text('Filter by Status'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                  DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
                ],
                onChanged: (v) {
                  setState(() => _statusFilter = v);
                  _loadData();
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Search'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _volunteers.isEmpty
                    ? const Center(child: Text('No volunteers found'))
                    : Card(
                        child: ListView(
                          children: [
                            DataTable(
                              showCheckboxColumn: false,
                              columns: const [
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Phone')),
                                DataColumn(label: Text('Tasks')),
                                DataColumn(label: Text('Attendance')),
                                DataColumn(label: Text('Status')),
                              ],
                              rows: _volunteers.map((v) {
                                return DataRow(
                                  onSelectChanged: (_) {
                                    Navigator.pushNamed(context, '/volunteers/detail', arguments: v.id);
                                  },
                                  cells: [
                                    DataCell(Text(v.fullName)),
                                    DataCell(Text(v.email)),
                                    DataCell(Text(v.phone)),
                                    DataCell(Text(v.tasksCompleted.toString())),
                                    DataCell(Text('${v.attendancePct.toStringAsFixed(1)}%')),
                                    DataCell(StatusBadge(status: v.status)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
