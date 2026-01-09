import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/appointments_api.dart';
import '../../../../core/storage/secure_storage.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final AppointmentsApi api;
  final SecureStorage storage;
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  final List<dynamic> animatedListItems = [];

  AppointmentsCubit(this.api, this.storage) : super(AppointmentsInitial());

  Future<void> fetchAppointments() async {
    emit(AppointmentsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final appointments = await api.getAppointments(token);

      // Filter next 3 days
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final threeDaysLater = today.add(const Duration(days: 3));

      final upcoming = appointments.where((a) {
        final date = DateTime.parse(a['date']).toLocal();
        // Check if date is today or in the future (within next 3 days)
        // We use !isBefore(today) to include today since date is likely just YYYY-MM-DD (midnight)
        return !date.isBefore(today) &&
            date.isBefore(threeDaysLater.add(const Duration(days: 1))) &&
            a['status'] == 'CONFIRMED';
      }).toList();

      if (isClosed) return;
      emit(AppointmentsLoaded(upcoming));
    } catch (e) {
      if (isClosed) return;
      emit(AppointmentsError(e.toString()));
    }
  }

  void clear() {
    emit(AppointmentsInitial());
  }
}