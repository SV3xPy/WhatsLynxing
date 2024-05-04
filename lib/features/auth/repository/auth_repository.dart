import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatslynxing/features/landing/screens/verifying_screen.dart';
import 'package:whatslynxing/common/utils/utils.dart';
import 'package:whatslynxing/models/user_model.dart';
import 'package:whatslynxing/screens/mobile_layout_screen.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<bool> userExist(String email) async {
    var userData = await firestore.collection('users').get();
    for (var doc in userData.docs) {
      var user = UserModel.fromMap(doc.data());
      if (email == user.email) {
        return true;
      }
    }
    return false;
  }

  Future<bool> signUpEmail(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        userCredential.user!.sendEmailVerification();
        return true;
      }
      return false;
      // await auth.verifyPhoneNumber(
      //   phoneNumber: email,
      //   verificationCompleted: (PhoneAuthCredential credential) async {
      //     await auth.signInWithCredential(credential);
      //   },
      //   verificationFailed: (e) {
      //     throw Exception(e.message);
      //   },
      //   codeSent: ((String verificationId, int? resendToken) async {
      //     Navigator.pushNamed(
      //       context,
      //       OTPScreen.routeName,
      //       arguments: verificationId,
      //     );
      //   }),
      //   codeAutoRetrievalTimeout: (String verificationId) {},
      // );
      // await auth.sendSignInLinkToEmail(
      //     email: email, actionCodeSettings: actionCodeSettings);
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.message!);
      }
      return false;
    }
  }

  Future<bool> signInUser(BuildContext context,
      {required String password, required String email}) async {
    try {
      var ban = false;
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          ban = true;
        }
      }
      return ban;
    } on FirebaseAuthException catch (e) {
      e.message!;
      return false;
    }
  }

  Future<bool> isEmailVerified() async {
    final user = auth.currentUser;
    if (user != null) {
      user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<bool> deleteUserAccount() async {
    final user = auth.currentUser;
    if (user != null) {
      try {
        await user.delete();
        await user.reload();
        print("Cuenta eliminada con éxito.");
        return true;
      } on FirebaseAuthException catch (e) {
        print("Error al eliminar la cuenta: ${e.message}");
      }
    } else {
      print("No hay usuario autenticado.");
      return false;
    }
    return false;
  }

  void saveUserData({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoURL =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        photoURL = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoURL,
        isOnline: true,
        email: auth.currentUser!.email!,
        groupID: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap()).then(
            (value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MobileLayoutScreen(),
              ),
              (route) => false,
            ),
          );
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update(
      {
        'isOnline': isOnline,
      },
    );
  }

  Future<bool> resetPassword(String email) async {
    try {
      if (await userExist(email)) {
        await auth.sendPasswordResetEmail(email: email);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      e.code;
      return false;
    }
  }
}
