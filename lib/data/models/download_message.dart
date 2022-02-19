import 'dart:convert';

class DownloadMessage {
  final String messageId;
  final bool isTextMsg;
  final String senderId;
  final String receiverId;
  final String sentTimestamp;
  final String messageStatus;
  final String msgFilePath;
  final int messageLen;
  final int disappearingDuration;
  final String msgSeenTime;
  DownloadMessage({
    required this.messageId,
    required this.isTextMsg,
    required this.senderId,
    required this.receiverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.msgFilePath,
    required this.messageLen,
    required this.disappearingDuration,
    required this.msgSeenTime,
  });

  DownloadMessage copyWith({
    String? messageId,
    bool? isTextMsg,
    String? senderId,
    String? receiverId,
    String? sentTimestamp,
    String? messageStatus,
    String? msgFilePath,
    int? messageLen,
    int? disappearingDuration,
    String? msgSeenTime,
  }) {
    return DownloadMessage(
      messageId: messageId ?? this.messageId,
      isTextMsg: isTextMsg ?? this.isTextMsg,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      msgFilePath: msgFilePath ?? this.msgFilePath,
      messageLen: messageLen ?? this.messageLen,
      disappearingDuration: disappearingDuration ?? this.disappearingDuration,
      msgSeenTime: msgSeenTime ?? this.msgSeenTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'isTextMsg': isTextMsg,
      'senderId': senderId,
      'receiverId': receiverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'msgFilePath': msgFilePath,
      'messageLen': messageLen,
      'disappearingDuration': disappearingDuration,
      'msgSeenTime': msgSeenTime,
    };
  }

  factory DownloadMessage.fromMap(Map<String, dynamic> map) {
    return DownloadMessage(
      messageId: map['messageId'] ?? '',
      isTextMsg: map['isTextMsg'] ?? false,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      msgFilePath: map['msgFilePath'] ?? '',
      messageLen: map['messageLen']?.toInt() ?? 0,
      disappearingDuration: map['disappearingDuration']?.toInt() ?? 0,
      msgSeenTime: map['msgSeenTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadMessage.fromJson(String source) =>
      DownloadMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DownloadMessage(messageId: $messageId, isTextMsg: $isTextMsg, senderId: $senderId, receiverId: $receiverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, msgFilePath: $msgFilePath, messageLen: $messageLen, disappearingDuration: $disappearingDuration, msgSeenTime: $msgSeenTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadMessage &&
        other.messageId == messageId &&
        other.isTextMsg == isTextMsg &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.msgFilePath == msgFilePath &&
        other.messageLen == messageLen &&
        other.disappearingDuration == disappearingDuration &&
        other.msgSeenTime == msgSeenTime;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        isTextMsg.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        msgFilePath.hashCode ^
        messageLen.hashCode ^
        disappearingDuration.hashCode ^
        msgSeenTime.hashCode;
  }
}
