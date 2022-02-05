import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';

class AudioSeekBar extends StatelessWidget {
  final double playPoint;
  const AudioSeekBar({
    Key? key,
    required this.playPoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      height: 0.5.h,
      child: Stack(
        children: [
          Container(
            width: 50.w,
            height: 0.5.h,
            decoration: BoxDecoration(
                color: AppColors.darkColor,
                borderRadius: BorderRadius.circular(0.25.h)),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColors.lightColor,
                borderRadius: BorderRadius.circular(0.25.h)),
            width: playPoint,
            height: 0.5.h,
          ),
        ],
      ),
    );
  }
}
