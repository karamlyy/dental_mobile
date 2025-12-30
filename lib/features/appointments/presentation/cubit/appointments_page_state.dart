
abstract class AppointmentsPageState {
  const AppointmentsPageState();

  @override
  List<Object> get props => [];
}

class AppointmentsPageInitial extends AppointmentsPageState {}

class AppointmentsPageLoading extends AppointmentsPageState {}

class AppointmentsPageLoaded extends AppointmentsPageState {
  final List<Map<String, dynamic>> appointments;
  final String filter; // 'all', 'upcoming', 'past', 'cancelled' etc. currently just 'all'

  const AppointmentsPageLoaded(this.appointments, {this.filter = 'all'});

  @override
  List<Object> get props => [appointments, filter];
}

class AppointmentsPageError extends AppointmentsPageState {
  final String message;

  const AppointmentsPageError(this.message);

  @override
  List<Object> get props => [message];
}
