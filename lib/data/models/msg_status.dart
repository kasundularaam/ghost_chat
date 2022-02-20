import 'dart:convert';

class MsgStatus {
  final String msgStatus;
  final String msgSeenTime;
  MsgStatus({
    required this.msgStatus,
    required this.msgSeenTime,
  });

  MsgStatus copyWith({
    String? msgStatus,
    String? msgSeenTime,
  }) {
    return MsgStatus(
      msgStatus: msgStatus ?? this.msgStatus,
      msgSeenTime: msgSeenTime ?? this.msgSeenTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msgStatus': msgStatus,
      'msgSeenTime': msgSeenTime,
    };
  }

  factory MsgStatus.fromMap(Map<String, dynamic> map) {
    return MsgStatus(
      msgStatus: map['msgStatus'] ?? '',
      msgSeenTime: map['msgSeenTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MsgStatus.fromJson(String source) =>
      MsgStatus.fromMap(json.decode(source));

  @override
  String toString() =>
      'MsgStatus(msgStatus: $msgStatus, msgSeenTime: $msgSeenTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MsgStatus &&
        other.msgStatus == msgStatus &&
        other.msgSeenTime == msgSeenTime;
  }

  @override
  int get hashCode => msgStatus.hashCode ^ msgSeenTime.hashCode;
}
