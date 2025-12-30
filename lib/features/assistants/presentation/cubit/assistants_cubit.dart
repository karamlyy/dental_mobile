import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/assistants_api.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/error_handler.dart';

part 'assistants_state.dart';

class AssistantsCubit extends Cubit<AssistantsState> {
  final AssistantsApi api;
  final SecureStorage storage;

  AssistantsCubit(this.api, this.storage) : super(AssistantsInitial());

  Future<void> fetchAssistants() async {
    emit(AssistantsLoading());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      final assistants = await api.getAssistants(token);
      if (isClosed) return;
      emit(AssistantsLoaded(assistants));
    } catch (e) {
      if (isClosed) return;
      final error = ErrorHandler.handle(e);
      emit(AssistantsError(
        error.message,
        error: error.error,
        statusCode: error.statusCode,
      ));
    }
  }


}
