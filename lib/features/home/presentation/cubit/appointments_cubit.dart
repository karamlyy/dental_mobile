import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/appointments_api.dart';
import '../../../../core/storage/secure_storage.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentsApi api;
  final SecureStorage storage;

  AppointmentsCubit(this.api, this.storage) : super(AppointmentsInitial());

  Future<void> fetchAppointments() async {
    emit(AppointmentsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final appointments = await api.getAppointments(token);

      // Filter next 3 days
      final now = DateTime.now();
      final threeDaysLater = now.add(const Duration(days: 3));
      final upcoming = appointments.where((a) {
        final date = DateTime.parse(a['date']);
        return date.isAfter(now.subtract(const Duration(days:1))) &&
            date.isBefore(threeDaysLater.add(const Duration(days:1)));
      }).toList();

      if (isClosed) return;
      emit(AppointmentsLoaded(upcoming));
    } catch (e) {
      if (isClosed) return;
      emit(AppointmentsError(e.toString()));
    }
  }
}