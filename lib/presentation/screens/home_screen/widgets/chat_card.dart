import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/core/permissions_service.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:ghost_chat/data/screen_args/chat_screen_args.dart';
import 'package:ghost_chat/logic/cubit/chat_card_cubit/chat_card_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/conversation_model.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatCard extends StatelessWidget {
  final ConversationModel conversation;
  const ChatCard({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  Future<String> getSavedName({required String friendNumber}) async {
    try {
      bool permissionStatus = await PermissionService.getPermission(
          permission: Permission.contacts);
      if (permissionStatus) {
        String friendName =
            await UsersRepo.getSavedName(userPhone: friendNumber);
        return friendName;
      } else {
        return friendNumber;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChatCardCubit>(context).loadChatCard(
        conversationId: conversation.conversationId,
        friendId: conversation.friendId);
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRouter.chatPage,
            arguments: ChatScreenArgs(
                friendId: conversation.friendId,
                conversationId: conversation.conversationId,
                friendNumber: conversation.friendNumber),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
                border: Border.all(width: 0.1.w),
                color: AppColors.darkSecondary,
                borderRadius: BorderRadius.circular(2.w)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ChatCardCubit, ChatCardState>(
                  builder: (context, state) {
                    if (state is ChatCardLoaded) {
                      return ClipOval(
                        child: state.friendImage != "null"
                            ? FadeInImage.assetNetwork(
                                placeholder: Strings.ghostPlaceHolder,
                                image: state.friendImage,
                                width: 14.w,
                                height: 14.w,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                Strings.ghostPlaceHolder,
                                width: 14.w,
                                height: 14.w,
                                fit: BoxFit.cover,
                              ),
                      );
                    } else {
                      return ClipOval(
                        child: Image.asset(
                          Strings.ghostPlaceHolder,
                          width: 14.w,
                          height: 14.w,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
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
                            child: FutureBuilder<String>(
                                future: getSavedName(
                                    friendNumber: conversation.friendNumber),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.lightColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  } else {
                                    return Text(
                                      conversation.friendNumber,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.lightColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }
                                }),
                          ),
                          Text(
                            timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(
                                  conversation.lastUpdate,
                                ),
                              ),
                            ),
                            style: TextStyle(
                                color: AppColors.lightColor.withOpacity(0.7),
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.4.h,
                      ),
                      BlocBuilder<ChatCardCubit, ChatCardState>(
                        builder: (context, state) {
                          if (state is ChatCardLoaded) {
                            if (state.unreadMsgCount > 0) {
                              return Text(
                                state.unreadMsgCount > 1
                                    ? "${state.unreadMsgCount} new messages"
                                    : "One new message",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else {
                              return Text(
                                "No new messages",
                                style: TextStyle(
                                  color: AppColors.lightColor.withOpacity(0.7),
                                  fontSize: 11.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          } else if (state is ChatCardLoading) {
                            return Text(
                              "Checking for new messages..",
                              style: TextStyle(
                                color: AppColors.lightColor.withOpacity(0.7),
                                fontSize: 11.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          } else {
                            return Text(
                              "No new messages",
                              style: TextStyle(
                                color: AppColors.lightColor.withOpacity(0.7),
                                fontSize: 11.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
