import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'message_button_state.dart';

class MessageButtonCubit extends Cubit<MessageButtonState> {
  MessageButtonCubit() : super(MessageButtonVoice());

  void messageBtnVoice() => emit(MessageButtonVoice());
  void messageBtnSendText() => emit(MessageButtonSendText());
  void messageBtnSendVoice() => emit(MessageButtonSendVoice());
  void messageBtnLoading() => emit(MessageButtonLoading());
}
