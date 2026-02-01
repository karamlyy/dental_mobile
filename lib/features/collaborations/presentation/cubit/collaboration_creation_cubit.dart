import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/collaborations_api.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'collaboration_creation_state.dart';

class CollaborationCreationCubit extends Cubit<CollaborationCreationState> {
  final CollaborationsApi api;
  final SecureStorage storage;
  final AnalyticsService analytics;

  CollaborationCreationCubit(this.api, this.storage, this.analytics) : super(CollaborationCreationInitial());

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

      final result = await api.createCollaboration(token, body);
      
      // Track collaboration creation in Analytics
      // Handle id as either String or int from backend
      final dynamic idValue = result['id'];
      final int? collaborationId = idValue != null 
          ? (idValue is int ? idValue : int.tryParse(idValue.toString()))
          : null;
      await analytics.logCollaborationCreated(
        collaborationId: collaborationId,
        type: serviceName,
      );
      
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
