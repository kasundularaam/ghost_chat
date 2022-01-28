import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/fi_voice_message.dart';
import 'package:ghost_chat/data/repositories/conversation_repo.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/repositories/sound_recorder.dart';
import 'package:ghost_chat/data/sqlite/message_helper.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'voice_message_state.dart';

class VoiceMessageCubit extends Cubit<VoiceMessageState> {
  VoiceMessageCubit() : super(VoiceMessageInitial());

  SoundRecorder soundRecorder = SoundRecorder();

  int counter = 0;
  String timeString = "00:00:00";
  String hoursStr = "";
  String minutesStr = "";
  String secondsStr = "";
  int startTimestamp = 0;
  int endTimestamp = 0;
  Timer? _myTimer;
  Duration timerInterval = const Duration(seconds: 1);

  Future<void> startRecording({required String conversationId}) async {
    try {
      Uuid uuid = const Uuid();
      String messageId = uuid.v1();
      messageId = messageId.replaceAll(RegExp(r'[^\w\s]+'), '');
      Directory dir = await getApplicationSupportDirectory();
      String pathToSave = "${dir.path}/send/$conversationId/$messageId.aac";
      soundRecorder.record(pathToSave: pathToSave);
      _myTimer = Timer.periodic(timerInterval, (timer) {
        counter++;
        hoursStr =
            ((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
        minutesStr = ((counter / 60) % 60).floor().toString().padLeft(2, '0');
        secondsStr = (counter % 60).floor().toString().padLeft(2, '0');
        timeString = "$hoursStr" ":" "$minutesStr" ":" "$secondsStr";
        emit(
          VoiceMessageRecording(
            recordTime: timeString,
            filePath: pathToSave,
            messageId: messageId,
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelRecording({required String filePath}) async {
    try {
      if (soundRecorder.isRecording) {
        soundRecorder.stop();
      }
      if (_myTimer != null) {
        _myTimer!.cancel();
        _myTimer = null;
      }
      soundRecorder.delete(filePath: filePath);
      emit(VoiceMessageCanceled());
      emit(VoiceMessageInitial());
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendVoiceMsg({
    required FiVoiceMessage voiceMessage,
    required String conversationId,
    required String friendNumber,
  }) async {
    if (_myTimer != null) {
      _myTimer!.cancel();
      _myTimer = null;
    }
    try {
      emit(VoiceMessageAddingToDB());
      await MessageHelper.addVoiceMessage(fiVoiceMessage: voiceMessage);
      FiVoiceMessage messageToUpload = await MessageHelper.getVoiceMsg(
        messageId: voiceMessage.messageId,
      );
      emit(
        VoiceMessageUploading(
          uploadingMsg: DownloadMessage(
              messageId: messageToUpload.messageId,
              senderId: messageToUpload.senderId,
              reciverId: messageToUpload.reciverId,
              sentTimestamp: messageToUpload.sentTimestamp,
              messageStatus: messageToUpload.messageStatus,
              msgFilePath: messageToUpload.audioFilePath,
              messageLen: 0,
              isTextMsg: false),
        ),
      );
      await MessageRepo.sendVoiceMessage(
        message: messageToUpload,
        conversationId: conversationId,
      );
      await ConversationRepo.updateConversation(
        friendId: messageToUpload.reciverId,
        lastUpdate: messageToUpload.sentTimestamp,
        conversationId: conversationId,
        friendNumber: friendNumber,
        active: true,
      );
      await MessageRepo.updateMessageStatus(
          conversationId: conversationId,
          messageId: messageToUpload.messageId,
          messageStatus: "Sent");
      emit(VoiceMessageSent());
    } catch (e) {
      emit(VoiceMessageFailed(errorMsg: e.toString()));
    }
  }

  Future<void> init() async {
    soundRecorder.init();
  }

  Future<void> dispose() async {
    soundRecorder.dispose();
  }
}
