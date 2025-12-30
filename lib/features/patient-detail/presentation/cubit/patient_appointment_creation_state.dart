part of 'patient_appointment_creation_cubit.dart';

abstract class PatientAppointmentCreationState {}

class PatientAppointmentCreationInitial extends PatientAppointmentCreationState {}

class PatientAppointmentCreationLoading extends PatientAppointmentCreationState {}

class PatientAppointmentCreationSuccess extends PatientAppointmentCreationState {}

class PatientAppointmentCreationError extends PatientAppointmentCreationState {
  final String message;
  final String? error;
  final int? statusCode;

  PatientAppointmentCreationError(this.message, {this.error, this.statusCode});
}
