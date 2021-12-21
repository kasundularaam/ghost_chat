import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/app_user.dart';

class ContactCard extends StatelessWidget {
  final AppUser appUser;
  const ContactCard({
    Key? key,
    required this.appUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          color: Colors.black,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/ghost_ph.gif",
                  image: appUser.userImg,
                  width: 14.w,
                  height: 14.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appUser.userName,
                      style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 0.3.h,
                    ),
                    Text(
                      appUser.userBio,
                      style: TextStyle(
                        color: AppColors.lightColor.withOpacity(0.7),
                        fontSize: 11.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          color: AppColors.primaryColor.withOpacity(0.3),
          height: 0.1.h,
          width: 100.w,
        ),
      ],
    );
  }
}
