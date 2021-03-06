import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/voice_msg_player_cubit/voice_msg_player_cubit.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/voice_msg_player.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';

class FriendVoiceMsgLayout extends StatefulWidget {
  final String conversationId;
  final DownloadMessage downloadMessage;
  const FriendVoiceMsgLayout({
    Key? key,
    required this.conversationId,
    required this.downloadMessage,
  }) : super(key: key);

  @override
  State<FriendVoiceMsgLayout> createState() => _FriendVoiceMsgLayoutState();
}

class _FriendVoiceMsgLayoutState extends State<FriendVoiceMsgLayout> {
  @override
  void initState() {
    BlocProvider.of<MessageCubit>(context).loadVoiceMessage(
      conversationId: widget.conversationId,
      downloadMessage: widget.downloadMessage,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: BlocBuilder<MessageCubit, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  } else if (state is MessageLoadedVoice) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: BlocProvider(
                            create: (context) => VoiceMsgPlayerCubit(
                                audioFilePath: state.message.audioFilePath),
                            child: const VoiceMsgPlayer(),
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          timeago.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(
                                state.message.sentTimestamp,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: AppColors.lightColor,
                            fontSize: 8.sp,
                          ),
                        ),
                      ],
                    );
                  } else if (state is MessageDisappeared) {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        "Cant load message at the moment!",
                        style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}
