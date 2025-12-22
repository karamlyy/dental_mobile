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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Yeni pasiyent əlavə etmək üçün yönləndirmə
            context.go('/add-patient');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}