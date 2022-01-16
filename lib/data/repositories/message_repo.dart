import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/encoded_message_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

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

  static Future<void> sendMessage(
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
        reciverId: message.reciverId,
        sentTimestamp: message.sentTimestamp,
        messageStatus: message.messageStatus,
        stImageStoragePath: stImageStoragePath,
        messageLen: message.messageLen,
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
      required String messageStatus}) async {
    try {
      await conversationRef
          .doc(conversationId)
          .collection("message")
          .doc(messageId)
          .update({"messageStatus": messageStatus});
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
}
