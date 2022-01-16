import 'dart:io';

class EncodedMessageModel {
  final String messageId;
  final String senderId;
  final String reciverId;
  final String sentTimestamp;
  final String messageStatus;
  final File stImage;
  final int messageLen;
  EncodedMessageModel({
    required this.messageId,
    required this.senderId,
    required this.reciverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.stImage,
    required this.messageLen,
  });

  EncodedMessageModel copyWith({
    String? messageId,
    String? senderId,
    String? reciverId,
    String? sentTimestamp,
    String? messageStatus,
    File? stImage,
    int? messageLen,
  }) {
    return EncodedMessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      reciverId: reciverId ?? this.reciverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      stImage: stImage ?? this.stImage,
      messageLen: messageLen ?? this.messageLen,
    );
  }

  @override
  String toString() {
    return 'EncodedMessageModel(messageId: $messageId, senderId: $senderId, reciverId: $reciverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, stImage: $stImage, messageLen: $messageLen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EncodedMessageModel &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.reciverId == reciverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.stImage == stImage &&
        other.messageLen == messageLen;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        reciverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        stImage.hashCode ^
        messageLen.hashCode;
  }
}
