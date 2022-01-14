part of 'chat_page_cubit.dart';

@immutable
abstract class ChatPageState {}

class ChatPageInitial extends ChatPageState {}

class ChatPageLoading extends ChatPageState {}

class ChatPageShowMessages extends ChatPageState {
  final List<DownloadMessage> messegesList;
  ChatPageShowMessages({
    required this.messegesList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatPageShowMessages &&
        listEquals(other.messegesList, messegesList);
  }

  @override
  int get hashCode => messegesList.hashCode;

  @override
  String toString() => 'ChatPageShowMessages(messegesList: $messegesList)';
}
