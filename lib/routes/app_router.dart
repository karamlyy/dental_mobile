import 'package:dental_mobile/features/home/presentation/pages/home_page.dart';
import 'package:dental_mobile/features/patient-detail/presentation/pages/patient_detail_page.dart';
import 'package:dental_mobile/features/patients/presentation/pages/add_patient_page.dart';
import 'package:dental_mobile/features/patients/presentation/pages/patients_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import 'profile_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(
      path: '/patients',
      builder: (context, state) => const PatientsPage(),
    ),
    GoRoute(
      path: '/add-patient',
      builder: (context, state) => AddPatientPage(),
    ),
    GoRoute(
      path: '/patient/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return PatientDetailPage(patientId: id);
      },
    ),
    GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
  ],
);
