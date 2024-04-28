import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/select_contacts/repository/select_contact_repository.dart';
import 'package:whatslynxing/models/user_model.dart';

final getUsersProvider =
    //   FutureProvider.family<List<UserModel>, String>((ref, userID) {
    // final selectUserRepository = ref.watch(selectUsersRepositoryProvider);
    // return selectUserRepository.getAllUsers(userID); Si no se quiere mostrar al usuario
    FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectUsersRepositoryProvider);
  return selectContactRepository.getAllUsers();
});

class SelectUserController {
  final ProviderRef ref;
  final SelectUserRepository selectContactRepository;
  SelectUserController({
    required this.ref,
    required this.selectContactRepository,
  });

  final selectUserControllerProvider = Provider((ref) {
    final selectUserRepository = ref.watch(selectUsersRepositoryProvider);
    return SelectUserController(
      ref: ref,
      selectContactRepository: selectUserRepository,
    );
  });

  // void selectContact(Contact selectedContact, BuildContext context) {
  //   selectContactRepository.selectContact(selectedContact, context);
  // }
}
