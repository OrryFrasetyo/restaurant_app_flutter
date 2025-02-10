import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/loading.json',
        width: 140,
        height: 140,
        fit: BoxFit.contain,
      ),
    );
  }
}
