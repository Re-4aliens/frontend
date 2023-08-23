import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class Permissions {
  static Future<bool>getPhotosPermission()async {
    Map<Permission, PermissionStatus>status = await [Permission.photos].request();
    if(status[Permission.photos]!.isGranted){
      return Future.value(true);
    }
    else if(status[Permission.photos]!.isPermanentlyDenied){
      openAppSettings();
      return Future.value(false);
    }
    else{
      return Future.value(false);
    }
  }

  static Future<bool>getCameraPermission()async {
    Map<Permission, PermissionStatus>status = await [Permission.camera].request();
    if(status[Permission.camera]!.isGranted){
      return Future.value(true);
    }
    else{
      return Future.value(false);
    }

  }
  static Future<bool>getNotificationPermission()async {
    Map<Permission, PermissionStatus>status = await [Permission.notification].request();
    if(status[Permission.notification]!.isGranted){
      return Future.value(true);
    }
    else if(status[Permission.notification]!.isPermanentlyDenied){
      openAppSettings();
      return Future.value(false);
    }
    else{
      return Future.value(false);
    }
  }

}