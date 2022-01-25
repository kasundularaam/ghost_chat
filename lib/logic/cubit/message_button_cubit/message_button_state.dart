part of 'message_button_cubit.dart';

@immutable
abstract class MessageButtonState {}

class MessageButtonSendText extends MessageButtonState {}

class MessageButtonSendVoice extends MessageButtonState {}

class MessageButtonVoice extends MessageButtonState {}
