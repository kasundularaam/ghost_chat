import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/friend_model.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:meta/meta.dart';

part 'chat_action_bar_state.dart';

class ChatActionBarCubit extends Cubit<ChatActionBarState> {
  ChatActionBarCubit() : super(ChatActionBarInitial());

  Future<void> loadActionBar({required String friendId}) async {
    try {
      emit(ChatActionBarLoading());
      Friend friend = await UsersRepo.getFriendDetails(userId: friendId);
      emit(
        ChatActionBarLoaded(friend: friend),
      );
    } catch (e) {
      emit(ChatActionBarFaild(errorMsg: e.toString()));
    }
  }
}
