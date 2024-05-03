import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/common/widgets/custom_button.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  static const String routeName = '/reset-password';
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar contraseña"),
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
                child: Text("Recupere su contraseña."),
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
                height: 30,
              ),
              CustomButton(
                text: 'Enviar correo de recuperación',
                onPressed: () {
                  ref
                      .read(
                        authControllerProvider,
                      )
                      .resetPassword(
                        emailController.text,
                      )
                      .then(
                    (value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Se ha enviado un correo.',
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'El usuario no existe.',
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
