import 'package:flutter/material.dart';
import '../cubit/patient_appointments_cubit.dart';

class AddAppointmentSheet extends StatefulWidget {
  final int patientId;
  final PatientAppointmentsCubit cubit;

  const AddAppointmentSheet({
    super.key,
    required this.patientId,
    required this.cubit,
  });

  @override
  State<AddAppointmentSheet> createState() => _AddAppointmentSheetState();
}

class _AddAppointmentSheetState extends State<AddAppointmentSheet> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _save() async {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarix və vaxt seçin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final dateIso = _selectedDate!.toIso8601String();
    final startStr = _formatTime(_startTime!);
    final endStr = _formatTime(_endTime!);

    final body = {
      'date': dateIso,
      'startTime': startStr,
      'endTime': endStr,
    };

    await widget.cubit.createAppointment(widget.patientId, body);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Yeni Appointment',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          
          ListTile(
            title: Text(_selectedDate == null
                ? 'Tarix seç'
                : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDate,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(_startTime == null
                      ? 'Başlama'
                      : _formatTime(_startTime!)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _pickTime(true),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ListTile(
                  title: Text(_endTime == null
                      ? 'Bitmə'
                      : _formatTime(_endTime!)),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _pickTime(false),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _save,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Yarat'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
