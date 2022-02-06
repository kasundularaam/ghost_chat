part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<Friend> friends;
  ContactsLoaded({
    required this.friends,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactsLoaded && listEquals(other.friends, friends);
  }

  @override
  int get hashCode => friends.hashCode;

  @override
  String toString() => 'ContactsLoaded(friends: $friends)';
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

class ContactsNoPermission extends ContactsState {
  final String errorMsg;
  ContactsNoPermission({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactsNoPermission && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'ContactsNoPermission(errorMsg: $errorMsg)';
}

class ContactsNoFriends extends ContactsState {}
