part of 'assistants_cubit.dart';

abstract class AssistantsState {}

class AssistantsInitial extends AssistantsState {}

class AssistantsLoading extends AssistantsState {}

class AssistantsLoaded extends AssistantsState {
  final List<Map<String, dynamic>> assistants;
  AssistantsLoaded(this.assistants);
}

class AssistantsError extends AssistantsState {
  final String message;
  AssistantsError(this.message);
}

class AssistantCreating extends AssistantsState {}

class AssistantCreated extends AssistantsState {}
