part of 'message_count_cubit.dart';

@immutable
abstract class MessageCountState {}

class MessageCountInitial extends MessageCountState {}

class MessageCountShow extends MessageCountState {
  final int unreadMsgCount;
  MessageCountShow({
    required this.unreadMsgCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageCountShow && other.unreadMsgCount == unreadMsgCount;
  }

  @override
  int get hashCode => unreadMsgCount.hashCode;

  @override
  String toString() => 'MessageCountShow(unreadMsgCount: $unreadMsgCount)';
}
