import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:meta/meta.dart';

part 'update_acc_state.dart';

class UpdateAccCubit extends Cubit<UpdateAccState> {
  UpdateAccCubit() : super(UpdateAccInitial());

  Future<void> updateAcc(
      {required String userName, required String userBio}) async {
    try {
      emit(UpdateAccUpdating());
      await AuthRepo.updateUserName(userName: userName);
      await AuthRepo.updateUserBio(userBio: userBio);
      emit(UpdateAccSucceed());
    } catch (e) {
      emit(UpdateAccFailed(errorMsg: e.toString()));
    }
  }
}
