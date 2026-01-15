import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/collaborations_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'collaborations_state.dart';

class CollaborationsCubit extends Cubit<CollaborationsState> {
  final CollaborationsApi api;
  final SecureStorage storage;

  CollaborationsCubit(this.api, this.storage) : super(CollaborationsInitial());

  Future<void> fetchCollaborations() async {
    emit(CollaborationsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final collaborations = await api.getCollaborations(token);
      if (isClosed) return;
      emit(CollaborationsLoaded(collaborations));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(CollaborationsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> updateCollaboration(String collaborationId, Map<String, dynamic> body) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.updateCollaboration(token, collaborationId, body);
      await fetchCollaborations(); // Reload the list
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(CollaborationsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> deleteCollaboration(String collaborationId) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.deleteCollaboration(token, collaborationId);
      await fetchCollaborations(); // Reload the list
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(CollaborationsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  void clear() {
    emit(CollaborationsInitial());
  }
}
