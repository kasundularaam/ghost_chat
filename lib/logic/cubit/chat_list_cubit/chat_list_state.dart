part of 'chat_list_cubit.dart';

@immutable
abstract class ChatListState {}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatCardArgs> chatCardArgsList;
  ChatListLoaded({
    required this.chatCardArgsList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatListLoaded &&
        listEquals(other.chatCardArgsList, chatCardArgsList);
  }

  @override
  int get hashCode => chatCardArgsList.hashCode;

  @override
  String toString() => 'ChatListLoaded(chatCardArgsList: $chatCardArgsList)';
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
