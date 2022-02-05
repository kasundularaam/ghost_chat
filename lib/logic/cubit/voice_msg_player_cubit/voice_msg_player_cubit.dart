import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'voice_msg_player_state.dart';

class VoiceMsgPlayerCubit extends Cubit<VoiceMsgPlayerState> {
  VoiceMsgPlayerCubit() : super(VoiceMsgPlayerInitial());

  AudioPlayer audioPlayer = AudioPlayer();

  Timer? timer;
  int counter = 0;
  Duration timerInterval = const Duration(milliseconds: 200);

  Future<void> loadPlayer({required audioFilePath}) async {
    try {
      emit(VoiceMsgPlayerLoading());
      await audioPlayer.setPitch(0.8);
      Duration? duration = await audioPlayer.setFilePath(audioFilePath);
      if (duration != null) {
        int audioLength = duration.inMilliseconds;
        emit(VoiceMsgPlayerLoaded(audioLength: audioLength));
      } else {
        emit(VoiceMsgPlayerFailed(errorMsg: "An error occurred"));
      }
    } catch (e) {
      emit(VoiceMsgPlayerFailed(errorMsg: e.toString()));
    }
  }

  Future<void> playPlayer({required int audioLength}) async {
    try {
      audioPlayer.play();
      timer = Timer.periodic(timerInterval, (timerVal) async {
        counter = counter + 200;
        if (counter < audioLength) {
          emit(VoiceMsgPlayerPlaying(
              seekBarValue: counter, audioLength: audioLength));
        } else {
          timer!.cancel();
          timer = null;
          counter = 0;
          await audioPlayer.stop();
          emit(VoiceMsgPlayerLoaded(audioLength: audioLength));
        }
      });
    } catch (e) {
      emit(VoiceMsgPlayerFailed(errorMsg: e.toString()));
    }
  }
}
