abstract class PatientNoteCreationState {}

class PatientNoteCreationInitial extends PatientNoteCreationState {}

class PatientNoteCreationLoading extends PatientNoteCreationState {}

class PatientNoteCreationSuccess extends PatientNoteCreationState {}

class PatientNoteCreationError extends PatientNoteCreationState {
  final String message;
  PatientNoteCreationError(this.message);
}
