import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/logic/cubit/contacts_cubit/contacts_cubit.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/widgets/contact_card.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ContactsCubit>(context).loadContacts();
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.darkGrey,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      Column(
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
                                List<Contact> contacts = state.contacts;
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.search_rounded,
                        size: 20.sp,
                        color: AppColors.lightColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocConsumer<ContactsCubit, ContactsState>(
              listener: (context, state) {
                if (state is ContactsFailed) {
                  SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              builder: (context, state) {
                if (state is ContactsLoaded) {
                  List<Contact> contacts = state.contacts;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: contacts.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          Contact contact = contacts[index];
                          return ContactCard(
                            contactName: contact.displayName!,
                          );
                        }),
                  );
                } else if (state is ContactsLoading) {
                  return const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    )),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: TextButton(
                          onPressed: () => openAppSettings(),
                          child: const Text("Grant Permissions")),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
