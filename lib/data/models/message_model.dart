import 'dart:convert';

class MessageModel {
  final String messageId;
  final String senderId;
  final String reciverId;
  final String sentTimestamp;
  final String messageStatus;
  final String stImage;
  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.reciverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.stImage,
  });

  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? reciverId,
    String? sentTimestamp,
    String? messageStatus,
    String? stImage,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      reciverId: reciverId ?? this.reciverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      stImage: stImage ?? this.stImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'reciverId': reciverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'stImage': stImage,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      reciverId: map['reciverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      stImage: map['stImage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageModel(messageId: $messageId, senderId: $senderId, reciverId: $reciverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, stImage: $stImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.reciverId == reciverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.stImage == stImage;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        reciverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        stImage.hashCode;
  }
}
