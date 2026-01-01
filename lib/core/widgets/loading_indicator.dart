import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.width = 100, this.height = 100});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotties/loading_animation.json',
        width: width,
        height: height,
      ),
    );
  }
}
