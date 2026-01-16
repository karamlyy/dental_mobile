import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/cache/cache_service.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesApi api;
  final SecureStorage storage;
  final CacheService cache;

  ServicesCubit(this.api, this.storage, this.cache) : super(ServicesInitial());

  Future<void> fetchServices({bool fromCache = true}) async {
    // If fromCache is true, try to load from cache first
    if (fromCache) {
      final cachedData = cache.getCachedServices();
      if (cachedData != null && cachedData.isNotEmpty) {
        emit(ServicesLoaded(cachedData));
        // Continue to fetch fresh data in background
        _fetchAndUpdateServices();
        return;
      }
    }

    // No cache available, show loading
    emit(ServicesLoading());
    await _fetchAndUpdateServices();
  }

  Future<void> _fetchAndUpdateServices() async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final services = await api.getServices(token);
      
      // Cache the fresh data
      await cache.cacheServices(services);
      
      if (isClosed) return;
      emit(ServicesLoaded(services));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ServicesError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> updateService(int serviceId, Map<String, dynamic> body) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      // Keep current state while updating
      final currentState = state;
      if (currentState is ServicesLoaded) {
        emit(ServicesLoaded(currentState.services));
      }

      await api.updateService(token, serviceId, body);
      
      // Refresh the services list after update (force refresh, skip cache)
      await fetchServices(fromCache: false);
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ServicesError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> deleteService(int serviceId) async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      // Keep current state while deleting
      final currentState = state;
      if (currentState is ServicesLoaded) {
        emit(ServicesLoaded(currentState.services));
      }

      await api.deleteService(token, serviceId);
      
      // Refresh the services list after deletion (force refresh, skip cache)
      await fetchServices(fromCache: false);
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ServicesError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  void clear() {
    emit(ServicesInitial());
  }
}
