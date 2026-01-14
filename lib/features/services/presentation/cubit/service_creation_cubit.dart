import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'service_creation_state.dart';

class ServiceCreationCubit extends Cubit<ServiceCreationState> {
  final ServicesApi api;
  final SecureStorage storage;

  ServiceCreationCubit(this.api, this.storage) : super(ServiceCreationInitial());

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

      await api.createService(token, body);
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
