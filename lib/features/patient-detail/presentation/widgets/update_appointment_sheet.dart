import 'package:dental_mobile/common/widgets/primary_button.dart';
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
  State<UpdateAppointmentSheet> createState() =>
      _UpdateAppointmentSheetState();
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

  final Map<String, String> _statusLabels = {
    'SCHEDULED': 'Planlaşdırılıb',
    'CONFIRMED': 'Təsdiqlənib',
    'COMPLETED': 'Tamamlandı',
    'CANCELLED': 'Ləğv edildi',
  };

  final Map<String, IconData> _statusIcons = {
    'SCHEDULED': Icons.schedule_outlined,
    'CONFIRMED': Icons.check_circle_outline,
    'COMPLETED': Icons.done_all,
    'CANCELLED': Icons.cancel_outlined,
  };

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
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
          left: 16,
          right: 16,
          top: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 🔹 Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            /// 🔹 Title
            Text(
              'Appointment statusu',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Görüşün cari vəziyyətini dəyişin',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            /// 🔄 Status selector (Card style)
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(
                          _statusIcons[status],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(_statusLabels[status]!),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStatus = val);
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// 🔹 Action button
            PrimaryButton(
              text: 'Təsdiqlə',
              onPressed: _isLoading ? null : _save,
              icon: _isLoading ? null : Icons.check,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}