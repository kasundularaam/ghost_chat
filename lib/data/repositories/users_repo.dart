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
      List<Friend> users = [];
      QuerySnapshot snapshot = await usersRef.get();
      snapshot.docs.map((doc) {
        Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
        AppUser appUser = AppUser.fromMap(map);
        if (appUser.userId != AuthRepo.currentUid) {
          users.add(Friend(
              userId: appUser.userId,
              userName: appUser.userName,
              userNumber: appUser.userNumber,
              userBio: appUser.userBio,
              userImg: appUser.userImg,
              contactName: "null"));
        }
      }).toList();

      List<Friend> friends = [];

      for (AppContact appContact in appContacts) {
        for (Friend user in users) {
          if (user.userNumber == appContact.userPhone) {
            friends.add(
              Friend(
                userId: user.userId,
                userName: user.userName,
                userNumber: user.userNumber,
                userBio: user.userBio,
                userImg: user.userImg,
                contactName: appContact.userName,
              ),
            );
          }
        }
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

  static Stream<String> getUserStatus({required String userId}) async* {
    try {
      Stream<DocumentSnapshot<Object?>> querySnapshots =
          usersRef.doc(userId).snapshots();
      Stream<String> userStatus = querySnapshots.map((document) {
        Map<String, dynamic> map = document.data() as Map<String, dynamic>;
        String status = map["userStatus"];
        if (status == "null") {
          return "Unavalable";
        } else if (status == "Online") {
          return "Online";
        } else {
          return timeago
              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(status)));
        }
      });
      yield* userStatus;
    } catch (e) {
      throw e.toString();
    }
  }

  static Stream<bool> typingStatus({required String friendId}) async* {
    try {
      Stream documentStram = usersRef.doc(friendId).snapshots();
      Map<String, dynamic>? map = documentStram as Map<String, dynamic>;
      String typingTo = map["typingTo"];
      if (typingTo == AuthRepo.currentUid) {
        yield true;
      } else {
        yield false;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
