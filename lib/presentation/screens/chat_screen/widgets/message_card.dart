import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/friend_voice_msg_layout.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/my_voice_msg_layout.dart';
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
    bool myMsg = message.senderId == AuthRepo.currentUid;
    if (myMsg) {
      if (message.isTextMsg) {
        return MyTextMsgLayout(
          conversationId: conversationId,
          downloadMessage: message,
        );
      } else {
        return MyVoiceMsgLayout(
          conversationId: conversationId,
          downloadMessage: message,
        );
      }
    } else {
      if (message.isTextMsg) {
        return FriendTextMsgLayout(
          conversationId: conversationId,
          downloadMessage: message,
        );
      } else {
        return FriendVoiceMsgLayout(
          conversationId: conversationId,
          downloadMessage: message,
        );
      }
    }
  }
}
