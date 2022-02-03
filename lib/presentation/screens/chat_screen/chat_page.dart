import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/data/models/fi_text_message.dart';
import 'package:ghost_chat/data/models/fi_voice_message.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:ghost_chat/logic/cubit/message_box_cubit/message_box_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_button_cubit/message_button_cubit.dart';
import 'package:ghost_chat/logic/cubit/send_message_cubit/send_message_cubit.dart';
import 'package:ghost_chat/logic/cubit/voice_message_cubit/voice_message_cubit.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/message_box.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/send_button.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/voice_box.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/voice_button.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/download_message.dart';
import 'package:ghost_chat/data/screen_args/chat_screen_args.dart';
import 'package:ghost_chat/logic/cubit/chat_action_bar_cubit/chat_action_bar_cubit.dart';
import 'package:ghost_chat/logic/cubit/chat_page_cubit/chat_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_cubit/message_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_status_cubit/message_status_cubit.dart';
import 'package:ghost_chat/logic/cubit/typing_status_cubit/typing_status_cubit.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/chat_action_bar.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/message_card.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController controller = TextEditingController();
  String audioFilePath = "";
  String voiceMesgId = "";

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      BlocProvider.of<VoiceMessageCubit>(context).init();
      String message = controller.text;

      if (message.isNotEmpty) {
        BlocProvider.of<MessageButtonCubit>(context).messageBtnSendText();
      } else {
        BlocProvider.of<MessageButtonCubit>(context).messageBtnVoice();
      }
    });
  }

  void sendVoiceMessage() {
    if (audioFilePath.isNotEmpty && voiceMesgId.isNotEmpty) {
      String sentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
      BlocProvider.of<VoiceMessageCubit>(context).sendVoiceMsg(
        voiceMessage: FiVoiceMessage(
            messageId: voiceMesgId,
            senderId: AuthRepo.currentUid,
            reciverId: widget.args.friendId,
            sentTimestamp: sentTimestamp,
            messageStatus: "Sending",
            audioFilePath: audioFilePath),
        conversationId: widget.args.conversationId,
        friendNumber: widget.args.friendNumber,
      );
      audioFilePath = "";
      voiceMesgId = "";
    }
  }

  void sendTextMessage({required message}) {
    if (message.isNotEmpty) {
      Uuid uuid = const Uuid();
      String messageId = uuid.v1();
      messageId = messageId.replaceAll(RegExp(r'[^\w\s]+'), '');
      String sentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
      BlocProvider.of<SendMessageCubit>(context).sendTextMessage(
        messageToSend: FiTextMessage(
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
    }
  }

  @override
  void dispose() {
    controller.clear();
    controller.dispose();
    BlocProvider.of<VoiceMessageCubit>(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            BlocListener<SendMessageCubit, SendMessageState>(
              listener: (context, state) {
                if (state is SendMessageAddingToDB) {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnLoading();
                  BlocProvider.of<MessageBoxCubit>(context)
                      .messageBoxLoading(loadingMsg: "getting ready...");
                } else if (state is SendMessageUploading) {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnVoice();
                  BlocProvider.of<MessageBoxCubit>(context).messageBoxText();
                  BlocProvider.of<ChatPageCubit>(context).addSendMessage(
                    downloadedMsg: state.sendingMsg,
                  );
                } else {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnVoice();
                  BlocProvider.of<MessageBoxCubit>(context).messageBoxText();
                }
              },
              child: const SizedBox(),
            ),
            BlocListener<VoiceMessageCubit, VoiceMessageState>(
              listener: (context, state) {
                if (state is VoiceMessageCanceled) {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnVoice();
                  BlocProvider.of<MessageBoxCubit>(context).messageBoxText();
                } else if (state is VoiceMessageAddingToDB) {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnLoading();
                  BlocProvider.of<MessageBoxCubit>(context)
                      .messageBoxLoading(loadingMsg: "getting ready...");
                } else if (state is VoiceMessageUploading) {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnVoice();
                  BlocProvider.of<MessageBoxCubit>(context).messageBoxText();
                  BlocProvider.of<ChatPageCubit>(context)
                      .addSendMessage(downloadedMsg: state.uploadingMsg);
                } else if (state is VoiceMessageRecording) {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnSendVoice();
                  BlocProvider.of<MessageBoxCubit>(context).messageBoxVoice();
                } else {
                  BlocProvider.of<MessageButtonCubit>(context)
                      .messageBtnVoice();
                  BlocProvider.of<MessageBoxCubit>(context).messageBoxText();
                }
              },
              child: const SizedBox(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: const BoxDecoration(
                color: AppColors.darkColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BlocBuilder<MessageBoxCubit, MessageBoxState>(
                    builder: (context, state) {
                      if (state is MessageBoxText) {
                        return MessageBox(controller: controller);
                      } else if (state is MessageBoxLoading) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              state.loadingMsg,
                              style: TextStyle(
                                color: AppColors.lightColor.withOpacity(0.7),
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return VoiceBox(
                          onCancel: () {
                            print("ON CANCEL>>>>>>>>> $audioFilePath");
                            BlocProvider.of<VoiceMessageCubit>(context)
                                .cancelRecording(
                              filePath: audioFilePath,
                            );
                          },
                          getAudioFilePath: (pathStr) =>
                              audioFilePath = pathStr,
                          getMessageId: (idStr) => voiceMesgId = idStr,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  BlocBuilder<MessageButtonCubit, MessageButtonState>(
                    builder: (context, state) {
                      if (state is MessageButtonSendText) {
                        return SendButton(
                          onTap: () =>
                              sendTextMessage(message: controller.text),
                        );
                      } else if (state is MessageButtonSendVoice) {
                        return SendButton(
                          onTap: () => sendVoiceMessage(),
                        );
                      } else if (state is MessageButtonLoading) {
                        return SizedBox(
                          width: 10.sp,
                          height: 10.sp,
                          child: const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      } else {
                        return VoiceButton(
                          onTap: () {
                            BlocProvider.of<MessageBoxCubit>(context)
                                .messageBoxVoice();

                            BlocProvider.of<MessageButtonCubit>(context)
                                .messageBtnSendVoice();
                            BlocProvider.of<VoiceMessageCubit>(context)
                                .startRecording(
                              conversationId: widget.args.conversationId,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
