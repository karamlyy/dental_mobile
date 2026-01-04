import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/patient_detail_api.dart';
import 'patient_notes_state.dart';

class PatientNotesCubit extends Cubit<PatientNotesState> {
  final PatientDetailApi api;
  final SecureStorage storage;

  PatientNotesCubit(this.api, this.storage) : super(PatientNotesInitial());

  Future<void> fetchNotes(int patientId) async {
    try {
      emit(PatientNotesLoading());
      final token = await storage.read('accessToken');
      if (token == null) {
        emit(PatientNotesError('Unauthorized'));
        return;
      }

      final notes = await api.getPatientNotes(token, patientId);
      emit(PatientNotesLoaded(notes));
    } catch (e) {
      emit(PatientNotesError(e.toString()));
    }
  }
}
