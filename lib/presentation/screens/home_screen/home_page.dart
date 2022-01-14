import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:ghost_chat/presentation/router/app_router.dart';
import 'package:sizer/sizer.dart';

import 'package:ghost_chat/core/constants/app_colors.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/screen_args/chat_card_args.dart';
import 'package:ghost_chat/logic/cubit/chat_list_cubit/chat_list_cubit.dart';
import 'package:ghost_chat/presentation/screens/home_screen/widgets/chat_card.dart';
import 'package:ghost_chat/presentation/screens/home_screen/widgets/home_action_bar.dart';
import 'package:ghost_chat/presentation/screens/home_screen/widgets/new_chat_btn.dart';

class HomePage extends StatefulWidget {
  final AppUser appUser;
  const HomePage({
    Key? key,
    required this.appUser,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    AuthRepo.goOnline();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      await AuthRepo.goOffline();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChatListCubit>(context).loadChats();
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BlocProvider.value(
                  value: AppRouter.homeActionBarCubit,
                  child: const HomeActionBar(),
                ),
                Expanded(
                  child: BlocConsumer<ChatListCubit, ChatListState>(
                    listener: (context, state) {
                      if (state is ChatListFailed) {
                        SnackBar snackBar =
                            SnackBar(content: Text(state.errorMsg));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    builder: (context, state) {
                      if (state is ChatListLoaded) {
                        List<ChatCardArgs> chaCardArgsList =
                            state.chatCardArgsList;
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                            itemCount: chaCardArgsList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              ChatCardArgs chatCardArgs =
                                  chaCardArgsList[index];
                              return ChatCard(
                                chatCardArgs: chatCardArgs,
                              );
                            });
                      } else if (state is ChatListLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                )
              ],
            ),
            Positioned(right: 3.w, bottom: 3.w, child: const NewMsgBtn())
          ],
        ),
      ),
    );
    //NIKAM
  }
}
