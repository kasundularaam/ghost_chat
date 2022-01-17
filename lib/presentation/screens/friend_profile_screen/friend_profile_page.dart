import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/screen_args/chat_screen_args.dart';
import 'package:ghost_chat/logic/cubit/go_chat_cubit/go_chat_cubit.dart';
import 'package:ghost_chat/logic/cubit/user_stats_cubit/user_stats_cubit.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';

class FriendProfilePage extends StatelessWidget {
  final Friend friend;
  const FriendProfilePage({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UserStatsCubit>(context)
        .getUserStatus(userId: friend.userId);
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            color: AppColors.darkGrey,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.lightColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                      color: AppColors.lightColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    Center(
                      child: ClipOval(
                        child: friend.userImg != "null"
                            ? FadeInImage.assetNetwork(
                                placeholder: Strings.ghostPlaceHolder,
                                image: friend.userImg,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                Strings.ghostPlaceHolder,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            friend.contactName,
                            style: TextStyle(
                                color: AppColors.lightColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            friend.userNumber,
                            style: TextStyle(
                              color: AppColors.lightColor.withOpacity(0.7),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          BlocBuilder<UserStatsCubit, UserStatsState>(
                            builder: (context, state) {
                              if (state is UserStatsLoading) {
                                return Text(
                                  "Loading...",
                                  style: TextStyle(
                                      color:
                                          AppColors.lightColor.withOpacity(0.7),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                );
                              } else if (state is UserStatsLoaded) {
                                return Text(
                                  state.userStatus,
                                  style: TextStyle(
                                      color: state.userStatus == "Online"
                                          ? Colors.green
                                          : AppColors.lightColor
                                              .withOpacity(0.7),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                );
                              } else {
                                return Text(
                                  "Unavailable",
                                  style: TextStyle(
                                      color:
                                          AppColors.lightColor.withOpacity(0.7),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      friend.userName,
                      style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      friend.userBio,
                      style: TextStyle(
                        color: AppColors.lightColor.withOpacity(0.7),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      color: AppColors.lightColor.withOpacity(0.3),
                      height: 0.05.h,
                      width: 100.w,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: GestureDetector(
                        onTap: () =>
                            BlocProvider.of<GoChatCubit>(context).goChat(
                          friendId: friend.userId,
                          friendNumber: friend.userNumber,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Send Messages",
                              style: TextStyle(
                                  color: AppColors.lightColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            BlocConsumer<GoChatCubit, GoChatState>(
                              listener: (context, state) {
                                if (state is GoChatFailed) {
                                  SnackBar snackBar =
                                      SnackBar(content: Text(state.errorMsg));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                if (state is GoChatSucceed) {
                                  Navigator.popAndPushNamed(
                                    context,
                                    AppRouter.chatPage,
                                    arguments: ChatScreenArgs(
                                        friendId: state.friendId,
                                        conversationId: state.conversationId,
                                        friendNumber: friend.userNumber),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is GoChatLoading) {
                                  return SizedBox(
                                    width: 18.sp,
                                    height: 18.sp,
                                    child: const CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    ),
                                  );
                                } else {
                                  return Icon(
                                    Icons.message_rounded,
                                    color: AppColors.primaryColor,
                                    size: 18.sp,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      color: AppColors.lightColor.withOpacity(0.3),
                      height: 0.05.h,
                      width: 100.w,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
