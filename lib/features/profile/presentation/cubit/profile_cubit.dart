import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/profile_api.dart';
import '../../data/models/user_profile_model.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/cache/cache_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileApi api;
  final SecureStorage storage;
  final CacheService cache;

  ProfileCubit(this.api, this.storage, this.cache) : super(ProfileInitial());

  Future<void> fetchProfile({bool fromCache = true}) async {
    // If fromCache is true, try to load from cache first
    if (fromCache) {
      final cachedData = cache.getCachedProfile();
      if (cachedData != null) {
        try {
          final profile = UserProfileModel.fromJson(cachedData);
          emit(ProfileLoaded(profile));
          // Continue to fetch fresh data in background
          _fetchAndUpdateProfile();
          return;
        } catch (e) {
          // If cached data is corrupted, continue to normal fetch
        }
      }
    }

    // No cache available, show loading
    emit(ProfileLoading());
    await _fetchAndUpdateProfile();
  }

  Future<void> _fetchAndUpdateProfile() async {
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final profileData = await api.getProfile(token);
      final profile = UserProfileModel.fromJson(profileData);
      
      // Cache the fresh data
      await cache.cacheProfile(profileData);
      
      if (isClosed) return;
      emit(ProfileLoaded(profile));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ProfileError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  void clear() {
    emit(ProfileInitial());
  }
}
