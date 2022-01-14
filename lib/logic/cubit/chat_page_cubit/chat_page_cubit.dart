import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:meta/meta.dart';

part 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageInitial());

  Future<void> showMessages({required String conversationId}) async {
    try {
      Stream<List<DownloadMessage>> messageStream =
          MessageRepo.getMessages(conversationId: conversationId);
      messageStream.listen((messageList) {
        if (messageList.isNotEmpty && messageList != null) {
          emit(ChatPageShowMessages(messegesList: messageList));
        } else {
          emit(ChatPageNoMessages());
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
