class EncodeRequest {
  final String imagePath;
  final String message;
  final String conversatioId;
  final String messageId;
  EncodeRequest({
    required this.imagePath,
    required this.message,
    required this.conversatioId,
    required this.messageId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EncodeRequest &&
        other.imagePath == imagePath &&
        other.message == message &&
        other.conversatioId == conversatioId &&
        other.messageId == messageId;
  }

  @override
  int get hashCode {
    return imagePath.hashCode ^
        message.hashCode ^
        conversatioId.hashCode ^
        messageId.hashCode;
  }

  @override
  String toString() {
    return 'EncodeRequest(imagePath: $imagePath, message: $message, conversatioId: $conversatioId, messageId: $messageId)';
  }
}
