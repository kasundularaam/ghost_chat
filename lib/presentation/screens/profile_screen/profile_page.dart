import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/logic/cubit/add_pro_pic_cubit/add_pro_pic_cubit.dart';
import 'package:ghost_chat/logic/cubit/edit_bio_cubit/edit_bio_cubit.dart';
import 'package:ghost_chat/logic/cubit/edit_name_cubit/edit_name_cubit.dart';
import 'package:ghost_chat/logic/cubit/home_action_bar_cubit/home_action_bar_cubit.dart';
import 'package:ghost_chat/logic/cubit/profile_page_cubit/profile_page_cubit.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_button.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String newName = "";
    String newBio = "";
    BlocProvider.of<ProfilePageCubit>(context).getMyDetails();
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            color: AppColors.darkGrey,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.lightColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                      color: AppColors.lightColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          BlocConsumer<ProfilePageCubit, ProfilePageState>(
            listener: (context, state) {
              if (state is ProfilePageFailed) {
                SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            builder: (context, state) {
              if (state is ProfilePageLoading) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 90.w,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Center(
                            child: ClipOval(
                              child: Image.asset(
                                Strings.ghostPlaceHolder,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: AppColors.lightColor.withOpacity(0.3),
                            height: 0.05.h,
                            width: 100.w,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: AppColors.lightColor.withOpacity(0.7),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state is ProfilePageLoaded) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 90.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Center(
                            child: BlocConsumer<AddProPicCubit, AddProPicState>(
                              listener: (context, addProPicState) {
                                if (addProPicState is AddProPicUploaded) {
                                  BlocProvider.of<ProfilePageCubit>(context)
                                      .getMyDetails();
                                  BlocProvider.of<HomeActionBarCubit>(context)
                                      .getUserImg();
                                  SnackBar snackBar = const SnackBar(
                                      content:
                                          Text("Profile picture updated!"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else if (addProPicState is AddProPicFailed) {
                                  SnackBar snackBar = SnackBar(
                                      content: Text(addProPicState.errorMsg));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              builder: (context, addProPicState) {
                                if (addProPicState is AddProPicUploading) {
                                  return SizedBox(
                                    height: 32.w,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () =>
                                        BlocProvider.of<AddProPicCubit>(context)
                                            .uploadProPic(),
                                    child: ClipOval(
                                      child: state.appUser.userImg != "null"
                                          ? FadeInImage(
                                              placeholder: const AssetImage(
                                                  Strings.ghostPlaceHolder),
                                              image: NetworkImage(
                                                  state.appUser.userImg),
                                              width: 32.w,
                                              height: 32.w,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              Strings.ghostPlaceHolder,
                                              width: 32.w,
                                              height: 32.w,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    color:
                                        AppColors.lightColor.withOpacity(0.7),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name",
                                        style: TextStyle(
                                          color: AppColors.lightColor
                                              .withOpacity(0.7),
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        state.appUser.userName,
                                        style: TextStyle(
                                            color: AppColors.lightColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              BlocConsumer<EditNameCubit, EditNameState>(
                                listener: (context, editNameState) {
                                  if (editNameState is EditNameFailed) {
                                    SnackBar snackBar = SnackBar(
                                        content: Text(editNameState.errorMsg));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (editNameState is EditNameSucceed) {
                                    BlocProvider.of<ProfilePageCubit>(context)
                                        .getMyDetails();
                                    SnackBar snackBar = const SnackBar(
                                        content: Text("Name Updated!"));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                builder: (context, editNameState) {
                                  if (editNameState is EditNameUpdating) {
                                    return const CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () => showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (bottomSheetContext) {
                                            return Padding(
                                              padding: MediaQuery.of(
                                                      bottomSheetContext)
                                                  .viewInsets,
                                              child: Container(
                                                color: AppColors.darkColor,
                                                padding: EdgeInsets.all(5.w),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "New Name",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .lightColor
                                                            .withOpacity(0.7),
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    AppTextInput(
                                                        onChanged:
                                                            (newNameText) =>
                                                                newName =
                                                                    newNameText,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        isPassword: false,
                                                        hintText:
                                                            "Enter your name...",
                                                        bgColor:
                                                            AppColors.darkGrey,
                                                        textColor: AppColors
                                                            .lightColor),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: AppButton(
                                                          btnText: "Update",
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                bottomSheetContext);
                                                            BlocProvider.of<
                                                                        EditNameCubit>(
                                                                    context)
                                                                .editName(
                                                                    newName:
                                                                        newName);
                                                          },
                                                          bgColor: AppColors
                                                              .primaryColor,
                                                          txtColor: AppColors
                                                              .lightColor),
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: AppColors.primaryColor,
                                        size: 18.sp,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            color: AppColors.lightColor.withOpacity(0.3),
                            height: 0.05.h,
                            width: 100.w,
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
                                    Icons.info_rounded,
                                    color:
                                        AppColors.lightColor.withOpacity(0.7),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bio",
                                        style: TextStyle(
                                          color: AppColors.lightColor
                                              .withOpacity(0.7),
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      Text(
                                        state.appUser.userBio,
                                        style: TextStyle(
                                            color: AppColors.lightColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              BlocConsumer<EditBioCubit, EditBioState>(
                                listener: (context, editBioState) {
                                  if (editBioState is EditBioFailed) {
                                    SnackBar snackBar = SnackBar(
                                        content: Text(editBioState.errorMsg));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (editBioState is EditBioSucceed) {
                                    BlocProvider.of<ProfilePageCubit>(context)
                                        .getMyDetails();
                                    SnackBar snackBar = const SnackBar(
                                        content: Text("Bio updated!"));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                builder: (context, editBioState) {
                                  if (editBioState is EditBioUpdating) {
                                    return const CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () => showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (bottomSheetContext) {
                                            return Padding(
                                              padding: MediaQuery.of(
                                                      bottomSheetContext)
                                                  .viewInsets,
                                              child: Container(
                                                color: AppColors.darkColor,
                                                padding: EdgeInsets.all(5.w),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "New Bio",
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .lightColor
                                                            .withOpacity(0.7),
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    AppTextInput(
                                                      onChanged: (newBioText) =>
                                                          newBio = newBioText,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      isPassword: false,
                                                      hintText:
                                                          "Enter your bio...",
                                                      bgColor:
                                                          AppColors.darkGrey,
                                                      textColor:
                                                          AppColors.lightColor,
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: AppButton(
                                                          btnText: "Update",
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                bottomSheetContext);
                                                            BlocProvider.of<
                                                                        EditBioCubit>(
                                                                    context)
                                                                .editBio(
                                                                    newBio:
                                                                        newBio);
                                                          },
                                                          bgColor: AppColors
                                                              .primaryColor,
                                                          txtColor: AppColors
                                                              .lightColor),
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: AppColors.primaryColor,
                                        size: 18.sp,
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            color: AppColors.lightColor.withOpacity(0.3),
                            height: 0.05.h,
                            width: 100.w,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_rounded,
                                color: AppColors.lightColor.withOpacity(0.7),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone",
                                    style: TextStyle(
                                      color:
                                          AppColors.lightColor.withOpacity(0.7),
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Text(
                                    state.appUser.userNumber,
                                    style: TextStyle(
                                        color: AppColors.lightColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 90.w,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Center(
                            child: ClipOval(
                              child: Image.asset(
                                Strings.ghostPlaceHolder,
                                width: 32.w,
                                height: 32.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: AppColors.lightColor.withOpacity(0.3),
                            height: 0.05.h,
                            width: 100.w,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Failed",
                            style: TextStyle(
                              color: AppColors.lightColor.withOpacity(0.7),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      )),
    );
  }
}
