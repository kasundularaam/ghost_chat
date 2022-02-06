part of 'chat_action_bar_cubit.dart';

@immutable
abstract class ChatActionBarState {}

class ChatActionBarInitial extends ChatActionBarState {}

class ChatActionBarLoading extends ChatActionBarState {}

class ChatActionBarLoaded extends ChatActionBarState {
  final Friend friend;
  ChatActionBarLoaded({
    required this.friend,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatActionBarLoaded && other.friend == friend;
  }

  @override
  int get hashCode => friend.hashCode;

  @override
  String toString() => 'ChatActionBarLoaded(friend: $friend)';
}

class ChatActionBarFaild extends ChatActionBarState {
  final String errorMsg;
  ChatActionBarFaild({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatActionBarFaild && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'ChatActionBarFaild(errorMsg: $errorMsg)';
}
