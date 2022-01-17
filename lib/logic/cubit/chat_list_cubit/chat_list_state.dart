part of 'chat_list_cubit.dart';

@immutable
abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ConversationModel> conversations;
  ChatListLoaded({
    required this.conversations,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatListLoaded &&
        listEquals(other.conversations, conversations);
  }

  @override
  int get hashCode => conversations.hashCode;

  @override
  String toString() => 'ChatListLoaded(conversations: $conversations)';
}

class ChatListFailed extends ChatListState {
  final String errorMsg;
  ChatListFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatListFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'ChatListFailed(errorMsg: $errorMsg)';
}
