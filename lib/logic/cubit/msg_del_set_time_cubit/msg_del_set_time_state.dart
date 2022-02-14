part of 'msg_del_set_time_cubit.dart';

@immutable
abstract class MsgDelSetTimeState {}

class MsgDelSetTimeInitial extends MsgDelSetTimeState {}

class MsgDelSetTimeLoading extends MsgDelSetTimeState {}

class MsgDelSetTimeSucceed extends MsgDelSetTimeState {}

class MsgDelSetTimeFailed extends MsgDelSetTimeState {
  final String errorMsg;
  MsgDelSetTimeFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MsgDelSetTimeFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'MsgDelSetTimeFailed(errorMsg: $errorMsg)';
}
