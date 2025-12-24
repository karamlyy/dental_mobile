import 'package:dental_mobile/features/patient-detail/data/patient_detail_api.dart';
import 'package:dental_mobile/features/patients/data/patients_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';

part 'patient_detail_state.dart';

class PatientDetailCubit extends Cubit<PatientDetailState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  PatientDetailCubit(this.api, this.storage) : super(PatientDetailInitial());

  Future<void> fetchPatient(int id) async {
    emit(PatientDetailLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final patient = await api.getPatientById(token, id);
      if (isClosed) return;
      emit(PatientDetailLoaded(patient));
    } catch (e) {
      if (isClosed) return;
      emit(PatientDetailError(e.toString()));
    }
  }
}
