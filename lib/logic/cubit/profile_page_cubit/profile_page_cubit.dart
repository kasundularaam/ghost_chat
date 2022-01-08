import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:meta/meta.dart';

part 'profile_page_state.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit() : super(ProfilePageInitial());

  Future<void> getMyDetails() async {
    try {
      emit(ProfilePageLoading());
      AppUser appUser = await AuthRepo.getUserDetails();
      emit(ProfilePageLoaded(appUser: appUser));
    } catch (e) {
      emit(ProfilePageFailed(errorMsg: e.toString()));
    }
  }
}
