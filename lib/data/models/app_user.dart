import 'dart:convert';

class AppUser {
  final String userId;
  final String userName;
  final String userNumber;
  final String userBio;
  final String userImg;
  final String? userStatus;
  final String? typingTo;
  AppUser({
    required this.userId,
    required this.userName,
    required this.userNumber,
    required this.userBio,
    required this.userImg,
    this.userStatus,
    this.typingTo,
  });

  AppUser copyWith({
    String? userId,
    String? userName,
    String? userNumber,
    String? userBio,
    String? userImg,
    String? userStatus,
    String? typingTo,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userNumber: userNumber ?? this.userNumber,
      userBio: userBio ?? this.userBio,
      userImg: userImg ?? this.userImg,
      userStatus: userStatus ?? this.userStatus,
      typingTo: typingTo ?? this.typingTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userNumber': userNumber,
      'userBio': userBio,
      'userImg': userImg,
      'userStatus': userStatus,
      'typingTo': typingTo,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userNumber: map['userNumber'] ?? '',
      userBio: map['userBio'] ?? '',
      userImg: map['userImg'] ?? '',
      userStatus: map['userStatus'],
      typingTo: map['typingTo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(userId: $userId, userName: $userName, userNumber: $userNumber, userBio: $userBio, userImg: $userImg, userStatus: $userStatus, typingTo: $typingTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.userId == userId &&
        other.userName == userName &&
        other.userNumber == userNumber &&
        other.userBio == userBio &&
        other.userImg == userImg &&
        other.userStatus == userStatus &&
        other.typingTo == typingTo;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        userNumber.hashCode ^
        userBio.hashCode ^
        userImg.hashCode ^
        userStatus.hashCode ^
        typingTo.hashCode;
  }
}
