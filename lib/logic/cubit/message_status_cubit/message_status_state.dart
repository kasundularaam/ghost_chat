part of 'message_status_cubit.dart';

@immutable
abstract class MessageStatusState {}

class MessageStatusInitial extends MessageStatusState {}

class MessageStatusLoading extends MessageStatusState {}

class MessageStatusLoaded extends MessageStatusState {
  final String status;
  MessageStatusLoaded({
    required this.status,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageStatusLoaded && other.status == status;
  }

  @override
  int get hashCode => status.hashCode;

  @override
  String toString() => 'MessageStatusLoaded(status: $status)';
}

class MessageStatusFailed extends MessageStatusState {
  final String errorMsg;
  MessageStatusFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageStatusFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'MessageStatusFailed(errorMsg: $errorMsg)';
}
