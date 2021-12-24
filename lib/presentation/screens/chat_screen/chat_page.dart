import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:sizer/sizer.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
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
                  width: 5.w,
                ),
                ClipOval(
                  child: Image.asset(
                    Strings.ghostPlaceHolder,
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.cover,
                  ),
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
                        color: AppColors.lightColor.withOpacity(0.7),
                        fontSize: 10.sp,
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      )),
    );
  }
}
