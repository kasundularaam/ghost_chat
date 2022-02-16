import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/screen_args/chat_screen_args.dart';
import 'package:ghost_chat/logic/cubit/add_pro_pic_cubit/add_pro_pic_cubit.dart';
import 'package:ghost_chat/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:ghost_chat/logic/cubit/chat_list_cubit/chat_list_cubit.dart';
import 'package:ghost_chat/logic/cubit/chat_page_cubit/chat_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/contacts_cubit/contacts_cubit.dart';
import 'package:ghost_chat/logic/cubit/cubit/msg_disappearing_settings_cubit.dart';
import 'package:ghost_chat/logic/cubit/edit_bio_cubit/edit_bio_cubit.dart';
import 'package:ghost_chat/logic/cubit/edit_name_cubit/edit_name_cubit.dart';
import 'package:ghost_chat/logic/cubit/go_chat_cubit/go_chat_cubit.dart';
import 'package:ghost_chat/logic/cubit/home_action_bar_cubit/home_action_bar_cubit.dart';
import 'package:ghost_chat/logic/cubit/landing_page_cubit/landing_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_box_cubit/message_box_cubit.dart';
import 'package:ghost_chat/logic/cubit/message_button_cubit/message_button_cubit.dart';
import 'package:ghost_chat/logic/cubit/profile_page_cubit/profile_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/send_message_cubit/send_message_cubit.dart';
import 'package:ghost_chat/logic/cubit/signout_cubit/signout_cubit.dart';
import 'package:ghost_chat/logic/cubit/update_acc_cubit/update_acc_cubit.dart';
import 'package:ghost_chat/logic/cubit/user_stats_cubit/user_stats_cubit.dart';
import 'package:ghost_chat/logic/cubit/voice_message_cubit/voice_message_cubit.dart';
import 'package:ghost_chat/presentation/screens/auth_screen/auth_page.dart';
import 'package:ghost_chat/presentation/screens/auth_screen/create_profile_page.dart';
import 'package:ghost_chat/presentation/screens/chat_screen/chat_page.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/contacts_page.dart';
import 'package:ghost_chat/presentation/screens/friend_profile_screen/friend_profile_page.dart';
import 'package:ghost_chat/presentation/screens/landing_screen/landing_page.dart';
import 'package:ghost_chat/presentation/screens/profile_screen/profile_page.dart';

import '../../core/exceptions/route_exception.dart';
import '../screens/home_screen/home_page.dart';

class AppRouter {
  static const String landingPage = '/';
  static const String homePage = '/home';
  static const String authPage = '/authPage';
  static const String contactsPage = '/contactsPage';
  static const String createProfilePage = '/createProfilePage';
  static const String profilePage = '/profilePage';
  static const String friendProfilePage = '/friendProfilePage';
  static const String chatPage = '/chatPage';

  static ContactsCubit contactsCubit = ContactsCubit();
  static HomeActionBarCubit homeActionBarCubit = HomeActionBarCubit();

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LandingPageCubit(),
            child: const LandingPage(),
          ),
        );
      case homePage:
        final AppUser appUser = settings.arguments as AppUser;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ChatListCubit(),
            child: HomePage(
              appUser: appUser,
            ),
          ),
        );
      case authPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const AuthPage(),
          ),
        );
      case contactsPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: contactsCubit,
            child: const ContactsPage(),
          ),
        );
      case createProfilePage:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<AddProPicCubit>(
                create: (context) => AddProPicCubit(),
              ),
              BlocProvider<UpdateAccCubit>(
                create: (context) => UpdateAccCubit(),
              ),
            ],
            child: const CreateProfilePage(),
          ),
        );
      case profilePage:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ProfilePageCubit(),
              ),
              BlocProvider(
                create: (context) => AddProPicCubit(),
              ),
              BlocProvider(
                create: (context) => EditNameCubit(),
              ),
              BlocProvider(
                create: (context) => EditBioCubit(),
              ),
              BlocProvider.value(
                value: homeActionBarCubit,
              ),
              BlocProvider(
                create: (context) => SignoutCubit(),
              ),
              BlocProvider(
                create: (context) => MsgDisappearingSettingsCubit(),
              ),
            ],
            child: const ProfilePage(),
          ),
        );
      case friendProfilePage:
        final Friend friend = settings.arguments as Friend;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => UserStatsCubit(),
              ),
              BlocProvider(
                create: (context) => GoChatCubit(),
              ),
            ],
            child: FriendProfilePage(
              friend: friend,
            ),
          ),
        );
      case chatPage:
        final ChatScreenArgs args = settings.arguments as ChatScreenArgs;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ChatPageCubit(),
              ),
              BlocProvider(
                create: (context) => SendMessageCubit(),
              ),
              BlocProvider(
                create: (context) => MessageButtonCubit(),
              ),
              BlocProvider(
                create: (context) => MessageBoxCubit(),
              ),
              BlocProvider(
                create: (context) => VoiceMessageCubit(),
              ),
            ],
            child: ChatPage(
              args: args,
            ),
          ),
        );
      default:
        throw const RouteException('Route not found!');
    }
  }
}
