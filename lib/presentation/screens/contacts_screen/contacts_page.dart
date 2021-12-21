import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/logic/cubit/contacts_cubit/contacts_cubit.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/widgets/contact_card.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/widgets/contacts_action_bar.dart';
import 'package:permission_handler/permission_handler.dart';

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
            BlocProvider.value(
              value: AppRouter.contactsCubit,
              child: const ContactsActionBar(),
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
                  List<AppUser> users = state.users;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: users.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          AppUser appUser = users[index];
                          return ContactCard(
                            appUser: appUser,
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
