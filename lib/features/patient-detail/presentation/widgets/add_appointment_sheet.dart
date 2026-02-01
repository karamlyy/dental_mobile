import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_appointment_creation_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:another_flushbar/flushbar.dart';
import '../cubit/patient_appointments_cubit.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/appointment_schedule_cubit.dart';
import 'package:dental_mobile/features/patient-detail/presentation/widgets/day_schedule_view.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';

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
    final currentTime = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        isStart ? _startTime = picked : _endTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  TimeOfDay _addMinutesToTime(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  void _save(BuildContext context) {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      Flushbar(
        message: 'Tarix və vaxt seçin',
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    if (endMinutes <= startMinutes) {
      Flushbar(
        message: AppLocalizations.of(context)!.endTimeBeforeStartTime,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
      return;
    }

    context.read<PatientAppointmentCreationCubit>().createAppointment(
      widget.patientId,
      {
        'date': _selectedDate!.toIso8601String().split('T')[0],
        'startTime': _formatTime(_startTime!),
        'endTime': _formatTime(_endTime!),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PatientAppointmentCreationCubit>()),
        BlocProvider(create: (_) => sl<AppointmentScheduleCubit>()),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<PatientAppointmentCreationCubit, PatientAppointmentCreationState>(
            listener: (context, state) {
              if (state is PatientAppointmentCreationError) {
                ErrorBottomSheet.show(
                  context,
                  AppError(
                    message: state.message,
                    error: state.error,
                    statusCode: state.statusCode,
                  ),
                );
              } else if (state is PatientAppointmentCreationSuccess) {
                widget.cubit.fetchAppointments(widget.patientId); // Refresh the list
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<PatientAppointmentCreationCubit, PatientAppointmentCreationState>(
              builder: (context, state) {
                final isLoading = state is PatientAppointmentCreationLoading;
                final maxHeight = MediaQuery.of(context).size.height - 
                                 MediaQuery.of(context).padding.top - 
                                 kToolbarHeight - 
                                 20;
                
                return SafeArea(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
                        left: 16,
                        right: 16,
                        top: 8,
                      ),
                      child: SingleChildScrollView(
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
                          l10n.newAppointment,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.arrangeNewAppointmentForPatient,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
            
                        const SizedBox(height: 24),
            
                        /// 📅 Date card
                        Card(
                          elevation: 0,
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            onTap: () async {
                              await _pickDate();
                              if (_selectedDate != null && context.mounted) {
                                final dateStr = _selectedDate!.toIso8601String().split('T')[0];
                                context.read<AppointmentScheduleCubit>().loadSchedule(dateStr);
                              }
                            },
                            leading: const Icon(Icons.calendar_month_outlined),
                            title: Text(l10n.date),
                            subtitle: Text(
                              _selectedDate == null
                                  ? l10n.selectDate
                                  : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
            
                        const SizedBox(height: 16),
                        
                        // Schedule View
                        if (_selectedDate != null)
                          BlocBuilder<AppointmentScheduleCubit, AppointmentScheduleState>(
                            builder: (context, scheduleState) {
                              if (scheduleState is AppointmentScheduleLoading) {
                                return const LoadingIndicator();
                              } else if (scheduleState is AppointmentScheduleLoaded) {
                                return DayScheduleView(
                                  selectedDate: _selectedDate!,
                                  selectedStartTime: _startTime,
                                  appointments: scheduleState.schedule,
                                  onTimeSelected: (time) {
                                    setState(() {
                                      _startTime = time;
                                    });
                                  },
                                );
                              } else if (scheduleState is AppointmentScheduleError) {
                                return Text(scheduleState.message, style: const TextStyle(color: Colors.red));
                              }
                              return const SizedBox.shrink();
                            },
                          ),

                        const SizedBox(height: 16),

                        // Duration chips - shown when start time is selected
                        if (_startTime != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Müddət',
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 8,
                                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final durations = [15, 30, 45, 60, 90, 120, 150, 180];
                                    final minutes = durations[index];
                                    final endTime = _addMinutesToTime(_startTime!, minutes);
                                    final isSelected = _endTime != null && 
                                        _endTime!.hour == endTime.hour && 
                                        _endTime!.minute == endTime.minute;
                                    
                                    final label = minutes >= 60 
                                        ? '${minutes ~/ 60} saat${minutes % 60 > 0 ? ' ${minutes % 60} dəq' : ''}'
                                        : '$minutes dəq';
                                    
                                    return ChoiceChip(
                                      label: Text(label),
                                      selected: isSelected,
                                      onSelected: (_) {
                                        setState(() {
                                          _endTime = endTime;
                                        });
                                      },
                                      selectedColor: theme.colorScheme.primary,
                                      labelStyle: TextStyle(
                                        color: isSelected ? theme.colorScheme.onPrimary : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
            
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
                                  title: Text(l10n.startTime, style: TextStyle(
                                    fontSize: 10
                                  ),),
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
                                  title: Text(l10n.endTime, style: TextStyle(
                                      fontSize: 10
                                  ),),
                                  subtitle: Text(
                                    _endTime == null ? '--:--' : _formatTime(_endTime!),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
            
                        const SizedBox(height: 24),
            
                        /// 🔹 Action button
                        PrimaryButton(
                          text: l10n.createAppointment,
                          isLoading: isLoading,
                          onPressed: () => _save(context),
                          icon: Icons.add,
                        ),
                      ],
                    ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      ),
    );
  }
}