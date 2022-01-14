part of 'go_chat_cubit.dart';

@immutable
abstract class GoChatState {}

class GoChatInitial extends GoChatState {}

class GoChatLoading extends GoChatState {}

class GoChatSucceed extends GoChatState {
  final String friendId;
  final String conversationId;
  GoChatSucceed({
    required this.friendId,
    required this.conversationId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoChatSucceed &&
        other.friendId == friendId &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode => friendId.hashCode ^ conversationId.hashCode;

  @override
  String toString() =>
      'GoChatSucceed(friendId: $friendId, conversationId: $conversationId)';
}

class GoChatFailed extends GoChatState {
  final String errorMsg;
  GoChatFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoChatFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'GoChatFailed(errorMsg: $errorMsg)';
}
