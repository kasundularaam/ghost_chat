import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/models/app_user.dart';
import 'package:ghost_chat/data/repositories/auth_repo.dart';
import 'package:ghost_chat/data/repositories/local_repo.dart';
import 'package:meta/meta.dart';

part 'add_pro_pic_state.dart';

class AddProPicCubit extends Cubit<AddProPicState> {
  AddProPicCubit() : super(AddProPicInitial());

  Future<void> loadProfilePic() async {
    try {
      emit(AddProPicLoading());
      AppUser user = await AuthRepo.getUserDetails();
      emit(AddProPicLoaded(userImg: user.userImg));
    } catch (e) {
      emit(AddProPicFailed(errorMsg: e.toString()));
      emit(AddProPicInitial());
    }
  }

  Future<void> uploadProPic() async {
    try {
      File imageFile = await LocalRepo.pickImage();
      emit(AddProPicUploading());
      await AuthRepo.addProfilePic(imageFile: imageFile);
      emit(AddProPicUploaded());
      loadProfilePic();
    } catch (e) {
      emit(AddProPicFailed(errorMsg: e.toString()));
      loadProfilePic();
    }
  }
}
