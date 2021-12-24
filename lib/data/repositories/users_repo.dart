import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';

class UsersRepo {
  static CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
  static Future<List<Friend>> getFriends(
      {required List<Contact> contacts}) async {
    try {
      List<Friend> friends = [];
      for (Contact contact in contacts) {
        if (contact.phones != null) {
          Item phone = contact.phones!.toSet().first;
          String contactNumber = phone.value!;
          contactNumber = contactNumber.replaceAll(RegExp(r'[^0-9]'), '');
          if (contactNumber.length >= 9) {
            String userNumber =
                "+94${contactNumber.substring(contactNumber.length - 9)}";
            QuerySnapshot snapshot =
                await usersRef.where("userNumber", isEqualTo: userNumber).get();
            snapshot.docs.map((doc) {
              Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
              AppUser appUser = AppUser.fromMap(map);
              if (appUser.userId != AuthRepo.currentUid()) {
                friends.add(Friend(
                    userId: appUser.userId,
                    userName: appUser.userName,
                    userNumber: appUser.userNumber,
                    userBio: appUser.userBio,
                    userImg: appUser.userImg,
                    contactName: contact.displayName!));
              }
            }).toList();
          }
        }
      }
      return friends;
    } catch (e) {
      throw e.toString();
    }
  }
}
