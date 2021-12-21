import 'dart:convert';

class AppUser {
  final String userId;
  final String userName;
  final String userNumber;
  final String userBio;
  final String userImg;
  AppUser({
    required this.userId,
    required this.userName,
    required this.userNumber,
    required this.userBio,
    required this.userImg,
  });

  AppUser copyWith({
    String? userId,
    String? userName,
    String? userNumber,
    String? userBio,
    String? userImg,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userNumber: userNumber ?? this.userNumber,
      userBio: userBio ?? this.userBio,
      userImg: userImg ?? this.userImg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userNumber': userNumber,
      'userBio': userBio,
      'userImg': userImg,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userNumber: map['userNumber'] ?? '',
      userBio: map['userBio'] ?? '',
      userImg: map['userImg'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(userId: $userId, userName: $userName, userNumber: $userNumber, userBio: $userBio, userImg: $userImg)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.userId == userId &&
        other.userName == userName &&
        other.userNumber == userNumber &&
        other.userBio == userBio &&
        other.userImg == userImg;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        userNumber.hashCode ^
        userBio.hashCode ^
        userImg.hashCode;
  }
}
