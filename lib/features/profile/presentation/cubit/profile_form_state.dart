part of 'profile_form_cubit.dart';

class ProfileFormState {
  final String? gender;
  final DateTime? dateOfBirth;

  ProfileFormState({
    this.gender,
    this.dateOfBirth,
  });

  ProfileFormState copyWith({
    String? gender,
    DateTime? dateOfBirth,
  }) {
    return ProfileFormState(
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
