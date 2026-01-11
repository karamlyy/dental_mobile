import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_profile_model.dart';

part 'profile_form_state.dart';

class ProfileFormCubit extends Cubit<ProfileFormState> {
  final TextEditingController clinicNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();

  ProfileFormCubit() : super(ProfileFormState());

  void initializeForm(UserProfileModel profile) {
    clinicNameController.text = profile.clinicName ?? '';
    addressController.text = profile.address ?? '';
    phoneNumberController.text = profile.phoneNumber ?? '';
    specializationController.text = profile.specialization ?? '';
    
    emit(state.copyWith(
      gender: profile.gender,
      dateOfBirth: profile.dateOfBirth,
    ));
  }

  void updateGender(String? gender) {
    emit(state.copyWith(gender: gender));
  }

  void updateDateOfBirth(DateTime? date) {
    emit(state.copyWith(dateOfBirth: date));
  }

  Map<String, dynamic> getFormData() {
    final data = <String, dynamic>{};

    if (clinicNameController.text.isNotEmpty) {
      data['clinicName'] = clinicNameController.text;
    }

    if (state.gender != null) {
      data['gender'] = state.gender;
    }

    if (phoneNumberController.text.isNotEmpty) {
      data['phoneNumber'] = phoneNumberController.text;
    }

    if (addressController.text.isNotEmpty) {
      data['address'] = addressController.text;
    }

    if (specializationController.text.isNotEmpty) {
      data['specialization'] = specializationController.text;
    }

    if (state.dateOfBirth != null) {
      // Send only date part in YYYY-MM-DD format
      final date = state.dateOfBirth!;
      data['dateOfBirth'] = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    return data;
  }

  @override
  Future<void> close() {
    clinicNameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    specializationController.dispose();
    return super.close();
  }
}
