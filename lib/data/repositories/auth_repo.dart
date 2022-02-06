import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:ghost_chat/data/models/app_user.dart';

class AuthRepo {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static DocumentReference reference =
      FirebaseFirestore.instance.collection("users").doc(currentUid);

  static String imageFilePath = "images/$currentUid/userImg.png";

  static storage.Reference profilePicRef =
      storage.FirebaseStorage.instance.ref(imageFilePath);

  static const String noAccount = "No Account Found!";

  static bool isSigned() {
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  static String get currentUid {
    try {
      User? currenUser = FirebaseAuth.instance.currentUser;
      if (currenUser != null) {
        return currenUser.uid;
      } else {
        throw "user not available";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static String get currentNum {
    try {
      User? currenUser = FirebaseAuth.instance.currentUser;
      if (currenUser != null) {
        return currenUser.phoneNumber!;
      } else {
        throw "user not available";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> varifyPhone({
    required String phone,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) =>
            verificationCompleted(credential),
        timeout: const Duration(seconds: 60),
        verificationFailed: (FirebaseAuthException e) => verificationFailed(e),
        codeSent: (String verificationId, int? resendToken) =>
            codeSent(verificationId),
        codeAutoRetrievalTimeout: (String verificationId) =>
            codeAutoRetrievalTimeout(verificationId),
      );
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<AuthCredential> verifyOTP({
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      return credential;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> signIn({required AuthCredential credential}) async {
    try {
      await auth.signInWithCredential(credential);
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> signoutUser() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<AppUser> getUserDetails() async {
    try {
      DocumentSnapshot snapshot = await reference.get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
        return AppUser.fromMap(data);
      } else {
        throw noAccount;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> initUserFirestore() async {
    try {
      AppUser newUser = AppUser(
        userId: currentUid,
        userName: "",
        userNumber: currentNum,
        userBio: "",
        userImg: "null",
        userStatus: "null",
        typingTo: "null",
      );
      await reference.set(newUser.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> addProfilePic({required File imageFile}) async {
    try {
      await profilePicRef.putFile(imageFile);
      String downloadUrl = await profilePicRef.getDownloadURL();
      await reference.update({"userImg": downloadUrl});
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> updateUserName({required String userName}) async {
    try {
      if (userName.isNotEmpty) {
        await reference.update({'userName': userName});
      } else {
        throw "Name is empty!";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> updateUserBio({required String userBio}) async {
    try {
      await reference.update({'userBio': userBio});
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> goOnline() async {
    try {
      await reference.update({"userStatus": "Online"});
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> goOffline() async {
    try {
      int now = DateTime.now().millisecondsSinceEpoch;
      await reference.update({"userStatus": "$now"});
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> updateTypeStatus({required String friendId}) async {
    try {
      await reference.update({"typingTo": friendId});
    } catch (e) {
      e.toString();
    }
  }
}
