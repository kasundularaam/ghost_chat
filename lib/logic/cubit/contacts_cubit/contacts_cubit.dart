import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/core/permissions_service.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  List<Contact> contacts = [];

  Future<void> loadContacts() async {
    try {
      emit(ContactsLoading());
      bool permissionStatus = await PermissionService.getPermission(
          permission: Permission.contacts);
      if (permissionStatus) {
        contacts = await ContactsService.getContacts();
        emit(ContactsLoaded(contacts: contacts));
      } else {
        emit(ContactsFailed(errorMsg: "Contact permission required"));
      }
    } catch (e) {
      emit(ContactsFailed(errorMsg: e.toString()));
    }
  }

  Future<void> searchContacts({required String searchText}) async {
    try {
      emit(ContactsLoading());
      if (contacts.isNotEmpty) {
        List<Contact> searchResults = [];
        for (var contact in contacts) {
          if (contact.displayName!
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
            searchResults.add(contact);
          }
        }
        emit(ContactsLoaded(contacts: searchResults));
      } else {
        loadContacts();
      }
    } catch (e) {
      emit(ContactsFailed(errorMsg: e.toString()));
    }
  }
}
