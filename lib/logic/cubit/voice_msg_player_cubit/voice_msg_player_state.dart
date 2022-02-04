part of 'voice_msg_player_cubit.dart';

@immutable
abstract class VoiceMsgPlayerState {}

class VoiceMsgPlayerInitial extends VoiceMsgPlayerState {}

class VoiceMsgPlayerLoading extends VoiceMsgPlayerState {}

class VoiceMsgPlayerLoaded extends VoiceMsgPlayerState {
  final int audioLength;
  VoiceMsgPlayerLoaded({
    required this.audioLength,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoiceMsgPlayerLoaded && other.audioLength == audioLength;
  }

  @override
  int get hashCode => audioLength.hashCode;

  @override
  String toString() => 'VoiceMsgPlayerLoaded(audioLength: $audioLength)';
}

class VoiceMsgPlayerPlaying extends VoiceMsgPlayerState {
  final int seekBarValue;
  VoiceMsgPlayerPlaying({
    required this.seekBarValue,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoiceMsgPlayerPlaying && other.seekBarValue == seekBarValue;
  }

  @override
  int get hashCode => seekBarValue.hashCode;

  @override
  String toString() => 'VoiceMsgPlayerPlaying(seekBarValue: $seekBarValue)';
}

class VoiceMsgPlayerPause extends VoiceMsgPlayerState {}

class VoiceMsgPlayerEnd extends VoiceMsgPlayerState {}

class VoiceMsgPlayerResume extends VoiceMsgPlayerState {}

class VoiceMsgPlayerFailed extends VoiceMsgPlayerState {
  final String errorMsg;
  VoiceMsgPlayerFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VoiceMsgPlayerFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'VoiceMsgPlayerFailed(errorMsg: $errorMsg)';
}