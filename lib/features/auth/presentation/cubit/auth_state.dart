part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String fullName;
  AuthSuccess(this.fullName);
}

class AuthError extends AuthState {
  final String message;
  final String? error;
  final int? statusCode;

  AuthError(this.message, {this.error, this.statusCode});
}