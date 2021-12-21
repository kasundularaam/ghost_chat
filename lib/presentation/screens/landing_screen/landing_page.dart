import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/logic/cubit/landing_page_cubit/landing_page_cubit.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LandingPageCubit>(context).checkUser();
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: BlocListener<LandingPageCubit, LandingPageState>(
          listener: (context, state) {
            if (state is LandingPageNoUser) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRouter.authPage, (route) => false);
            } else if (state is LandingPageUserReady) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.homePage,
                (route) => false,
                arguments: state.appUser,
              );
            } else if (state is LandingPageNewAccount) {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRouter.createProfilePage, (route) => false);
            }
          },
          child: Hero(
            tag: "Logo",
            child: Center(child: Image.asset("assets/images/logo.png")),
          ),
        ),
      ),
    );
  }
}
