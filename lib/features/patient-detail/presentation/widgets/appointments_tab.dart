import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'status_dot.dart';
import 'add_appointment_sheet.dart';
import 'update_appointment_sheet.dart';

class AppointmentsTab extends StatelessWidget {
  final int patientId;
  const AppointmentsTab({super.key, required this.patientId});

  String _formatDate(String iso) {
    final date = DateTime.parse(iso);
    return '${date.day}.${date.month}.${date.year}';
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'SCHEDULED':
        return 'Planlaşdırılıb';
      case 'CONFIRMED':
        return 'Təsdiqlənib';
      case 'COMPLETED':
        return 'Tamamlanıb';
      case 'CANCELLED':
        return 'Ləğv edilib';
      case 'NO_SHOW':
        return 'Gəlmədi';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'SCHEDULED':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientAppointmentsCubit>()..fetchAppointments(patientId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
          builder: (context, state) {
            if (state is PatientAppointmentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PatientAppointmentsLoaded) {
              if (state.appointments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Bu pasiyentin hələ görüşü yoxdur',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final appt = state.appointments[index];

                  return GestureDetector(
                    onTap: () {
                      final cubit = context.read<PatientAppointmentsCubit>();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => UpdateAppointmentSheet(
                          appointmentId: appt['id'],
                          currentStatus: appt['status'],
                          cubit: cubit,
                          patientId: patientId,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),


                      ),
                      child: Row(
                        children: [
                          StatusDot(appt['status']),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${appt['startTime']} - ${appt['endTime']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(appt['date']),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(appt['status']).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(

                              _statusLabel(appt['status'],),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(appt['status']),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is PatientAppointmentsError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final cubit = context.read<PatientAppointmentsCubit>();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddAppointmentSheet(
                    patientId: patientId,
                    cubit: cubit,
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
