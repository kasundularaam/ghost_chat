import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/logic/cubit/cubit/auth_cubit.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_button.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phone = "";
    String smsCode = "";
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          children: [
            SizedBox(
              height: 5.h,
            ),
            BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
              if (state is AuthFailed) {
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is AuthInvalidOTP) {
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is AuthSucceed) {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRouter.landingPage, (route) => false);
              }
            }, builder: (context, state) {
              if (state is AuthCodeSent) {
                return Column(
                  children: [
                    Text(
                      "Verifying your number",
                      style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "We have sent an verification SMS to",
                            style: TextStyle(
                                color: AppColors.lightColor, fontSize: 12.sp),
                          ),
                          TextSpan(
                            text: "\n${state.phone}",
                            style: TextStyle(
                                color: AppColors.lightColor, fontSize: 12.sp),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  BlocProvider.of<AuthCubit>(context)
                                      .changeNumber(),
                            text: "\nChange",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: " if it is wrong",
                            style: TextStyle(
                              color: AppColors.lightColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    AppTextInput(
                      onChanged: (smsCodeText) => smsCode = smsCodeText,
                      textInputAction: TextInputAction.done,
                      isPassword: false,
                      hintText: "--   --   --   --   --   --",
                      bgColor: AppColors.darkGrey,
                      textColor: AppColors.lightColor,
                      textInputType: TextInputType.phone,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        btnText: "OK",
                        onPressed: () => BlocProvider.of<AuthCubit>(context)
                            .verifyOTP(
                                smsCode: smsCode,
                                verificationId: state.verificationId,
                                phone: state.phone),
                        bgColor: AppColors.primaryColor,
                        txtColor: AppColors.lightColor,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Did not recive an SMS?",
                        style: TextStyle(
                            color: AppColors.lightColor, fontSize: 10.sp),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 0.1.h,
                      width: 100.w,
                      color: AppColors.lightColor,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.message_rounded,
                              size: 18.sp,
                              color: AppColors.lightColor,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "Resend SMS",
                              style: TextStyle(
                                  color: AppColors.lightColor, fontSize: 12.sp),
                            ),
                          ],
                        ),
                        Text(
                          state.timeLeft,
                          style: TextStyle(
                              color: AppColors.lightColor, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is AuthLoading || state is AuthInvalidOTP) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (state is AuthTimeOut) {
                return Column(
                  children: [
                    Text(
                      "Verifying your number",
                      style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "We have sent an verification SMS to",
                            style: TextStyle(
                                color: AppColors.lightColor, fontSize: 12.sp),
                          ),
                          TextSpan(
                            text: "\n${state.phone}",
                            style: TextStyle(
                                color: AppColors.lightColor, fontSize: 12.sp),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  BlocProvider.of<AuthCubit>(context)
                                      .changeNumber(),
                            text: "\nChange",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: " if it is wrong",
                            style: TextStyle(
                              color: AppColors.lightColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    AppTextInput(
                      onChanged: (smsCodeText) => smsCode = smsCodeText,
                      textInputAction: TextInputAction.done,
                      isPassword: false,
                      hintText: "--   --   --   --   --   --",
                      bgColor: AppColors.darkGrey,
                      textColor: AppColors.lightColor,
                      textInputType: TextInputType.phone,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        btnText: "OK",
                        onPressed: () => BlocProvider.of<AuthCubit>(context)
                            .verifyOTP(
                                smsCode: smsCode,
                                verificationId: state.verificationId,
                                phone: state.phone),
                        bgColor: AppColors.primaryColor,
                        txtColor: AppColors.lightColor,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Did not recive SMS?",
                        style: TextStyle(
                            color: AppColors.lightColor, fontSize: 10.sp),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 0.1.h,
                      width: 100.w,
                      color: AppColors.lightColor.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.message_rounded,
                              size: 18.sp,
                              color: AppColors.lightColor,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              "Resend SMS",
                              style: TextStyle(
                                color: AppColors.lightColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => BlocProvider.of<AuthCubit>(context)
                              .requestAuth(phone: state.phone),
                          child: const Text(
                            "RESEND",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Image.asset("assets/images/logo.png"),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Enter your phone number",
                      style: TextStyle(
                          color: AppColors.lightColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "We will need to verify your  phone number",
                      style: TextStyle(
                        color: AppColors.lightColor.withOpacity(0.6),
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Text(
                          "+94",
                          style: TextStyle(
                            color: AppColors.lightColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                          child: AppTextInput(
                            onChanged: (phoneText) => phone = "+94$phoneText",
                            textInputAction: TextInputAction.done,
                            isPassword: false,
                            hintText: "   -- --   -- -- --   -- -- -- --",
                            bgColor: AppColors.darkGrey,
                            textColor: AppColors.lightColor,
                            textInputType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton(
                        btnText: "NEXT",
                        onPressed: () => BlocProvider.of<AuthCubit>(context)
                            .requestAuth(phone: phone),
                        bgColor: AppColors.primaryColor,
                        txtColor: AppColors.lightColor,
                      ),
                    ),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
