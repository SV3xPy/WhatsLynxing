import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/common/utils/utils.dart';
import 'package:whatslynxing/models/user_model.dart';
import 'package:whatslynxing/features/chat/screens/mobile_chat_screen.dart';

final selectUsersRepositoryProvider = Provider(
  (ref) => SelectUserRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectUserRepository {
  final FirebaseFirestore firestore;
  SelectUserRepository({
    required this.firestore,
  });

  //Si no se quiere mostrar al mismo usuario
  // Future<List<UserModel>> getAllUsers(String currentUserId) async {
  //   try {
  //     final userCollection = await firestore.collection('users').get();
  //     final List<UserModel> users = userCollection.docs
  //         .map(
  //           (document) => UserModel.fromMap(
  //             document.data(),
  //           ),
  //         )
  //         .where((user) => user.uid != currentUserId)
  //         .toList();
  //     return users;
  //   } catch (e) {
  //     List<UserModel> users = [];
  //     return users;
  //   }
  // }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final userCollection = await firestore.collection('users').get();
      final List<UserModel> users = userCollection.docs
          .map(
            (document) => UserModel.fromMap(
              document.data(),
            ),
          )
          .toList();
      return users;
    } catch (e) {
      List<UserModel> users = [];
      return users;
    }
  }

  // Future<void> searchUsers(String searchTerm, BuildContext context) async {
  //   try {
  //     final userCollection = await firestore.collection('users').get();
  //     final List<UserModel> users = userCollection.docs
  //         .map(
  //           (document) => UserModel.fromMap(
  //             document.data(),
  //           ),
  //         )
  //         .toList();

  //     final List<UserModel> filteredUsers = users
  //         .where((user) =>
  //             user.email.contains(searchTerm) || user.name.contains(searchTerm))
  //         .toList();
  //   } catch (e) {
  //     showSnackBar(
  //       context: context,
  //       content: e.toString(),
  //     );
  //   }
  // }

  // Future<List<Contact>> getContacts() async {
  //   List<Contact> contacts = [];
  //   try {
  //     if (await FlutterContacts.requestPermission()) {
  //       contacts = await FlutterContacts.getContacts(
  //         withProperties: true,
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  //   return contacts;
  // }

  void selectUser(String selectedEmail, BuildContext context) async {
    try {
      final userQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: selectedEmail)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // El usuario fue encontrado, puedes realizar la acción deseada aquí
        final userData = UserModel.fromMap(userQuery.docs.first.data());
        Navigator.pushNamed(
          context,
          MobileChatScreen.routeName,
          arguments: {
            'name': userData.name,
            'uid': userData.uid,
          },
        );
      } else {
        // El usuario no fue encontrado
        showSnackBar(
          context: context,
          content: 'Este correo electrónico no existe en esta aplicación.',
        );
      }
    } catch (e) {
      // Maneja el error si ocurre alguno durante la búsqueda
      showSnackBar(
        context: context,
        content: 'Error al buscar usuario: $e',
      );
    }
  }
}
