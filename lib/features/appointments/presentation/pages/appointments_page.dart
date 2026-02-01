import 'package:dental_mobile/core/widgets/loading_indicator.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/appointments/presentation/cubit/appointments_page_cubit.dart';
import 'package:dental_mobile/features/appointments/presentation/cubit/appointments_page_state.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentsPageCubit>()..fetchAppointments(),
      child: const AppointmentsView(),
    );
  }
}

class AppointmentsView extends StatelessWidget {
  const AppointmentsView({super.key});

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
    final cubit = context.read<AppointmentsPageCubit>();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appointments),
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: cubit.selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                cubit.changeDate(picked);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: isDarkMode ? 0.02 : 0.7,
              child: SvgPicture.asset(
                'assets/icons/appBackground.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Date strip
              BlocBuilder<AppointmentsPageCubit, AppointmentsPageState>(
                buildWhen: (previous, current) => true, // Rebuild on any state change
                builder: (context, state) {
                  return SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: 30, // Show 30 days
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index - 7)); // 7 days before today to 22 days after
                        final isSelected = _isSameDay(date, cubit.selectedDate);
                        final isToday = _isSameDay(date, DateTime.now());
                        
                        return GestureDetector(
                          onTap: () => cubit.changeDate(date),
                          child: Container(
                            width: 56,
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? theme.colorScheme.primary 
                                  : isToday 
                                      ? theme.colorScheme.primary.withOpacity(0.1)
                                      : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                              border: isToday && !isSelected 
                                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('EEE', 'az').format(date).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected 
                                        ? theme.colorScheme.onPrimary 
                                        : theme.colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected 
                                        ? theme.colorScheme.onPrimary 
                                        : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // Appointments list
              Expanded(
                child: BlocConsumer<AppointmentsPageCubit, AppointmentsPageState>(
                  listener: (context, state) {
                    if (state is AppointmentsPageLoaded) {
                      _refreshList(state.appointments, cubit, context);
                    }
                  },
                  builder: (context, state) {
                    if (state is AppointmentsPageLoading) {
                      return const LoadingIndicator();
                    } else if (state is AppointmentsPageLoaded) {
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
                              Text(l10n.noAppointments),
                            ],
                          ),
                        );
                      }
        
                      return AnimatedList(
                        key: cubit.listKey,
                        padding: const EdgeInsets.all(16),
                        initialItemCount: cubit.animatedListItems.length,
                        itemBuilder: (context, index, animation) {
                          if (index >= cubit.animatedListItems.length) {
                            return const SizedBox();
                          }
                          final a = cubit.animatedListItems[index];
                          return _buildItem(a, animation, l10n, context);
                        },
                      );
                    } else if (state is AppointmentsPageError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _refreshList(
    List<dynamic> newAppointments,
    AppointmentsPageCubit cubit,
    BuildContext context,
  ) {
    // Determine items to remove
    for (var i = cubit.animatedListItems.length - 1; i >= 0; i--) {
      final removedItem = cubit.animatedListItems.removeAt(i);
      cubit.listKey.currentState?.removeItem(
        i,
        (context, animation) => _buildItem(
          removedItem,
          animation,
          AppLocalizations.of(context)!,
          context,
        ),
      );
    }

    // Add new items
    Future.forEach(newAppointments.asMap().entries, (entry) async {
      await Future.delayed(const Duration(milliseconds: 50));
      // Verify usage of cubit list if multiple calls happen?
      // For now assume simple clear-fill logic.
      cubit.animatedListItems.add(entry.value);
      cubit.listKey.currentState?.insertItem(
        cubit.animatedListItems.length - 1,
      );
    });
  }

  Widget _buildItem(
    dynamic a,
    Animation<double> animation,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final patient = a['patient'];
    final date = DateTime.parse(a['date']);
    final headerDate = DateFormat('dd MMMM yyyy').format(date);
    final patientName = patient != null
        ? (patient['fullName'] ?? 'Unknown')
        : 'Unknown';
    final patientId = patient != null ? patient['id'] : null;

    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              if (patientId != null) {
                await context.push('/patient/$patientId');
                // Refresh appointments after returning from patient detail
                if (context.mounted) {
                  context.read<AppointmentsPageCubit>().fetchAppointments();
                }
              }
            },
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
                              patientName,
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
    );
  }
}
