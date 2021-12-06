import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppTextInput extends StatelessWidget {
  final Function(String) onChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final TextInputType? textInputType;
  final bool isPassword;
  final String hintText;
  final Color bgColor;
  final Color textColor;
  final TextAlign? textAlign;
  const AppTextInput({
    Key? key,
    required this.onChanged,
    this.focusNode,
    this.controller,
    required this.textInputAction,
    this.textInputType,
    required this.isPassword,
    required this.hintText,
    required this.bgColor,
    required this.textColor,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        onChanged: onChanged,
        focusNode: focusNode,
        autofocus: false,
        keyboardType: textInputType,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          fontSize: 14.sp,
          color: textColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: textColor.withOpacity(0.7),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          border: InputBorder.none,
        ),
        textInputAction: textInputAction,
      ),
    );
  }
}
