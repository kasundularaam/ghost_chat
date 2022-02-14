import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/data/models/conversation_model.dart';
import 'package:ghost_chat/data/repositories/conversation_repo.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListInitial());

  Future<void> loadChats() async {
    try {
      Stream<List<ConversationModel>> convStream =
          ConversationRepo.getMyConversations();
      convStream.listen((conveList) {
        emit(ChatListLoaded(conversations: conveList));
      });
    } catch (e) {
      emit(ChatListFailed(errorMsg: e.toString()));
    }
  }
}
