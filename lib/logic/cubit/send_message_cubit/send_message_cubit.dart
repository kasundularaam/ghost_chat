import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/encrypt_services/handle_encode.dart';
import 'package:ghost_chat/data/models/decoded_message_model.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/encoded_message_model.dart';
import 'package:ghost_chat/data/repositories/conversation_repo.dart';
import 'package:ghost_chat/data/repositories/local_repo.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/requests/encode_request.dart';
import 'package:ghost_chat/data/sqlite/message_helper.dart';
import 'package:meta/meta.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit() : super(SendMessageInitial());

  Future<void> sendMessage({
    required DecodedMessageModel messageToSend,
    required String conversationId,
    required String friendNumber,
  }) async {
    try {
      emit(SendMessageAddingToDB());
      await MessageHelper.addMessage(decodedMessage: messageToSend);
      DecodedMessageModel messageToEncode =
          await MessageHelper.getMessage(messageId: messageToSend.messageId);

      emit(
        SendMessageUploading(
          sendingMsg: DownloadMessage(
            messageId: messageToEncode.messageId,
            senderId: messageToEncode.senderId,
            reciverId: messageToEncode.reciverId,
            sentTimestamp: messageToEncode.sentTimestamp,
            messageStatus: messageToEncode.messageStatus,
            stImageStoragePath: "null",
            messageLen: 0,
          ),
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

      await MessageRepo.sendMessage(
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
          messageStatus: "sent");
      emit(SendMessageSent());
    } catch (e) {
      emit(SendMessageFailed(errorMsg: e.toString()));
    }
  }
}
