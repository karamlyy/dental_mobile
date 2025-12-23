import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di.dart';
import '../cubit/patient_detail_cubit.dart';
import '../widgets/patient_header.dart';
import '../widgets/patient_tabs.dart';

class PatientDetailPage extends StatelessWidget {
  final int patientId;
  const PatientDetailPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientDetailCubit>()..fetchPatient(patientId),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Pasiyent profili',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<PatientDetailCubit, PatientDetailState>(
          builder: (context, state) {
            if (state is PatientDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PatientDetailLoaded) {
              final patient = state.patient;
              return Column(
                children: [
                  PatientHeader(patient: patient),
                  const Divider(),
                  Expanded(child: PatientTabs(patientId: patientId)),
                ],
              );
            }
            if (state is PatientDetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}


