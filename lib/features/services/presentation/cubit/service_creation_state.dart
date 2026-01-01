part of 'service_creation_cubit.dart';

abstract class ServiceCreationState {}

class ServiceCreationInitial extends ServiceCreationState {}

class ServiceCreationLoading extends ServiceCreationState {}

class ServiceCreationSuccess extends ServiceCreationState {}

class ServiceCreationError extends ServiceCreationState {
  final String message;
  final dynamic error;
  final int? statusCode;

  ServiceCreationError(this.message, {this.error, this.statusCode});
}
