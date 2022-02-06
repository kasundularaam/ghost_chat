import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/chat_action_bar_cubit/chat_action_bar_cubit.dart';
import 'package:ghost_chat/logic/cubit/typing_status_cubit/typing_status_cubit.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';

import '../../../../data/models/friend_model.dart';

class ChatActionBar extends StatefulWidget {
  final String friendId;
  final String friendNumber;
  const ChatActionBar({
    Key? key,
    required this.friendId,
    required this.friendNumber,
  }) : super(key: key);

  @override
  State<ChatActionBar> createState() => _ChatActionBarState();
}

class _ChatActionBarState extends State<ChatActionBar> {
  Friend? friend;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChatActionBarCubit>(context)
        .loadActionBar(friendId: widget.friendId);
    BlocProvider.of<TypingStatusCubit>(context)
        .getTypingStatus(friendId: widget.friendId);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 2.h,
      ),
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
            width: 2.w,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (friend != null) {
                  Navigator.pushNamed(
                    context,
                    AppRouter.friendProfilePage,
                    arguments: friend,
                  );
                }
              },
              child: Row(
                children: [
                  BlocBuilder<ChatActionBarCubit, ChatActionBarState>(
                    builder: (context, state) {
                      if (state is ChatActionBarLoaded) {
                        friend = state.friend;
                        return ClipOval(
                          child: state.friend.userImg != "null"
                              ? FadeInImage.assetNetwork(
                                  placeholder: Strings.ghostPlaceHolder,
                                  image: state.friend.userImg,
                                  width: 10.w,
                                  height: 10.w,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  Strings.ghostPlaceHolder,
                                  width: 10.w,
                                  height: 10.w,
                                  fit: BoxFit.cover,
                                ),
                        );
                      } else {
                        return ClipOval(
                          child: Image.asset(
                            Strings.ghostPlaceHolder,
                            width: 10.w,
                            height: 10.w,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<ChatActionBarCubit, ChatActionBarState>(
                          builder: (context, state) {
                            if (state is ChatActionBarLoaded) {
                              return Text(
                                state.friend.contactName,
                                style: TextStyle(
                                  color: AppColors.lightColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } else {
                              return Text(
                                widget.friendNumber,
                                style: TextStyle(
                                  color: AppColors.lightColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 1.h),
                        BlocBuilder<TypingStatusCubit, TypingStatusState>(
                          builder: (context, state) {
                            if (state is TypingStatusLoaded) {
                              return Text(
                                state.status,
                                style: TextStyle(
                                  color: AppColors.lightColor.withOpacity(0.7),
                                  fontSize: 10.sp,
                                ),
                              );
                            } else {
                              return Text(
                                "",
                                style: TextStyle(
                                  color: AppColors.lightColor.withOpacity(0.7),
                                  fontSize: 10.sp,
                                ),
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
        ],
      ),
    );
  }
}
