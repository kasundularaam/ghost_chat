import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/presentation/screens/home_screen/widgets/chat_card.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.darkGrey,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 40.w,
                    fit: BoxFit.fitWidth,
                  ),
                  ClipOval(
                    child: Image.asset(
                      "assets/images/profile.jpeg",
                      width: 10.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppColors.lightColor,
              height: 0.1.h,
              width: 100.w,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatCard();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
