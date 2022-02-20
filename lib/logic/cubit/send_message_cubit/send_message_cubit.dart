import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/data/encrypt_services/handle_encode.dart';
import 'package:ghost_chat/data/models/fi_text_message.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/models/encoded_message_model.dart';
import 'package:ghost_chat/data/models/msg_status.dart';
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
            receiverId: messageToEncode.receiverId,
            sentTimestamp: messageToEncode.sentTimestamp,
            messageStatus: messageToEncode.messageStatus,
            msgFilePath: "null",
            messageLen: 0,
            isTextMsg: true,
            disappearingDuration: messageToEncode.disappearingDuration,
            msgSeenTime: messageToEncode.msgSeenTime,
          ),
        ),
      );

      String originalPath = await LocalRepo.getImageFileFromAssets();

      String encodedImgPath = await handleEncodeRequest(
        request: EncodeRequest(
          imagePath: originalPath,
          message: messageToEncode.message,
          conversationId: conversationId,
          messageId: messageToEncode.messageId,
        ),
      );
      File stImage = File(encodedImgPath);
      EncodedMessageModel encodedMessage = EncodedMessageModel(
        messageId: messageToEncode.messageId,
        senderId: messageToEncode.senderId,
        receiverId: messageToEncode.receiverId,
        sentTimestamp: messageToEncode.sentTimestamp,
        messageStatus: messageToEncode.messageStatus,
        stImage: stImage,
        messageLen: messageToEncode.message.length,
        disappearingDuration: messageToEncode.disappearingDuration,
        msgSeenTime: messageToEncode.msgSeenTime,
      );

      await MessageRepo.sendTextMessage(
          message: encodedMessage, conversationId: conversationId);
      await ConversationRepo.updateConversation(
        friendId: encodedMessage.receiverId,
        lastUpdate: encodedMessage.sentTimestamp,
        conversationId: conversationId,
        friendNumber: friendNumber,
        active: true,
      );
      await MessageRepo.updateMessageStatus(
        conversationId: conversationId,
        messageId: encodedMessage.messageId,
        msgStatus: MsgStatus(
          msgStatus: Strings.sent,
          msgSeenTime: "null",
        ),
      );
      emit(SendMessageSent());
    } catch (e) {
      emit(SendMessageFailed(errorMsg: e.toString()));
    }
  }
}
