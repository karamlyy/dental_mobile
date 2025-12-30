import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../home/data/appointments_api.dart';
import 'appointments_page_state.dart';

class AppointmentsPageCubit extends Cubit<AppointmentsPageState> {
  final AppointmentsApi api;
  final SecureStorage storage;

  AppointmentsPageCubit(this.api, this.storage) : super(AppointmentsPageInitial());

  Future<void> fetchAppointments() async {
    emit(AppointmentsPageLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final appointments = await api.getAppointments(token);
      
      // Sort by date descending (newest first) or ascending? 
      // Usually for appointments, upcoming first (ascending date).
      // The API returns List, we should probably sort it.
      // Date format is likely ISO8601 string.
      appointments.sort((a, b) {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });

      emit(AppointmentsPageLoaded(appointments));
    } catch (e) {
      emit(AppointmentsPageError(e.toString()));
    }
  }
}
