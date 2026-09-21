import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';
import 'package:shared/shared.dart';

class CreateEventDialog extends StatefulWidget {
  final Event? event;

  const CreateEventDialog({Key? key, this.event}) : super(key: key);

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  DateTime _startTime = DateTime.now().add(const Duration(days: 1));
  DateTime _endTime = DateTime.now().add(const Duration(days: 1, hours: 2));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event?.eventName ?? '');
    _descController = TextEditingController(text: widget.event?.description ?? '');
    _locationController = TextEditingController(text: widget.event?.location ?? '');
    if (widget.event != null) {
      _startTime = widget.event!.startTime;
      _endTime = widget.event!.endTime;
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    final data = {
      'eventName': _nameController.text,
      'description': _descController.text,
      'location': _locationController.text,
      'startTime': _startTime.toIso8601String(),
      'endTime': _endTime.toIso8601String(),
      'status': widget.event?.status ?? 'upcoming',
    };

    try {
      if (widget.event == null) {
        await ApiService().createEvent(data);
      } else {
        await ApiService().updateEvent(widget.event!.id, data);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error saving event')));
      }
    }
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startTime : _endTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStart ? _startTime : _endTime),
      );
      if (time != null) {
        setState(() {
          final newDt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          if (isStart) {
            _startTime = newDt;
            if (_endTime.isBefore(_startTime)) _endTime = _startTime.add(const Duration(hours: 1));
          } else {
            _endTime = newDt;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.event == null ? 'Create Event' : 'Edit Event', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(_startTime)),
                      onTap: () => _pickDateTime(true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(_endTime)),
                      onTap: () => _pickDateTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
