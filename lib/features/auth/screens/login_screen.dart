import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/common/widgets/custom_button.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/auth/screens/signup_screen.dart';
import 'package:whatslynxing/screens/mobile_layout_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void navigateToSignupScreen(BuildContext context) {
    Navigator.pushNamed(context, SignupScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicia sesión"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text("Inicie sesión en WhatsLynxing."),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Correo institucional',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Olvidé mi contraseña.",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿No tienes cuenta? "),
                  GestureDetector(
                    onTap: () {
                      navigateToSignupScreen(context);
                    },
                    child: const Text(
                      "¡Regístrate aquí!",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.5,
              ),
              CustomButton(
                text: 'ENTRAR',
                onPressed: () {
                  ref
                      .read(authControllerProvider)
                      .signInWithEmail(
                        context,
                        emailController.text,
                        passwordController.text,
                      )
                      .then(
                    (value) {
                      if (value) {
                        Navigator.pushNamed(
                            context, MobileLayoutScreen.routeName);
                      } else {
                        print("Error al iniciar sesión.");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se encontró el usuario. Cree una cuenta nueva.',
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
