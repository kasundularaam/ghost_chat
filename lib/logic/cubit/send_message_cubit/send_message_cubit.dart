import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/encyption/message_encoder.dart';
import 'package:ghost_chat/data/models/decoded_message_model.dart';
import 'package:ghost_chat/data/models/encoded_message_model.dart';
import 'package:ghost_chat/data/repositories/conversation_repo.dart';
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
  }) async {
    try {
      emit(SendMessageAddingToDB());
      await MessageHelper.addMessage(decodedMessage: messageToSend);
      DecodedMessageModel messageToEncode =
          await MessageHelper.getMessage(messageId: messageToSend.messageId);

      emit(SendMessageUploading());
      String token = messageToEncode.senderId.substring(2, 10) +
          messageToEncode.reciverId.substring(2, 10);
      File stImage = await encodeMessageIntoImage(
          EncodeRequest(msg: messageToEncode.message, token: token));

      EncodedMessageModel encodedMessage = EncodedMessageModel(
          messageId: messageToEncode.messageId,
          senderId: messageToEncode.senderId,
          reciverId: messageToEncode.reciverId,
          sentTimestamp: messageToEncode.sentTimestamp,
          messageStatus: messageToEncode.messageStatus,
          stImage: stImage);

      await MessageRepo.sendMessage(
          message: encodedMessage, conversationId: conversationId);
      await ConversationRepo.updateConversation(
          friendId: encodedMessage.reciverId,
          lastUpdate: encodedMessage.sentTimestamp,
          conversationId: conversationId,
          active: true);
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
