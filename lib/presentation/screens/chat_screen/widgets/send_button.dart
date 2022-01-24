import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class SendButton extends StatelessWidget {
  final Function onTap;
  const SendButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: const BoxDecoration(
            color: AppColors.primaryColor, shape: BoxShape.circle),
        child: Icon(
          Icons.send_rounded,
          color: AppColors.lightColor,
          size: 18.sp,
        ),
      ),
    );
  }
}
