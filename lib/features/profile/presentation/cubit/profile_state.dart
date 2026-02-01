part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;
  
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  final String? error;
  final int? statusCode;

  ProfileError(this.message, {this.error, this.statusCode});
}
