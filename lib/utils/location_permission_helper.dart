import 'package:permission_handler/permission_handler.dart';

class LocationPermissionHelper {
  /// Request location permission (fine location)
  static Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      // Ask user for permission
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      // Open app settings if permanently denied
      await openAppSettings();
    }
  }

  /// Check if location permission is granted
  static Future<bool> isLocationGranted() async {
    return await Permission.location.isGranted;
  }

  /// Request background location (optional)
  static Future<void> requestBackgroundPermission() async {
    var status = await Permission.locationAlways.status;

    if (status.isDenied) {
      status = await Permission.locationAlways.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
