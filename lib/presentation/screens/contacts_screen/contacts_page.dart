import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/logic/cubit/contacts_cubit/contacts_cubit.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/widgets/contact_card.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/widgets/contacts_action_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ContactsCubit>(context).getFriends(term: 1);
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Column(
          children: [
            BlocProvider.value(
              value: AppRouter.contactsCubit,
              child: const ContactsActionBar(),
            ),
            BlocConsumer<ContactsCubit, ContactsState>(
              listener: (context, state) {
                if (state is ContactsFailed) {
                  SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (state is ContactsNoPermission) {
                  SnackBar snackBar = SnackBar(content: Text(state.errorMsg));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              builder: (context, state) {
                if (state is ContactsLoaded) {
                  List<Friend> friends = state.friends;
                  return Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            itemCount: friends.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Friend friend = friends[index];
                              return ContactCard(
                                friend: friend,
                              );
                            }),
                      ],
                    ),
                  );
                } else if (state is ContactsLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                } else if (state is ContactsNoPermission) {
                  return Expanded(
                    child: Center(
                      child: TextButton(
                          onPressed: () => openAppSettings(),
                          child: const Text("Grant Permissions")),
                    ),
                  );
                } else if (state is ContactsNoFriends) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "Non of your friends using\nGhost Chat!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.lightColor.withOpacity(0.7),
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: TextButton(
                          onPressed: () =>
                              BlocProvider.of<ContactsCubit>(context)
                                  .getFriends(term: 1),
                          child: const Text("Retry")),
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
