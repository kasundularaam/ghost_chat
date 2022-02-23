part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {
  final String loadingMsg;
  MessageLoading({
    required this.loadingMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageLoading && other.loadingMsg == loadingMsg;
  }

  @override
  int get hashCode => loadingMsg.hashCode;

  @override
  String toString() => 'MessageLoading(loadingMsg: $loadingMsg)';
}

class MessageLoadedText extends MessageState {
  final FiTextMessage message;
  MessageLoadedText({
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageLoadedText && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'MessageLoadedText(message: $message)';
}

class MessageLoadedVoice extends MessageState {
  final FiVoiceMessage message;
  MessageLoadedVoice({
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageLoadedVoice && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'MessageLoadedVoice(message: $message)';
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

class MessageDisappeared extends MessageState {
  final String message;
  MessageDisappeared({
    required this.message,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageDisappeared && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => 'MessageDisappeared(message: $message)';
}
