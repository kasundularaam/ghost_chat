import 'dart:convert';

class FiVoiceMessage {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String sentTimestamp;
  final String messageStatus;
  final String audioFilePath;
  final int disappearingDuration;
  final String msgSeenTime;
  FiVoiceMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.audioFilePath,
    required this.disappearingDuration,
    required this.msgSeenTime,
  });

  FiVoiceMessage copyWith({
    String? messageId,
    String? senderId,
    String? receiverId,
    String? sentTimestamp,
    String? messageStatus,
    String? audioFilePath,
    int? disappearingDuration,
    String? msgSeenTime,
  }) {
    return FiVoiceMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      audioFilePath: audioFilePath ?? this.audioFilePath,
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
      'audioFilePath': audioFilePath,
      'disappearingDuration': disappearingDuration,
      'msgSeenTime': msgSeenTime,
    };
  }

  factory FiVoiceMessage.fromMap(Map<String, dynamic> map) {
    return FiVoiceMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      audioFilePath: map['audioFilePath'] ?? '',
      disappearingDuration: map['disappearingDuration']?.toInt() ?? 0,
      msgSeenTime: map['msgSeenTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FiVoiceMessage.fromJson(String source) =>
      FiVoiceMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FiVoiceMessage(messageId: $messageId, senderId: $senderId, receiverId: $receiverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, audioFilePath: $audioFilePath, disappearingDuration: $disappearingDuration, msgSeenTime: $msgSeenTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FiVoiceMessage &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.audioFilePath == audioFilePath &&
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
        audioFilePath.hashCode ^
        disappearingDuration.hashCode ^
        msgSeenTime.hashCode;
  }
}
