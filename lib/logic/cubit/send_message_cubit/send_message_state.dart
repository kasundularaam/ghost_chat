part of 'send_message_cubit.dart';

@immutable
abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageAddingToDB extends SendMessageState {}

class SendMessageUploading extends SendMessageState {}

class SendMessageSent extends SendMessageState {}

class SendMessageFailed extends SendMessageState {
  final String errorMsg;
  SendMessageFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SendMessageFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'SendMessageFailed(errorMsg: $errorMsg)';
}
