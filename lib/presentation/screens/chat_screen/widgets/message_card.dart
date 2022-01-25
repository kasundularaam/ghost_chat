import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      return const MyMsgLayout();
    } else {
      return const FriendMsgLayout();
    }
  }
}

class MyMsgLayout extends StatelessWidget {
  const MyMsgLayout({
    Key? key,
  }) : super(key: key);

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
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  } else if (state is MessageLoadedText) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(3.w),
                                child: Text(
                                  state.message.message,
                                  style: TextStyle(
                                    color: AppColors.lightColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 2.w, right: 2.w),
                                child: BlocBuilder<MessageStatusCubit,
                                    MessageStatusState>(
                                  builder: (context, state) {
                                    if (state is MessageStatusLoaded) {
                                      if (state.status.toLowerCase() ==
                                          "sent") {
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.4.h,
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
                  } else {
                    return Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(3.w),
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

class FriendMsgLayout extends StatelessWidget {
  const FriendMsgLayout({
    Key? key,
  }) : super(key: key);

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
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  } else if (state is MessageLoadedText) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Text(
                            state.message.message,
                            style: TextStyle(
                              color: AppColors.lightColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
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
                  } else {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(3.w),
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
