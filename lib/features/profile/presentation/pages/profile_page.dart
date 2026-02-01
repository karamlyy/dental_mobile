import 'package:dental_mobile/config/theme/theme_cubit.dart';
import 'package:dental_mobile/config/theme/theme_state.dart';
import 'package:dental_mobile/features/assistants/presentation/cubit/assistants_cubit.dart';
import 'package:dental_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dental_mobile/features/collaborations/presentation/cubit/collaborations_cubit.dart';
import 'package:dental_mobile/features/expenses/presentation/cubit/expenses_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dental_mobile/features/profile/presentation/widgets/language_selector.dart';
import 'package:dental_mobile/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:dental_mobile/features/profile/presentation/widgets/section_card.dart';
import 'package:dental_mobile/features/services/presentation/cubit/services_cubit.dart';
import 'package:dental_mobile/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          BlocSelector<ProfileCubit, ProfileState, String?>(
            selector: (state) {
              if (state is ProfileLoaded) {
                return state.profile.role;
              }
              return null;
            },
            builder: (context, role) {
              // Only show edit button for DOCTOR role
              if (role == 'DOCTOR') {
                return TextButton(
                  onPressed: () => context.push('/edit-profile'),
                  child: Text(l10n.edit),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: isDarkMode ? 0.02 : 0.7,
              child: SvgPicture.asset(
                'assets/icons/appBackground.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileCubit>().fetchProfile();
                        },
                        child: const Text('Yenidən cəhd et'),
                      ),
                    ],
                  ),
                );
              }

              if (state is! ProfileLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              final profile = state.profile;

              return RefreshIndicator(
                onRefresh: () => context.read<ProfileCubit>().fetchProfile(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SectionCard(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgPicture.asset(
                                  profile.gender == 'FEMALE'
                                      ? 'assets/icons/femaleDoctor.svg'
                                      : 'assets/icons/maleDoctor.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.fullName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      profile.clinicName ?? '',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// ⚙️ SETTINGS
                        SectionCard(
                          title: l10n.settings,
                          child: BlocBuilder<ThemeCubit, ThemeState>(
                            builder: (context, state) {
                              final isDark = state.themeMode == ThemeMode.dark;

                              return Column(
                                children: [

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.4),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            isDark
                                                ? l10n.darkMode
                                                : l10n.lightMode,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Switch.adaptive(
                                          value: isDark,
                                          onChanged: (value) {
                                            context.read<ThemeCubit>().setTheme(
                                              value
                                                  ? ThemeMode.dark
                                                  : ThemeMode.light,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  LanguageSelector(),
                                ],
                              );
                            },
                          ),
                        ),

                        if (profile.role == 'DOCTOR') ...[
                          const SizedBox(height: 16),
                          SectionCard(
                            title: l10n.doctorPanel,
                            child: Column(
                              children: [
                                ProfileMenuItem(
                                  title: l10n.assistantsList,
                                  onTap: () => context.push('/assistants'),
                                ),
                                const SizedBox(height: 12),
                                ProfileMenuItem(
                                  title: l10n.services,
                                  onTap: () => context.push('/services'),
                                ),
                                const SizedBox(height: 12),
                                ProfileMenuItem(
                                  title: l10n.collaborations,
                                  onTap: () => context.push('/collaborations'),
                                ),
                                const SizedBox(height: 12),
                                ProfileMenuItem(
                                  title: l10n.myExpenses,
                                  onTap: () => context.push('/expenses'),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        /// 🚪 LOGOUT
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          child: ListTile(
                            leading: const Icon(
                              CupertinoIcons.arrow_right_circle,
                              color: Colors.red,
                            ),
                            title: Text(
                              l10n.logout,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () => _showLogoutDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog.adaptive(
          title: Text(l10n.logoutConfirmTitle),
          content: Text(l10n.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                context.read<AuthCubit>().logout();
                context.read<StatsCubit>().clear();
                context.read<AppointmentsCubit>().clear();
                context.read<AssistantsCubit>().clear();
                context.read<ServicesCubit>().clear();
                context.read<CollaborationsCubit>().clear();
                context.read<ExpensesCubit>().clear();
                context.read<ProfileCubit>().clear();
                context.go('/login');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }
}
