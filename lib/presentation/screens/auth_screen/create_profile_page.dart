import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/logic/cubit/add_pro_pic_cubit/add_pro_pic_cubit.dart';
import 'package:ghost_chat/logic/cubit/update_acc_cubit/update_acc_cubit.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_button.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

class CreateProfilePage extends StatelessWidget {
  const CreateProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = "";
    String userBio = "";
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: SizedBox(
              width: 100.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Create Your Account",
                    style: TextStyle(
                        color: AppColors.lightColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    height: 40.w,
                    child: BlocConsumer<AddProPicCubit, AddProPicState>(
                      listener: (context, state) {
                        if (state is AddProPicFailed) {
                          SnackBar snackBar = const SnackBar(
                              content:
                                  Text("Failed to upload profile picture!"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (state is AddProPicUploaded) {
                          SnackBar snackBar = const SnackBar(
                              content: Text("Profile picture uploaded!"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      builder: (context, state) {
                        if (state is AddProPicLoaded) {
                          return GestureDetector(
                            onTap: () =>
                                BlocProvider.of<AddProPicCubit>(context)
                                    .uploadProPic(),
                            child: ClipOval(
                              child: state.userImg != "null"
                                  ? FadeInImage.assetNetwork(
                                      placeholder: Strings.ghostPlaceHolder,
                                      image: state.userImg,
                                      width: 40.w,
                                      height: 40.w,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      Strings.ghostPlaceHolder,
                                      width: 40.w,
                                      height: 40.w,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        } else if (state is AddProPicLoading ||
                            state is AddProPicUploading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () =>
                                BlocProvider.of<AddProPicCubit>(context)
                                    .uploadProPic(),
                            child: ClipOval(
                              child: Image.asset(
                                Strings.ghostPlaceHolder,
                                width: 40.w,
                                height: 40.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  AppTextInput(
                    onChanged: (name) => userName = name.trim(),
                    textInputAction: TextInputAction.done,
                    isPassword: false,
                    hintText: "Name",
                    bgColor: AppColors.darkGrey,
                    textColor: AppColors.lightColor,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  AppTextInput(
                    onChanged: (bio) => userBio = bio.trim(),
                    textInputAction: TextInputAction.done,
                    isPassword: false,
                    hintText: "Bio",
                    bgColor: AppColors.darkGrey,
                    textColor: AppColors.lightColor,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  BlocConsumer<UpdateAccCubit, UpdateAccState>(
                    listener: (context, state) {
                      if (state is UpdateAccFailed) {
                        SnackBar snackBar =
                            const SnackBar(content: Text("An error occured!"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (state is UpdateAccSucceed) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRouter.landingPage, (route) => false);
                      }
                    },
                    builder: (context, state) {
                      if (state is UpdateAccUpdating) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: AppButton(
                            btnText: "Done",
                            onPressed: () =>
                                BlocProvider.of<UpdateAccCubit>(context)
                                    .updateAcc(
                                        userName: userName, userBio: userBio),
                            bgColor: AppColors.primaryColor,
                            txtColor: AppColors.lightColor,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
