import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/encoded_message_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:ghost_chat/data/models/fi_voice_message.dart';
import 'package:ghost_chat/data/models/msg_status.dart';

import '../../core/constants/strings.dart';
import 'auth_repo.dart';

class MessageRepo {
  static CollectionReference conversationRef =
      FirebaseFirestore.instance.collection("conversation");

  static Stream<List<DownloadMessage>> getMessages(
      {required String conversationId}) async* {
    try {
      Stream<QuerySnapshot<Object?>> querySnapshot = conversationRef
          .doc(conversationId)
          .collection("message")
          .orderBy("sentTimestamp", descending: true)
          .snapshots();
      Stream<List<DownloadMessage>> messageStream = querySnapshot.map(
          (snapshot) => snapshot.docs
              .map((document) => DownloadMessage.fromMap(
                  document.data() as Map<String, dynamic>))
              .toList());
      yield* messageStream;
    } catch (e) {
      throw e.toString();
    }
  }

  static Stream<int> getUnreadMsgCount(
      {required String conversationId}) async* {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
          conversationRef
              .doc(conversationId)
              .collection("message")
              .where("receiverId", isEqualTo: AuthRepo.currentUid)
              .where("messageStatus", isNotEqualTo: Strings.seen)
              .snapshots();

      Stream<int> countStream = querySnapshot.map((snapshot) => snapshot.docs
          .map((document) => DownloadMessage.fromMap(document.data()))
          .toList()
          .length);

      yield* countStream;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> sendTextMessage(
      {required EncodedMessageModel message,
      required String conversationId}) async {
    try {
      String stImageStoragePath =
          "conversation/$conversationId/${message.messageId}.png";
      storage.Reference stImageRef =
          storage.FirebaseStorage.instance.ref(stImageStoragePath);
      await stImageRef.putFile(message.stImage);

      DownloadMessage downloadMessage = DownloadMessage(
        messageId: message.messageId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        sentTimestamp: message.sentTimestamp,
        messageStatus: message.messageStatus,
        msgFilePath: stImageStoragePath,
        messageLen: message.messageLen,
        isTextMsg: true,
        disappearingDuration: message.disappearingDuration,
        msgSeenTime: message.msgSeenTime,
      );

      await conversationRef
          .doc(conversationId)
          .collection("message")
          .doc(downloadMessage.messageId)
          .set(downloadMessage.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> sendVoiceMessage(
      {required FiVoiceMessage message, required String conversationId}) async {
    try {
      String audioFilePath =
          "conversation/$conversationId/${message.messageId}.aac";
      storage.Reference audioFileRef =
          storage.FirebaseStorage.instance.ref(audioFilePath);
      await audioFileRef.putFile(File(message.audioFilePath));

      DownloadMessage downloadMessage = DownloadMessage(
        messageId: message.messageId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        sentTimestamp: message.sentTimestamp,
        messageStatus: message.messageStatus,
        msgFilePath: audioFilePath,
        messageLen: 0,
        isTextMsg: false,
        disappearingDuration: message.disappearingDuration,
        msgSeenTime: message.msgSeenTime,
      );

      await conversationRef
          .doc(conversationId)
          .collection("message")
          .doc(downloadMessage.messageId)
          .set(downloadMessage.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> updateMessageStatus(
      {required String conversationId,
      required String messageId,
      required MsgStatus msgStatus}) async {
    try {
      await conversationRef
          .doc(conversationId)
          .collection("message")
          .doc(messageId)
          .update({"messageStatus": msgStatus.msgStatus});
      await conversationRef
          .doc(conversationId)
          .collection("message")
          .doc(messageId)
          .update({"msgSeenTime": msgStatus.msgSeenTime});
    } catch (e) {
      throw e.toString();
    }
  }

  static Stream<String> getMessageStatus({
    required String conversationId,
    required String messageId,
  }) async* {
    try {
      Stream<DocumentSnapshot<Object?>> querySnapshots = conversationRef
          .doc(conversationId)
          .collection("message")
          .doc(messageId)
          .snapshots();
      Stream<String> messageStatus = querySnapshots.map((document) {
        Map<String, dynamic> map = document.data() as Map<String, dynamic>;
        return map["messageStatus"];
      });
      yield* messageStatus;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> deleteMessage(
      {required String messageId, required String conversationId}) async {
    try {
      String imageFilePath = "conversation/$conversationId/$messageId.png";
      storage.Reference stImageRef =
          storage.FirebaseStorage.instance.ref(imageFilePath);
      await stImageRef.delete();
      await conversationRef
          .doc(conversationId)
          .collection("message")
          .doc(messageId)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}
