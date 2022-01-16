import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/data/models/decoded_message_model.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:ghost_chat/logic/cubit/chat_page_cubit/chat_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';
import 'package:ghost_chat/logic/cubit/send_message_cubit/send_message_cubit.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/message_card.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/data/screen_args/chat_screen_args.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatelessWidget {
  final ChatScreenArgs args;
  const ChatPage({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String message = "";
    BlocProvider.of<ChatPageCubit>(context)
        .showMessages(conversationId: args.conversationId);
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                      onTap: () => Navigator.pushNamed(
                          context, AppRouter.friendProfilePage,
                          arguments: args.friendId),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              Strings.ghostPlaceHolder,
                              width: 10.w,
                              height: 10.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kasun Dulara",
                                  style: TextStyle(
                                    color: AppColors.lightColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Typing...",
                                  style: TextStyle(
                                    color:
                                        AppColors.lightColor.withOpacity(0.7),
                                    fontSize: 10.sp,
                                  ),
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
            ),
            Expanded(
              child: BlocBuilder<ChatPageCubit, ChatPageState>(
                builder: (context, state) {
                  if (state is ChatPageShowMessages) {
                    return ListView(
                      padding: const EdgeInsets.all(0),
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        ListView.builder(
                          itemCount: state.messegesList.length,
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DownloadMessage message = state.messegesList[index];
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) => MessageCubit()),
                                BlocProvider(
                                    create: (context) => MessageStatusCubit()),
                              ],
                              child: MessageCard(
                                  message: message,
                                  conversationId: args.conversationId),
                            );
                          },
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    );
                  } else if (state is ChatPageLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Messages",
                        style: TextStyle(
                          color: AppColors.lightColor.withOpacity(0.7),
                          fontSize: 10.sp,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: const BoxDecoration(
                color: AppColors.darkColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextInput(
                      onChanged: (messageText) => message = messageText,
                      textInputAction: TextInputAction.newline,
                      controller: controller,
                      isPassword: false,
                      textInputType: TextInputType.multiline,
                      hintText: "Text Message",
                      bgColor: AppColors.darkGrey.withOpacity(0.2),
                      textColor: AppColors.lightColor,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  BlocConsumer<SendMessageCubit, SendMessageState>(
                    listener: (context, state) {
                      if (state is SendMessageUploading) {}
                    },
                    builder: (context, state) {
                      if (state is SendMessageAddingToDB) {
                        return SizedBox(
                          width: 18.sp,
                          height: 18.sp,
                          child: const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            if (message.isNotEmpty) {
                              Uuid uuid = const Uuid();
                              String messageId = uuid.v1();
                              messageId =
                                  messageId.replaceAll(RegExp(r'[^\w\s]+'), '');
                              String sentTimestamp = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              BlocProvider.of<SendMessageCubit>(context)
                                  .sendMessage(
                                      messageToSend: DecodedMessageModel(
                                        messageId: messageId,
                                        senderId: AuthRepo.currentUid,
                                        reciverId: args.friendId,
                                        sentTimestamp: sentTimestamp,
                                        messageStatus: "Sending",
                                        message: message,
                                      ),
                                      conversationId: args.conversationId);
                              controller.clear();
                              message = "";
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.send_rounded,
                              color: AppColors.lightColor,
                              size: 18.sp,
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
