import 'package:dental_mobile/config/di.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:dental_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/home/presentation/widgets/home_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/appointments_cubit.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: FutureBuilder<String?>(
          future: SecureStorage().read('fullName'),
          builder: (context, snapshot) {
            final name = snapshot.data ?? '';
            return Row(
              children: [
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: CircleAvatar(
                    child: Text(name.isNotEmpty ? name[0] : '?'),
                  ),
                ),
                const SizedBox(width: 8),
                Text(name),
              ],
            );
          },
        ),
      ),
      body: const HomePageContent(),
    );
  }
}
