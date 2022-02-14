import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/voice_message_cubit/voice_message_cubit.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';

class VoiceBox extends StatelessWidget {
  final Function onCancel;
  final Function(String) getMessageId;
  final Function(String) getAudioFilePath;
  const VoiceBox({
    Key? key,
    required this.onCancel,
    required this.getMessageId,
    required this.getAudioFilePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Recording...",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryColor,
              ),
            ),
            BlocConsumer<VoiceMessageCubit, VoiceMessageState>(
              listener: (context, state) {
                if (state is VoiceMessageRecording) {
                  getAudioFilePath(state.filePath);
                  getMessageId(state.messageId);
                }
              },
              builder: (context, state) {
                if (state is VoiceMessageRecording) {
                  return Text(
                    state.recordTime,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.lightColor,
                    ),
                  );
                } else {
                  return Text(
                    "00:00",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.lightColor,
                    ),
                  );
                }
              },
            ),
            GestureDetector(
              onTap: () => onCancel(),
              child: Container(
                padding: EdgeInsets.all(1.w),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.lightColor,
                  size: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
