abstract class PatientServiceCreationState {}

class PatientServiceCreationInitial extends PatientServiceCreationState {}

class PatientServiceCreationLoading extends PatientServiceCreationState {}

class PatientServiceCreationSuccess extends PatientServiceCreationState {}

class PatientServiceCreationError extends PatientServiceCreationState {
  final String message;
  PatientServiceCreationError(this.message);
}
