import 'package:dental_mobile/app.dart';
import 'package:flutter/material.dart';
import 'config/di.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  final storage = sl<AuthCubit>().storage;
  final token = await storage.read('accessToken');

  runApp(App(isLoggedIn: token != null));
}

