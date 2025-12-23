import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/config/theme/app_theme.dart';
import 'package:dental_mobile/config/theme/theme_cubit.dart';
import 'package:dental_mobile/config/theme/theme_state.dart';
import 'package:dental_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dental_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dental_mobile/features/home/presentation/pages/home_page.dart';
import 'package:dental_mobile/features/patient-detail/presentation/pages/patient_detail_page.dart';
import 'package:dental_mobile/features/patients/presentation/pages/add_patient_page.dart';
import 'package:dental_mobile/features/patients/presentation/pages/patients_page.dart';
import 'package:dental_mobile/routes/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;
  const App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: isLoggedIn ? '/' : '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              BlocProvider(create: (_) => sl<AuthCubit>(), child: LoginPage()),
        ),
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
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
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage())
      ],
    );

    return BlocProvider<ThemeCubit>(
      create: (_) => sl<ThemeCubit>()..loadTheme(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'Dental CRM',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeState.themeMode,
          );
        },
      ),
    );
  }
}
