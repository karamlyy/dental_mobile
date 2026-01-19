import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesApi api;
  final SecureStorage storage;

  ServicesCubit(this.api, this.storage) : super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesLoading());
    
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final services = await api.getServices(token);
      
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

      await api.updateService(token, serviceId, body);
      
      // Refresh the services list after update
      await fetchServices();
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

      await api.deleteService(token, serviceId);
      
      // Refresh the services list after deletion
      await fetchServices();
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
