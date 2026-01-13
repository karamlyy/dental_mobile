import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_update_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_form_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();
    final formCubit = context.read<ProfileFormCubit>();

    // Initialize form with current profile data
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileLoaded) {
      context.read<ProfileFormCubit>().initializeForm(profileState.profile);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: isDarkMode ? 0.02 : 0.7,
              child: SvgPicture.asset(
                'assets/icons/appBackground.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
            listener: (context, state) {
              if (state is ProfileUpdateSuccess) {
                context.read<ProfileCubit>().fetchProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil uğurla yeniləndi'),
                    backgroundColor: Colors.green,
                  ),
                );
                context.pop();
              } else if (state is ProfileUpdateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: isKeyboardVisible ? 130 : 200,
                            curve: Curves.easeInOut,
                            child: SvgPicture.asset(
                              profileState is ProfileLoaded
                                  ? (profileState.profile.gender == 'FEMALE'
                                        ? 'assets/icons/editProfileFemale.svg'
                                        : 'assets/icons/editProfile.svg')
                                  : 'assets/icons/editProfile.svg',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.editProfile,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        l10n.enterProfileInfoToEdit,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Clinic Name
                      TextFormField(
                        controller: formCubit.clinicNameController,
                        decoration: InputDecoration(
                          labelText: l10n.clinicName,
                          prefixIcon: const Icon(Icons.business),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Gender Selection
                      BlocBuilder<ProfileFormCubit, ProfileFormState>(
                        builder: (context, state) {
                          return DropdownButtonFormField<String>(
                            initialValue: state.gender,
                            decoration: InputDecoration(
                              labelText: l10n.gender,
                              prefixIcon: const Icon(Icons.person),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'MALE',
                                child: Text(l10n.male),
                              ),
                              DropdownMenuItem(
                                value: 'FEMALE',
                                child: Text(l10n.female),
                              ),
                            ],
                            onChanged: (value) => formCubit.updateGender(value),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      TextFormField(
                        controller: formCubit.phoneNumberController,
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumber,
                          prefixIcon: const Icon(Icons.phone),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: formCubit.addressController,
                        decoration: InputDecoration(
                          labelText: l10n.address,
                          prefixIcon: const Icon(Icons.location_on),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Specialization
                      TextFormField(
                        controller: formCubit.specializationController,
                        decoration: InputDecoration(
                          labelText: l10n.specialization,
                          prefixIcon: const Icon(Icons.school),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      BlocBuilder<ProfileFormCubit, ProfileFormState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () => _selectDateOfBirth(
                              context,
                              formCubit,
                              state.dateOfBirth,
                            ),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: l10n.birthDate,
                                prefixIcon: const Icon(Icons.calendar_today),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                              ),
                              child: Text(
                                state.dateOfBirth != null
                                    ? DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(state.dateOfBirth!)
                                    : l10n.selectDate,
                                style: TextStyle(
                                  color: state.dateOfBirth != null
                                      ? null
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                        builder: (context, state) {
                          final isLoading = state is ProfileUpdateLoading;
                          return PrimaryButton(
                            text: l10n.saveChanges,
                            isLoading: isLoading,
                            onPressed: () =>
                                _saveProfile(context, formKey, formCubit),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateOfBirth(
    BuildContext context,
    ProfileFormCubit formCubit,
    DateTime? currentDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != currentDate) {
      formCubit.updateDateOfBirth(picked);
    }
  }

  void _saveProfile(
    BuildContext context,
    GlobalKey<FormState> formKey,
    ProfileFormCubit formCubit,
  ) {
    if (formKey.currentState!.validate()) {
      final updateData = formCubit.getFormData();
      context.read<ProfileUpdateCubit>().updateProfile(updateData);
    }
  }
}
