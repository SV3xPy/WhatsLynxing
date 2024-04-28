import 'package:flutter/material.dart';
import 'package:whatslynxing/common/widgets/error.dart';
import 'package:whatslynxing/features/auth/screens/login_screen.dart';
import 'package:whatslynxing/features/auth/screens/signup_screen.dart';
import 'package:whatslynxing/features/landing/screens/verifying_screen.dart';
//import 'package:whatslynxing/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatslynxing/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatslynxing/screens/mobile_layout_screen.dart';
import 'package:whatslynxing/features/auth/screens/user_information_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      );
    case VerifyingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const VerifyingScreen(),
      );
    case UserInfoScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    // case SelectContactsScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const SelectContactsScreen(),
    //   );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
        ),
      );
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: "Esta página no existe."),
        ),
      );
  }
}