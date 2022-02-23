import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/fi_voice_message.dart';
import 'package:ghost_chat/data/repositories/conversation_repo.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/sqlite/message_helper.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/strings.dart';
import '../../../data/models/msg_status.dart';

part 'voice_message_state.dart';

class VoiceMessageCubit extends Cubit<VoiceMessageState> {
  VoiceMessageCubit() : super(VoiceMessageInitial());

  Record audioRecorder = Record();

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
    bool permissionsGranted = await Permission.microphone.request().isGranted;
    if (permissionsGranted) {
      try {
        Uuid uuid = const Uuid();
        String messageId = uuid.v1();
        messageId = messageId.replaceAll(RegExp(r'[^\w\s]+'), '');
        Directory dir = await getApplicationDocumentsDirectory();
        String pathToSave = "${dir.path}/send/$conversationId/$messageId.acc";
        File file = await File(pathToSave).create(recursive: true);
        await audioRecorder.start(path: file.path);
        bool isRec = await audioRecorder.isRecording();
        if (isRec) {
          _myTimer = Timer.periodic(timerInterval, (timer) {
            counter++;
            hoursStr =
                ((counter / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
            minutesStr =
                ((counter / 60) % 60).floor().toString().padLeft(2, '0');
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
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> cancelRecording({required String filePath}) async {
    try {
      bool isRec = await audioRecorder.isRecording();
      if (isRec) {
        await audioRecorder.stop();
        if (_myTimer != null) {
          counter = 0;
          _myTimer!.cancel();
          _myTimer = null;
          emit(VoiceMessageCanceled());
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendVoiceMsg({
    required FiVoiceMessage voiceMessage,
    required String conversationId,
    required String friendNumber,
  }) async {
    bool isRec = await audioRecorder.isRecording();
    if (isRec) {
      audioRecorder.stop();
      if (_myTimer != null) {
        counter = 0;
        _myTimer!.cancel();
        _myTimer = null;

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
                receiverId: messageToUpload.receiverId,
                sentTimestamp: messageToUpload.sentTimestamp,
                messageStatus: messageToUpload.messageStatus,
                msgFilePath: messageToUpload.audioFilePath,
                messageLen: 0,
                isTextMsg: false,
                disappearingDuration: messageToUpload.disappearingDuration,
                msgSeenTime: messageToUpload.msgSeenTime,
              ),
            ),
          );
          await MessageRepo.sendVoiceMessage(
            message: messageToUpload,
            conversationId: conversationId,
          );
          await ConversationRepo.updateConversation(
            friendId: messageToUpload.receiverId,
            lastUpdate: messageToUpload.sentTimestamp,
            conversationId: conversationId,
            friendNumber: friendNumber,
            active: true,
          );
          await MessageRepo.updateMessageStatus(
            conversationId: conversationId,
            messageId: messageToUpload.messageId,
            msgStatus: MsgStatus(
              msgStatus: Strings.sent,
              msgSeenTime: "null",
            ),
          );
          emit(VoiceMessageSent());
        } catch (e) {
          emit(VoiceMessageFailed(errorMsg: e.toString()));
        }
      }
    }
  }
}
