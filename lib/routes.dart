import 'package:flutter/material.dart';
import 'package:chillfix_provider/screens/login_screen.dart';
import 'package:chillfix_provider/screens/dashboard_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}