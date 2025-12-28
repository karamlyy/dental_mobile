import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/patients_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  final PatientsApi api;
  final SecureStorage storage;
  Timer? _debounce;

  PatientsCubit(this.api, this.storage) : super(PatientsInitial());

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchPatients(search: query);
    });
  }

  Future<void> fetchPatients({String? search}) async {
    emit(PatientsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final patients = await api.getPatients(token, search: search);
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

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}