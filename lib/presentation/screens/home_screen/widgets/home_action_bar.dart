import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';

class HomeActionBar extends StatefulWidget {
  final String userImage;
  const HomeActionBar({
    Key? key,
    required this.userImage,
  }) : super(key: key);

  @override
  _HomeActionBarState createState() => _HomeActionBarState();
}

class _HomeActionBarState extends State<HomeActionBar> {
  bool searchMode = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGrey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/images/logo.png",
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
                    ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/ghost_ph.gif",
                        image: widget.userImage,
                        width: 10.w,
                        fit: BoxFit.cover,
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
                                bgColor: AppColors.darkColor.withOpacity(0.4),
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
          Container(
            color: AppColors.lightColor.withOpacity(1),
            height: 0.05.h,
            width: 100.w,
          ),
        ],
      ),
    );
  }
}
