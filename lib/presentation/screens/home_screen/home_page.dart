import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/presentation/screens/home_screen/widgets/chat_card.dart';
import 'package:ghost_chat/presentation/screens/home_screen/widgets/home_action_bar.dart';
import 'package:ghost_chat/presentation/screens/home_screen/widgets/new_chat_btn.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HomeActionBar(),
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
            Positioned(right: 3.w, bottom: 3.w, child: const NewMsgBtn())
          ],
        ),
      ),
    );
    //NIKAM
  }
}
