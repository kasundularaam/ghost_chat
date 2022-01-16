import 'dart:convert';

class DownloadMessage {
  final String messageId;
  final String senderId;
  final String reciverId;
  final String sentTimestamp;
  final String messageStatus;
  final String stImageStoragePath;
  final int messageLen;
  DownloadMessage({
    required this.messageId,
    required this.senderId,
    required this.reciverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.stImageStoragePath,
    required this.messageLen,
  });

  DownloadMessage copyWith({
    String? messageId,
    String? senderId,
    String? reciverId,
    String? sentTimestamp,
    String? messageStatus,
    String? stImageStoragePath,
    int? messageLen,
  }) {
    return DownloadMessage(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      reciverId: reciverId ?? this.reciverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      stImageStoragePath: stImageStoragePath ?? this.stImageStoragePath,
      messageLen: messageLen ?? this.messageLen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'reciverId': reciverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'stImageStoragePath': stImageStoragePath,
      'messageLen': messageLen,
    };
  }

  factory DownloadMessage.fromMap(Map<String, dynamic> map) {
    return DownloadMessage(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      reciverId: map['reciverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      stImageStoragePath: map['stImageStoragePath'] ?? '',
      messageLen: map['messageLen']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadMessage.fromJson(String source) =>
      DownloadMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DownloadMessage(messageId: $messageId, senderId: $senderId, reciverId: $reciverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, stImageStoragePath: $stImageStoragePath, messageLen: $messageLen)';
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
        other.stImageStoragePath == stImageStoragePath &&
        other.messageLen == messageLen;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        senderId.hashCode ^
        reciverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        stImageStoragePath.hashCode ^
        messageLen.hashCode;
  }
}
