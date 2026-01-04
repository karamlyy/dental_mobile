part of 'collaboration_creation_cubit.dart';

abstract class CollaborationCreationState {}

class CollaborationCreationInitial extends CollaborationCreationState {}

class CollaborationCreationLoading extends CollaborationCreationState {}

class CollaborationCreationSuccess extends CollaborationCreationState {}

class CollaborationCreationError extends CollaborationCreationState {
  final String message;
  final dynamic error;
  final int? statusCode;

  CollaborationCreationError(this.message, {this.error, this.statusCode});
}
