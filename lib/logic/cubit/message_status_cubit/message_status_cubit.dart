import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:meta/meta.dart';

part 'message_status_state.dart';

class MessageStatusCubit extends Cubit<MessageStatusState> {
  MessageStatusCubit() : super(MessageStatusInitial());

  Future<void> getMessageStatus(
      {required String conversationId, required String messageId}) async {
    try {
      emit(MessageStatusLoading());
      MessageRepo.getMessageStatus(
              conversationId: conversationId, messageId: messageId)
          .listen((status) {
        emit(MessageStatusLoaded(status: status));
      });
    } catch (e) {
      emit(MessageStatusFailed(errorMsg: e.toString()));
    }
  }
}
