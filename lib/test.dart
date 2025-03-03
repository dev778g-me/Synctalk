import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

Future<bool> requestStoragePermission(BuildContext context) async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      print("u got");
      // Android 13+ == Api 33 so you no need special permission
      return true;
    } else if (androidInfo.version.sdkInt >= 30) {
      // Android 11+ (Use MediaStore API for Downloads folder)
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final requestStatus = await Permission.storage.request();
        if (!requestStatus.isGranted) {
          showPermissionDeniedMessage(context);
          return false;
        }
      }
      return true;
    } else {
      // Android 10 and below
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final requestStatus = await Permission.storage.request();
        if (!requestStatus.isGranted) {
          showPermissionDeniedMessage(context);
          return false;
        }
      }
      return true;
    }
  } else {
    //ios
    return true;
  }
}

void showPermissionDeniedMessage(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Storage permission is required to save files.'),
        action: SnackBarAction(
          label: 'Open Settings',
          onPressed: openAppSettings,
        ),
      ),
    );
  });
}
