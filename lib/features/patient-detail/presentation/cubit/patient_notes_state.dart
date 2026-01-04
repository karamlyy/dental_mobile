abstract class PatientNotesState {}

class PatientNotesInitial extends PatientNotesState {}

class PatientNotesLoading extends PatientNotesState {}

class PatientNotesLoaded extends PatientNotesState {
  final List<Map<String, dynamic>> notes;
  PatientNotesLoaded(this.notes);
}

class PatientNotesError extends PatientNotesState {
  final String message;
  PatientNotesError(this.message);
}
