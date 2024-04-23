import 'package:flutter/material.dart';
import 'package:whatslynxing/common/widgets/error.dart';
import 'package:whatslynxing/features/auth/screens/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Esta página no existe."),
        ),
      );
  }
}
