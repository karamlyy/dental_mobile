part of 'assistant_creation_cubit.dart';

abstract class AssistantCreationState {}

class AssistantCreationInitial extends AssistantCreationState {}

class AssistantCreationLoading extends AssistantCreationState {}

class AssistantCreationSuccess extends AssistantCreationState {}

class AssistantCreationError extends AssistantCreationState {
  final String message;
  final String? error;
  final int? statusCode;

  AssistantCreationError(this.message, {this.error, this.statusCode});
}
