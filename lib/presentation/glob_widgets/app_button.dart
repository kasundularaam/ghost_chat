import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppButton extends StatelessWidget {
  final String btnText;
  final Function onPressed;
  final Color bgColor;
  final Color txtColor;
  const AppButton({
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
        padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.w),
          color: bgColor,
        ),
        child: Text(
          btnText,
          style: TextStyle(
              fontSize: 14.sp, color: txtColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
