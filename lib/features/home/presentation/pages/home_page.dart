import 'package:dental_mobile/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:dental_mobile/features/home/presentation/cubit/stats_cubit.dart';
import 'package:dental_mobile/features/home/presentation/widgets/home_appbar.dart';
import 'package:dental_mobile/features/home/presentation/widgets/home_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: HomeAppBar(),
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
          HomePageContent(),
        ],
      ),
    );
  }
}
