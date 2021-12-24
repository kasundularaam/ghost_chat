import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/core/permissions_service.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  List<Friend> friends = [];

  Future<void> loadContacts() async {
    try {
      emit(ContactsLoading());
      bool permissionStatus = await PermissionService.getPermission(
          permission: Permission.contacts);
      if (permissionStatus) {
        List<Contact> contacts = await ContactsService.getContacts();
        friends = await UsersRepo.getFriends(contacts: contacts);
        emit(ContactsLoaded(friends: friends));
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
      if (friends.isNotEmpty) {
        List<Friend> searchResults = [];
        for (var friend in friends) {
          if (friend.contactName
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
            searchResults.add(friend);
          }
        }
        emit(ContactsLoaded(friends: searchResults));
      } else {
        loadContacts();
        searchFriends(searchText: searchText);
      }
    } catch (e) {
      emit(ContactsFailed(errorMsg: e.toString()));
    }
  }
}
