import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';
import '../../../../core/error/error_handler.dart';

part 'patient_appointment_creation_state.dart';

class PatientAppointmentCreationCubit extends Cubit<PatientAppointmentCreationState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  PatientAppointmentCreationCubit(this.api, this.storage)
      : super(PatientAppointmentCreationInitial());

  Future<void> createAppointment(
      int patientId, Map<String, dynamic> appointmentData) async {
    emit(PatientAppointmentCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.createAppointment(patientId, token, appointmentData);
      
      emit(PatientAppointmentCreationSuccess());
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(PatientAppointmentCreationError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}
