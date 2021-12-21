part of 'landing_page_cubit.dart';

@immutable
abstract class LandingPageState {}

class LandingPageInitial extends LandingPageState {}

class LandingPageLoading extends LandingPageState {}

class LandingPageUserReady extends LandingPageState {
  final AppUser appUser;
  LandingPageUserReady({
    required this.appUser,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LandingPageUserReady && other.appUser == appUser;
  }

  @override
  int get hashCode => appUser.hashCode;

  @override
  String toString() => 'LandingPageUserReady(appUser: $appUser)';
}

class LandingPageNoUser extends LandingPageState {}

class LandingPageNewAccount extends LandingPageState {}

class LandingPageFailed extends LandingPageState {
  final String errorMsg;
  LandingPageFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LandingPageFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'LandingPageFailed(errorMsg: $errorMsg)';
}
