import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatslynxing/features/auth/repository/auth_repository.dart';
import 'package:whatslynxing/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Future<bool> signUpWithEmail(
      BuildContext context, String email, String password) {
    return authRepository.signUpEmail(context, email, password);
  }

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) {
    return authRepository.signInUser(context, password: password, email: email);
  }

  Future<bool> userVerifiedEmail() {
    return authRepository.isEmailVerified();
  }

  Future<bool> deleteUser() {
    return authRepository.deleteUserAccount();
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserData(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  Future<bool> resetPassword(String email) {
    return authRepository.resetPassword(email);
  }
}

//Hasta como sería el manejo de datos