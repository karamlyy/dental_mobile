import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/profile_api.dart';
import '../../data/models/user_profile_model.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileApi api;
  final SecureStorage storage;

  ProfileCubit(this.api, this.storage) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final profileData = await api.getProfile(token);
      final profile = UserProfileModel.fromJson(profileData);
      
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
