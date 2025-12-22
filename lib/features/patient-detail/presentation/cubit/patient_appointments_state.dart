part of 'patient_appointments_cubit.dart';

abstract class PatientAppointmentsState {}

class PatientAppointmentsInitial
    extends PatientAppointmentsState {}

class PatientAppointmentsLoading
    extends PatientAppointmentsState {}

class PatientAppointmentsLoaded
    extends PatientAppointmentsState {
  final List<Map<String, dynamic>> appointments;
  PatientAppointmentsLoaded(this.appointments);
}

class PatientAppointmentsError
    extends PatientAppointmentsState {
  final String message;
  PatientAppointmentsError(this.message);
}