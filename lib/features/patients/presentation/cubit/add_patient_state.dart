part of 'add_patient_cubit.dart';

enum AddPatientStatus { initial, loading, success, error }

class AddPatientState {
  final String fullName;
  final String phone;
  final String gender;
  final AddPatientStatus status;
  final String? errorMessage;
  final String? error;
  final int? statusCode;

  const AddPatientState({
    this.fullName = '',
    this.phone = '',
    this.gender = 'MALE',
    this.status = AddPatientStatus.initial,
    this.errorMessage,
    this.error,
    this.statusCode,
  });

  AddPatientState copyWith({
    String? fullName,
    String? phone,
    String? gender,
    AddPatientStatus? status,
    String? Function()? errorMessage,
    String? Function()? error,
    int? Function()? statusCode,
  }) {
    return AddPatientState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      error: error != null ? error() : this.error,
      statusCode: statusCode != null ? statusCode() : this.statusCode,
    );
  }
}
