import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:ghost_chat/data/models/app_user.dart';

class UsersRepo {
  static CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
  static Future<List<AppUser>> getFriends(
      {required List<Contact> contacts}) async {
    try {
      List<AppUser> users = [];
      for (Contact contact in contacts) {
        String contactNumber = contact.phones![0] as String;
        String userNumber =
            "+94${contactNumber.substring(contactNumber.length - 9)}";
        QuerySnapshot snapshot =
            await usersRef.where("userNumber", isEqualTo: userNumber).get();
        snapshot.docs.map((doc) {
          Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
          users.add(AppUser.fromMap(map));
        });
      }
      return users;
    } catch (e) {
      throw e.toString();
    }
  }
}
