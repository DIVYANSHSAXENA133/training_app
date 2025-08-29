import 'package:flutter/material.dart';
import '../screens/rider_input_screen.dart';
import '../screens/training_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String training = '/training';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const RiderInputScreen(),
        );
      case training:
        return MaterialPageRoute(
          builder: (_) => const TrainingScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const RiderInputScreen(),
        );
    }
  }
}
