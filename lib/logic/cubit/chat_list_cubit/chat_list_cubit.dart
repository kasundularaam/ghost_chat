import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/core/constants/app_enums.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/screen_args/chat_card_args.dart';
import 'package:meta/meta.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListInitial());

  Future<void> loadChats() async {
    try {
      emit(ChatListLoading());
      await Future.delayed(const Duration(seconds: 2));

      ChatCardArgs milene = ChatCardArgs(
          friend: Friend(
              contactName: "Milene Mayer M",
              userBio: 'a',
              userId: '1',
              userImg: "assets/images/milene.png",
              userName: 'Mil',
              userNumber: '12'),
          msgType: MsgType.text,
          lastMsgTime: "19:50",
          unreadMsgCount: 3,
          lastMsg: "Hey Pakete!");
      List<ChatCardArgs> chatCardArgsList = [
        milene,
        // berry,
        // pakete,
        // angustia,
        // kamunas
      ];
      emit(ChatListLoaded(chatCardArgsList: chatCardArgsList));
    } catch (e) {
      emit(ChatListFailed(errorMsg: e.toString()));
    }
  }
}
