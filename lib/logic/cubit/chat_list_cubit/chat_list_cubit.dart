import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/core/constants/app_enums.dart';
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
          userName: "Milene Mayer",
          profileImg: "assets/images/milene.png",
          msgType: MsgType.text,
          lastMsgTime: "19:50",
          unreadMsgCount: 3,
          lastMsg: "Hey Milene!");
      ChatCardArgs berry = ChatCardArgs(
          userName: "Milene Mayer",
          profileImg: "assets/images/milene.png",
          msgType: MsgType.text,
          lastMsgTime: "19:50",
          unreadMsgCount: 3,
          lastMsg: "Hey Milene!");
      ChatCardArgs pakete = ChatCardArgs(
          userName: "Milene Mayer",
          profileImg: "assets/images/milene.png",
          msgType: MsgType.text,
          lastMsgTime: "19:50",
          unreadMsgCount: 3,
          lastMsg: "Hey Milene!");
      ChatCardArgs angustia = ChatCardArgs(
          userName: "Milene Mayer",
          profileImg: "assets/images/milene.png",
          msgType: MsgType.text,
          lastMsgTime: "19:50",
          unreadMsgCount: 3,
          lastMsg: "Hey Milene!");
      ChatCardArgs kamunas = ChatCardArgs(
          userName: "Milene Mayer",
          profileImg: "assets/images/milene.png",
          msgType: MsgType.text,
          lastMsgTime: "19:50",
          unreadMsgCount: 3,
          lastMsg: "Hey Milene!");
      List<ChatCardArgs> chatCardArgsList = [
        milene,
        berry,
        pakete,
        angustia,
        kamunas
      ];
      emit(ChatListLoaded(chatCardArgsList: chatCardArgsList));
    } catch (e) {
      emit(ChatListFailed(errorMsg: e.toString()));
    }
  }
}
