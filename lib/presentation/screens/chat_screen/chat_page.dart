import 'package:flutter/material.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';

class ChatPage extends StatelessWidget {
  final String userId;
  const ChatPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            color: AppColors.lightColor.withOpacity(0.7),
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  ListView.builder(
                    itemCount: 100,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: index % 2 == 0
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? Colors.black
                                : AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Text(
                            "Hey my index is $index",
                            style: TextStyle(
                              color: AppColors.lightColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
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
                        onChanged: (message) {},
                        textInputAction: TextInputAction.send,
                        isPassword: false,
                        hintText: "Text Message",
                        bgColor: AppColors.darkGrey.withOpacity(0.2),
                        textColor: AppColors.lightColor),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor, shape: BoxShape.circle),
                    child: Icon(
                      Icons.send_rounded,
                      color: AppColors.lightColor,
                      size: 18.sp,
                    ),
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
