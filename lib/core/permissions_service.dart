import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> getPermission({required Permission permission}) async {
    PermissionStatus status = await permission.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
