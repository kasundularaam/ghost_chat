import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';

class MessageBox extends StatelessWidget {
  final TextEditingController controller;
  const MessageBox({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        autofocus: false,
        maxLines: 6,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.lightColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: "Text Message",
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.lightColor.withOpacity(0.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.newline,
      ),
    );
  }
}
