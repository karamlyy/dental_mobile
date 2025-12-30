import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/assistants_api.dart';
import '../../../../core/error/error_handler.dart';

part 'assistant_creation_state.dart';

class AssistantCreationCubit extends Cubit<AssistantCreationState> {
  final AssistantsApi api;
  final SecureStorage storage;

  AssistantCreationCubit(this.api, this.storage) : super(AssistantCreationInitial());

  Future<void> addAssistant({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AssistantCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.createAssistant(token, {
        'email': email,
        'password': password,
        'fullName': fullName,
      });

      if (isClosed) return;
      emit(AssistantCreationSuccess());
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(AssistantCreationError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }
}
