import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/assistants_api.dart';
import '../../../../core/storage/secure_storage.dart';

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
      emit(AssistantsError(e.toString()));
    }
  }

  Future<void> addAssistant({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AssistantCreating());
    try {
      final token = await storage.read('accessToken');
      if (token == null) throw Exception('No access token');

      await api.createAssistant(token, {
        'email': email,
        'password': password,
        'fullName': fullName,
      });

      if (isClosed) return;
      emit(AssistantCreated());
      await fetchAssistants();
    } catch (e) {
      if (isClosed) return;
      emit(AssistantsError(e.toString()));
    }
  }
}
