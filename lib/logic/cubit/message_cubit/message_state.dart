part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final DecodedMessageModel message;
  MessageLoaded({
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageLoaded && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'MessageLoaded(message: $message)';
}

class MessageFailed extends MessageState {
  final String errorMsg;
  MessageFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'MessageFailed(errorMsg: $errorMsg)';
}
