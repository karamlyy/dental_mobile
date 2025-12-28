import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/features/patients/presentation/cubit/patients_cubit.dart';

import 'package:dental_mobile/features/patients/presentation/widgets/patients_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientsCubit>()..fetchPatients(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pasiyentlər')),
        body: PatientsPageContent(),
        floatingActionButton: Builder(
          builder: (context) {
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                final result = await context.push('/add-patient');
                if (result == true && context.mounted) {
                  context.read<PatientsCubit>().fetchPatients();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Yeni pasiyent',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}