import 'package:bloc/bloc.dart';
import 'package:ghost_chat/core/constants/strings.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'msg_disappearing_settings_state.dart';

class MsgDisappearingSettingsCubit extends Cubit<MsgDisappearingSettingsState> {
  MsgDisappearingSettingsCubit() : super(MsgDisappearingSettingsInitial());

  Future loadTime() async {
    try {
      emit(MsgDisappearingSettingsLoading());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int time = prefs.getInt(Strings.msgDisappearingTimeKey) ?? 10;
      emit(MsgDisappearingSettingsLoaded(disappearingTime: time));
    } catch (e) {
      emit(MsgDisappearingSettingsFailed(errorMsg: e.toString()));
    }
  }

  Future editTime({required int newTime}) async {
    try {
      emit(MsgDisappearingSettingsUpdating());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(Strings.msgDisappearingTimeKey, newTime);
      emit(MsgDisappearingSettingsUpdated());
      loadTime();
    } catch (e) {
      emit(MsgDisappearingSettingsFailed(errorMsg: e.toString()));
    }
  }
}
