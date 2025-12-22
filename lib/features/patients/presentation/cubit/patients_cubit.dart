import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/patients_api.dart';
import '../../../../core/storage/secure_storage.dart';

part 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  final PatientsApi api;
  final SecureStorage storage;

  PatientsCubit(this.api, this.storage) : super(PatientsInitial());

  Future<void> fetchPatients() async {
    emit(PatientsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final patients = await api.getPatients(token);
      emit(PatientsLoaded(patients));
    } catch (e) {
      emit(PatientsError(e.toString()));
    }
  }

  Future<void> addPatient(String fullName, String phone) async {
    emit(PatientsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await fetchPatients();
    } catch (e) {
      emit(PatientsError(e.toString()));
    }
  }
}