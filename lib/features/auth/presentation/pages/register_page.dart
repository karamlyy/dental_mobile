import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:dental_mobile/core/error/app_error.dart';
import 'package:dental_mobile/common/widgets/error_bottom_sheet.dart';
import '../cubit/auth_cubit.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;


    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go('/login');
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
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff212327),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/icon_hero.svg',
                          width: 42,
                          height: 42,

                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        l10n.register,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Center(
                      child: Text(
                        l10n.enterCredentialsToRegister,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: l10n.nameAndSurname,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    PrimaryButton(
                      text: l10n.createAccount,
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        context.read<AuthCubit>().register(
                              _emailController.text,
                              _passwordController.text,
                              _fullNameController.text,
                            );
                      },
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.haveAccount),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(l10n.login),
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