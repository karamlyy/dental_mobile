import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/assistants_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/cache/cache_service.dart';

part 'assistants_state.dart';

class AssistantsCubit extends Cubit<AssistantsState> {
  final AssistantsApi api;
  final SecureStorage storage;
  final CacheService cache;

  AssistantsCubit(this.api, this.storage, this.cache) : super(AssistantsInitial());

  Future<void> fetchAssistants({bool fromCache = true}) async {
    // If fromCache is true, try to load from cache first
    if (fromCache) {
      final cachedData = cache.getCachedAssistants();
      if (cachedData != null && cachedData.isNotEmpty) {
        emit(AssistantsLoaded(cachedData));
        // Continue to fetch fresh data in background
        _fetchAndUpdateAssistants();
        return;
      }
    }

    // No cache available, show loading
    emit(AssistantsLoading());
    await _fetchAndUpdateAssistants();
  }

  Future<void> _fetchAndUpdateAssistants() async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final assistants = await api.getAssistants(token);
      
      // Cache the fresh data
      await cache.cacheAssistants(assistants);
      
      if (isClosed) return;
      emit(AssistantsLoaded(assistants));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(AssistantsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  void clear() {
    emit(AssistantsInitial());
  }
}
