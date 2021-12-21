import 'package:ghost_chat/core/constants/app_enums.dart';

class ChatCardArgs {
  final String userName;
  final String profileImg;
  final MsgType msgType;
  final String lastMsgTime;
  final String lastMsg;
  final int unreadMsgCount;
  ChatCardArgs({
    required this.userName,
    required this.profileImg,
    required this.msgType,
    required this.lastMsgTime,
    required this.lastMsg,
    required this.unreadMsgCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatCardArgs &&
        other.userName == userName &&
        other.profileImg == profileImg &&
        other.msgType == msgType &&
        other.lastMsgTime == lastMsgTime &&
        other.lastMsg == lastMsg &&
        other.unreadMsgCount == unreadMsgCount;
  }

  @override
  int get hashCode {
    return userName.hashCode ^
        profileImg.hashCode ^
        msgType.hashCode ^
        lastMsgTime.hashCode ^
        lastMsg.hashCode ^
        unreadMsgCount.hashCode;
  }

  @override
  String toString() {
    return 'ChatCardArgs(userName: $userName, profileImg: $profileImg, msgType: $msgType, lastMsgTime: $lastMsgTime, lastMsg: $lastMsg, unreadMsgCount: $unreadMsgCount)';
  }
}
