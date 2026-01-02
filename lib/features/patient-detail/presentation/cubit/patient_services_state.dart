abstract class PatientServicesState {}

class PatientServicesInitial extends PatientServicesState {}

class PatientServicesLoading extends PatientServicesState {}

class PatientServicesLoaded extends PatientServicesState {
  final List<Map<String, dynamic>> services;

  PatientServicesLoaded(this.services);
}

class PatientServicesError extends PatientServicesState {
  final String message;

  PatientServicesError(this.message);
}
