import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:meta/meta.dart';

part 'chat_crd_img_state.dart';

class ChatCrdImgCubit extends Cubit<ChatCrdImgState> {
  ChatCrdImgCubit() : super(ChatCrdImgInitial());

  Future<void> loadFriendImg({required String friendId}) async {
    try {
      Friend friend = await UsersRepo.getFriendDetails(userId: friendId);

      emit(ChatCrdImgLoaded(friendImage: friend.userImg));
    } catch (e) {
      print(e);
    }
  }
}
