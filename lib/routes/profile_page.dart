import 'package:dental_mobile/config/theme/theme_cubit.dart';
import 'package:dental_mobile/config/theme/theme_state.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:dental_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = SecureStorage();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      body: FutureBuilder<Map<String, String?>>(
        future: _loadUserData(storage),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!;
          final fullName = userData['fullName'] ?? 'İstifadəçi';
          final role = userData['role'] ?? 'Həkim';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _SectionCard(
                  title: 'Profil',
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              role == 'DOCTOR' ? 'Həkim' : 'Assistant',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ⚙️ SETTINGS
                _SectionCard(
                  title: 'Tənzimləmələr',
                  child: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      final isDark = state.themeMode == ThemeMode.dark;

                      return Column(
                        children: [
                          /// 🌗 Dark / Light switch
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
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
                                    isDark ? 'Qaranlıq rejim' : 'Açıq rejim',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Switch.adaptive(
                                  value: isDark,
                                  onChanged: (value) {
                                    context.read<ThemeCubit>().setTheme(
                                      value ? ThemeMode.dark : ThemeMode.light,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                /// ⚙️ ASSISTANTS
                if (role == 'DOCTOR') ...[
                  const SizedBox(height: 24),
                  _SectionCard(
                    title: 'Assistantlar',
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Assistant siyahısı'),
                      subtitle: const Text('Assistantları idarə edin'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.push('/assistants'),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                /// 🚪 LOGOUT
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Çıxış et',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showLogoutDialog(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Hesabdan çıxış'),
          content: const Text('Hesabdan çıxmaq istədiyinizə əminsiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ləğv et'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                context.read<AuthCubit>().logout();
                context.read<StatsCubit>().clear();
                context.read<AppointmentsCubit>().clear();
                context.go('/login');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Çıxış et'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, String?>> _loadUserData(SecureStorage storage) async {
    final fullName = await storage.read('fullName');
    final role = await storage.read('role');
    return {'fullName': fullName, 'role': role};
  }
}

class _SectionCard extends StatelessWidget {
  final String title;

  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
