import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/users_repo.dart';
import 'package:meta/meta.dart';

part 'user_stats_state.dart';

class UserStatsCubit extends Cubit<UserStatsState> {
  UserStatsCubit() : super(UserStatsInitial());

  Future<void> getUserStatus({required String userId}) async {
    try {
      emit(UserStatsLoading());
      UsersRepo.getUserStatus(userId: userId).listen((userStatus) {
        emit(UserStatsLoaded(userStatus: userStatus));
      });
    } catch (e) {
      emit(UserStatsFailed(errorMsg: e.toString()));
    }
  }
}
