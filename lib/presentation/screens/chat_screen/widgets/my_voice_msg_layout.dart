import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/voice_msg_player_cubit/voice_msg_player_cubit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';

import 'voice_msg_player.dart';

class MyVoiceMsgLayout extends StatefulWidget {
  final String conversationId;
  final DownloadMessage downloadMessage;
  const MyVoiceMsgLayout({
    Key? key,
    required this.conversationId,
    required this.downloadMessage,
  }) : super(key: key);

  @override
  State<MyVoiceMsgLayout> createState() => _MyVoiceMsgLayoutState();
}

class _MyVoiceMsgLayoutState extends State<MyVoiceMsgLayout> {
  AudioPlayer? audioPlayer;
  @override
  void initState() {
    audioPlayer = AudioPlayer();
    BlocProvider.of<MessageCubit>(context).loadVoiceMessage(
      downloadMessage: widget.downloadMessage,
      conversationId: widget.conversationId,
    );
    BlocProvider.of<MessageStatusCubit>(context).getMessageStatus(
      conversationId: widget.conversationId,
      messageId: widget.downloadMessage.messageId,
    );
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Flexible(
              child: BlocBuilder<MessageCubit, MessageState>(
                builder: (context, state) {
                  if (state is MessageLoading) {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: BlocProvider(
                            create: (context) => VoiceMsgPlayerCubit(player: audioPlayer!),
                            child: VoiceMsgPlayer(
                              audioFilePath: state.message.audioFilePath,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                            SizedBox(
                              width: 3.w,
                            ),
                            BlocBuilder<MessageStatusCubit, MessageStatusState>(
                              builder: (context, state) {
                                if (state is MessageStatusLoaded) {
                                  if (state.status.toLowerCase() == "sent") {
                                    return Icon(
                                      Icons.check_rounded,
                                      color: AppColors.lightColor,
                                      size: 14.sp,
                                    );
                                  } else if (state.status.toLowerCase() ==
                                      "seen") {
                                    return Icon(
                                      Icons.done_all_rounded,
                                      color: AppColors.primaryColor,
                                      size: 14.sp,
                                    );
                                  } else if (state.status.toLowerCase() ==
                                      "delevered") {
                                    return Icon(
                                      Icons.done_all_rounded,
                                      color: AppColors.lightColor,
                                      size: 14.sp,
                                    );
                                  } else {
                                    return Icon(
                                      Icons.access_time_rounded,
                                      color: AppColors.lightColor,
                                      size: 14.sp,
                                    );
                                  }
                                } else {
                                  return Icon(
                                    Icons.access_time_rounded,
                                    color: AppColors.lightColor,
                                    size: 14.sp,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black,
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
            )
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}
