import 'package:dental_mobile/config/theme/text_theme_extension.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'stat_card.dart';

class HomeStats extends StatelessWidget {
  const HomeStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StatsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatCard(
                    title: 'Bu gün görüş sayı',
                    value: state.todayAppointments.toString(),
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 12),
                  StatCard(
                    title: 'Pasiyentlər',
                    value: state.totalPatients.toString(),
                    color: Colors.green,
                    onTap: () => context.push('/patients'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (state.nextAppointment != null) ...[
                Text('Növbəti görüş',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: 4),
                              Text(
                                state.nextAppointment!['startTime'],
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Appointment info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.nextAppointment?['patientName'] ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).extension<AppTextColors>()?.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                state.nextAppointment?['date']?.substring(0, 10) ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).extension<AppTextColors>()?.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        }

        if (state is StatsError) {
          return Text(state.message);
        }

        return const SizedBox();
      },
    );
  }
}
