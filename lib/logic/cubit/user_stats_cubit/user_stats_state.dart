part of 'user_stats_cubit.dart';

@immutable
abstract class UserStatsState {}

class UserStatsInitial extends UserStatsState {}

class UserStatsLoading extends UserStatsState {}

class UserStatsLoaded extends UserStatsState {
  final String userStatus;
  UserStatsLoaded({
    required this.userStatus,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserStatsLoaded && other.userStatus == userStatus;
  }

  @override
  int get hashCode => userStatus.hashCode;

  @override
  String toString() => 'UserStatsLoaded(userStatus: $userStatus)';
}

class UserStatsFailed extends UserStatsState {
  final String errorMsg;
  UserStatsFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserStatsFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'UserStatsFailed(errorMsg: $errorMsg)';
}
