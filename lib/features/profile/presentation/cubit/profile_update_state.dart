part of 'profile_update_cubit.dart';

abstract class ProfileUpdateState {}

class ProfileUpdateInitial extends ProfileUpdateState {}

class ProfileUpdateLoading extends ProfileUpdateState {}

class ProfileUpdateSuccess extends ProfileUpdateState {}

class ProfileUpdateError extends ProfileUpdateState {
  final String message;
  final String? error;
  final int? statusCode;

  ProfileUpdateError(this.message, {this.error, this.statusCode});
}
