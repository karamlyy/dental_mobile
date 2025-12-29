import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/add_patient_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => sl<AddPatientCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.newPatient),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocListener<AddPatientCubit, AddPatientState>(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔹 Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xff4FACFE),
                        child: Icon(Icons.person_add,
                            color: Colors.white, size: 32),
                      ),
                      SizedBox(height: 12),
                      Text(
                        l10n.addNewPatient,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        l10n.enterPatientInfo,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Form Card
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      BlocBuilder<AddPatientCubit, AddPatientState>(
                        buildWhen: (p, c) => p.fullName != c.fullName,
                        builder: (context, state) {
                          return TextFormField(
                            initialValue: state.fullName,
                            decoration: InputDecoration(
                              labelText: l10n.nameAndSurname,
                              filled: true,
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            ),
                            onChanged: (value) => context
                                .read<AddPatientCubit>()
                                .fullNameChanged(value),

                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      BlocBuilder<AddPatientCubit, AddPatientState>(
                        buildWhen: (p, c) => p.phone != c.phone,
                        builder: (context, state) {
                          return TextField(

                            keyboardType: TextInputType.phone,

                            decoration: InputDecoration(
                              labelText: l10n.phoneNumber,
                              filled: true,
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            ),

                            onChanged: (value) => context
                                .read<AddPatientCubit>()
                                .phoneChanged(value),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                BlocBuilder<AddPatientCubit, AddPatientState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    return PrimaryButton(
                      text: l10n.addPatient,
                      onPressed: state.status == AddPatientStatus.loading
                          ? null
                          : () => context.read<AddPatientCubit>().submit(),
                      icon: state.status == AddPatientStatus.loading
                          ? null
                          : Icons.person_add,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}