import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/encrypt_services/handle_encode.dart';
import 'package:ghost_chat/data/models/fi_text_message.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/encoded_message_model.dart';
import 'package:ghost_chat/data/models/fi_voice_message.dart';
import 'package:ghost_chat/data/repositories/conversation_repo.dart';
import 'package:ghost_chat/data/repositories/local_repo.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/requests/encode_request.dart';
import 'package:ghost_chat/data/sqlite/message_helper.dart';
import 'package:meta/meta.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageInitial());

  Future<void> sendTextMessage({
    required FiTextMessage messageToSend,
    required String conversationId,
    required String friendNumber,
  }) async {
    try {
      emit(
        SendMessageAddingToDB(),
      );
      await MessageHelper.addTextMessage(fiTextMessage: messageToSend);
      FiTextMessage messageToEncode = await MessageHelper.getTextMessage(
        messageId: messageToSend.messageId,
      );

      emit(
        SendMessageUploading(
          sendingMsg: DownloadMessage(
              messageId: messageToEncode.messageId,
              senderId: messageToEncode.senderId,
              reciverId: messageToEncode.reciverId,
              sentTimestamp: messageToEncode.sentTimestamp,
              messageStatus: messageToEncode.messageStatus,
              msgFilePath: "null",
              messageLen: 0,
              isTextMsg: true),
        ),
      );

      String originalPath = await LocalRepo.getImageFileFromAssets();

      String encodedImgPath = await handleEncodeRequest(
        request: EncodeRequest(
          imagePath: originalPath,
          message: messageToEncode.message,
          conversatioId: conversationId,
          messageId: messageToEncode.messageId,
        ),
      );
      File stImage = File(encodedImgPath);
      EncodedMessageModel encodedMessage = EncodedMessageModel(
        messageId: messageToEncode.messageId,
        senderId: messageToEncode.senderId,
        reciverId: messageToEncode.reciverId,
        sentTimestamp: messageToEncode.sentTimestamp,
        messageStatus: messageToEncode.messageStatus,
        stImage: stImage,
        messageLen: messageToEncode.message.length,
      );

      await MessageRepo.sendTextMessage(
          message: encodedMessage, conversationId: conversationId);
      await ConversationRepo.updateConversation(
        friendId: encodedMessage.reciverId,
        lastUpdate: encodedMessage.sentTimestamp,
        conversationId: conversationId,
        friendNumber: friendNumber,
        active: true,
      );
      await MessageRepo.updateMessageStatus(
          conversationId: conversationId,
          messageId: encodedMessage.messageId,
          messageStatus: "Sent");
      emit(SendMessageSent());
    } catch (e) {
      emit(SendMessageFailed(errorMsg: e.toString()));
    }
  }

  Future<void> sendVoiceMessage({
    required FiVoiceMessage messageToSend,
    required String conversationId,
    required String friendNumber,
  }) async {
    try {
      emit(
        SendMessageAddingToDB(),
      );
      await MessageHelper.addVoiceMessage(fiVoiceMessage: messageToSend);
      FiVoiceMessage messageToUpload = await MessageHelper.getVoiceMsg(
        messageId: messageToSend.messageId,
      );

      emit(
        SendMessageUploading(
          sendingMsg: DownloadMessage(
            messageId: messageToUpload.messageId,
            senderId: messageToUpload.senderId,
            reciverId: messageToUpload.reciverId,
            sentTimestamp: messageToUpload.sentTimestamp,
            messageStatus: messageToUpload.messageStatus,
            msgFilePath: messageToUpload.audioFilePath,
            messageLen: 0,
            isTextMsg: false,
          ),
        ),
      );

      await MessageRepo.sendVoiceMessage(
          message: messageToUpload, conversationId: conversationId);
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
          messageStatus: "sent");
      emit(SendMessageSent());
    } catch (e) {
      emit(SendMessageFailed(errorMsg: e.toString()));
    }
  }
}
