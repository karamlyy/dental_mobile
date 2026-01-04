part of 'collaborations_cubit.dart';

abstract class CollaborationsState {}

class CollaborationsInitial extends CollaborationsState {}

class CollaborationsLoading extends CollaborationsState {}

class CollaborationsLoaded extends CollaborationsState {
  final List<Map<String, dynamic>> collaborations;

  CollaborationsLoaded(this.collaborations);
}

class CollaborationsError extends CollaborationsState {
  final String message;
  final dynamic error;
  final int? statusCode;

  CollaborationsError(this.message, {this.error, this.statusCode});
}
