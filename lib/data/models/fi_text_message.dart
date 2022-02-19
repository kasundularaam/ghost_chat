import 'dart:convert';

class FiTextMessage {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String sentTimestamp;
  final String messageStatus;
  final String message;
  final int disappearingDuration;
  final String msgSeenTime;
  FiTextMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.message,
    required this.disappearingDuration,
    required this.msgSeenTime,
  });

  FiTextMessage copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? sentTimestamp,
    String? messageStatus,
    String? message,
    int? disappearingDuration,
    String? msgSeenTime,
  }) {
    return FiTextMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      message: message ?? this.message,
      disappearingDuration: disappearingDuration ?? this.disappearingDuration,
      msgSeenTime: msgSeenTime ?? this.msgSeenTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'message': message,
      'disappearingDuration': disappearingDuration,
      'msgSeenTime': msgSeenTime,
    };
  }

  factory FiTextMessage.fromMap(Map<String, dynamic> map) {
    return FiTextMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      message: map['message'] ?? '',
      disappearingDuration: map['disappearingDuration']?.toInt() ?? 0,
      msgSeenTime: map['msgSeenTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FiTextMessage.fromJson(String source) =>
      FiTextMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FiTextMessage(messageId: $messageId, senderId: $senderId, receiverId: $receiverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, message: $message, disappearingDuration: $disappearingDuration, msgSeenTime: $msgSeenTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FiTextMessage &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.message == message &&
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
        message.hashCode ^
        disappearingDuration.hashCode ^
        msgSeenTime.hashCode;
  }
}
