import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/data/encrypt_services/handle_decode.dart';
import 'package:ghost_chat/data/models/fi_text_message.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/fi_voice_message.dart';
import 'package:ghost_chat/data/repositories/local_repo.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/sqlite/message_helper.dart';
import 'package:meta/meta.dart';

import '../../../data/models/msg_status.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  FiTextMessage? _loadedMsgText;
  FiVoiceMessage? _loadedMsgVoice;
  Timer? _myTimer;

  Future<void> loadTextMessage(
      {required DownloadMessage downloadMessage,
      required String conversationId}) async {
    try {
      if (_loadedMsgText != null) {
        DateTime seenTime = DateTime.fromMillisecondsSinceEpoch(int.parse(
          downloadMessage.msgSeenTime,
        ));
        int disappearTime = seenTime
            .add(Duration(minutes: downloadMessage.disappearingDuration))
            .millisecondsSinceEpoch;

        if (disappearTime < DateTime.now().millisecondsSinceEpoch) {
          _myTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (disappearTime < DateTime.now().millisecondsSinceEpoch) {
              emit(
                MessageLoadedText(
                  message: _loadedMsgText!,
                ),
              );
            } else {
              loadTextMessage(
                  downloadMessage: downloadMessage,
                  conversationId: conversationId);
            }
          });
        } else {}
      } else {
        emit(MessageLoading(loadingMsg: "checking..."));
        bool exist = await MessageHelper.checkMessageExist(
            messageId: downloadMessage.messageId);
        if (exist) {
          emit(MessageLoading(loadingMsg: "loading..."));
          FiTextMessage messageFromDb = await MessageHelper.getTextMessage(
              messageId: downloadMessage.messageId);
          _loadedMsgText = messageFromDb;
          loadTextMessage(
              downloadMessage: downloadMessage, conversationId: conversationId);
        } else {
          emit(MessageLoading(loadingMsg: "downloading..."));
          String encodedImgPath = await LocalRepo.getStImagePath(
              conversationId: conversationId,
              messageId: downloadMessage.messageId,
              messageFilePath: downloadMessage.msgFilePath);
          emit(MessageLoading(loadingMsg: "decoding..."));

          String decryptedMsg = handleDecodeRequest(
            imagePath: encodedImgPath,
            messageLength: downloadMessage.messageLen,
          );
          FiTextMessage decodedMessage = FiTextMessage(
            messageId: downloadMessage.messageId,
            senderId: downloadMessage.senderId,
            receiverId: downloadMessage.receiverId,
            sentTimestamp: downloadMessage.sentTimestamp,
            messageStatus: Strings.seen,
            message: decryptedMsg,
            disappearingDuration: downloadMessage.disappearingDuration,
            msgSeenTime: DateTime.now().millisecondsSinceEpoch.toString(),
          );
          emit(
            MessageLoading(
              loadingMsg: "finalizing...",
            ),
          );
          await MessageHelper.addTextMessage(
            fiTextMessage: decodedMessage,
          );
          await MessageRepo.updateMessageStatus(
            conversationId: conversationId,
            messageId: decodedMessage.messageId,
            msgStatus: MsgStatus(
              msgStatus: Strings.seen,
              msgSeenTime: decodedMessage.msgSeenTime,
            ),
          );
          loadTextMessage(
            downloadMessage: downloadMessage,
            conversationId: conversationId,
          );
        }
      }
    } catch (e) {
      emit(
        MessageFailed(
          errorMsg: e.toString(),
        ),
      );
    }
  }

  Future<void> loadVoiceMessage(
      {required DownloadMessage downloadMessage,
      required String conversationId}) async {
    try {
      if (_loadedMsgVoice != null) {
        emit(
          MessageLoadedVoice(
            message: _loadedMsgVoice!,
          ),
        );
      } else {
        emit(MessageLoading(loadingMsg: "checking..."));
        bool exist = await MessageHelper.checkMessageExist(
            messageId: downloadMessage.messageId);
        if (exist) {
          emit(MessageLoading(loadingMsg: "loading..."));
          FiVoiceMessage messageFromDb = await MessageHelper.getVoiceMsg(
              messageId: downloadMessage.messageId);
          _loadedMsgVoice = messageFromDb;
          loadTextMessage(
              downloadMessage: downloadMessage, conversationId: conversationId);
        } else {
          emit(MessageLoading(loadingMsg: "downloading voice message..."));
          String downloadedAudioPath = await LocalRepo.getAudioFilePath(
            conversationId: conversationId,
            messageId: downloadMessage.messageId,
            messageFilePath: downloadMessage.msgFilePath,
          );

          FiVoiceMessage fiVoiceMessage = FiVoiceMessage(
            messageId: downloadMessage.messageId,
            senderId: downloadMessage.senderId,
            receiverId: downloadMessage.receiverId,
            sentTimestamp: downloadMessage.sentTimestamp,
            messageStatus: Strings.seen,
            audioFilePath: downloadedAudioPath,
            disappearingDuration: downloadMessage.disappearingDuration,
            msgSeenTime: DateTime.now().millisecondsSinceEpoch.toString(),
          );
          emit(MessageLoading(loadingMsg: "finalizing..."));
          await MessageHelper.addVoiceMessage(fiVoiceMessage: fiVoiceMessage);
          await MessageRepo.updateMessageStatus(
            conversationId: conversationId,
            messageId: fiVoiceMessage.messageId,
            msgStatus: MsgStatus(
              msgStatus: Strings.seen,
              msgSeenTime: fiVoiceMessage.msgSeenTime,
            ),
          );
          loadTextMessage(
              downloadMessage: downloadMessage, conversationId: conversationId);
        }
      }
    } catch (e) {
      emit(MessageFailed(errorMsg: e.toString()));
    }
  }
}
