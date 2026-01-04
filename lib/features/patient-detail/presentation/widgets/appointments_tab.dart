import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_appointments_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'status_dot.dart';
import 'add_appointment_sheet.dart';
import 'update_appointment_sheet.dart';

class AppointmentsTab extends StatelessWidget {
  final int patientId;
  const AppointmentsTab({super.key, required this.patientId});

  String _formatDate(String iso) {
    final date = DateTime.parse(iso).toLocal();
    return '${date.day}.${date.month}.${date.year}';
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'SCHEDULED':
        return l10n.scheduled;
      case 'CONFIRMED':
        return l10n.confirmed;
      case 'COMPLETED':
        return l10n.completed;
      case 'CANCELLED':
        return l10n.canceled;
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
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<PatientAppointmentsCubit>()..fetchAppointments(patientId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PatientAppointmentsCubit, PatientAppointmentsState>(
          builder: (context, state) {
            if (state is PatientAppointmentsLoading) {
              return const LoadingIndicator();
            }

            if (state is PatientAppointmentsLoaded) {
              if (state.appointments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/noData.svg',
                        width: 200,
                        height: 200,
                      ),

                      const SizedBox(height: 12),
                       Text(
                        l10n.noAppointmentsFound,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 0),
                itemBuilder: (context, index) {
                  final appt = state.appointments[index];

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(


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

                      leading: StatusDot(appt['status']),

                      title: Text(
                        '${appt['startTime']} - ${appt['endTime']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _formatDate(appt['date']),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),

                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _statusColor(appt['status']).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _statusLabel(appt['status'], l10n),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(appt['status']),
                          ),
                        ),
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
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      l10n.newAppointment,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
