import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/config/theme/text_theme_extension.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'stat_card.dart';

class HomeStats extends StatelessWidget {
  const HomeStats({super.key});



  Future<void> callPatient(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $phone');
    }
  }

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return const LoadingIndicator();
        }

        if (state is StatsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatCard(
                    title: l10n.appointments,
                    value: state.todayAppointments.toString(),
                    color: Colors.blue,
                    icon: CupertinoIcons.calendar_today,
                    subtitle: l10n.today,
                    useGradient: true,
                  ),
                  const SizedBox(width: 12),
                  StatCard(
                    title: l10n.patients,
                    value: state.totalPatients.toString(),
                    color: Colors.green,
                    icon: CupertinoIcons.person_2_fill,
                    subtitle: l10n.overall,
                    useGradient: true,
                    onTap: () => context.push('/patients'),
                    iconButton: IconButton(
                      onPressed: () => context.push('/add-patient'),
                      icon: const Icon(CupertinoIcons.add, color: Colors.green, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (state.nextAppointment != null) ...[
                Text(l10n.nextAppointment, style: Theme.of(context).textTheme.titleMedium),
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
                              Icon(CupertinoIcons.clock, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: 4),
                              Text(
                                state.nextAppointment?['startTime'] ?? '--:--',
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
                                state.nextAppointment?['date'] != null
                                    ? DateTime.parse(state.nextAppointment!['date'])
                                        .toLocal()
                                        .toIso8601String()
                                        .substring(0, 10)
                                    : '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).extension<AppTextColors>()?.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => callPatient(state.nextAppointment!['phone']),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              CupertinoIcons.phone,
                              color: Colors.green,
                              size: 20,
                            ),
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
