import 'package:dio/dio.dart';
import 'app_error.dart';

class ErrorHandler {
  static AppError handle(dynamic e) {
    if (e is DioException) {
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        try {
          return AppError.fromJson(e.response!.data as Map<String, dynamic>);
        } catch (_) {
          // Fallback if JSON parsing fails
        }
      }
      
      // Default Dio error mapping
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return AppError(message: 'Bağlantı vaxtı bitdi. İnternetinizi yoxlayın.');
        case DioExceptionType.badResponse:
          return AppError(
            message: 'Server xətası baş verdi.',
            statusCode: e.response?.statusCode,
            error: 'Bad Response',
          );
        case DioExceptionType.cancel:
          return AppError(message: 'Sorğu ləğv edildi.');
        default:
          return AppError(message: 'Xəta: ${e.message}');
      }
    }

    if (e is Error || e is Exception) {
      return AppError(message: e.toString());
    }

    return AppError(message: 'Gözlənilməz bir xəta baş verdi.');
  }
}
