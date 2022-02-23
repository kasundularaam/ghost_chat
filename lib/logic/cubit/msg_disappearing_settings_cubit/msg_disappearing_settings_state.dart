part of 'msg_disappearing_settings_cubit.dart';

@immutable
abstract class MsgDisappearingSettingsState {}

class MsgDisappearingSettingsInitial extends MsgDisappearingSettingsState {}

class MsgDisappearingSettingsLoading extends MsgDisappearingSettingsState {}

class MsgDisappearingSettingsLoaded extends MsgDisappearingSettingsState {
  final int disappearingTime;
  MsgDisappearingSettingsLoaded({
    required this.disappearingTime,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MsgDisappearingSettingsLoaded &&
        other.disappearingTime == disappearingTime;
  }

  @override
  int get hashCode => disappearingTime.hashCode;

  @override
  String toString() =>
      'MsgDisappearingSettingsLoaded(disappearingTime: $disappearingTime)';
}

class MsgDisappearingSettingsUpdating extends MsgDisappearingSettingsState {}

class MsgDisappearingSettingsUpdated extends MsgDisappearingSettingsState {}

class MsgDisappearingSettingsFailed extends MsgDisappearingSettingsState {
  final String errorMsg;
  MsgDisappearingSettingsFailed({
    required this.errorMsg,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MsgDisappearingSettingsFailed && other.errorMsg == errorMsg;
  }

  @override
  int get hashCode => errorMsg.hashCode;

  @override
  String toString() => 'MsgDisappearingSettingsFailed(errorMsg: $errorMsg)';
}
