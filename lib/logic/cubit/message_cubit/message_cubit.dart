import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/encrypt_services/handle_decode.dart';
import 'package:ghost_chat/data/models/decoded_message_model.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/repositories/local_repo.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/sqlite/message_helper.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  Future<void> loadMessage(
      {required DownloadMessage downloadMessage,
      required String conversationId}) async {
    try {
      emit(MessageLoading());
      bool exist = await MessageHelper.checkMessageExist(
          messageId: downloadMessage.messageId);
      if (exist) {
        DecodedMessageModel messageFromDb = await MessageHelper.getMessage(
            messageId: downloadMessage.messageId);
        emit(
          MessageLoaded(
            message: messageFromDb,
          ),
        );
      } else {
        String encodedImgPath = await LocalRepo.getStImagePath(
            conversationId: conversationId,
            messageId: downloadMessage.messageId,
            stImgStoragePath: downloadMessage.stImageStoragePath);

        String decryptedMsg = handleDecodeRequest(
          imagePath: encodedImgPath,
          messageLength: downloadMessage.messageLen,
        );

        DecodedMessageModel decodedMessage = DecodedMessageModel(
            messageId: downloadMessage.messageId,
            senderId: downloadMessage.senderId,
            reciverId: downloadMessage.reciverId,
            sentTimestamp: downloadMessage.sentTimestamp,
            messageStatus: "Seen",
            message: decryptedMsg);
        await MessageHelper.addMessage(decodedMessage: decodedMessage);
        await MessageRepo.updateMessageStatus(
            conversationId: conversationId,
            messageId: decodedMessage.messageId,
            messageStatus: "Seen");
        loadMessage(
            downloadMessage: downloadMessage, conversationId: conversationId);
      }
    } catch (e) {
      emit(MessageFailed(errorMsg: e.toString()));
    }
  }
}
