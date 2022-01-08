import 'dart:convert';

class AppContact {
  final String userPhone;
  final String userName;
  AppContact({
    required this.userPhone,
    required this.userName,
  });

  AppContact copyWith({
    String? userPhone,
    String? userName,
  }) {
    return AppContact(
      userPhone: userPhone ?? this.userPhone,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userPhone': userPhone,
      'userName': userName,
    };
  }

  factory AppContact.fromMap(Map<String, dynamic> map) {
    return AppContact(
      userPhone: map['userPhone'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppContact.fromJson(String source) =>
      AppContact.fromMap(json.decode(source));

  @override
  String toString() => 'AppContact(userPhone: $userPhone, userName: $userName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppContact &&
        other.userPhone == userPhone &&
        other.userName == userName;
  }

  @override
  int get hashCode => userPhone.hashCode ^ userName.hashCode;
}
