import 'package:flutter/material.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/common/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingresa tu correo institucional"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("WhatsLynxing necesitará verificar tu correo."),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {},
              child: Text("Será borrado"),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('+91'),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Correo institucional',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.6),
            SizedBox(
              width: 90,
              child: CustomButton(
                text: 'SIGUIENTE',
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
