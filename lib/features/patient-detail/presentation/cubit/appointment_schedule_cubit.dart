import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';
import '../../../../core/error/error_handler.dart';

part 'appointment_schedule_state.dart';

class AppointmentScheduleCubit extends Cubit<AppointmentScheduleState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  AppointmentScheduleCubit(this.api, this.storage)
      : super(AppointmentScheduleInitial());

  Future<void> loadSchedule(String date) async {
    emit(AppointmentScheduleLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final schedule = await api.getSchedule(token, date);
      emit(AppointmentScheduleLoaded(schedule));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(AppointmentScheduleError(error.message));
    }
  }
}
