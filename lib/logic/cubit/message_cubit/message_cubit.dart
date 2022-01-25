import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/encrypt_services/handle_decode.dart';
import 'package:ghost_chat/data/models/fi_text_message.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/fi_voice_message.dart';
import 'package:ghost_chat/data/repositories/local_repo.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/sqlite/message_helper.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  FiTextMessage? _loadedMsgText;
  FiVoiceMessage? _loadedMsgVoice;

  Future<void> loadTextMessage(
      {required DownloadMessage downloadMessage,
      required String conversationId}) async {
    try {
      if (_loadedMsgText != null) {
        emit(
          MessageLoadedText(
            message: _loadedMsgText!,
          ),
        );
      } else {
        emit(MessageLoading(loadingMsg: "checking..."));
        bool exist = await MessageHelper.checkMessageExist(
            messageId: downloadMessage.messageId);
        if (exist) {
          emit(MessageLoading(loadingMsg: "loading..."));
          FiTextMessage messageFromDb = await MessageHelper.getTextMessage(
              messageId: downloadMessage.messageId);
          _loadedMsgText = messageFromDb;
          emit(
            MessageLoadedText(
              message: _loadedMsgText!,
            ),
          );
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
            reciverId: downloadMessage.reciverId,
            sentTimestamp: downloadMessage.sentTimestamp,
            messageStatus: "Seen",
            message: decryptedMsg,
          );
          emit(MessageLoading(loadingMsg: "finalizing..."));
          await MessageHelper.addTextMessage(fiTextMessage: decodedMessage);
          await MessageRepo.updateMessageStatus(
              conversationId: conversationId,
              messageId: decodedMessage.messageId,
              messageStatus: "Seen");
          loadTextMessage(
              downloadMessage: downloadMessage, conversationId: conversationId);
        }
      }
    } catch (e) {
      emit(MessageFailed(errorMsg: e.toString()));
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
          emit(
            MessageLoadedVoice(
              message: _loadedMsgVoice!,
            ),
          );
        } else {
          emit(MessageLoading(loadingMsg: "downloading voice message..."));
          String downloadedAudioPath = await LocalRepo.getStImagePath(
            conversationId: conversationId,
            messageId: downloadMessage.messageId,
            messageFilePath: downloadMessage.msgFilePath,
          );

          FiVoiceMessage fiVoiceMessage = FiVoiceMessage(
            messageId: downloadMessage.messageId,
            senderId: downloadMessage.senderId,
            reciverId: downloadMessage.reciverId,
            sentTimestamp: downloadMessage.sentTimestamp,
            messageStatus: "Seen",
            audioFilePath: downloadedAudioPath,
          );
          emit(MessageLoading(loadingMsg: "finalizing..."));
          await MessageHelper.addVoiceMessage(fiVoiceMessage: fiVoiceMessage);
          await MessageRepo.updateMessageStatus(
            conversationId: conversationId,
            messageId: fiVoiceMessage.messageId,
            messageStatus: "Seen",
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
