import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';

class FriendTextMsgLayout extends StatelessWidget {
  final String conversationId;
  final DownloadMessage downloadMessage;
  const FriendTextMsgLayout({
    Key? key,
    required this.conversationId,
    required this.downloadMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MessageCubit>(context).loadTextMessage(
      downloadMessage: downloadMessage,
      conversationId: conversationId,
    );
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
                  } else if (state is MessageLoadedText) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            2.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(2.w),
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
