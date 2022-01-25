import 'dart:convert';

class DownloadMessage {
  final String messageId;
  final bool isTextMsg;
  final String senderId;
  final String reciverId;
  final String sentTimestamp;
  final String messageStatus;
  final String msgFilePath;
  final int messageLen;
  DownloadMessage({
    required this.messageId,
    required this.isTextMsg,
    required this.senderId,
    required this.reciverId,
    required this.sentTimestamp,
    required this.messageStatus,
    required this.msgFilePath,
    required this.messageLen,
  });

  DownloadMessage copyWith({
    String? messageId,
    bool? isTextMsg,
    String? senderId,
    String? reciverId,
    String? sentTimestamp,
    String? messageStatus,
    String? msgFilePath,
    int? messageLen,
  }) {
    return DownloadMessage(
      messageId: messageId ?? this.messageId,
      isTextMsg: isTextMsg ?? this.isTextMsg,
      senderId: senderId ?? this.senderId,
      reciverId: reciverId ?? this.reciverId,
      sentTimestamp: sentTimestamp ?? this.sentTimestamp,
      messageStatus: messageStatus ?? this.messageStatus,
      msgFilePath: msgFilePath ?? this.msgFilePath,
      messageLen: messageLen ?? this.messageLen,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'isTextMsg': isTextMsg,
      'senderId': senderId,
      'reciverId': reciverId,
      'sentTimestamp': sentTimestamp,
      'messageStatus': messageStatus,
      'msgFilePath': msgFilePath,
      'messageLen': messageLen,
    };
  }

  factory DownloadMessage.fromMap(Map<String, dynamic> map) {
    return DownloadMessage(
      messageId: map['messageId'] ?? '',
      isTextMsg: map['isTextMsg'] ?? false,
      senderId: map['senderId'] ?? '',
      reciverId: map['reciverId'] ?? '',
      sentTimestamp: map['sentTimestamp'] ?? '',
      messageStatus: map['messageStatus'] ?? '',
      msgFilePath: map['msgFilePath'] ?? '',
      messageLen: map['messageLen']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownloadMessage.fromJson(String source) =>
      DownloadMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DownloadMessage(messageId: $messageId, isTextMsg: $isTextMsg, senderId: $senderId, reciverId: $reciverId, sentTimestamp: $sentTimestamp, messageStatus: $messageStatus, msgFilePath: $msgFilePath, messageLen: $messageLen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadMessage &&
        other.messageId == messageId &&
        other.isTextMsg == isTextMsg &&
        other.senderId == senderId &&
        other.reciverId == reciverId &&
        other.sentTimestamp == sentTimestamp &&
        other.messageStatus == messageStatus &&
        other.msgFilePath == msgFilePath &&
        other.messageLen == messageLen;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
        isTextMsg.hashCode ^
        senderId.hashCode ^
        reciverId.hashCode ^
        sentTimestamp.hashCode ^
        messageStatus.hashCode ^
        msgFilePath.hashCode ^
        messageLen.hashCode;
  }
}
