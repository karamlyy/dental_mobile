import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/collaborations_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'collaboration_creation_state.dart';

class CollaborationCreationCubit extends Cubit<CollaborationCreationState> {
  final CollaborationsApi api;
  final SecureStorage storage;

  CollaborationCreationCubit(this.api, this.storage) : super(CollaborationCreationInitial());

  Future<void> addCollaboration({
    required String technicianName,
    required String serviceName,
    required double price,
    required String description,
  }) async {
    emit(CollaborationCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final body = {
        'technicianName': technicianName,
        'serviceName': serviceName,
        'price': price,
        'description': description,
      };

      await api.createCollaboration(token, body);
      if (isClosed) return;
      emit(CollaborationCreationSuccess());
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(CollaborationCreationError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}
