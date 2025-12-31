part of 'appointment_schedule_cubit.dart';

abstract class AppointmentScheduleState {}

class AppointmentScheduleInitial extends AppointmentScheduleState {}

class AppointmentScheduleLoading extends AppointmentScheduleState {}

class AppointmentScheduleLoaded extends AppointmentScheduleState {
  final List<Map<String, dynamic>> schedule;
  AppointmentScheduleLoaded(this.schedule);
}

class AppointmentScheduleError extends AppointmentScheduleState {
  final String message;
  AppointmentScheduleError(this.message);
}
