import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/add_patient_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => sl<AddPatientCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.newPatient),
          centerTitle: true,
          elevation: 0,
          forceMaterialTransparency: true,
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
            SafeArea(
              child: BlocConsumer<AddPatientCubit, AddPatientState>(
                listener: (context, state) {
                  if (state.status == AddPatientStatus.success) {
                    context.read<StatsCubit>().fetchStats();
                    Navigator.pop(context, true);
                  } else if (state.status == AddPatientStatus.error) {
                    ErrorBottomSheet.show(
                      context,
                      AppError(
                        message: state.errorMessage ?? 'Xəta baş verdi',
                        error: state.error,
                        statusCode: state.statusCode,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // 🔹 Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                KeyboardVisibilityBuilder(
                                  builder: (context, isKeyboardVisible) {
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      height: isKeyboardVisible ? 130 : 200,
                                      curve: Curves.easeInOut,
                                      child: SvgPicture.asset(
                                        'assets/icons/createPatientHero.svg',
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  l10n.addNewPatient,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  l10n.enterPatientInfo,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 0),

                          // 🔹 Form Card
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                TextFormField(
                                  initialValue: state.fullName,
                                  decoration: InputDecoration(
                                    labelText: l10n.nameAndSurname,
                                    filled: true,
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12,
                                    ),
                                  ),
                                  onChanged: (value) => context
                                      .read<AddPatientCubit>()
                                      .fullNameChanged(value),
                                ),
                                const SizedBox(height: 16),

                                TextField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: l10n.phoneNumber,
                                    prefixIcon: Icon(Icons.phone),
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
                                  onChanged: (value) => context
                                      .read<AddPatientCubit>()
                                      .phoneChanged(value),
                                ),
                                const SizedBox(height: 16),

                                DropdownButtonFormField<String>(
                                  initialValue: state.gender,
                                  decoration: InputDecoration(
                                    labelText: 'cins',
                                    filled: true,
                                    prefixIcon: const Icon(Icons.people),
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
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<AddPatientCubit>()
                                          .genderChanged(value);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          PrimaryButton(
                            text: l10n.addPatient,
                            isLoading: state.status == AddPatientStatus.loading,
                            onPressed: () =>
                                context.read<AddPatientCubit>().submit(),
                            icon: Icons.person_add,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
