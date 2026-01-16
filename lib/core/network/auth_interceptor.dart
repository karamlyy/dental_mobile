import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import '../cache/cache_service.dart';
import '../storage/secure_storage.dart';
import '../utils/globals.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage storage;
  final CacheService cache;

  AuthInterceptor(this.storage, this.cache);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await storage.delete('accessToken');
      await storage.delete('refreshToken');
      await storage.delete('userId');
      await storage.delete('role');
      await storage.delete('fullName');
      
      // Clear all cached data on 401
      await cache.clearAllCaches();
      
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        context.go('/login');
      }
    }
    super.onError(err, handler);
  }
}
