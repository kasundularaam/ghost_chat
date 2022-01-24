import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';

class VoiceBox extends StatelessWidget {
  final Function onCancel;
  const VoiceBox({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.3.h, horizontal: 1.h),
        decoration: BoxDecoration(
          color: AppColors.darkGrey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: Text(
                "Recording...",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              "00:00",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.lightColor,
              ),
            ),
            SizedBox(
              width: 5.w,
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
            )
          ],
        ),
      ),
    );
  }
}
