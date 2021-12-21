part of 'add_pro_pic_cubit.dart';

@immutable
abstract class AddProPicState {}

class AddProPicInitial extends AddProPicState {}

class AddProPicUploading extends AddProPicState {}

class AddProPicUploaded extends AddProPicState {}

class AddProPicFailed extends AddProPicState {
  final String errorMsg;
  AddProPicFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddProPicFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'AddProPicFailed(errorMsg: $errorMsg)';
}

class AddProPicLoading extends AddProPicState {}

class AddProPicLoaded extends AddProPicState {
  final String userImg;
  AddProPicLoaded({
    required this.userImg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddProPicLoaded && other.userImg == userImg;
  }

  @override
  int get hashCode => userImg.hashCode;

  @override
  String toString() => 'AddProPicLoaded(userImg: $userImg)';
}
