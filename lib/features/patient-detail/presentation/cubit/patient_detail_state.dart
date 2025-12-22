part of 'patient_detail_cubit.dart';

abstract class PatientDetailState {}

class PatientDetailInitial extends PatientDetailState {}

class PatientDetailLoading extends PatientDetailState {}

class PatientDetailLoaded extends PatientDetailState {
  final Map<String, dynamic> patient;
  PatientDetailLoaded(this.patient);
}

class PatientDetailError extends PatientDetailState {
  final String message;
  PatientDetailError(this.message);
}