import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:meta/meta.dart';

part 'landing_page_state.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit() : super(LandingPageInitial());

  Future<void> checkUser() async {
    try {
      emit(LandingPageLoading());
      await Future.delayed(const Duration(seconds: 1));
      bool isSigned = AuthRepo.isSigned();
      if (isSigned) {
        emit(LandingPageUserIn());
      } else {
        emit(LandingPageNoUser());
      }
    } catch (e) {
      emit(LandingPageFailed(errorMsg: e.toString()));
    }
  }
}
