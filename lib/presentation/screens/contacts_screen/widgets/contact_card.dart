import 'package:flutter/material.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/data/models/friend_model.dart';

class ContactCard extends StatelessWidget {
  final Friend friend;
  const ContactCard({
    Key? key,
    required this.friend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.friendProfilePage,
              arguments: friend),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppColors.lightColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: friend.userImg != "null"
                      ? FadeInImage.assetNetwork(
                          placeholder: Strings.ghostPlaceHolder,
                          image: friend.userImg,
                          width: 14.w,
                          height: 14.w,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          Strings.ghostPlaceHolder,
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
                        friend.contactName,
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
                        friend.userBio,
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
        ),
        SizedBox(
          height: 1.h,
        )
      ],
    );
  }
}
