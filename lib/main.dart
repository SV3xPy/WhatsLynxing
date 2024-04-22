import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/features/landing/screens/landing_screen.dart';
import 'package:whatslynxing/firebase_options.dart';
import 'package:whatslynxing/screens/mobile_layout_screen.dart';
import 'package:whatslynxing/screens/web_layout_screen.dart';
import 'package:whatslynxing/utils/responsive_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsLynxing',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const LandingScreen(),
    );
  }
}
