import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghost_chat/data/models/conversation_model.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';

class ConversationRepo {
  static Future<void> updateConversation({
    required String friendId,
    required String lastUpdate,
    required String conversationId,
    required bool active,
    required String friendNumber,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(AuthRepo.currentUid)
          .collection("conversations")
          .doc(friendId)
          .set({
        "conversationId": conversationId,
        "friendId": friendId,
        "lastUpdate": lastUpdate,
        "friendNumber": friendNumber,
        "active": active
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection("conversations")
          .doc(AuthRepo.currentUid)
          .set({
        "conversationId": conversationId,
        "friendId": AuthRepo.currentUid,
        "lastUpdate": lastUpdate,
        "friendNumber": AuthRepo.currentNum,
        "active": active
      }, SetOptions(merge: true));
    } catch (e) {
      throw e.toString();
    }
  }

  static Stream<List<ConversationModel>> getMyConversations() async* {
    try {
      Stream<QuerySnapshot<Object?>> querySnapshot = FirebaseFirestore.instance
          .collection("users")
          .doc(AuthRepo.currentUid)
          .collection("conversations")
          .where("active", isEqualTo: true)
          .orderBy("lastUpdate", descending: true)
          .snapshots();
      Stream<List<ConversationModel>> convStream = querySnapshot.map(
          (snapshot) => snapshot.docs
              .map((document) => ConversationModel.fromMap(
                  document.data() as Map<String, dynamic>))
              .toList());
      yield* convStream;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<ConversationModel> getConversation(
      {required String friendId}) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(AuthRepo.currentUid)
          .collection("conversations")
          .doc(friendId)
          .get();
      Map<String, dynamic>? map = snapshot.data() as Map<String, dynamic>;

      return ConversationModel.fromMap(map);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<bool> checkConvExist({required String friendId}) async {
    try {
      DocumentSnapshot docSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(friendId)
          .collection("conversations")
          .doc(AuthRepo.currentUid)
          .get();
      return docSnap.exists;
    } catch (e) {
      throw e.toString();
    }
  }
}
