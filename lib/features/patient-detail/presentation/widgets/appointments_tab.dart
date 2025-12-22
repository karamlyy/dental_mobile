import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patient-detail/presentation/cubit/patient_appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'status_dot.dart';
import 'add_appointment_sheet.dart';

class AppointmentsTab extends StatelessWidget {
  final int patientId;
  const AppointmentsTab({super.key, required this.patientId});

  String _formatDate(String iso) {
    final date = DateTime.parse(iso);
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientAppointmentsCubit>()
        ..fetchAppointments(patientId),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PatientAppointmentsCubit,
            PatientAppointmentsState>(
          builder: (context, state) {
            if (state is PatientAppointmentsLoading) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            if (state is PatientAppointmentsLoaded) {
              if (state.appointments.isEmpty) {
                return const Center(
                    child: Text('Appointment yoxdur'));
              }

              return ListView.builder(
                itemCount: state.appointments.length,
                itemBuilder: (context, index) {
                  final appt = state.appointments[index];

                  return ListTile(
                    leading: StatusDot(appt['status']),
                    title: Text(
                      '${appt['startTime']} - ${appt['endTime']}',
                    ),
                    subtitle: Text(
                      _formatDate(appt['date']),
                    ),
                    trailing: Text(
                      appt['status'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                  );
                },
              );
            }

            if (state is PatientAppointmentsError) {
              return Center(
                  child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddAppointmentSheet(
                    patientId: patientId,
                    cubit: context.read<PatientAppointmentsCubit>(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }
}