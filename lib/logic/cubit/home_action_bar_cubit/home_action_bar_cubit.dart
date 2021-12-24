import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:meta/meta.dart';

part 'home_action_bar_state.dart';

class HomeActionBarCubit extends Cubit<HomeActionBarState> {
  HomeActionBarCubit() : super(HomeActionBarInitial());

  Future<void> getUserImg() async {
    try {
      emit(HomeActionBarLoading());
      AppUser appUser = await AuthRepo.getUserDetails();
      emit(HomeActionBarLoaded(userImg: appUser.userImg));
    } catch (e) {
      emit(HomeActionBarFailed(errorMsg: e.toString()));
    }
  }
}
