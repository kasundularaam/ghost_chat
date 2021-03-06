import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/voice_msg_player_cubit/voice_msg_player_cubit.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/widgets/audio_seek_bar.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';

class VoiceMsgPlayer extends StatefulWidget {
  const VoiceMsgPlayer({
    Key? key,
  }) : super(key: key);

  @override
  _VoiceMsgPlayerState createState() => _VoiceMsgPlayerState();
}

class _VoiceMsgPlayerState extends State<VoiceMsgPlayer> {
  @override
  void initState() {
    BlocProvider.of<VoiceMsgPlayerCubit>(context).loadPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceMsgPlayerCubit, VoiceMsgPlayerState>(
      builder: (context, state) {
        if (state is VoiceMsgPlayerLoading) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: AppColors.lightColor,
                size: 26.sp,
              ),
              const AudioSeekBar(
                playPoint: 0,
              ),
              SizedBox(
                width: 2.w,
              ),
            ],
          );
        } else if (state is VoiceMsgPlayerLoaded) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () =>
                    BlocProvider.of<VoiceMsgPlayerCubit>(context).playPlayer(),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.lightColor,
                  size: 26.sp,
                ),
              ),
              const AudioSeekBar(
                playPoint: 0,
              ),
              SizedBox(
                width: 2.w,
              ),
            ],
          );
        } else if (state is VoiceMsgPlayerPlaying) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () =>
                    BlocProvider.of<VoiceMsgPlayerCubit>(context).pausePlayer(),
                child: Icon(
                  Icons.pause_rounded,
                  color: AppColors.lightColor,
                  size: 26.sp,
                ),
              ),
              AudioSeekBar(
                playPoint: (50.w / state.audioLength) * state.seekBarValue,
              ),
              SizedBox(
                width: 2.w,
              ),
            ],
          );
        } else if (state is VoiceMsgPlayerPause) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => BlocProvider.of<VoiceMsgPlayerCubit>(context)
                    .resumePlayer(),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.lightColor,
                  size: 26.sp,
                ),
              ),
              AudioSeekBar(
                playPoint: (50.w / state.audioLength) * state.seekbarProgress,
              ),
              SizedBox(
                width: 2.w,
              ),
            ],
          );
        } else {
          return Text(
            "Cant load message at the moment!",
            style: TextStyle(
              color: AppColors.lightColor,
              fontSize: 12.sp,
            ),
          );
        }
      },
    );
  }
}
