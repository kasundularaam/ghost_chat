import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/logic/cubit/contacts_cubit/contacts_cubit.dart';
import 'package:ghost_chat/presentation/glob_widgets/app_text_input.dart';
import 'package:sizer/sizer.dart';

class ContactsActionBar extends StatefulWidget {
  const ContactsActionBar({Key? key}) : super(key: key);

  @override
  _ContactsActionBarState createState() => _ContactsActionBarState();
}

class _ContactsActionBarState extends State<ContactsActionBar> {
  bool searchMood = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGrey,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 20.sp,
              color: AppColors.lightColor,
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            child: searchMood
                ? AppTextInput(
                    onChanged: (searchText) =>
                        BlocProvider.of<ContactsCubit>(context)
                            .searchFriends(searchText: searchText),
                    textInputAction: TextInputAction.search,
                    isPassword: false,
                    hintText: "Search...",
                    bgColor: AppColors.darkColor.withOpacity(0.4),
                    textColor: AppColors.lightColor)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contacts",
                        style: TextStyle(
                            color: AppColors.lightColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      BlocBuilder<ContactsCubit, ContactsState>(
                        builder: (context, state) {
                          if (state is ContactsLoaded) {
                            List<AppUser> contacts = state.users;
                            return Text(
                              "${contacts.length} Contacts",
                              style: TextStyle(
                                color: AppColors.lightColor,
                                fontSize: 10.sp,
                              ),
                            );
                          } else {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                color: AppColors.lightColor,
                                fontSize: 10.sp,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 2.w, left: 5.w),
            child: InkWell(
              onTap: () {
                if (searchMood) {
                  setState(() {
                    searchMood = false;
                  });
                } else {
                  setState(() {
                    searchMood = true;
                  });
                }
              },
              child: Icon(
                searchMood ? Icons.close_rounded : Icons.search_rounded,
                size: 20.sp,
                color: AppColors.lightColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
