part of 'patient_payments_cubit.dart';

abstract class PatientPaymentsState {}

class PatientPaymentsInitial extends PatientPaymentsState {}

class PatientPaymentsLoading extends PatientPaymentsState {}

class PatientPaymentsLoaded extends PatientPaymentsState {
  final List<Map<String, dynamic>> payments;
  PatientPaymentsLoaded(this.payments);
}

class PatientPaymentsError extends PatientPaymentsState {
  final String message;
  final String? error;
  final int? statusCode;

  PatientPaymentsError(this.message, {this.error, this.statusCode});
}
