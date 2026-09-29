import "package:permission_handler/permission_handler.dart";

class PermissionHandler {
  /// Request specific permissions
  /// This is kept for future use if specific permissions are needed
  Future<bool> requestSpecificPermission(Permission permission) async {
    var status = await permission.request();
    return status == PermissionStatus.granted;
  }

  /// Verify a particular Permission status
  Future<bool> hasPermission(Permission permission) async {
    var permissionStatus = await permission.status;
    return permissionStatus == PermissionStatus.granted;
  }

  /// Request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Check if app settings need to be opened for permissions
  Future<bool> shouldShowRequestRationale(Permission permission) async {
    return await permission.shouldShowRequestRationale;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}
