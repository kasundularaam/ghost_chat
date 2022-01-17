class ChatScreenArgs {
  final String friendId;
  final String conversationId;
  final String friendNumber;
  ChatScreenArgs({
    required this.friendId,
    required this.conversationId,
    required this.friendNumber,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatScreenArgs &&
        other.friendId == friendId &&
        other.conversationId == conversationId &&
        other.friendNumber == friendNumber;
  }

  @override
  int get hashCode =>
      friendId.hashCode ^ conversationId.hashCode ^ friendNumber.hashCode;

  @override
  String toString() =>
      'ChatScreenArgs(friendId: $friendId, conversationId: $conversationId, friendNumber: $friendNumber)';
}
