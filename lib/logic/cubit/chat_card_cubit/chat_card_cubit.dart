import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:meta/meta.dart';

part 'chat_card_state.dart';

class ChatCardCubit extends Cubit<ChatCardState> {
  ChatCardCubit() : super(ChatCardInitial());

  Future<void> loadChatCard(
      {required String conversationId, required String friendId}) async {
    try {
      emit(ChatCardLoading());
      int unreadMsgCount =
          await MessageRepo.getUnreadMsgCount(conversationId: conversationId);
      Friend friend = await UsersRepo.getFriendDetails(userId: friendId);

      emit(ChatCardLoaded(
          unreadMsgCount: unreadMsgCount, friendImage: friend.userImg));
    } catch (e) {
      print(e);
    }
  }
}
