import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/presentation/cubit/appointments_cubit.dart';
import '../../../home/presentation/cubit/stats_cubit.dart';
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
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        isStart ? _startTime = picked : _endTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarix və vaxt seçin')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await widget.cubit.createAppointment(
      widget.patientId,
      {
        'date': _selectedDate!.toIso8601String(),
        'startTime': _formatTime(_startTime!),
        'endTime': _formatTime(_endTime!),
      },
    );

    if (mounted) {
      context.read<StatsCubit>().fetchStats();
      context.read<AppointmentsCubit>().fetchAppointments();
      Navigator.pop(context);
    }
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
              'Yeni appointment',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pasiyent üçün görüş vaxtı təyin edin',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            /// 📅 Date card
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                onTap: _pickDate,
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Tarix'),
                subtitle: Text(
                  _selectedDate == null
                      ? 'Tarix seçin'
                      : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),

            const SizedBox(height: 16),

            /// ⏰ Time cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      onTap: () => _pickTime(true),
                      leading: const Icon(Icons.schedule_outlined),
                      title: const Text('Başlama'),
                      subtitle: Text(
                        _startTime == null
                            ? '--:--'
                            : _formatTime(_startTime!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 0,
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      onTap: () => _pickTime(false),
                      leading: const Icon(Icons.schedule_outlined),
                      title: const Text('Bitmə'),
                      subtitle: Text(
                        _endTime == null ? '--:--' : _formatTime(_endTime!),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const SizedBox(height: 24),

            /// 🔹 Action button
            PrimaryButton(
              text: 'Görüş yarat',
              onPressed: _isLoading ? null : _save,
              icon: _isLoading ? null : Icons.add,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}