import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';
import 'patient_note_creation_state.dart';

class PatientNoteCreationCubit extends Cubit<PatientNoteCreationState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  PatientNoteCreationCubit(this.api, this.storage)
      : super(PatientNoteCreationInitial());

  Future<void> createNote({
    required int patientId,
    required String note,
  }) async {
    emit(PatientNoteCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.createNote(patientId, token, {
        'note': note,
      });

      emit(PatientNoteCreationSuccess());
    } catch (e) {
      emit(PatientNoteCreationError(e.toString()));
    }
  }
}
