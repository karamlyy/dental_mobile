import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/profile_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final ProfileApi api;
  final SecureStorage storage;

  ProfileUpdateCubit(this.api, this.storage) : super(ProfileUpdateInitial());

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(ProfileUpdateLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.updateProfile(token, data);
      
      if (isClosed) return;
      emit(ProfileUpdateSuccess());
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ProfileUpdateError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  void reset() {
    emit(ProfileUpdateInitial());
  }
}
