// features/home/presentation/cubit/stats_state.dart
part of 'stats_cubit.dart';

abstract class StatsState {}

class StatsInitial extends StatsState {}
class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final int todayAppointments;
  final int totalPatients;
  final Map<String, dynamic>? nextAppointment;

  StatsLoaded({
    required this.todayAppointments,
    required this.totalPatients,
    this.nextAppointment,
  });
}

class StatsError extends StatsState {
  final String message;
  StatsError(this.message);
}