import 'dart:convert';

class FiVoiceMessage {
  final String messageId;
  final String senderId;
  final String reciverId;
  final String sentTimestamp;
  final String messageStatus;
  final String audioFilePath;
  FiVoiceMessage({
    required this.messageId,
    required this.senderId,
    required this.reciverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.audioFilePath,
  });

  FiVoiceMessage copyWith({
    String? messageId,
    String? senderId,
    String? reciverId,
    String? sentTimestamp,
    String? messageStatus,
    String? audioFilePath,
  }) {
    return FiVoiceMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      reciverId: reciverId ?? this.reciverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      audioFilePath: audioFilePath ?? this.audioFilePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'reciverId': reciverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'audioFilePath': audioFilePath,
    };
  }

  factory FiVoiceMessage.fromMap(Map<String, dynamic> map) {
    return FiVoiceMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      reciverId: map['reciverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      audioFilePath: map['audioFilePath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FiVoiceMessage.fromJson(String source) =>
      FiVoiceMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FiVoiceMessage(messageId: $messageId, senderId: $senderId, reciverId: $reciverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, audioFilePath: $audioFilePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FiVoiceMessage &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.reciverId == reciverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.audioFilePath == audioFilePath;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        reciverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        audioFilePath.hashCode;
  }
}
