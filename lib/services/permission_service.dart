import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos, // Gallery on iOS
      Permission.storage, // Storage on Android
      Permission.notification,
      Permission.sms,
    ].request();
    
    // Log statuses for debugging if needed
    statuses.forEach((permission, status) {
      print('${permission.toString()}: ${status.toString()}');
    });
  }

  Future<bool> hasCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  Future<bool> hasGalleryPermission() async {
    if (await Permission.photos.isGranted || await Permission.storage.isGranted) {
      return true;
    }
    return false;
  }
}
