import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
//https://stackoverflow.com/questions/77505933/unable-to-build-android-bundle-or-ios-etc
//Se sigue el link anterior para reparar la dependencia de la libreria.
//En el segundo se modifica lo siguente en donde da el error
//enabled: data?.enabled ?? enabled ?? false
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({BuildContext? context, required String content}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  return image;
}

Future<File?> pickVideoGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: '9CiMScKmCfqABEyeCk25SvfYs9tHMhmz',
    );
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context: context, content: e.toString());
    }
  }
  return gif;
}
