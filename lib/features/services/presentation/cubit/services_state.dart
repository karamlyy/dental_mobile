part of 'services_cubit.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<Map<String, dynamic>> services;

  ServicesLoaded(this.services);
}

class ServicesError extends ServicesState {
  final String message;
  final dynamic error;
  final int? statusCode;

  ServicesError(this.message, {this.error, this.statusCode});
}
