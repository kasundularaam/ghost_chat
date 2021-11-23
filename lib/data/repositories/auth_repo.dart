import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static bool isSigned() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
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
}
