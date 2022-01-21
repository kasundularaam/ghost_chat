import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:sizer/sizer.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:uuid/uuid.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/decoded_message_model.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:ghost_chat/data/screen_args/chat_screen_args.dart';
import 'package:ghost_chat/logic/cubit/chat_action_bar_cubit/chat_action_bar_cubit.dart';
import 'package:ghost_chat/logic/cubit/chat_page_cubit/chat_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';
import 'package:ghost_chat/logic/cubit/send_message_cubit/send_message_cubit.dart';
import 'package:ghost_chat/logic/cubit/typing_status_cubit/typing_status_cubit.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/chat_action_bar.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/message_card.dart';

class ChatPage extends StatefulWidget {
  final ChatScreenArgs args;
  const ChatPage({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final StreamController<String> streamController = StreamController();
  @override
  void initState() {
    streamController.stream.listen((msgText) {
      String messageText = msgText;

      if (msgText.isNotEmpty) {
        AuthRepo.updateTypeStatus(friendId: widget.args.friendId);
      } else {
        AuthRepo.updateTypeStatus(friendId: "null");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    AuthRepo.updateTypeStatus(friendId: "null");
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String message = "";
    BlocProvider.of<ChatPageCubit>(context)
        .showMessages(conversationId: widget.args.conversationId);
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Column(
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ChatActionBarCubit(),
                ),
                BlocProvider(
                  create: (context) => TypingStatusCubit(),
                )
              ],
              child: ChatActionBar(
                  friendId: widget.args.friendId,
                  friendNumber: widget.args.friendNumber),
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
                                  conversationId: widget.args.conversationId),
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
              child: BlocConsumer<SendMessageCubit, SendMessageState>(
                listener: (context, state) {
                  if (state is SendMessageUploading) {
                    BlocProvider.of<ChatPageCubit>(context)
                        .addSendMessage(downloadedMsg: state.sendingMsg);
                  }
                },
                builder: (context, state) {
                  if (state is SendMessageAddingToDB) {
                    return Text(
                      "Encrypting...",
                      style: TextStyle(
                        color: AppColors.lightColor.withOpacity(0.7),
                        fontSize: 10.sp,
                      ),
                    );
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: AppTextInput(
                            onChanged: (messageText) {
                              message = messageText;
                              streamController.add(messageText);
                            },
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
                        GestureDetector(
                          onTap: () {
                            if (message.isNotEmpty) {
                              AuthRepo.updateTypeStatus(friendId: "null");
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
                                  reciverId: widget.args.friendId,
                                  sentTimestamp: sentTimestamp,
                                  messageStatus: "Sending",
                                  message: message,
                                ),
                                conversationId: widget.args.conversationId,
                                friendNumber: widget.args.friendNumber,
                              );
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
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
