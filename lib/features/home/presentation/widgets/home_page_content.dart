import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:dental_mobile/features/home/presentation/widgets/home_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeStats(),
          const SizedBox(height: 20),
          Text('Növbəti görüşlər', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
              builder: (context, state) {
                if (state is AppointmentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AppointmentsLoaded) {
                  if (state.appointments.isEmpty) {
                    return const Center(
                        child: Text('Növbəti 3 gün üçün appointment yoxdur',
                            style: TextStyle(fontSize: 16)));
                  }
                  return ListView.separated(
                    itemCount: state.appointments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      final a = state.appointments[index];
                      final patient = a['patient'];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,

                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status indicator
                              Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.only(top: 4, right: 12),
                                decoration: BoxDecoration(
                                  color: _statusColor(a['status']),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      patient['fullName'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${a['date'].substring(0, 10)} | ${a['startTime']} - ${a['endTime']}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color:
                                  _statusColor(a['status']).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _statusLabel(a['status']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _statusColor(a['status']),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is AppointmentsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}