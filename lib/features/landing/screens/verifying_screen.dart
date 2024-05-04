import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/auth/screens/user_information_screen.dart';

class VerifyingScreen extends ConsumerWidget {
  static const String routeName = '/verifying-screen';
  const VerifyingScreen({super.key});

  void navigateToUserInfoScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    Timer.periodic(
      const Duration(seconds: 5),
      (Timer t) async {
        await ref.read(authControllerProvider).userVerifiedEmail().then(
          (value) {
            if (value) {
              t.cancel();
              navigateToUserInfoScreen(context);
              print("Se verificó.");
            }
          },
        );
        // final isVerified =
        //     await ref.read(authControllerProvider).userVerifiedEmail();
        // if (isVerified) {
        //   // Si el correo electrónico está verificado, navega a la pantalla de información del usuario.
        //   navigateToUserInfoScreen(context);
        //   t.cancel(); // Cancela el temporizador una vez que el correo electrónico está verificado.
        // }
      },
    );

    return PopScope(
      onPopInvoked: (_) async {
        try {
          final success = await ref.read(authControllerProvider).deleteUser();
          if (success) {
            print("Cuenta eliminada con éxito.");
          } else {}
        } catch (e) {
          print("Error al eliminar la cuenta: $e");
        }
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Verificando tu correo"),
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text(
                  'Enlace de verificación enviado.',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Por favor, revisa tu correo y da clic en el enlace para verificar tu cuenta y continuar con tu registro.",
                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
