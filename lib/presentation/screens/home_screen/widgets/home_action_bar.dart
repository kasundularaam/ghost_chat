import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:ghost_chat/logic/cubit/home_action_bar_cubit/home_action_bar_cubit.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';

class HomeActionBar extends StatefulWidget {
  const HomeActionBar({Key? key}) : super(key: key);

  @override
  _HomeActionBarState createState() => _HomeActionBarState();
}

class _HomeActionBarState extends State<HomeActionBar> {
  bool searchMode = false;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeActionBarCubit>(context).getUserImg();
    return Container(
      color: AppColors.lightColor.withOpacity(0.15),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Strings.logo,
                  width: 40.w,
                  fit: BoxFit.fitWidth,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          searchMode ? searchMode = false : searchMode = true;
                        });
                      },
                      child: Icon(
                        Icons.search_rounded,
                        color: AppColors.lightColor,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRouter.profilePage),
                      child: ClipOval(
                        child:
                            BlocBuilder<HomeActionBarCubit, HomeActionBarState>(
                          builder: (context, state) {
                            if (state is HomeActionBarLoaded) {
                              return state.userImg != "null"
                                  ? FadeInImage.assetNetwork(
                                      placeholder: Strings.ghostPlaceHolder,
                                      image: state.userImg,
                                      width: 10.w,
                                      height: 10.w,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      Strings.ghostPlaceHolder,
                                      width: 10.w,
                                      height: 10.w,
                                      fit: BoxFit.cover,
                                    );
                            } else {
                              return Image.asset(
                                Strings.ghostPlaceHolder,
                                width: 10.w,
                                height: 10.w,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          searchMode
              ? Column(
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppTextInput(
                                onChanged: (searchTxt) {},
                                textInputAction: TextInputAction.search,
                                isPassword: false,
                                hintText: "Search...",
                                bgColor: AppColors.lightColor.withOpacity(0.2),
                                textColor: AppColors.lightColor),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                searchMode = false;
                              });
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 20.sp,
                              color: AppColors.lightColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
