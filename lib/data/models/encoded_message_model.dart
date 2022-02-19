import 'dart:io';

class EncodedMessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String sentTimestamp;
  final String messageStatus;
  final File stImage;
  final int messageLen;
  final int disappearingDuration;
  final String msgSeenTime;
  EncodedMessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.stImage,
    required this.messageLen,
    required this.disappearingDuration,
    required this.msgSeenTime,
  });

  EncodedMessageModel copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? sentTimestamp,
    String? messageStatus,
    File? stImage,
    int? messageLen,
    int? disappearingDuration,
    String? msgSeenTime,
  }) {
    return EncodedMessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      stImage: stImage ?? this.stImage,
      messageLen: messageLen ?? this.messageLen,
      disappearingDuration: disappearingDuration ?? this.disappearingDuration,
      msgSeenTime: msgSeenTime ?? this.msgSeenTime,
    );
  }

  @override
  String toString() {
    return 'EncodedMessageModel(messageId: $messageId, senderId: $senderId, receiverId: $receiverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, stImage: $stImage, messageLen: $messageLen, disappearingDuration: $disappearingDuration, msgSeenTime: $msgSeenTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EncodedMessageModel &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.stImage == stImage &&
        other.messageLen == messageLen &&
        other.disappearingDuration == disappearingDuration &&
        other.msgSeenTime == msgSeenTime;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        stImage.hashCode ^
        messageLen.hashCode ^
        disappearingDuration.hashCode ^
        msgSeenTime.hashCode;
  }
}
