import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';

import 'friend_text_msg_layout.dart';
import 'my_text_msg_layout.dart';

class MessageCard extends StatelessWidget {
  final DownloadMessage message;
  final String conversationId;
  const MessageCard({
    Key? key,
    required this.message,
    required this.conversationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MessageCubit>(context).loadTextMessage(
        downloadMessage: message, conversationId: conversationId);
    BlocProvider.of<MessageStatusCubit>(context).getMessageStatus(
        conversationId: conversationId, messageId: message.messageId);
    bool myMsg = message.senderId == AuthRepo.currentUid;
    if (myMsg) {
      if (message.isTextMsg) {
        return const MyTextMsgLayout();
      } else {
        return Text("VOICE MESSAGE");
      }
    } else {
      if (message.isTextMsg) {
        return const FriendTextMsgLayout();
      } else {
        return Text("VOICE MESSAGE");
      }
    }
  }
}
