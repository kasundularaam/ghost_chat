class DecodeRequest {
  String imgToDecode;
  String? token;
  DecodeRequest({
    required this.imgToDecode,
    this.token,
  });

  bool shouldDecrypt() {
    return (token != null && token!.isNotEmpty);
  }
}
