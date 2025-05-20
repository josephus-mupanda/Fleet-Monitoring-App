import 'package:flutter/material.dart';
import '../../screens/car_detail_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/not_found_screen.dart';
import 'app_route.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoute.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoute.carDetail:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => CarDetailScreen(carId: args),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const NotFoundScreen();
    });
  }
}