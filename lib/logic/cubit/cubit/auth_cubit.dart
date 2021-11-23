import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Timer? timer;
  int timeLeft = 60;

  Future<void> requestAuth({required String phone}) async {
    try {
      emit(AuthLoading());
      if (phone.length == 12) {
        await AuthRepo.varifyPhone(
            phone: phone,
            verificationCompleted: (credential) =>
                AuthRepo.signIn(credential: credential),
            verificationFailed: (e) => emit(AuthFailed(errorMsg: e.toString())),
            codeSent: (verificationId) =>
                codeSentState(verificationId: verificationId, phone: phone),
            codeAutoRetrievalTimeout: (verificationId) {
              timeLeft = 60;
              timer!.cancel();
              timer = null;
              emit(AuthTimeOut(verificationId: verificationId, phone: phone));
            });
      } else {
        emit(AuthFailed(errorMsg: "Invalid number!"));
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailed(errorMsg: e.toString()));
    }
  }

  void codeSentState({required String verificationId, required String phone}) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft--;
      emit(AuthCodeSent(
          verificationId: verificationId, timeLeft: "$timeLeft", phone: phone));
    });
  }

  Future<void> verifyOTP(
      {required String smsCode,
      required String verificationId,
      required String phone}) async {
    try {
      emit(AuthLoading());
      if (smsCode.length == 6) {
        AuthCredential credential = await AuthRepo.verifyOTP(
            smsCode: smsCode, verificationId: verificationId);
        await AuthRepo.signIn(credential: credential);
        emit(AuthSucceed());
      } else {
        emit(AuthFailed(errorMsg: "Invalid OTP"));
      }
    } catch (e) {
      emit(AuthInvalidOTP(
          errorMsg: e.toString(), verificationId: verificationId));
      codeSentState(verificationId: verificationId, phone: phone);
    }
  }

  Future<void> signIn({required AuthCredential credential}) async {
    try {
      emit(AuthLoading());
      await AuthRepo.signIn(credential: credential);
      emit(AuthSucceed());
    } catch (e) {
      emit(AuthFailed(errorMsg: e.toString()));
    }
  }
}
