import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost_chat/core/permissions_service.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  Future<void> loadContacts() async {
    try {
      emit(ContactsLoading());
      bool permissionStatus = await PermissionService.getPermission(
          permission: Permission.contacts);
      if (permissionStatus) {
        List<Contact> contacts = await ContactsService.getContacts();
        emit(ContactsLoaded(contacts: contacts));
      } else {
        emit(ContactsFailed(errorMsg: "Contact permission required"));
      }
    } catch (e) {
      emit(ContactsFailed(errorMsg: e.toString()));
    }
  }
}
