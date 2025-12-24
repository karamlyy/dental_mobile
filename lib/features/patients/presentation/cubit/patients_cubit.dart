import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/patients_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

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
      if (isClosed) return;
      emit(PatientsLoaded(patients));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(PatientsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> addPatient(String fullName, String phone) async {
    emit(PatientsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.createPatient(token, {
        'fullName': fullName,
        'phone': phone,
      });

      await fetchPatients();
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(PatientsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}