import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/logic/cubit/add_pro_pic_cubit/add_pro_pic_cubit.dart';
import 'package:ghost_chat/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:ghost_chat/logic/cubit/chat_list_cubit/chat_list_cubit.dart';
import 'package:ghost_chat/logic/cubit/contacts_cubit/contacts_cubit.dart';
import 'package:ghost_chat/logic/cubit/landing_page_cubit/landing_page_cubit.dart';
import 'package:ghost_chat/logic/cubit/update_acc_cubit/update_acc_cubit.dart';
import 'package:ghost_chat/presentation/screens/auth_screen/auth_page.dart';
import 'package:ghost_chat/presentation/screens/auth_screen/create_profile_page.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/contacts_page.dart';
import 'package:ghost_chat/presentation/screens/landing_screen/landing_page.dart';
import 'package:ghost_chat/presentation/screens/profile_screen/profile_page.dart';
import 'package:ghost_chat/presentation/screens/user_profile_screen/user_profile_page.dart';

import '../../core/exceptions/route_exception.dart';
import '../screens/home_screen/home_page.dart';

class AppRouter {
  static const String landingPage = '/';
  static const String homePage = '/home';
  static const String authPage = '/authPage';
  static const String contactsPage = '/contactsPage';
  static const String createProfilePage = '/createProfilePage';
  static const String profilePage = '/profilePage';
  static const String userProfilePage = '/userprofilePage';

  static ContactsCubit contactsCubit = ContactsCubit();

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
          builder: (_) => BlocProvider.value(
            value: contactsCubit,
            child: const ProfilePage(),
          ),
        );
      case userProfilePage:
        final String userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: contactsCubit,
            child: UserProfilePage(
              userId: userId,
            ),
          ),
        );
      default:
        throw const RouteException('Route not found!');
    }
  }
}
