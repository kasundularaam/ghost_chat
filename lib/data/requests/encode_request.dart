class EncodeRequest {
  String msg;
  String? token;
  EncodeRequest({
    required this.msg,
    this.token,
  });
  bool shouldEncrypt() {
    return (token != null && token!.isNotEmpty);
  }
}
