import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:meta/meta.dart';

part 'edit_bio_state.dart';

class EditBioCubit extends Cubit<EditBioState> {
  EditBioCubit() : super(EditBioInitial());

  Future<void> editBio({required String newBio}) async {
    try {
      if (newBio.isNotEmpty) {
        emit(EditBioUpdating());
        await AuthRepo.updateUserBio(userBio: newBio);
        emit(EditBioSucceed());
      }
    } catch (e) {
      emit(EditBioFailed(errorMsg: e.toString()));
    }
  }
}
