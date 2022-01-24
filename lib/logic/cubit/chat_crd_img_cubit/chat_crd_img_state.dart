part of 'chat_crd_img_cubit.dart';

@immutable
abstract class ChatCrdImgState {}

class ChatCrdImgInitial extends ChatCrdImgState {}

class ChatCrdImgLoaded extends ChatCrdImgState {
  final String friendImage;
  ChatCrdImgLoaded({
    required this.friendImage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatCrdImgLoaded && other.friendImage == friendImage;
  }

  @override
  int get hashCode => friendImage.hashCode;

  @override
  String toString() => 'ChatCrdImgLoaded(friendImage: $friendImage)';
}
