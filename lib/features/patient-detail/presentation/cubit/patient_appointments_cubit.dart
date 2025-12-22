import 'package:dental_mobile/features/patients/data/patients_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';

part 'patient_appointments_state.dart';

class PatientAppointmentsCubit extends Cubit<PatientAppointmentsState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  PatientAppointmentsCubit(this.api, this.storage)
    : super(PatientAppointmentsInitial());

  Future<void> fetchAppointments(int patientId) async {
    emit(PatientAppointmentsLoading());

    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final list = await api.getPatientAppointments(token, patientId);

      emit(PatientAppointmentsLoaded(list));
    } catch (e) {
      emit(PatientAppointmentsError(e.toString()));
    }
  }
}
