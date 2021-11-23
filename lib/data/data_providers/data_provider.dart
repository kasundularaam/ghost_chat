// Dummy file

import 'package:ghost_chat/data/models/app_user.dart';

class DataProvider {
  static AppUser getCurrentUser() {
    try {
      return AppUser(userId: "001", userName: "Kasun Dulara");
    } catch (e) {
      throw e.toString();
    }
  }
}
