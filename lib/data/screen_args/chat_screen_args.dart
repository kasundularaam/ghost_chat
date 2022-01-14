class ChatScreenArgs {
  final String friendId;
  final String conversationId;
  ChatScreenArgs({
    required this.friendId,
    required this.conversationId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatScreenArgs &&
        other.friendId == friendId &&
        other.conversationId == conversationId;
  }

  @override
  int get hashCode => friendId.hashCode ^ conversationId.hashCode;

  @override
  String toString() =>
      'ChatScreenArgs(friendId: $friendId, conversationId: $conversationId)';
}
