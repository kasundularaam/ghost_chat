part of 'chat_action_bar_cubit.dart';

@immutable
abstract class ChatActionBarState {}

class ChatActionBarInitial extends ChatActionBarState {}

class ChatActionBarLoading extends ChatActionBarState {}

class ChatActionBarLoaded extends ChatActionBarState {
  final String friendName;
  final String friendImg;
  ChatActionBarLoaded({
    required this.friendName,
    required this.friendImg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatActionBarLoaded &&
        other.friendName == friendName &&
        other.friendImg == friendImg;
  }

  @override
  int get hashCode => friendName.hashCode ^ friendImg.hashCode;

  @override
  String toString() =>
      'ChatActionBarLoaded(friendName: $friendName, friendImg: $friendImg)';
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
