import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/config/theme/app_theme.dart';
import 'package:dental_mobile/core/analytics/analytics_service.dart';
import 'package:dental_mobile/core/utils/globals.dart';
import 'package:dental_mobile/config/theme/theme_cubit.dart';
import 'package:dental_mobile/config/theme/theme_state.dart';
import 'package:dental_mobile/core/localization/locale_cubit.dart';
import 'package:dental_mobile/core/localization/locale_state.dart';
import 'package:dental_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dental_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:dental_mobile/features/auth/presentation/pages/register_page.dart';
import 'package:dental_mobile/features/collaborations/presentation/pages/collaborations_page.dart';
import 'package:dental_mobile/features/expenses/presentation/pages/expenses_page.dart';
import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/home/presentation/pages/home_page.dart';
import 'package:dental_mobile/features/appointments/presentation/pages/appointments_page.dart';
import 'package:dental_mobile/features/patient-detail/presentation/pages/patient_detail_page.dart';
import 'package:dental_mobile/features/patients/presentation/pages/add_patient_page.dart';
import 'package:dental_mobile/features/patients/presentation/pages/patients_page.dart';
import 'package:dental_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:dental_mobile/features/assistants/presentation/cubit/assistants_cubit.dart';
import 'package:dental_mobile/features/assistants/presentation/pages/assistants_page.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_form_cubit.dart';
import 'package:dental_mobile/features/services/presentation/pages/services_page.dart';
import 'package:dental_mobile/features/services/presentation/cubit/services_cubit.dart';
import 'package:dental_mobile/features/collaborations/presentation/cubit/collaborations_cubit.dart';
import 'package:dental_mobile/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_update_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:dental_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;
  const App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: isLoggedIn ? '/' : '/login',
      observers: [
        sl<AnalyticsService>().observer,
      ],
      redirect: (context, state) async {
        final storage = sl<SecureStorage>();
        final hasSeenOnboarding = await storage.read('hasSeenOnboarding');

        if (hasSeenOnboarding != 'true' && state.matchedLocation != '/onboarding') {
          return '/onboarding';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
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
        GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<ProfileUpdateCubit>()),
              BlocProvider(create: (_) => sl<ProfileFormCubit>()),
            ],
            child: const EditProfilePage(),
          ),
        ),
        GoRoute(
          path: '/assistants',
          builder: (context, state) => const AssistantsPage(),
        ),
        GoRoute(
          path: '/appointments',
          builder: (context, state) => const AppointmentsPage(),
        ),
        GoRoute(
          path: '/services',
          builder: (context, state) => const ServicesPage(),
        ),
        GoRoute(
          path: '/collaborations',
          builder: (context, state) => const CollaborationsPage(),
        ),
        GoRoute(
          path: '/expenses',
          builder: (context, state) => const ExpensesPage(),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>()..loadTheme(),
        ),
        BlocProvider<LocaleCubit>(
          create: (_) => sl<LocaleCubit>()..loadLocale(),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>(),
        ),
        BlocProvider<StatsCubit>(
          create: (_) => sl<StatsCubit>()..fetchStats(),
        ),
        BlocProvider<AppointmentsCubit>(
          create: (_) => sl<AppointmentsCubit>()..fetchAppointments(),
        ),
        BlocProvider<AssistantsCubit>(
          create: (_) => sl<AssistantsCubit>()..fetchAssistants(),
        ),
        BlocProvider<ServicesCubit>(
          create: (_) => sl<ServicesCubit>()..fetchServices(),
        ),
        BlocProvider<CollaborationsCubit>(
          create: (_) => sl<CollaborationsCubit>()..fetchCollaborations(),
        ),
        BlocProvider<ExpensesCubit>(
          create: (_) => sl<ExpensesCubit>()..fetchExpenses(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>()..fetchProfile(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<StatsCubit>().fetchStats();
            context.read<AppointmentsCubit>().fetchAppointments();
            context.read<AssistantsCubit>().fetchAssistants();
            context.read<ServicesCubit>().fetchServices();
            context.read<CollaborationsCubit>().fetchCollaborations();
            context.read<ExpensesCubit>().fetchExpenses();
            context.read<ProfileCubit>().fetchProfile();
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, localeState) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: router,
                  title: 'Dental Mobile',
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeState.themeMode,
                  locale: localeState.locale,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('az'),
                    Locale('en'),
                    Locale('ru'),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
