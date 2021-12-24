import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  const UserProfilePage({
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
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
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
                Text(
                  "Profile",
                  style: TextStyle(
                      color: AppColors.lightColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4.h,
                    ),
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          Strings.ghostPlaceHolder,
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Kasun Dulara",
                            style: TextStyle(
                                color: AppColors.lightColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            "+94703554519",
                            style: TextStyle(
                              color: AppColors.lightColor.withOpacity(0.7),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Text(
                            "Online",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Berry 😎",
                      style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "S I N C E 1 9 5 6",
                      style: TextStyle(
                        color: AppColors.lightColor.withOpacity(0.7),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      color: AppColors.lightColor.withOpacity(0.3),
                      height: 0.05.h,
                      width: 100.w,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Send Messages",
                              style: TextStyle(
                                  color: AppColors.lightColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.message_rounded,
                              color: AppColors.primaryColor,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      color: AppColors.lightColor.withOpacity(0.3),
                      height: 0.05.h,
                      width: 100.w,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
