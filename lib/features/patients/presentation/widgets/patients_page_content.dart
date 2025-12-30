import 'package:dental_mobile/features/patients/presentation/cubit/patients_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientsPageContent extends StatelessWidget {
  const PatientsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: l10n.searchPatients,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) =>
                context.read<PatientsCubit>().onSearchChanged(value),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<PatientsCubit, PatientsState>(
              builder: (context, state) {
                if (state is PatientsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PatientsLoaded) {
                  if (state.patients.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noPatientsFound,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: state.patients.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 0),
                    itemBuilder: (context, index) {
                      final patient = state.patients[index];

                      return GestureDetector(
                        onTap: () {
                          context.push('/patient/${patient['id']}');
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  child: Text(
                                    patient['fullName'][0],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient['fullName'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        patient['phone'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is PatientsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
