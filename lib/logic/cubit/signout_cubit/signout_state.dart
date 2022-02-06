part of 'signout_cubit.dart';

@immutable
abstract class SignoutState {}

class SignoutInitial extends SignoutState {}

class SignoutLoading extends SignoutState {}

class SignoutSucceed extends SignoutState {}

class SignoutFailed extends SignoutState {
  final String errorMsg;
  SignoutFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SignoutFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'SignoutFailed(errorMsg: $errorMsg)';
}
