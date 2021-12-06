part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSucceed extends AuthState {}

class AuthFailed extends AuthState {
  final String errorMsg;
  AuthFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'AuthFailed(errorMsg: $errorMsg)';
}

class AuthCodeSent extends AuthState {
  final String verificationId;
  final String phone;
  final String timeLeft;
  AuthCodeSent({
    required this.verificationId,
    required this.phone,
    required this.timeLeft,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthCodeSent &&
        other.verificationId == verificationId &&
        other.phone == phone &&
        other.timeLeft == timeLeft;
  }

  @override
  int get hashCode =>
      verificationId.hashCode ^ phone.hashCode ^ timeLeft.hashCode;

  @override
  String toString() =>
      'AuthCodeSent(verificationId: $verificationId, phone: $phone, timeLeft: $timeLeft)';
}

class AuthTimeOut extends AuthState {
  final String verificationId;
  final String phone;
  AuthTimeOut({
    required this.verificationId,
    required this.phone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthTimeOut &&
        other.verificationId == verificationId &&
        other.phone == phone;
  }

  @override
  int get hashCode => verificationId.hashCode ^ phone.hashCode;

  @override
  String toString() =>
      'AuthTimeOut(verificationId: $verificationId, phone: $phone)';
}

class AuthInvalidOTP extends AuthState {
  final String errorMsg;
  final String verificationId;
  AuthInvalidOTP({
    required this.errorMsg,
    required this.verificationId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthInvalidOTP &&
        other.errorMsg == errorMsg &&
        other.verificationId == verificationId;
  }

  @override
  int get hashCode => errorMsg.hashCode ^ verificationId.hashCode;

  @override
  String toString() =>
      'AuthInvalidOTP(errorMsg: $errorMsg, verificationId: $verificationId)';
}
