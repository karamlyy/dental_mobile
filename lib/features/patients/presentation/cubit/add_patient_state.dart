part of 'add_patient_cubit.dart';

enum AddPatientStatus { initial, loading, success, error }

class AddPatientState {
  final String fullName;
  final String phone;
  final AddPatientStatus status;
  final String? errorMessage;
  final String? error;
  final int? statusCode;

  const AddPatientState({
    this.fullName = '',
    this.phone = '',
    this.status = AddPatientStatus.initial,
    this.errorMessage,
    this.error,
    this.statusCode,
  });

  AddPatientState copyWith({
    String? fullName,
    String? phone,
    AddPatientStatus? status,
    String? errorMessage,
    String? error,
    int? statusCode,
  }) {
    return AddPatientState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      error: error ?? this.error,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}
