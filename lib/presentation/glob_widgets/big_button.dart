import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class BigButton extends StatelessWidget {
  final String btnText;
  final Function onPressed;
  final Color bgColor;
  final Color txtColor;
  const BigButton({
    Key? key,
    required this.btnText,
    required this.onPressed,
    required this.bgColor,
    required this.txtColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.5.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.w),
          color: AppColors.primaryColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset.fromDirection(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            btnText,
            style: TextStyle(
                fontSize: 18.sp, color: txtColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
