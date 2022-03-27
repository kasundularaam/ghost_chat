part of 'chat_page_cubit.dart';

@immutable
abstract class ChatPageState {}

class ChatPageInitial extends ChatPageState {}

class ChatPageLoading extends ChatPageState {}

class ChatPageShowMessages extends ChatPageState {
  final List<DownloadMessage> messagesList;
  ChatPageShowMessages({
    required this.messagesList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatPageShowMessages &&
        listEquals(other.messagesList, messagesList);
  }

  @override
  int get hashCode => messagesList.hashCode;

  @override
  String toString() => 'ChatPageShowMessages(messagesList: $messagesList)';
}

class ChatPageNoMessages extends ChatPageState {}
