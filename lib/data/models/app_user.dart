import 'dart:convert';

class AppUser {
  String userId;
  String userName;
  AppUser({
    required this.userId,
    required this.userName,
  });

  AppUser copyWith({
    String? userId,
    String? userName,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'],
      userName: map['userName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() => 'AppUser(userId: $userId, userName: $userName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.userId == userId &&
        other.userName == userName;
  }

  @override
  int get hashCode => userId.hashCode ^ userName.hashCode;
}
