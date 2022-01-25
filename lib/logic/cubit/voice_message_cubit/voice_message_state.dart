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

class VoiceMessageSent extends VoiceMessageState {}
