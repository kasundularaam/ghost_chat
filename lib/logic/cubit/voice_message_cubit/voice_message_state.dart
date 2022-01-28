part of 'voice_message_cubit.dart';

@immutable
abstract class VoiceMessageState {}

class VoiceMessageInitial extends VoiceMessageState {}

class VoiceMessageRecording extends VoiceMessageState {
  final String recordTime;
  final String filePath;
  final String messageId;
  VoiceMessageRecording({
    required this.recordTime,
    required this.filePath,
    required this.messageId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoiceMessageRecording &&
        other.recordTime == recordTime &&
        other.filePath == filePath &&
        other.messageId == messageId;
  }

  @override
  int get hashCode =>
      recordTime.hashCode ^ filePath.hashCode ^ messageId.hashCode;

  @override
  String toString() =>
      'VoiceMessageRecording(recordTime: $recordTime, filePath: $filePath, messageId: $messageId)';
}

class VoiceMessageCanceled extends VoiceMessageState {}

class VoiceMessageAddingToDB extends VoiceMessageState {}

class VoiceMessageUploading extends VoiceMessageState {
  final DownloadMessage uploadingMsg;
  VoiceMessageUploading({
    required this.uploadingMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoiceMessageUploading && other.uploadingMsg == uploadingMsg;
  }

  @override
  int get hashCode => uploadingMsg.hashCode;

  @override
  String toString() => 'VoiceMessageUploading(uploadingMsg: $uploadingMsg)';
}

class VoiceMessageSent extends VoiceMessageState {}

class VoiceMessageFailed extends VoiceMessageState {
  final String errorMsg;
  VoiceMessageFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoiceMessageFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'VoiceMessageFailed(errorMsg: $errorMsg)';
}
