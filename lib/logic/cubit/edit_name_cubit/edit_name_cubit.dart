import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:meta/meta.dart';

part 'edit_name_state.dart';

class EditNameCubit extends Cubit<EditNameState> {
  EditNameCubit() : super(EditNameInitial());

  Future<void> editName({required String newName}) async {
    try {
      if (newName.isNotEmpty) {
        emit(EditNameUpdating());
        await AuthRepo.updateUserName(userName: newName);
        emit(EditNameSucceed());
      } else {
        throw "Name is empty!";
      }
    } catch (e) {
      emit(EditNameFailed(errorMsg: e.toString()));
    }
  }
}
