part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<AppUser> users;
  ContactsLoaded({
    required this.users,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactsLoaded && listEquals(other.users, users);
  }

  @override
  int get hashCode => users.hashCode;

  @override
  String toString() => 'ContactsLoaded(users: $users)';
}

class ContactsFailed extends ContactsState {
  final String errorMsg;
  ContactsFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactsFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'ContactsFailed(errorMsg: $errorMsg)';
}
