import 'package:dental_mobile/config/theme/theme_cubit.dart';
import 'package:dental_mobile/config/theme/theme_state.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = SecureStorage();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: FutureBuilder<Map<String, String?>>(
        future: _loadUserData(storage),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!;
          final fullName = userData['fullName'] ?? 'İstifadəçi';
          final role = userData['role'] ?? 'Həkim';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Doctor Information Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Həkim Məlumatları',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Ad Soyad'),
                        subtitle: Text(fullName),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        leading: const Icon(Icons.badge),
                        title: const Text('Rol'),
                        subtitle: Text(role),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Settings Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tənzimləmələr',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tema',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              RadioListTile<ThemeMode>(
                                title: const Text('Sistem'),
                                value: ThemeMode.system,
                                groupValue: state.themeMode,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<ThemeCubit>().setTheme(value);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                              RadioListTile<ThemeMode>(
                                title: const Text('Açıq'),
                                value: ThemeMode.light,
                                groupValue: state.themeMode,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<ThemeCubit>().setTheme(value);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                              RadioListTile<ThemeMode>(
                                title: const Text('Qaranlıq'),
                                value: ThemeMode.dark,
                                groupValue: state.themeMode,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<ThemeCubit>().setTheme(value);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Logout Section
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Çıxış',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await storage.deleteAll();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, String?>> _loadUserData(SecureStorage storage) async {
    final fullName = await storage.read('fullName');
    final role = await storage.read('role');
    return {'fullName': fullName, 'role': role};
  }
}
