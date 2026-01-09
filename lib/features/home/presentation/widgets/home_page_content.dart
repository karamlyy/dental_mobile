import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:dental_mobile/features/home/presentation/widgets/home_stats.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<AppointmentsCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeStats(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.nextAppointments, style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  context.push('/appointments');
                },
                child: const Text('Hamısına bax'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocConsumer<AppointmentsCubit, AppointmentsState>(
              listener: (context, state) {
                if (state is AppointmentsLoaded) {
                  _refreshList(state.appointments, cubit, context);
                }
              },
              builder: (context, state) {
                if (state is AppointmentsLoading) {
                  return const LoadingIndicator();
                } else if (state is AppointmentsLoaded) {
                  if (state.appointments.isEmpty && cubit.animatedListItems.isEmpty) {
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/noData.svg',
                              width: 200,
                              height: 200,
                            ),
                            const SizedBox(height: 16),
                            Text('Növbəti 3 gündə təsdiqlənmiş görüş yoxdur',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ));
                  }
                  return AnimatedList(
                    key: cubit.listKey,
                    initialItemCount: cubit.animatedListItems.length,
                    itemBuilder: (context, index, animation) {
                      if (index >= cubit.animatedListItems.length) {
                        return const SizedBox();
                      }
                      final a = cubit.animatedListItems[index];
                      return _buildItem(a, animation, l10n, context);
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

  void _refreshList(List<dynamic> newAppointments, AppointmentsCubit cubit, BuildContext context) {
    for (var i = cubit.animatedListItems.length - 1; i >= 0; i--) {
       final removedItem = cubit.animatedListItems.removeAt(i);
       cubit.listKey.currentState?.removeItem(
         i, 
         (context, animation) => _buildItem(removedItem, animation, AppLocalizations.of(context)!, context),
       );
    }
    
    Future.forEach(newAppointments.asMap().entries, (entry) async {
      await Future.delayed(const Duration(milliseconds: 50));
      cubit.animatedListItems.add(entry.value);
      cubit.listKey.currentState?.insertItem(cubit.animatedListItems.length - 1);
    });
  }

  Widget _buildItem(dynamic a, Animation<double> animation, AppLocalizations l10n, BuildContext context) {
    final patient = a['patient'];
    final date = DateTime.parse(a['date']);
    final headerDate = DateFormat('dd MMMM yyyy').format(date);

    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            onTap: () {
              if (patient != null && patient['id'] != null) {
                context.push('/patient/${patient['id']}');
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12), // Add margin for spacing
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          headerDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              a['status'],
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _statusLabel(a['status'], l10n),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _statusColor(a['status']),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patient['fullName'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${a['startTime']} - ${a['endTime']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}