import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/assistants_api.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/utils/validators.dart';

part 'assistant_creation_state.dart';

class AssistantCreationCubit extends Cubit<AssistantCreationState> {
  final AssistantsApi api;
  final SecureStorage storage;
  final AnalyticsService analytics;

  AssistantCreationCubit(this.api, this.storage, this.analytics) : super(AssistantCreationInitial());

  Future<void> addAssistant({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String gender,
  }) async {
    // Email validasiya
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      emit(AssistantCreationError(emailError));
      return;
    }

    // Digər xanaların validasiyası
    if (fullName.trim().isEmpty) {
      emit(AssistantCreationError('Ad və soyad tələb olunur'));
      return;
    }

    if (phoneNumber.trim().isEmpty) {
      emit(AssistantCreationError('Telefon nömrəsi tələb olunur'));
      return;
    }

    if (password.trim().isEmpty) {
      emit(AssistantCreationError('Şifrə tələb olunur'));
      return;
    }

    if (password.trim().length < 6) {
      emit(AssistantCreationError('Şifrə ən azı 6 simvol olmalıdır'));
      return;
    }

    emit(AssistantCreationLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final result = await api.createAssistant(token, {
        'email': email.trim(),
        'password': password.trim(),
        'fullName': fullName.trim(),
        'phoneNumber': phoneNumber.trim(),
        'gender': gender,
      });

      // Track assistant creation in Analytics
      // Handle id as either String or int from backend
      final dynamic idValue = result['id'];
      final int? assistantId = idValue != null 
          ? (idValue is int ? idValue : int.tryParse(idValue.toString()))
          : null;
      await analytics.logAssistantCreated(assistantId: assistantId, name: fullName);

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
