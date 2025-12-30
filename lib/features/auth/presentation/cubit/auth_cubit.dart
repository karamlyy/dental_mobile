import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthApi api;
  final SecureStorage storage;

  AuthCubit(this.api, this.storage) : super(AuthInitial());

  Future<void> register(String email, String password, String fullName) async {
    emit(AuthLoading());
    try {
      final res = await api.register({
        'email': email,
        'password': password,
        'fullName': fullName,
      });
      await storage.write('accessToken', res['accessToken']);
      await storage.write('refreshToken', res['refreshToken']);
      if (isClosed) return;
      emit(AuthSuccess(res['fullName']));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(AuthError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final res = await api.login({'email': email, 'password': password});

      // Tokens
      await storage.write('accessToken', res['accessToken']);
      await storage.write('refreshToken', res['refreshToken']);

      // User info
      await storage.write('userId', res['userId']);
      await storage.write('role', res['role']);
      await storage.write('fullName', res['fullName']);

      if (isClosed) return;
      emit(AuthSuccess(res['fullName']));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(AuthError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> logout() async {
    await storage.delete('accessToken');
    await storage.delete('fullName');
    await storage.delete('role');
    emit(AuthInitial());
  }
}