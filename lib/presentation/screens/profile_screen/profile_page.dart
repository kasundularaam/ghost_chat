import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/logic/cubit/add_pro_pic_cubit/add_pro_pic_cubit.dart';
import 'package:ghost_chat/logic/cubit/cubit/msg_disappearing_settings_cubit.dart';
import 'package:ghost_chat/logic/cubit/edit_bio_cubit/edit_bio_cubit.dart';
import 'package:ghost_chat/logic/cubit/edit_name_cubit/edit_name_cubit.dart';
import 'package:ghost_chat/logic/cubit/home_action_bar_cubit/home_action_bar_cubit.dart';
import 'package:ghost_chat/logic/cubit/profile_page_cubit/profile_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/signout_cubit/signout_cubit.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_button.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:sizer/sizer.dart';

import '../../router/app_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProfilePageCubit>(context).getMyDetails();
    BlocProvider.of<MsgDisappearingSettingsCubit>(context).loadTime();
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              color: AppColors.lightColor.withOpacity(0.15),
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
                      fontWeight: FontWeight.w600,
                    ),
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
                            //Profile Picture
                            Center(
                              child:
                                  BlocConsumer<AddProPicCubit, AddProPicState>(
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
                                  } else if (addProPicState
                                      is AddProPicFailed) {
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
                                          BlocProvider.of<AddProPicCubit>(
                                                  context)
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
                                          content:
                                              Text(editNameState.errorMsg));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else if (editNameState
                                        is EditNameSucceed) {
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
                                      return SizedBox(
                                        width: 18.sp,
                                        height: 18.sp,
                                        child: const CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
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
                                                        CrossAxisAlignment
                                                            .start,
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
                                                              (newNameText) {},
                                                          controller:
                                                              nameController,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          isPassword: false,
                                                          hintText:
                                                              "Enter your name...",
                                                          bgColor: AppColors
                                                              .darkGrey,
                                                          textColor: AppColors
                                                              .lightColor),
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
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
                                                                          nameController
                                                                              .text);
                                                              nameController
                                                                  .clear();
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
                                      return SizedBox(
                                        width: 18.sp,
                                        height: 18.sp,
                                        child: const CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
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
                                                        CrossAxisAlignment
                                                            .start,
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
                                                        onChanged:
                                                            (newBioText) {},
                                                        controller:
                                                            bioController,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        isPassword: false,
                                                        hintText:
                                                            "Enter your bio...",
                                                        bgColor:
                                                            AppColors.darkGrey,
                                                        textColor: AppColors
                                                            .lightColor,
                                                      ),
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: AppButton(
                                                            btnText: "Update",
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  bottomSheetContext);
                                                              BlocProvider.of<
                                                                          EditBioCubit>(
                                                                      context)
                                                                  .editBio(
                                                                      newBio: bioController
                                                                          .text);
                                                              bioController
                                                                  .clear();
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
                                        color: AppColors.lightColor
                                            .withOpacity(0.7),
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
                                      Icons.timer_rounded,
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
                                          "Message disappearing time",
                                          style: TextStyle(
                                            color: AppColors.lightColor
                                                .withOpacity(0.7),
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        BlocBuilder<
                                            MsgDisappearingSettingsCubit,
                                            MsgDisappearingSettingsState>(
                                          builder:
                                              (context, msgDisappearingState) {
                                            if (msgDisappearingState
                                                is MsgDisappearingSettingsLoaded) {
                                              return Text(
                                                "${msgDisappearingState.disappearingTime}mins",
                                                style: TextStyle(
                                                  color: AppColors.lightColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                "...",
                                                style: TextStyle(
                                                  color: AppColors.lightColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                BlocConsumer<MsgDisappearingSettingsCubit,
                                    MsgDisappearingSettingsState>(
                                  listener: (context, msgDisappearingState) {
                                    if (msgDisappearingState
                                        is MsgDisappearingSettingsFailed) {
                                      SnackBar snackBar = SnackBar(
                                          content: Text(
                                              msgDisappearingState.errorMsg));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else if (msgDisappearingState
                                        is MsgDisappearingSettingsUpdated) {
                                      BlocProvider.of<
                                                  MsgDisappearingSettingsCubit>(
                                              context)
                                          .loadTime();
                                      SnackBar snackBar = const SnackBar(
                                        content: Text(
                                          "Message disappearing time updated!",
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  builder: (context, msgDisappearingState) {
                                    if (msgDisappearingState
                                            is MsgDisappearingSettingsUpdating ||
                                        msgDisappearingState
                                            is MsgDisappearingSettingsLoading) {
                                      return SizedBox(
                                        width: 18.sp,
                                        height: 18.sp,
                                        child: const CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Update message disappearing time",
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
                                                            (newTimeText) {},
                                                        controller:
                                                            timeController,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        textInputType:
                                                            TextInputType
                                                                .number,
                                                        isPassword: false,
                                                        hintText:
                                                            "Enter new time in minutes...",
                                                        bgColor:
                                                            AppColors.darkGrey,
                                                        textColor: AppColors
                                                            .lightColor,
                                                      ),
                                                      SizedBox(
                                                        height: 2.h,
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: AppButton(
                                                            btnText: "Update",
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  bottomSheetContext);
                                                              BlocProvider.of<
                                                                          MsgDisappearingSettingsCubit>(
                                                                      context)
                                                                  .editTime(
                                                                newTime:
                                                                    int.parse(
                                                                  timeController
                                                                      .text,
                                                                ),
                                                              );
                                                              timeController
                                                                  .clear();
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
            BlocConsumer<SignoutCubit, SignoutState>(
              listener: (context, state) {
                if (state is SignoutSucceed) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRouter.landingPage, (route) => false);
                }
              },
              builder: (context, state) {
                if (state is SignoutLoading) {
                  return SizedBox(
                    width: 10.w,
                    height: 10.w,
                    child: const CircularProgressIndicator(
                        color: AppColors.primaryColor),
                  );
                } else if (state is SignoutSucceed) {
                  return Icon(
                    Icons.check_rounded,
                    color: AppColors.primaryColor,
                    size: 18.sp,
                  );
                } else {
                  return GestureDetector(
                    onTap: () =>
                        BlocProvider.of<SignoutCubit>(context).signoutUser(),
                    child: Text(
                      "SIGN OUT",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 5.h,
            )
          ],
        ),
      ),
    );
  }
}
