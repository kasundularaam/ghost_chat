import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'message_box_state.dart';

class MessageBoxCubit extends Cubit<MessageBoxState> {
  MessageBoxCubit() : super(MessageBoxText());

  void messageBoxText() => emit(MessageBoxText());
  void messageBoxVoice() => emit(MessageBoxVoice());
}
