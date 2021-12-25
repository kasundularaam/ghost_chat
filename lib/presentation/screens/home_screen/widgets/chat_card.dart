import 'package:flutter/material.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/screen_args/chat_card_args.dart';

class ChatCard extends StatelessWidget {
  final ChatCardArgs chatCardArgs;
  const ChatCard({
    Key? key,
    required this.chatCardArgs,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.chatPage,
              arguments: chatCardArgs.friend.userId),
          child: Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
                border: Border.all(width: 0.1.w),
                color: AppColors.darkColor,
                borderRadius: BorderRadius.circular(2.w)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    // "assets/images/milene.png",
                    chatCardArgs.friend.userImg,
                    width: 14.w,
                    height: 14.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatCardArgs.friend.contactName,
                              style: TextStyle(
                                color: AppColors.lightColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            chatCardArgs.lastMsgTime,
                            style: TextStyle(
                                color: AppColors.lightColor.withOpacity(0.7),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0.3.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatCardArgs.lastMsg,
                              style: TextStyle(
                                color: AppColors.lightColor.withOpacity(0.7),
                                fontSize: 11.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle),
                            child: Text(
                              "${chatCardArgs.unreadMsgCount}",
                              style: TextStyle(
                                  color: AppColors.lightColor.withOpacity(0.7),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 0.5.w,
        ),
      ],
    );
  }
}
