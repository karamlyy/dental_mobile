import 'package:dental_mobile/features/home/presentation/widgets/home_appbar.dart';
import 'package:dental_mobile/features/home/presentation/widgets/home_page_content.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      body: HomePageContent(),
    );
  }
}
