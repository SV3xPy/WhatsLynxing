import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatslynxing/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatslynxing/common/utils/utils.dart';
import 'package:whatslynxing/models/chat_contact.dart';
import 'package:whatslynxing/models/status_model.dart';
import 'package:whatslynxing/models/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String email,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );

      print("Imagenes: $imageurl");
      List<String> uidWhoCanSee = [];

      var userDataFirebase = await firestore
          .collection('users')
          .doc(uid)
          .collection('chats')
          .get();
      uidWhoCanSee.add(auth.currentUser!.uid);
      for (var doc in userDataFirebase.docs) {
        var chatData = ChatContact.fromMap(doc.data());
        uidWhoCanSee.add(chatData.contacId);
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();
      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(
          statusesSnapshot.docs[0].data(),
        );
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        email: email,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(
            status.toMap(),
          );
      print("Quienes pueden ver: $uidWhoCanSee");
    } on FirebaseException catch (e) {
      print(e.toString());
      if (context.mounted) {
        showSnackBar(
          context: context,
          content: 'Error al buscar usuario: $e',
        );
      }
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      var userDataFirebase = await firestore.collection('users').get();
      for (var doc in userDataFirebase.docs) {
        var userData = UserModel.fromMap(doc.data());
        var statusesSnapshot = await firestore
            .collection('status')
            .where(
              'email',
              isEqualTo: userData.email,
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(
                    const Duration(
                      hours: 24,
                    ),
                  )
                  .millisecondsSinceEpoch,
            )
            .get();
        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(
            tempData.data(),
          );
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(content: e.toString());
    }
    return statusData;
  }
}
