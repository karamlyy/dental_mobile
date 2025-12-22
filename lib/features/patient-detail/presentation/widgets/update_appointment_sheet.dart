import 'package:flutter/material.dart';
import '../cubit/patient_appointments_cubit.dart';

class UpdateAppointmentSheet extends StatefulWidget {
  final int appointmentId;
  final String currentStatus;
  final PatientAppointmentsCubit cubit;
  final int patientId;

  const UpdateAppointmentSheet({
    super.key,
    required this.appointmentId,
    required this.currentStatus,
    required this.cubit,
    required this.patientId,
  });

  @override
  State<UpdateAppointmentSheet> createState() => _UpdateAppointmentSheetState();
}

class _UpdateAppointmentSheetState extends State<UpdateAppointmentSheet> {
  late String _selectedStatus;
  bool _isLoading = false;

  final List<String> _statuses = [
    'SCHEDULED',
    'CONFIRMED',
    'COMPLETED',
    'CANCELLED',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    await widget.cubit.updateAppointmentStatus(
      widget.appointmentId,
      {'status': _selectedStatus},
    );

    await widget.cubit.fetchAppointments(widget.patientId);

    if (mounted) Navigator.pop(context);
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
            'Appointment Statusunu dəyiş',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),

          DropdownButtonFormField<String>(
            value: _selectedStatus,
            items: _statuses
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedStatus = val);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Status',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _save,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Təsdiqlə'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}