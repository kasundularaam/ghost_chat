import 'dart:convert';

import 'package:ghost_chat/data/models/friend_model.dart';

class ChatCardArgs {
  final Friend friend;
  final String lastMsgTime;
  final String lastMsg;
  final int unreadMsgCount;
  ChatCardArgs({
    required this.friend,
    required this.lastMsgTime,
    required this.lastMsg,
    required this.unreadMsgCount,
  });

  ChatCardArgs copyWith({
    Friend? friend,
    String? lastMsgTime,
    String? lastMsg,
    int? unreadMsgCount,
  }) {
    return ChatCardArgs(
      friend: friend ?? this.friend,
      lastMsgTime: lastMsgTime ?? this.lastMsgTime,
      lastMsg: lastMsg ?? this.lastMsg,
      unreadMsgCount: unreadMsgCount ?? this.unreadMsgCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'friend': friend.toMap(),
      'lastMsgTime': lastMsgTime,
      'lastMsg': lastMsg,
      'unreadMsgCount': unreadMsgCount,
    };
  }

  factory ChatCardArgs.fromMap(Map<String, dynamic> map) {
    return ChatCardArgs(
      friend: Friend.fromMap(map['friend']),
      lastMsgTime: map['lastMsgTime'] ?? '',
      lastMsg: map['lastMsg'] ?? '',
      unreadMsgCount: map['unreadMsgCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatCardArgs.fromJson(String source) =>
      ChatCardArgs.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatCardArgs(friend: $friend, lastMsgTime: $lastMsgTime, lastMsg: $lastMsg, unreadMsgCount: $unreadMsgCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatCardArgs &&
        other.friend == friend &&
        other.lastMsgTime == lastMsgTime &&
        other.lastMsg == lastMsg &&
        other.unreadMsgCount == unreadMsgCount;
  }

  @override
  int get hashCode {
    return friend.hashCode ^
        lastMsgTime.hashCode ^
        lastMsg.hashCode ^
        unreadMsgCount.hashCode;
  }
}
