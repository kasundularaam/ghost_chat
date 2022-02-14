import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'voice_msg_player_state.dart';

class VoiceMsgPlayerCubit extends Cubit<VoiceMsgPlayerState> {
  final String audioFilePath;
  VoiceMsgPlayerCubit({required this.audioFilePath})
      : super(VoiceMsgPlayerInitial());

  AudioPlayer? audioPlayer;

  Timer? timer;
  int counter = 0;
  Duration timerInterval = const Duration(milliseconds: 200);
  int audioLength = 0;

  Future<void> loadPlayer() async {
    try {
      emit(
        VoiceMsgPlayerLoading(),
      );
      audioPlayer = AudioPlayer();
      await audioPlayer!.setPitch(0.8);
      Duration? duration = await audioPlayer!.setFilePath(audioFilePath);
      if (duration != null) {
        audioLength = duration.inMilliseconds;
        emit(VoiceMsgPlayerLoaded(audioLength: audioLength));
      } else {
        emit(VoiceMsgPlayerFailed(errorMsg: "An error occurred"));
      }
    } catch (e) {
      emit(VoiceMsgPlayerFailed(errorMsg: e.toString()));
    }
  }

  Future<void> pausePlayer() async {
    try {
      if (timer != null) {
        await audioPlayer!.pause();
        timer!.cancel();
        timer = null;
        emit(VoiceMsgPlayerPause(
            seekbarProgress: counter, audioLength: audioLength));
      }
    } catch (e) {
      emit(VoiceMsgPlayerFailed(errorMsg: e.toString()));
    }
  }

  Future<void> resumePlayer() async {
    try {
      await audioPlayer!.seek(Duration(milliseconds: counter));
      audioPlayer!.play();
      timer = Timer.periodic(timerInterval, (timerVal) async {
        counter = counter + 200;
        if (counter < audioLength) {
          emit(
            VoiceMsgPlayerPlaying(
              seekBarValue: counter,
              audioLength: audioLength,
            ),
          );
        } else {
          timer!.cancel();
          timer = null;
          counter = 0;
          await audioPlayer!.stop();
          await audioPlayer!.dispose();
          loadPlayer();
        }
      });
    } catch (e) {
      emit(
        VoiceMsgPlayerFailed(
          errorMsg: e.toString(),
        ),
      );
    }
  }

  Future<void> playPlayer() async {
    try {
      audioPlayer!.play();
      timer = Timer.periodic(timerInterval, (timerVal) async {
        counter = counter + 200;
        if (counter < audioLength) {
          emit(VoiceMsgPlayerPlaying(
              seekBarValue: counter, audioLength: audioLength));
        } else {
          timer!.cancel();
          timer = null;
          counter = 0;
          await audioPlayer!.stop();
          await audioPlayer!.dispose();
          loadPlayer();
        }
      });
    } catch (e) {
      emit(VoiceMsgPlayerFailed(errorMsg: e.toString()));
    }
  }
}
