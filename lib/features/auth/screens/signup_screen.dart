import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:whatslynxing/colors.dart';
import 'package:whatslynxing/common/widgets/custom_button.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/landing/screens/verifying_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const routeName = '/signup-screen';
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void navigateToVerifyingScreen(BuildContext context) {
    Navigator.pushNamed(context, VerifyingScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crea una cuenta"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Correo institucional',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Por favor, ingrese un correo."),
                    FormBuilderValidators.email(
                        errorText: "Ingrese un correo válido."),
                    (val) {
                      if (!val!.endsWith("@itcelaya.edu.mx")) {
                        return "Ingrese un correo institucional del ITC.";
                      }
                      return null;
                    }
                  ]),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                        errorText: "Por favor, ingrese una contaseña."),
                    (val) {
                      if (val!.length < 6) {
                        return "La contraseña debe tener al menos 6 caracteres.";
                      }
                      return null;
                    }
                  ]),
                ),
                SizedBox(
                  height: size.height * 0.5,
                ),
                CustomButton(
                  text: 'REGISTRARSE',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ref
                          .read(authControllerProvider)
                          .signUpWithEmail(
                            context,
                            emailController.text,
                            passwordController.text,
                          )
                          .then(
                        (value) {
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Se ha enviado un correo de verificación.'),
                              ),
                            );
                            navigateToVerifyingScreen(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Ocurrió un error con el registro.'),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
