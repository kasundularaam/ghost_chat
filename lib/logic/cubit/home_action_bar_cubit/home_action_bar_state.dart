part of 'home_action_bar_cubit.dart';

@immutable
abstract class HomeActionBarState {}

class HomeActionBarInitial extends HomeActionBarState {}

class HomeActionBarLoading extends HomeActionBarState {}

class HomeActionBarLoaded extends HomeActionBarState {
  final String userImg;
  HomeActionBarLoaded({
    required this.userImg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeActionBarLoaded && other.userImg == userImg;
  }

  @override
  int get hashCode => userImg.hashCode;

  @override
  String toString() => 'HomeActionBarLoaded(userImg: $userImg)';
}

class HomeActionBarFailed extends HomeActionBarState {
  final String errorMsg;
  HomeActionBarFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeActionBarFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'HomeActionBarFailed(errorMsg: $errorMsg)';
}
