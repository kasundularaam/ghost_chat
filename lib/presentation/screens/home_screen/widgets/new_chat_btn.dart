import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

class NewMsgBtn extends StatelessWidget {
  const NewMsgBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.contactsPage),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.darkColor,
              offset: Offset(1, 1),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          Icons.message_rounded,
          size: 20.sp,
          color: AppColors.lightColor,
        ),
      ),
    );
  }
}
