import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart' as storage;

class LocalRepo {
  static ImagePicker picker = ImagePicker();
  static Future<File> pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 420,
      maxHeight: 420,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      throw "No image selected";
    }
  }

  static Future<String> getImageFileFromAssets() async {
    ByteData byteData = await rootBundle.load("assets/images/original.png");

    Directory dir = await getApplicationSupportDirectory();
    String filePath = "${dir.path}/original.png";

    File file = await File(filePath).create(recursive: true);

    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return filePath;
  }

  static Future<String> getStImagePath(
      {required String conversationId,
      required String messageId,
      required String messageFilePath}) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath =
        "${directory.path}/received/$conversationId/$messageId.png";
    File file = await File(filePath).create(recursive: true);
    try {
      await storage.FirebaseStorage.instance
          .ref(messageFilePath)
          .writeToFile(file);

      return file.path;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> getAudioFilePath(
      {required String conversationId,
      required String messageId,
      required String messageFilePath}) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath =
        "${directory.path}/received/$conversationId/$messageId.acc";
    File file = await File(filePath).create(recursive: true);
    try {
      await storage.FirebaseStorage.instance
          .ref(messageFilePath)
          .writeToFile(file);

      return file.path;
    } catch (e) {
      throw e.toString();
    }
  }
}
