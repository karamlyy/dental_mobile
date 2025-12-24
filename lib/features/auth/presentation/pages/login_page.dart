import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.read<StatsCubit>().fetchStats();
              context.read<AppointmentsCubit>().fetchAppointments();
              context.go('/');
            } else if (state is AuthError) {
              ErrorBottomSheet.show(
                context,
                AppError(
                  message: state.message,
                  error: state.error,
                  statusCode: state.statusCode,
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// 🔹 LOGO / ICON
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/onboarding_hero.svg',
                          width: 42,
                          height: 42,

                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 TITLE
                    const Center(
                      child: Text(
                        'Xoş gəlmisiniz',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Center(
                      child: Text(
                        'Daxil olmaq üçün məlumatları yazın',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 📧 EMAIL
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 🔑 PASSWORD
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifrə',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// 🔘 LOGIN BUTTON
                    PrimaryButton(
                      text: 'Daxil ol',

                      onPressed: state is AuthLoading
                          ? null
                          : () {
                        context.read<AuthCubit>().login(
                          _emailController.text,
                          _passwordController.text,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    /// ➕ REGISTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Hesabınız yoxdur?'),
                        TextButton(
                          onPressed: () => context.go('/register'),
                          child: const Text('Qeydiyyat'),
                        ),
                      ],
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