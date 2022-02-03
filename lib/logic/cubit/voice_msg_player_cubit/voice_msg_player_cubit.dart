import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

part 'voice_msg_player_state.dart';

class VoiceMsgPlayerCubit extends Cubit<VoiceMsgPlayerState> {
  AudioPlayer player;
  VoiceMsgPlayerCubit({required this.player}) : super(VoiceMsgPlayerInitial());

  Timer? timer;
  int counter = 0;
  Duration timerInterval = const Duration(milliseconds: 200);

  Future<void> loadPlayer({required audioFilePath}) async {
    print("AUDIOOOO>>>>> $audioFilePath");
    try {
      emit(VoiceMsgPlayerLoading());
      Duration? duration = await player.setFilePath(audioFilePath);
      print("DURATION>>>>> $duration");
      if (duration != null) {
        int audioLength = duration.inMilliseconds;
        await player.setPitch(0);
        emit(VoiceMsgPlayerLoaded(audioLength: audioLength));
      }else{
        emit(VoiceMsgPlayerFailed(errorMsg: "An error occurred"));
      }
    } catch (e) {
      print("ERROR>>>>> $e");
      emit(VoiceMsgPlayerFailed(errorMsg: e.toString()));
    }
  }

  Future<void> playPlayer({required int audioLength}) async {
    try {
      player.play();
      timer = Timer.periodic(timerInterval, (timerVal) async {
        counter = counter + 200;
        if (counter < audioLength) {
          emit(VoiceMsgPlayerPlaying(seekBarValue: counter));
        } else {
          timer!.cancel();
          timer = null;
          counter = 0;
          await player.stop();
          emit(VoiceMsgPlayerLoaded(audioLength: audioLength));
        }
      });
    } catch (e) {
      emit(VoiceMsgPlayerFailed(errorMsg: e.toString()));
    }
  }

}
