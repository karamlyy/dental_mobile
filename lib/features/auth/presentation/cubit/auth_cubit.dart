import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/auth_api.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/cache/cache_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/utils/crashlytics_helper.dart';
import '../../../../core/utils/validators.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthApi api;
  final SecureStorage storage;
  final AnalyticsService analytics;
  final CacheService cache;

  AuthCubit(this.api, this.storage, this.analytics, this.cache) : super(AuthInitial());

  Future<void> register(
    String email,
    String password,
    String fullName,
    String clinicName,
    String address,
    String phoneNumber,
    String specialization,
  ) async {
    // Email validasiya
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      emit(AuthError(emailError));
      return;
    }

    // Digər xanaların validasiyası
    if (fullName.trim().isEmpty) {
      emit(AuthError('Ad və soyad tələb olunur'));
      return;
    }

    if (clinicName.trim().isEmpty) {
      emit(AuthError('Klinika adı tələb olunur'));
      return;
    }

    if (address.trim().isEmpty) {
      emit(AuthError('Ünvan tələb olunur'));
      return;
    }

    if (phoneNumber.trim().isEmpty) {
      emit(AuthError('Telefon nömrəsi tələb olunur'));
      return;
    }

    if (specialization.trim().isEmpty) {
      emit(AuthError('İxtisas tələb olunur'));
      return;
    }

    if (password.trim().isEmpty) {
      emit(AuthError('Şifrə tələb olunur'));
      return;
    }

    if (password.trim().length < 6) {
      emit(AuthError('Şifrə ən azı 6 simvol olmalıdır'));
      return;
    }

    emit(AuthLoading());
    try {
      await CrashlyticsHelper.log('Starting user registration');
      
      final res = await api.register({
        'email': email.trim(),
        'password': password.trim(),
        'fullName': fullName.trim(),
        'clinicName': clinicName.trim(),
        'address': address.trim(),
        'phoneNumber': phoneNumber.trim(),
        'specialization': specialization.trim(),
      });
      
      await storage.write('accessToken', res['accessToken']);
      await storage.write('refreshToken', res['refreshToken']);
      
      // Set user context for Crashlytics
      await CrashlyticsHelper.setUserId(res['userId'] ?? 'unknown');
      await CrashlyticsHelper.setCustomKey('user_email', email);
      await CrashlyticsHelper.setCustomKey('specialization', specialization);
      await CrashlyticsHelper.log('User registration successful');
      
      // Track registration in Analytics
      await analytics.logSignUp('email');
      await analytics.setUserId(res['userId']?.toString());
      await analytics.setUserProperty(name: 'specialization', value: specialization);
      
      if (isClosed) return;
      emit(AuthSuccess(res['fullName']));
    } catch (e, stackTrace) {
      if (isClosed) return;
      
      // Log error to Crashlytics
      await CrashlyticsHelper.logError(
        e,
        stackTrace,
        reason: 'User registration failed',
      );
      
      final error = ErrorHandler.handle(e);
      emit(AuthError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> login(String email, String password) async {
    // Email validasiya
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      emit(AuthError(emailError));
      return;
    }

    // Password validasiya
    if (password.trim().isEmpty) {
      emit(AuthError('Şifrə tələb olunur'));
      return;
    }

    emit(AuthLoading());
    try {
      await CrashlyticsHelper.log('Starting user login');
      
      final res = await api.login({'email': email.trim(), 'password': password.trim()});

      // Tokens
      await storage.write('accessToken', res['accessToken']);
      await storage.write('refreshToken', res['refreshToken']);

      // User info
      await storage.write('userId', res['userId']);
      await storage.write('role', res['role']);
      await storage.write('fullName', res['fullName']);

      // Set user context for Crashlytics
      await CrashlyticsHelper.setUserId(res['userId'] ?? 'unknown');
      await CrashlyticsHelper.setCustomKey('user_email', email);
      await CrashlyticsHelper.setCustomKey('user_role', res['role'] ?? 'unknown');
      await CrashlyticsHelper.log('User login successful');

      // Track login in Analytics
      await analytics.logLogin('email');
      await analytics.setUserId(res['userId']?.toString());
      await analytics.setUserProperty(name: 'role', value: res['role']?.toString());

      if (isClosed) return;
      emit(AuthSuccess(res['fullName']));
    } catch (e, stackTrace) {
      if (isClosed) return;
      
      // Log error to Crashlytics
      await CrashlyticsHelper.logError(
        e,
        stackTrace,
        reason: 'User login failed',
      );
      
      final error = ErrorHandler.handle(e);
      emit(AuthError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }

  Future<void> logout() async {
    await CrashlyticsHelper.log('User logging out');
    
    // Track logout in Analytics
    await analytics.logLogout();
    
    await storage.delete('accessToken');
    await storage.delete('refreshToken');
    await storage.delete('userId');
    await storage.delete('role');
    await storage.delete('fullName');
    
    // Clear all cached data
    await cache.clearAllCaches();
    
    // Clear user context from Crashlytics and Analytics
    await CrashlyticsHelper.setUserId('');
    await analytics.setUserId(null);
    
    emit(AuthInitial());
  }
}