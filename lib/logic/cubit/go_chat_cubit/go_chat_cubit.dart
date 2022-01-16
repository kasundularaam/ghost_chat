import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/conversation_model.dart';
import 'package:ghost_chat/data/repositories/conversation_repo.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'go_chat_state.dart';

class GoChatCubit extends Cubit<GoChatState> {
  GoChatCubit() : super(GoChatInitial());

  Future<void> goChat({required String friendId}) async {
    try {
      emit(GoChatLoading());
      bool exist = await ConversationRepo.checkConvExist(friendId: friendId);
      if (exist) {
        ConversationModel conversation =
            await ConversationRepo.getConversation(friendId: friendId);
        emit(
          GoChatSucceed(
            friendId: conversation.friendId,
            conversationId: conversation.conversationId,
          ),
        );
      } else {
        Uuid uuid = const Uuid();
        String genConvId = uuid.v1();
        genConvId = genConvId.replaceAll(RegExp(r'[^\w\s]+'), '');
        String lastUpdate = DateTime.now().microsecondsSinceEpoch.toString();
        await ConversationRepo.updateConversation(
          friendId: friendId,
          lastUpdate: lastUpdate,
          conversationId: genConvId,
          active: false,
        );
      }
      ConversationModel conversation =
          await ConversationRepo.getConversation(friendId: friendId);
      emit(GoChatSucceed(
          friendId: friendId, conversationId: conversation.conversationId));
    } catch (e) {
      emit(GoChatFailed(errorMsg: e.toString()));
    }
  }
}
