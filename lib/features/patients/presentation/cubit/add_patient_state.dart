part of 'add_patient_cubit.dart';

enum AddPatientStatus { initial, loading, success, error }

class AddPatientState {
  final String fullName;
  final String phone;
  final AddPatientStatus status;
  final String? errorMessage;

  const AddPatientState({
    this.fullName = '',
    this.phone = '',
    this.status = AddPatientStatus.initial,
    this.errorMessage,
  });

  AddPatientState copyWith({
    String? fullName,
    String? phone,
    AddPatientStatus? status,
    String? errorMessage,
  }) {
    return AddPatientState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
