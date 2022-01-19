import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:meta/meta.dart';

part 'typing_status_state.dart';

class TypingStatusCubit extends Cubit<TypingStatusState> {
  TypingStatusCubit() : super(TypingStatusInitial());

  bool typingStats = false;
  String userStats = "";

  Future<void> getTypingStatus({required String friendId}) async {
    try {
      Stream<String> userStream = UsersRepo.getUserStatus(userId: friendId);
      Stream<bool> typingStream = UsersRepo.typingStatus(friendId: friendId);

      userStream.listen((user) {
        userStats = user;
      });

      typingStream.listen((typing) {
        typingStats = typing;
        if (typingStats) {
          emit(TypingStatusLoaded(status: "Typing..."));
        } else {
          emit(TypingStatusLoaded(status: userStats));
        }
      });
    } catch (e) {
      emit(TypingStatusFailed(errorMsg: e.toString()));
    }
  }
}
