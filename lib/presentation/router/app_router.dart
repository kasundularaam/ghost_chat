import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost_chat/logic/cubit/auth_cubit/auth_cubit.dart';
import 'package:ghost_chat/logic/cubit/contacts_cubit/contacts_cubit.dart';
import 'package:ghost_chat/logic/cubit/landing_page_cubit/landing_page_cubit.dart';
import 'package:ghost_chat/presentation/screens/auth_screen/auth_page.dart';
import 'package:ghost_chat/presentation/screens/contacts_screen/contacts_page.dart';
import 'package:ghost_chat/presentation/screens/landing_screen/landing_page.dart';

import '../../core/exceptions/route_exception.dart';
import '../screens/home_screen/home_page.dart';

class AppRouter {
  static const String landingPage = '/';
  static const String homePage = '/home';
  static const String authPage = '/authPage';
  static const String contactsPage = '/contactsPage';

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
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
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
      default:
        throw const RouteException('Route not found!');
    }
  }
}
