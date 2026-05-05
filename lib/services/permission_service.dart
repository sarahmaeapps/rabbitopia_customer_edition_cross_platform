import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

class PermissionService {
  Future<void> requestAllPermissions() async {
    if (kIsWeb) {
      debugPrint('Skipping permission requests on web platform.');
      return;
    }
    
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
    if (kIsWeb) return true; // Most web browsers handle this per-request
    return await Permission.camera.isGranted;
  }

  Future<bool> hasGalleryPermission() async {
    if (kIsWeb) return true;
    if (await Permission.photos.isGranted || await Permission.storage.isGranted) {
      return true;
    }
    return false;
  }
}
