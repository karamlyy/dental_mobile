import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services_api.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'service_creation_state.dart';

class ServiceCreationCubit extends Cubit<ServiceCreationState> {
  final ServicesApi api;
  final SecureStorage storage;
  final AnalyticsService analytics;

  ServiceCreationCubit(this.api, this.storage, this.analytics) : super(ServiceCreationInitial());

  Future<void> addService({
    required String name,
    double? price,
    String? description,
  }) async {
    emit(ServiceCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final body = {
        'name': name,
        'price': price,
        if (description != null) 'description': description,
      };

      final result = await api.createService(token, body);
      
      // Track service creation in Analytics
      final serviceId = result['id'] as int?;
      await analytics.logServiceCreated(serviceId: serviceId, serviceName: name);
      
      if (isClosed) return;
      emit(ServiceCreationSuccess());
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(ServiceCreationError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}
