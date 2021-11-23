part of 'landing_page_cubit.dart';

@immutable
abstract class LandingPageState {}

class LandingPageInitial extends LandingPageState {}

class LandingPageLoading extends LandingPageState {}

class LandingPageUserIn extends LandingPageState {}

class LandingPageNoUser extends LandingPageState {}

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
