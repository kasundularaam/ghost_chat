part of 'chat_card_cubit.dart';

@immutable
abstract class ChatCardState {}

class ChatCardInitial extends ChatCardState {}

class ChatCardLoading extends ChatCardState {}

class ChatCardLoaded extends ChatCardState {
  final int unreadMsgCount;
  final String friendImage;
  ChatCardLoaded({
    required this.unreadMsgCount,
    required this.friendImage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatCardLoaded &&
        other.unreadMsgCount == unreadMsgCount &&
        other.friendImage == friendImage;
  }

  @override
  int get hashCode => unreadMsgCount.hashCode ^ friendImage.hashCode;

  @override
  String toString() =>
      'ChatCardLoaded(unreadMsgCount: $unreadMsgCount, friendImage: $friendImage)';
}
