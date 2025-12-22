import 'package:dental_mobile/features/patients/presentation/cubit/patients_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientsPageContent extends StatelessWidget {
  const PatientsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Patients List
        Expanded(
          child: BlocBuilder<PatientsCubit, PatientsState>(
            builder: (context, state) {
              if (state is PatientsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PatientsLoaded) {
                if (state.patients.isEmpty) {
                  return const Center(child: Text('Pasiyent tapılmadı'));
                }
                return ListView.builder(
                  itemCount: state.patients.length,
                  itemBuilder: (context, index) {
                    final patient = state.patients[index];
                    return ListTile(
                      title: Text(patient['fullName']),
                      subtitle: Text(patient['phone']),
                      onTap: () {
                        context.go('/patient/${patient['id']}');
                      },
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
    );
  }
}
