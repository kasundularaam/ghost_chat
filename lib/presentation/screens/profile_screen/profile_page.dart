import 'package:flutter/material.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: AppColors.lightColor,
      )),
    );
  }
}
