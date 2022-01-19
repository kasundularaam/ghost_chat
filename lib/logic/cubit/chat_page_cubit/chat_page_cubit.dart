import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:meta/meta.dart';

part 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageInitial());

  List<DownloadMessage> allMessages = [];

  Future<void> showMessages({required String conversationId}) async {
    try {
      Stream<List<DownloadMessage>> fireStream =
          MessageRepo.getMessages(conversationId: conversationId);
      fireStream.listen((fireList) {
        for (DownloadMessage fireMsg in fireList) {
          bool exist = allMessages
              .map((messageFromAll) => messageFromAll.messageId)
              .contains(fireMsg.messageId);
          if (!exist) {
            allMessages.add(fireMsg);
            if (allMessages.isNotEmpty) {
              emit(
                ChatPageShowMessages(
                  messegesList: allMessages.reversed.toList(),
                ),
              );
            } else {
              emit(ChatPageNoMessages());
            }
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void addSendMessage({required DownloadMessage downloadedMsg}) async {
    try {
      allMessages.insert(0, downloadedMsg);
      if (allMessages.isNotEmpty) {
        emit(
          ChatPageShowMessages(
            messegesList: allMessages.reversed.toList(),
          ),
        );
      } else {
        emit(ChatPageNoMessages());
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
