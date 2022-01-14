import 'dart:convert';

class DecodedMessageModel {
  final String messageId;
  final String senderId;
  final String reciverId;
  final String sentTimestamp;
  final String messageStatus;
  final String message;
  DecodedMessageModel({
    required this.messageId,
    required this.senderId,
    required this.reciverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.message,
  });

  DecodedMessageModel copyWith({
    String? messageId,
    String? senderId,
    String? reciverId,
    String? sentTimestamp,
    String? messageStatus,
    String? message,
  }) {
    return DecodedMessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      reciverId: reciverId ?? this.reciverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'reciverId': reciverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'message': message,
    };
  }

  factory DecodedMessageModel.fromMap(Map<String, dynamic> map) {
    return DecodedMessageModel(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      reciverId: map['reciverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DecodedMessageModel.fromJson(String source) =>
      DecodedMessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DecodedMessageModel(messageId: $messageId, senderId: $senderId, reciverId: $reciverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DecodedMessageModel &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.reciverId == reciverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.message == message;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        reciverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        message.hashCode;
  }
}
