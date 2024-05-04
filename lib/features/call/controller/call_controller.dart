import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatslynxing/features/auth/controller/auth_controller.dart';
import 'package:whatslynxing/features/call/repository/call_repository.dart';
import 'package:whatslynxing/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController(
      {required this.auth, required this.callRepository, required this.ref});
  Stream<DocumentSnapshot> get callStream => callRepository.callStream;
  
  void makeCall(BuildContext context, String receiverName, String receiverUid,
      String receiverProfilePicm, bool isGroupChat) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
          callerId: auth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePicm,
          callId: callId,
          hasDialled: true);
      Call receiverCallData = Call(
          callerId: auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePicm,
          callId: callId,
          hasDialled: false);
      if (isGroupChat) {
        callRepository.makeGroupCall(senderCallData, context, receiverCallData);
      } else {
        callRepository.makeCall(senderCallData, context, receiverCallData);
      }
    });
  }

  void endCall(
    String callerId,
    String receiverId,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverId, context);
  }
}
