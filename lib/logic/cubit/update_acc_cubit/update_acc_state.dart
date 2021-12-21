part of 'update_acc_cubit.dart';

@immutable
abstract class UpdateAccState {}

class UpdateAccInitial extends UpdateAccState {}

class UpdateAccUpdating extends UpdateAccState {}

class UpdateAccSucceed extends UpdateAccState {}

class UpdateAccFailed extends UpdateAccState {
  final String errorMsg;
  UpdateAccFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateAccFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'UpdateAccFailed(errorMsg: $errorMsg)';
}
