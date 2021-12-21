import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/core/permissions_service.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  List<AppUser> users = [];

  Future<void> loadContacts() async {
    try {
      emit(ContactsLoading());
      bool permissionStatus = await PermissionService.getPermission(
          permission: Permission.contacts);
      if (permissionStatus) {
        List<Contact> contacts = await ContactsService.getContacts();
        users = await UsersRepo.getFriends(contacts: contacts);
        emit(ContactsLoaded(users: users));
      } else {
        emit(ContactsFailed(errorMsg: "Contact permission required"));
      }
    } catch (e) {
      emit(ContactsFailed(errorMsg: e.toString()));
    }
  }

  Future<void> searchFriends({required String searchText}) async {
    try {
      emit(ContactsLoading());
      if (users.isNotEmpty) {
        List<AppUser> searchResults = [];
        for (var user in users) {
          if (user.userName.toLowerCase().contains(searchText.toLowerCase())) {
            searchResults.add(user);
          }
        }
        emit(ContactsLoaded(users: searchResults));
      } else {
        loadContacts();
        searchFriends(searchText: searchText);
      }
    } catch (e) {
      emit(ContactsFailed(errorMsg: e.toString()));
    }
  }
}
