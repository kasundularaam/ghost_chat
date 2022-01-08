part of 'profile_page_cubit.dart';

@immutable
abstract class ProfilePageState {}

class ProfilePageInitial extends ProfilePageState {}

class ProfilePageLoading extends ProfilePageState {}

class ProfilePageLoaded extends ProfilePageState {
  final AppUser appUser;
  ProfilePageLoaded({
    required this.appUser,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfilePageLoaded && other.appUser == appUser;
  }

  @override
  int get hashCode => appUser.hashCode;

  @override
  String toString() => 'ProfilePageLoaded(appUser: $appUser)';
}

class ProfilePageFailed extends ProfilePageState {
  final String errorMsg;
  ProfilePageFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfilePageFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'ProfilePageFailed(errorMsg: $errorMsg)';
}
