import 'dart:convert';

class DownloadMessage {
  final String messageId;
  final String senderId;
  final String reciverId;
  final String sentTimestamp;
  final String messageStatus;
  final String stImgDownloadUrl;
  DownloadMessage({
    required this.messageId,
    required this.senderId,
    required this.reciverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.stImgDownloadUrl,
  });

  DownloadMessage copyWith({
    String? messageId,
    String? senderId,
    String? reciverId,
    String? sentTimestamp,
    String? messageStatus,
    String? stImgDownloadUrl,
  }) {
    return DownloadMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      reciverId: reciverId ?? this.reciverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      stImgDownloadUrl: stImgDownloadUrl ?? this.stImgDownloadUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'reciverId': reciverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'stImgDownloadUrl': stImgDownloadUrl,
    };
  }

  factory DownloadMessage.fromMap(Map<String, dynamic> map) {
    return DownloadMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      reciverId: map['reciverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      stImgDownloadUrl: map['stImgDownloadUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadMessage.fromJson(String source) =>
      DownloadMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DownloadMessage(messageId: $messageId, senderId: $senderId, reciverId: $reciverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, stImgDownloadUrl: $stImgDownloadUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadMessage &&
        other.messageId == messageId &&
        other.senderId == senderId &&
        other.reciverId == reciverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.stImgDownloadUrl == stImgDownloadUrl;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        reciverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        stImgDownloadUrl.hashCode;
  }
}
