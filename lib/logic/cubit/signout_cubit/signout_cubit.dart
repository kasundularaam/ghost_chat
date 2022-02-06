import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:meta/meta.dart';

part 'signout_state.dart';

class SignoutCubit extends Cubit<SignoutState> {
  SignoutCubit() : super(SignoutInitial());

  Future<void> signoutUser() async {
    try {
      emit(SignoutLoading());
      AuthRepo.signoutUser();
      emit(SignoutSucceed());
    } catch (e) {
      emit(SignoutFailed(errorMsg: e.toString()));
    }
  }
}
