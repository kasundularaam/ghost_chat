import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyTextMsgLayout extends StatelessWidget {
  const MyTextMsgLayout({Key? key}) : super(key: key);

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
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.w),
                            child: Text(
                              state.message.message,
                              style: TextStyle(
                                color: AppColors.lightColor,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color:
                                      AppColors.primaryColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                            child: Row(
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
                                BlocBuilder<MessageStatusCubit,
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
                              ],
                            ),
                          ),
                        ],
                      ),
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
