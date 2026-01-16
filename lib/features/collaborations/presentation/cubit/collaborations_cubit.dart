import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/collaborations_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/cache/cache_service.dart';

part 'collaborations_state.dart';

class CollaborationsCubit extends Cubit<CollaborationsState> {
  final CollaborationsApi api;
  final SecureStorage storage;
  final CacheService cache;

  CollaborationsCubit(this.api, this.storage, this.cache) : super(CollaborationsInitial());

  Future<void> fetchCollaborations({bool fromCache = true}) async {
    // If fromCache is true, try to load from cache first
    if (fromCache) {
      final cachedData = cache.getCachedCollaborations();
      if (cachedData != null && cachedData.isNotEmpty) {
        emit(CollaborationsLoaded(cachedData));
        // Continue to fetch fresh data in background
        _fetchAndUpdateCollaborations();
        return;
      }
    }

    // No cache available, show loading
    emit(CollaborationsLoading());
    await _fetchAndUpdateCollaborations();
  }

  Future<void> _fetchAndUpdateCollaborations() async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final collaborations = await api.getCollaborations(token);
      
      // Cache the fresh data
      await cache.cacheCollaborations(collaborations);
      
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
      await fetchCollaborations(fromCache: false); // Reload the list (force refresh)
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
      await fetchCollaborations(fromCache: false); // Reload the list (force refresh)
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
