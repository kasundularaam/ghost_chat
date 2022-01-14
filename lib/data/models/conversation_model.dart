import 'dart:convert';

class ConversationModel {
  final String conversationId;
  final String friendId;
  final String lastUpdate;
  final bool active;
  ConversationModel({
    required this.conversationId,
    required this.friendId,
    required this.lastUpdate,
    required this.active,
  });

  ConversationModel copyWith({
    String? conversationId,
    String? friendId,
    String? lastUpdate,
    bool? active,
  }) {
    return ConversationModel(
      conversationId: conversationId ?? this.conversationId,
      friendId: friendId ?? this.friendId,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'friendId': friendId,
      'lastUpdate': lastUpdate,
      'active': active,
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      conversationId: map['conversationId'] ?? '',
      friendId: map['friendId'] ?? '',
      lastUpdate: map['lastUpdate'] ?? '',
      active: map['active'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromJson(String source) =>
      ConversationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ConversationModel(conversationId: $conversationId, friendId: $friendId, lastUpdate: $lastUpdate, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationModel &&
        other.conversationId == conversationId &&
        other.friendId == friendId &&
        other.lastUpdate == lastUpdate &&
        other.active == active;
  }

  @override
  int get hashCode {
    return conversationId.hashCode ^
        friendId.hashCode ^
        lastUpdate.hashCode ^
        active.hashCode;
  }
}
