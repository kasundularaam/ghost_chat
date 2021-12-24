import 'dart:convert';

class Friend {
  final String userId;
  final String userName;
  final String userNumber;
  final String userBio;
  final String userImg;
  final String contactName;
  Friend({
    required this.userId,
    required this.userName,
    required this.userNumber,
    required this.userBio,
    required this.userImg,
    required this.contactName,
  });

  Friend copyWith({
    String? userId,
    String? userName,
    String? userNumber,
    String? userBio,
    String? userImg,
    String? contactName,
  }) {
    return Friend(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userNumber: userNumber ?? this.userNumber,
      userBio: userBio ?? this.userBio,
      userImg: userImg ?? this.userImg,
      contactName: contactName ?? this.contactName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userNumber': userNumber,
      'userBio': userBio,
      'userImg': userImg,
      'contactName': contactName,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userNumber: map['userNumber'] ?? '',
      userBio: map['userBio'] ?? '',
      userImg: map['userImg'] ?? '',
      contactName: map['contactName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Friend.fromJson(String source) => Friend.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Friend(userId: $userId, userName: $userName, userNumber: $userNumber, userBio: $userBio, userImg: $userImg, contactName: $contactName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Friend &&
        other.userId == userId &&
        other.userName == userName &&
        other.userNumber == userNumber &&
        other.userBio == userBio &&
        other.userImg == userImg &&
        other.contactName == contactName;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        userNumber.hashCode ^
        userBio.hashCode ^
        userImg.hashCode ^
        contactName.hashCode;
  }
}
