import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:ghost_chat/data/models/app_contact.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:timeago/timeago.dart' as timeago;

class UsersRepo {
  static CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");

  static Future<List<Friend>> getFriends(
      {required List<Contact> contacts}) async {
    List<AppContact> appContacts = await getAppContacts(contacts: contacts);
    try {
      List<Friend> friends = [];
      for (AppContact appcontact in appContacts) {
        QuerySnapshot snapshot = await usersRef
            .where("userNumber", isEqualTo: appcontact.userPhone)
            .get();
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
                contactName: appcontact.userName));
          }
        }).toList();
      }

      return friends;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<AppContact>> getAppContacts(
      {required List<Contact> contacts}) async {
    try {
      List<AppContact> appContacts = [];
      for (Contact contact in contacts) {
        if (contact.phones != null && contact.phones!.isNotEmpty) {
          Item phone = contact.phones!.toSet().first;
          String contactNumber = phone.value!;
          contactNumber = contactNumber.replaceAll(RegExp(r'[^0-9]'), '');
          if (contactNumber.length >= 9) {
            String userPhone =
                "+94${contactNumber.substring(contactNumber.length - 9)}";
            appContacts.add(AppContact(
                userPhone: userPhone, userName: contact.displayName!));
          }
        }
      }
      return appContacts;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> getSavedName({required String userPhone}) async {
    try {
      String savedName = "";
      List<Contact> contacts = await ContactsService.getContacts();
      List<AppContact> appContacts = await getAppContacts(contacts: contacts);
      for (AppContact appContact in appContacts) {
        if (appContact.userPhone == userPhone) {
          savedName = appContact.userName;
        }
      }
      if (savedName.isNotEmpty) {
        return savedName;
      } else {
        throw "No contact matching!";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<Friend> getFriendDetails({required String userId}) async {
    try {
      DocumentSnapshot snapshot = await usersRef.doc(userId).get();
      Map<String, dynamic>? map = snapshot.data() as Map<String, dynamic>;
      AppUser appUser = AppUser.fromMap(map);
      String savedName = await getSavedName(userPhone: appUser.userNumber);
      return Friend(
        userId: appUser.userId,
        userName: appUser.userName,
        userNumber: appUser.userNumber,
        userBio: appUser.userBio,
        userImg: appUser.userImg,
        contactName: savedName,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  static Stream<String> getStatus({required String userId}) async* {
    try {
      Stream documentStram = usersRef.doc(userId).snapshots();
      Map<String, dynamic>? map = documentStram as Map<String, dynamic>;
      String userStatus = map["userStatus"];
      if (userStatus == "Online") {
        yield userStatus;
      } else {
        yield timeago.format(
          DateTime.fromMillisecondsSinceEpoch(
            int.parse(userStatus),
          ),
        );
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Stream<bool> typingStatus(
      {required String friendId, required String myId}) async* {
    try {
      Stream documentStram = usersRef.doc(friendId).snapshots();
      Map<String, dynamic>? map = documentStram as Map<String, dynamic>;
      String typingTo = map["typingTo"];
      if (typingTo == myId) {
        yield true;
      } else {
        yield false;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
