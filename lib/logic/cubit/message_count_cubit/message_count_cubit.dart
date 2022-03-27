import 'package:bloc/bloc.dart';
import 'package:ghost_chat/data/repositories/message_repo.dart';
import 'package:meta/meta.dart';

part 'message_count_state.dart';

class MessageCountCubit extends Cubit<MessageCountState> {
  MessageCountCubit() : super(MessageCountInitial());

  Future<void> showUnreadMsgCount({required String conversationId}) async {
    try {
      Stream<int> countStream =
          MessageRepo.getUnreadMsgCount(conversationId: conversationId);
      countStream.listen((msgCount) {
        emit(MessageCountShow(unreadMsgCount: msgCount));
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
