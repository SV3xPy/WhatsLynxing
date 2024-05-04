import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatslynxing/features/group/repository/group_repository.dart';
import 'package:whatslynxing/models/user_model.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(
    groupRepository: groupRepository,
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({required this.groupRepository, required this.ref});
  void createGroup(BuildContext context, String name, File profilePic,
      List<UserModel> selectedContacts) {
    groupRepository.createGroup(context, name, profilePic, selectedContacts);
  }
}
