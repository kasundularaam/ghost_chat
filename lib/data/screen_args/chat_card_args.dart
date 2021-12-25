import 'dart:convert';

import 'package:ghost_chat/core/constants/app_enums.dart';
import 'package:ghost_chat/data/models/friend_model.dart';

class ChatCardArgs {
  final Friend friend;
  final MsgType msgType;
  final String lastMsgTime;
  final String lastMsg;
  final int unreadMsgCount;
  ChatCardArgs({
    required this.friend,
    required this.msgType,
    required this.lastMsgTime,
    required this.lastMsg,
    required this.unreadMsgCount,
  });

  ChatCardArgs copyWith({
    Friend? friend,
    MsgType? msgType,
    String? lastMsgTime,
    String? lastMsg,
    int? unreadMsgCount,
  }) {
    return ChatCardArgs(
      friend: friend ?? this.friend,
      msgType: msgType ?? this.msgType,
      lastMsgTime: lastMsgTime ?? this.lastMsgTime,
      lastMsg: lastMsg ?? this.lastMsg,
      unreadMsgCount: unreadMsgCount ?? this.unreadMsgCount,
    );
  }

  @override
  String toString() {
    return 'ChatCardArgs(friend: $friend, msgType: $msgType, lastMsgTime: $lastMsgTime, lastMsg: $lastMsg, unreadMsgCount: $unreadMsgCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatCardArgs &&
        other.friend == friend &&
        other.msgType == msgType &&
        other.lastMsgTime == lastMsgTime &&
        other.lastMsg == lastMsg &&
        other.unreadMsgCount == unreadMsgCount;
  }

  @override
  int get hashCode {
    return friend.hashCode ^
        msgType.hashCode ^
        lastMsgTime.hashCode ^
        lastMsg.hashCode ^
        unreadMsgCount.hashCode;
  }
}
